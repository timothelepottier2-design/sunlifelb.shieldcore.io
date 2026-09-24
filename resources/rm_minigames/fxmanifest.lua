fx_version 'cerulean'
game 'gta5'

lua54 'yes'

shared_scripts {
    'cfg.lua'
}

client_scripts {
    'client/*.lua',
}

ui_page "web/dist/index.html"

files {
    "web/dist/*.html",
    'web/dist/*.*',
    'web/dist/assets/*.*',
    'web/dist/circleClick/*.*',
    'web/dist/combinationLock/*.*',
    'web/dist/fingerprint/*.*',
    'web/dist/memoryGame/*.*',
    'web/dist/multipleLockpick/*.*',
    'web/dist/quicktimeEvent/*.*',
    'web/dist/timedAction/*.*',
    'web/dist/timedBar/*.*',
    'web/dist/timedButton/*.*',
}

escrow_ignore {
    'cfg.lua',
    'client/editable_client.lua',
}
dependency '/assetpacks'