local function isIp(id)
    if type(id) ~= 'string' or id == '' then
        return true
    end

    local lower = id:lower()
    if lower:sub(1, 3) == 'ip:' or lower:sub(1, 4) == 'ip6:' then
        return true
    end

    local bare = lower
    local colon = lower:find(':', 1, true)
    if colon then
        bare = lower:sub(colon + 1)
    end

    bare = bare:gsub('^%[', ''):gsub('%]$', '')

    if bare:match('^%d+%.%d+%.%d+%.%d+$') then
        return true
    end

    if bare:find(':', 1, true) and bare:match('^[0-9a-f:]+$') then
        return true
    end

    return false
end

function VimGetPlayerIdentifiers(playerSource)
    local ids = {}

    for i = 0, GetNumPlayerIdentifiers(playerSource) - 1 do
        local id = GetPlayerIdentifier(playerSource, i)
        if id and id ~= '' and not isIp(id) then
            ids[#ids + 1] = id
        end
    end

    return ids
end

function VimFilterNonIpIdentifiers(ids)
    local safe = {}
    for i = 1, #(ids or {}) do
        local id = ids[i]
        if id and not isIp(tostring(id)) then
            safe[#safe + 1] = tostring(id)
        end
    end
    return safe
end
