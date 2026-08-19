AddEventHandler('playerConnecting', function(name, _, deferrals)
    local src = source

    deferrals.defer()
    Wait(0)
    deferrals.update('Checking VIM Network...')

    if VimIsPlaceholder(Secrets and Secrets.ApiKey) then
        VimWarn('player allowed in without VIM check — API key not set.')
        deferrals.done()
        return
    end

    local identifiers = VimGetPlayerIdentifiers(src)
    if #identifiers == 0 then
        deferrals.done()
        return
    end

    local released = false

    local function releaseJoin()
        if released then return end
        released = true
        deferrals.done()
    end

    SetTimeout(Config.RequestTimeoutMs or 12000, function()
        if not released then
            VimWarn('VIM check timed out — allowing join (a late alert may still arrive).')
            releaseJoin()
        end
    end)

    VimRunJoinCheck(name, identifiers, function(attempt, maxAttempts)
        deferrals.update(('Checking VIM Network... (%s/%s)'):format(attempt, maxAttempts))
    end, function(result)
        if released and not result.ok then
            return
        end

        if result.ok then
            VimHandleJoinCheckResult(name, src, identifiers, result.data)
        elseif result.reason == 'invalid_json' then
            VimWarn('VIM API returned bad JSON — allowing join.')
        else
            VimWarn(('VIM API failed (HTTP %s) — allowing join.'):format(tostring(result.httpCode or '?')))
        end

        releaseJoin()
    end)
end)
