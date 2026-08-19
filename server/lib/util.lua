local resource = GetCurrentResourceName()

function VimDbg(msg)
    if Config.Debug then
        print(('[%s] %s'):format(resource, msg))
    end
end

function VimWarn(msg)
    print(('[%s] WARNING: %s'):format(resource, msg))
end

function VimIsPlaceholder(value)
    value = tostring(value or '')
    return value == ''
        or value:find('YOUR_', 1, true)
        or value:find('PASTE_', 1, true)
end

function VimClip(text, maxLen)
    text = tostring(text or '')
    if #text <= maxLen then
        return text
    end
    return text:sub(1, maxLen - 3) .. '...'
end

function VimShouldRetryHttp(code)
    code = tonumber(code) or 0
    if code == 0 then return true end
    if code == 408 or code == 425 or code == 429 then return true end
    return code >= 500 and code <= 599
end

function VimListLines(items, limit, prefix)
    local lines = {}
    local count = 0
    for i = 1, #(items or {}) do
        if count >= limit then break end
        local item = items[i]
        if item ~= nil then
            count = count + 1
            lines[#lines + 1] = prefix .. tostring(item)
        end
    end
    return table.concat(lines, '\n')
end
