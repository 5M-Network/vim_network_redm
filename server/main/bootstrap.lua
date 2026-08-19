AddEventHandler('onResourceStart', function(resource)
    if resource ~= GetCurrentResourceName() then
        return
    end

    if VimIsPlaceholder(Secrets and Secrets.ApiKey) then
        VimWarn('API key is missing — join checks are off (players can still connect).')
    end

    if VimIsPlaceholder(Secrets and Secrets.DiscordWebhook) then
        VimWarn('Discord webhook is missing — flagged players will only log to console.')
    end

    if VimIsPlaceholder(Config.ApiBaseUrl) then
        VimWarn('ApiBaseUrl is still a placeholder — set config.lua before going live.')
    end
end)
