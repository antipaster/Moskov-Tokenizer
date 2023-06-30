fx_version 'cerulean'
game 'gta5'

description 'Security Util for Fivem Server.'

dependency "yarn"

client_scripts {
	'config.lua',
	'client.lua'
}

server_scripts {
	'uuid.js',
	'config.lua',
	'server.lua'
}

exports {
	'setupClientResource'
}

server_exports {
	'generateToken',
	'setupServerResource',
	'secureServerEvent',
	'getResourceToken'
}

file 'init.lua'
