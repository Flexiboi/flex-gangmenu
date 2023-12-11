fx_version 'cerulean'
game 'gta5'

description 'flex-gangmenu'
version '2.1.0'

ui_page('html/index.html') 

shared_scripts {
    'config.lua',
    '@qb-core/shared/locale.lua',
    'locales/en.lua',
    'locales/*.lua'
}

server_script {
    '@oxmysql/lib/MySQL.lua',
    'server/server.lua'
}
client_script {
    '@PolyZone/client.lua',
	'@PolyZone/BoxZone.lua',
	'@PolyZone/ComboZone.lua',
    'client/client.lua',
    'client/minigames.lua',
}
    

files {
    'html/index.html',
    'html/css/style.css',
    'html/js/java.js',
}

lua54 'yes'
