fx_version 'cerulean'
game 'gta5'
lua54 'yes'

description 'sJobs - Merged jobs resource'

dependency 'oxmysql'
dependency 'es_extended'

ui_page 'html/index.html'

files {
    'html/index.html',

    'mechanics/ui/**',
    'mechanics/data/**',

    'mechanics/data/carcols_gen9.meta',
    'mechanics/data/carmodcols_gen9.meta',

    'jobsui/html/**',
}

data_file 'CARCOLS_GEN9_FILE' 'mechanics/data/carcols_gen9.meta'
data_file 'CARMODCOLS_GEN9_FILE' 'mechanics/data/carmodcols_gen9.meta'

shared_scripts {
    '@ox_lib/init.lua',
    'config.lua',

    'police/config.lua',

    'streettuners/cfg_streettuners.lua',

    'voting/cfg_voting.lua',
}

client_scripts {

    'src/client/RMenu.lua',
    'src/client/menu/RageUI.lua',
    'src/client/menu/Menu.lua',
    'src/client/menu/MenuController.lua',
    'src/client/components/*.lua',
    'src/client/menu/elements/*.lua',
    'src/client/menu/items/*.lua',
    'src/client/menu/panels/*.lua',
    'src/client/menu/windows/*.lua',

    'property/src/client/UIInstructionalButton.lua',

    'client/*.lua',

    'bobcat/client/cl_base.lua',
    'bobcat/client/cl_menu.lua',

    'farm/config.lua',
    'farm/client/cl_main.lua',
    'farm/client/cl_garage.lua',
    'farm/client/builder.lua',

    'fourriere/config.lua',
    'fourriere/client/rage.lua',

    'jobs_pack/config.lua',

    'jobs_pack/client/cl_payevent.lua',
    'jobs_pack/client/cl_jobplace.lua',
    'jobs_pack/client/cl_jardinier.lua',
    'jobs_pack/client/cl_chantier.lua',
    'jobs_pack/client/cl_farm.lua',
    'jobs_pack/client/cl_bucheron.lua',
    'jobs_pack/client/cl_livreur.lua',
    'jobs_pack/client/cl_guide.lua',
    'jobs_pack/client/cl_eats.lua',

    'lsfd/client/cl_base.lua',
    'lsfd/client/cl_menu.lua',
    'lsfd/client/firesHandler.lua',

    'paletoauto/cfg_catalogue.lua',
    'paletoauto/client/utils.lua',
    'paletoauto/client/main.lua',

    'pdm/cfg_catalogue.lua',
    'pdm/client/utils.lua',
    'pdm/client/main.lua',

    'police/client/handcuff.lua',
    'police/client/menottes.lua',

    'property/cfg_property.lua',
    'property/client/cl_utils.lua',
    'property/client/cl_functions.lua',
    'property/client/cl_animations.lua',
    'property/client/cl_commands.lua',
    'property/client/cl_drill.lua',
    'property/client/cl_events.lua',
    'property/client/cl_job.lua',
    'property/client/cl_menu.lua',
    'property/client/cl_telescope.lua',
    'property/client/cl_thread.lua',

    '@es_extended/locale.lua',
    'rems/locales/fr.lua',
    'rems/config.lua',
    'rems/client/main.lua',
    'rems/client/appel.lua',
    'rems/client/job.lua',
    'rems/client/terminal.lua',
    'rems/client/blessure.lua',
    'rems/client/stretcher.lua',
    'rems/client/menu.lua',
    'rems/client/module/*.lua',
    'rems/client/deathscreen/main.lua',
    'rems/client/deathscreen/_ui.lua',

    'mechanics/cfg_mecano.lua',
    'mechanics/client/nui_customs.lua',
    'mechanics/client/customs.lua',

    'jobsui/client/client.lua',

    'voting/client/cl_main.lua',
}

server_scripts {
    '@oxmysql/lib/MySQL.lua',
    '@es_extended/locale.lua',

    'server/alerte.lua',
    'server/armory.lua',
    'server/cardealer.lua',
    'server/custom.lua',
    'server/garage.lua',
    'server/gestion.lua',
    'server/k9.lua',
    'server/menu.lua',
    'server/mission.lua',
    'server/pharmacy.lua',
    'server/service.lua',
    'server/target.lua',

    'farm/server/_json.lua',

    'bobcat/server/srv_bobcat_events.lua',

    'farm/config.lua',
    'farm/server/srv_main.lua',

    'fourriere/config.lua',
    'fourriere/server/main.lua',

    'jobs_pack/config.lua',
    'jobs_pack/server/sv_jobplace.lua',

    'lsfd/server/srv_main.lua',
    'lsfd/server/srv_events.lua',

    'paletoauto/cfg_catalogue.lua',
    'paletoauto/server/main.lua',

    'pdm/cfg_catalogue.lua',
    'pdm/server/main.lua',

    'police/server/main.lua',

    'streettuners/server/srv_craft.lua',

    'property/server/srv_property_main.lua',
    'property/server/srv_property_events.lua',
    'property/server/srv_property_api_guard.lua',

    'rems/locales/fr.lua',
    'rems/config.lua',
    'rems/server/_main.lua',
    'rems/server/blessure.lua',
    'rems/server/stretcher.lua',

    'mechanics/cfg_mecano.lua',
    'mechanics/server/customs.lua',

    'jobsui/server/srv_main.lua',

    'voting/server/srv_main.lua',
}

export 'inService'
export 'GeneratePlate'
export 'takedBox'
export 'isUsingEMSItem'
export 'drawBar'

server_export 'getSocietyService'
server_export 'getPoliceSheriffService'
server_export 'getEMSInService'
server_export 'getJobService'
