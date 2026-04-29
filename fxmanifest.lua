fx_version 'cerulean'
game 'gta5'
version '1.0.0'
author 'Bar Store'
discord 'https://discord.gg/brcore'
description 'Bar Store - Fake Plate Flipper System (QBCore & Ox_inventory)'

shared_scripts {
    '@ox_lib/init.lua',
    'framework/*.lua',
    'config.lua'
}

server_scripts {
    '@oxmysql/lib/MySQL.lua',
    'inventory/*.lua',
    'server.lua'
}

client_script 'client.lua'

files {
    'black.png'
} 

lua54 'yes'
