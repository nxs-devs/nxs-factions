fx_version 'cerulean'
game 'gta5'
lua54 'yes'

client_scripts {
    '@ox_lib/init.lua',
    'client/marker.lua',
    'client/main.lua'
}

shared_scripts {
    'config/*.*',
    '@ox_lib/init.lua',
    '@es_extended/imports.lua'
}

server_scripts {
    '@oxmysql/lib/MySQL.lua',
    'server/*.lua'
}

files {
    'locales/*.json'
}

escrow_ignore {
	'config/config.lua',
    'config/data.json',
    'locales/it.json'
}