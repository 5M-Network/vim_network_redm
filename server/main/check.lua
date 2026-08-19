local function apiUrl()
    return (Config.ApiBaseUrl or ''):gsub('/+$', '') .. '/api/fivem/v1/check'
end

function VimRunJoinCheck(playerName, identifiers, onAttempt, onComplete)
    local attempts = 0
    local maxAttempts = math.max(1, tonumber(Config.ApiRetries) or 3)
    local retryDelay = tonumber(Config.ApiRetryDelayMs) or 800
    local body = json.encode({ ids = identifiers, name = playerName })
    local headers = {
        ['Content-Type'] = 'application/json',
        ['Authorization'] = 'Bearer ' .. (Secrets.ApiKey or ''),
    }

    local finished = false

    local function finish(result)
        if finished then return end
        finished = true
        onComplete(result)
    end

    local function attempt()
        attempts = attempts + 1
        onAttempt(attempts, maxAttempts)

        PerformHttpRequest(apiUrl(), function(code, text)
            if code == 200 and text and text ~= '' then
                local ok, data = pcall(json.decode, text)
                if ok and type(data) == 'table' then
                    finish({ ok = true, data = data })
                else
                    finish({ ok = false, httpCode = code, reason = 'invalid_json' })
                end
                return
            end

            if VimShouldRetryHttp(code) and attempts < maxAttempts then
                VimDbg(('API HTTP %s — retry %s/%s'):format(tostring(code), attempts, maxAttempts))
                SetTimeout(retryDelay, attempt)
                return
            end

            finish({ ok = false, httpCode = code, reason = 'http_error' })
        end, 'POST', body, headers)
    end

    attempt()
end
