
fx_version 'adamant'
game 'gta5'
lua54 'yes'

ui_page 'html/ui.html'

client_scripts {
	'locale.lua',
	'locales/fr.lua',
	'config.lua',
	'config.weapons.lua',
	'essentialmode_module/client/main.lua',

	'client/common.lua',
	'client/entityiter.lua',
	'client/functions.lua',
	'client/wrapper.lua',
	'client/main.lua',
	'client/modules/death.lua',
	'client/modules/scaleform.lua',
	'client/modules/streaming.lua',
	'common/modules/math.lua',
	'common/modules/table.lua',
	'common/functions.lua',
	'client/ac_functions.lua',
	'config.foodsystem.lua',
	'client/foodsystem.lua',
	'licenses_module/src/RMenu.lua',
	'licenses_module/src/UIInstructionalButton.lua',
	'licenses_module/src/menu/RageUI.lua',
	'licenses_module/src/menu/Menu.lua',
	'licenses_module/src/menu/MenuController.lua',
	'licenses_module/src/menu/RecText.lua',
	'licenses_module/src/components/*.lua',
	'licenses_module/src/menu/elements/*.lua',
	'licenses_module/src/menu/items/*.lua',
	'licenses_module/src/menu/panels/*.lua',
	'licenses_module/src/menu/windows/*.lua',
	'licenses_module/client/cl_main.lua'
}

server_scripts {
	'sv_gc.lua',
	'@async/async.lua',
	'@oxmysql/lib/MySQL.lua',
	'locale.lua',
	'locales/fr.lua',
	'config.lua',
	'config.weapons.lua',
	'essentialmode_module/server/util.lua',
	'essentialmode_module/server/main.lua',
	'essentialmode_module/server/db.lua',
	'essentialmode_module/server/classes/player.lua',
	'essentialmode_module/server/classes/groups.lua',
	'essentialmode_module/server/player/login.lua',

	'server/common.lua',
	'server/classes/utils.lua',
	'server/classes/database.lua',
	'server/classes/_props.lua',
	'server/classes/_rank.lua',
	'server/classes/player.lua',
	'server/classes/addonaccount.lua',
	'server/functions.lua',
	'server/paycheck.lua',
	'server/main.lua',
	'server/weaponsitem.lua',
	'server/commands.lua',
	'common/modules/math.lua',
	'common/modules/table.lua',
	'common/functions.lua',
	'server/ac_functions.lua',
	'server/main_addonaccount.lua',

	-- merged: foodsystem
	'config.foodsystem.lua',
	'server/foodsystem.lua',

	-- merged: licenses
	'licenses_module/server/srv_main.lua',
	'licenses_module/server/srv_events.lua'
}

files {
	'locale.js',
	'html/ui.html',
	'html/css/app.css',
	'html/js/mustache.min.js',
	'html/js/wrapper.js',
	'html/js/app.js',
	'html/fonts/pdown.ttf',
	'html/fonts/bankgothic.ttf',
	'html/img/accounts/bank.png',
	'html/img/accounts/black_money.png'
}

export 'getSharedObject'

server_export 'getSharedObject'

server_exports {
	'getPlayerFromId',
	'addAdminCommand',
	'addCommand',
	'addGroupCommand',
	'canGroupTarget',
	'log',
	'debugMsg'
}

dependencies {
	'oxmysql',
	'async'
}