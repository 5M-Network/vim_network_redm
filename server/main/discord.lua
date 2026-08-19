local function embedField(label, value, inline)
    value = tostring(value or ''):gsub('%s+$', '')
    if value == '' then
        value = '-'
    end
    return {
        name = label,
        value = VimClip(value, 1024),
        inline = inline == true,
    }
end

local function buildAlertEmbed(alert)
    local reasons = VimListLines(alert.reasons, 8, '- ')
    if reasons == '' then
        reasons = '- See profile on the website'
    end

    local matched = VimListLines(alert.matched_on, 8, '- ')
    if matched == '' then
        matched = '- (see profile)'
    end

    local idLines = {}
    for i = 1, math.min(#(alert.identifiers or {}), 10) do
        idLines[#idLines + 1] = '`' .. tostring(alert.identifiers[i]) .. '`'
    end
    local identifiers = table.concat(idLines, '\n')
    if identifiers == '' then
        identifiers = '`(none)`'
    end

    local evidence = tostring(alert.evidence_count or 0) .. ' item(s)'
    if alert.profile_url and alert.profile_url ~= '' then
        evidence = evidence .. '\n' .. alert.profile_url
    end

    local description = {
        ('**Connecting as:** %s (server ID %s)'):format(alert.name or 'Unknown', tostring(alert.source or '?')),
        ('**Listed on VIM as:** %s'):format(alert.listed_name or alert.name or 'Unknown'),
    }

    if Config.Platform and Config.Platform ~= '' and Config.Platform ~= 'FiveM' then
        description[#description + 1] = ('**Platform:** %s'):format(Config.Platform)
    end

    if alert.date_added and alert.date_added ~= '' then
        description[#description + 1] = ('**Listed:** %s'):format(alert.date_added)
    end

    local fields = {
        embedField('Risk', alert.risk_score or 0, true),
        embedField('Severity', alert.severity or 'UNKNOWN', true),
        embedField('Evidence', evidence, false),
        embedField('Reasons', reasons, false),
    }

    if alert.summary and alert.summary ~= '' then
        fields[#fields + 1] = embedField('Summary', alert.summary, false)
    end

    fields[#fields + 1] = embedField('Matched IDs', matched, false)
    fields[#fields + 1] = embedField('Identifiers', identifiers, false)

    local title = 'Flagged player connecting'
    if Config.Platform and Config.Platform ~= 'FiveM' then
        title = ('Flagged player connecting (%s)'):format(Config.Platform)
    end

    return {
        title = title,
        description = VimClip(table.concat(description, '\n'), 2048),
        color = Config.WebhookColor or 15158332,
        fields = fields,
        footer = { text = 'VIM Network' },
    }
end

function VimSendFlaggedAlert(alert)
    if VimIsPlaceholder(Secrets and Secrets.DiscordWebhook) then
        VimWarn(('flagged player "%s" but Discord webhook is not configured'):format(tostring(alert.name or 'unknown')))
        return
    end

    PerformHttpRequest(Secrets.DiscordWebhook, function() end, 'POST', json.encode({
        username = Config.WebhookUsername or 'VIM Network',
        avatar_url = (Config.WebhookAvatarUrl ~= '' and Config.WebhookAvatarUrl) or nil,
        embeds = { buildAlertEmbed(alert) },
    }), { ['Content-Type'] = 'application/json' })
end

function VimHandleJoinCheckResult(playerName, playerSource, identifiers, apiData)
    local risk = tonumber(apiData.risk_score) or 0
    if not Config.WarnOnFlagged or not apiData.flagged or risk < (Config.MinRiskScore or 1) then
        return
    end

    local match = (type(apiData.matches) == 'table' and apiData.matches[1]) or {}

    VimSendFlaggedAlert({
        name = playerName,
        listed_name = match.name,
        source = playerSource,
        risk_score = risk,
        severity = match.severity or 'UNKNOWN',
        profile_url = apiData.primary_profile_url or match.profile_url,
        matched_on = VimFilterNonIpIdentifiers(match.matched_on or {}),
        identifiers = identifiers,
        reasons = match.reasons or {},
        summary = match.summary or '',
        evidence_count = match.evidence_count or 0,
        date_added = match.date_added or '',
    })

    VimDbg(('flagged %s (risk %s)'):format(playerName, risk))
end
