# vim_network_redm

## Install

1. Copy this folder into your RedM server `resources/` directory.

2. In **`server/webhooks.lua`**, set your API key and Discord webhook:
   ```lua
   Secrets.ApiKey = 'your-key-from-manage-page'
   Secrets.DiscordWebhook = 'https://discord.com/api/webhooks/...'
   ```
   Get the API key from your trusted server **manage page** on the VIM Network website.

3. Add to **`server.cfg`**:
   ```cfg
   ensure vim_network_redm
   ```

4. Restart the server or run `ensure vim_network_redm`.

---

© VIM Network. See [LICENSE](LICENSE) — no redistribution, resale, or use in competing services.
