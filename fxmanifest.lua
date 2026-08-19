fx_version 'cerulean'
game 'rdr3'

rdr3_warning 'I acknowledge that this is a prerelease build of RedM, and I am aware my resources *will* become incompatible once RedM ships.'

name 'vim_network_redm'
author 'VIM Network'
description 'VIM Network join warnings for RedM (evidence check + Discord alert, no auto-kick).'
version '1.1.1'

lua54 'yes'

server_scripts {
    'config.lua',
    'server/lib/util.lua',
    'server/lib/identifiers.lua',
    'server/webhooks.lua',
    'server/main/check.lua',
    'server/main/discord.lua',
    'server/main/bootstrap.lua',
    'server/main/connecting.lua',
}
