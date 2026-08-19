Config = {}

-- ─── Required ─────────────────────────────────────────────────────────────────

-- Your VIM Network site URL
Config.ApiBaseUrl = 'https://vim-network.org'

-- ─── Alerts ─────────────────────────────────────────────────────────────────

Config.WarnOnFlagged = true
Config.MinRiskScore = 1

-- ─── API timing ─────────────────────────────────────────────────────────────

Config.RequestTimeoutMs = 12000
Config.ApiRetries = 3
Config.ApiRetryDelayMs = 800

-- ─── Discord appearance (optional) ──────────────────────────────────────────

Config.WebhookUsername = 'VIM Network'
Config.WebhookAvatarUrl = ''
Config.WebhookColor = 15158332 -- red (#E74C3C)

Config.Platform = 'RedM'

-- ─── Debug ──────────────────────────────────────────────────────────────────

Config.Debug = false
