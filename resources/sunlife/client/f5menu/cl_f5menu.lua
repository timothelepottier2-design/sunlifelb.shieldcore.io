ESX = nil

local MenuOpened = false
local minimap = false
local moteur = false
local coffre = false
local capot = false
local avantgauche = false
local avantdroite = false
local arrieregauche = false
local arrieredroite = false
local menu = {}
local PlayerData = {}
local HillbillyAS = false
local GangsterAS = false
local scoot = false
local hud = true -- le HUD est affiche par defaut
local lod = 55
local activerSousmenudemerde = false
local StaffName = "Personne"
local ActiveNote = false
local anchorDown = false
local anchoredBoat = 0
local ambiantSounds = true

local playerPeds = {}
local myPedItem = {}
local BackWeaponAllowed = {}
local spawnedAttachedEntities = {}
local BackWeaponOffsets = {}
local EditingBackWeaponHash = nil
local radioOptions = nil
local radioLabels = nil
local radioIndex  = 1

local function findIndexByKey(opts, key)
	for i,v in ipairs(opts) do if v.key == key then return i end end
	return 1
end

-- Menu des accessoires d'armes (avantage "accarmes"). getCurrentWeapon traverse
-- la frontiere de ressource (msgpack) et le corps d'un menu RageUI tourne a
-- chaque frame : on met le resultat en cache 250 ms.
local accWeaponCache   = nil
local accWeaponCacheAt = -1000

local function InvalidateAccWeapon()
	accWeaponCacheAt = -1000
end

local function GetAccWeapon()
	local now = GetGameTimer()
	if (now - accWeaponCacheAt) < 250 then
		return accWeaponCache
	end
	accWeaponCacheAt = now
	accWeaponCache = exports.inventaire:getCurrentWeapon()
	return accWeaponCache
end

WeaponsBackWeaponList = {
    ['WEAPON_DAGGER'] = {propName = 'w_me_dagger'},
    ['WEAPON_BAT'] = {propName = 'w_me_bat'},
    ['WEAPON_BOTTLE'] = {propName = 'w_me_bottle'},
    ['WEAPON_CROWBAR'] = {propName = 'w_me_crowbar'},
    ['WEAPON_FLASHLIGHT'] = {propName = 'w_me_flashlight'},
    ['WEAPON_GOLFCLUB'] = {propName = 'w_me_gclub'},
    ['WEAPON_HAMMER'] = {propName = 'w_me_hammer'},
    ['WEAPON_HATCHET'] = {propName = 'w_me_hatchet'},
    ['WEAPON_KNUCKLE'] = {propName = 'w_me_knuckle'},
    ['WEAPON_KNIFE'] = {propName = 'w_me_knife_01'},
    ['WEAPON_MACHETE'] = {propName = 'w_me_machette_lr'},
    ['WEAPON_SWITCHBLADE'] = {propName = 'w_me_switchblade'},
    ['WEAPON_NIGHTSTICK'] = {propName = 'w_me_nightstick'},
    ['WEAPON_WRENCH'] = {propName = 'w_me_wrench'},
    ['WEAPON_BATTLEAXE'] = {propName = 'w_me_battleaxe'},
    ['WEAPON_POOLCUE'] = {propName = 'w_me_poolcue'},
    ['WEAPON_STONE_HATCHET'] = {propName = 'w_me_stonehatchet'},
    ['WEAPON_CANDYCANE'] = {propName = 'w_me_candy_cane'},
    ['WEAPON_PISTOL'] = {propName = 'w_pi_pistol'},
    ['WEAPON_PISTOL_MK2'] = {propName = 'w_pi_pistolmk2'},
    ['WEAPON_COMBATPISTOL'] = {propName = 'w_pi_combatpistol'},
    ['WEAPON_APPISTOL'] = {propName = 'w_pi_appistol'},
    ['WEAPON_STUNGUN'] = {propName = 'w_pi_stungun'},
    ['WEAPON_PISTOL50'] = {propName = 'w_pi_pistol50'},
    ['WEAPON_SNSPISTOL'] = {propName = 'w_pi_sns_pistol'},
    ['WEAPON_SNSPISTOL_MK2'] = {propName = 'w_pi_sns_pistolmk2'},
    ['WEAPON_HEAVYPISTOL'] = {propName = 'w_pi_heavypistol'},
    ['WEAPON_VINTAGEPISTOL'] = {propName = 'w_pi_vintage_pistol'},
    ['WEAPON_FLAREGUN'] = {propName = 'w_pi_flaregun'},
    ['WEAPON_MARKSMANPISTOL'] = {propName = 'w_pi_marksmanpistol'},
    ['WEAPON_REVOLVER'] = {propName = 'w_pi_revolver'},
    ['WEAPON_REVOLVER_MK2'] = {propName = 'w_pi_revolvermk2'},
    ['WEAPON_DOUBLEACTION'] = {propName = 'w_pi_doubleaction'},
    ['WEAPON_RAYPISTOL'] = {propName = 'w_pi_raygun'},
    ['WEAPON_CERAMICPISTOL'] = {propName = 'w_pi_ceramic_pistol'},
    ['WEAPON_NAVYREVOLVER'] = {propName = 'w_pi_navyrevolver'},
    ['WEAPON_GADGETPISTOL'] = {propName = 'w_pi_gadget_pistol'},
    ['WEAPON_STUNGUN_MP'] = {propName = 'w_pi_stungun_mp'},
    ['WEAPON_PISTOLXM3'] = {propName = 'w_pi_pistolxm3'},
    ['WEAPON_MICROSMG'] = {propName = 'w_sb_microsmg'},
    ['WEAPON_SMG'] = {propName = 'w_sb_smg'},
    ['WEAPON_SMG_MK2'] = {propName = 'w_sb_smgmk2'},
    ['WEAPON_ASSAULTSMG'] = {propName = 'w_sb_assaultsmg'},
    ['WEAPON_COMBATPDW'] = {propName = 'w_sb_pdw'},
    ['WEAPON_MACHINEPISTOL'] = {propName = 'w_sb_machinepistol'},
    ['WEAPON_MINISMG'] = {propName = 'w_sb_minismg'},
    ['WEAPON_TECPISTOL'] = {propName = 'w_sb_tec9'},
    ['WEAPON_PUMPSHOTGUN'] = {propName = 'w_sg_pumpshotgun'},
    ['WEAPON_PUMPSHOTGUN_MK2'] = {propName = 'w_sg_pumpshotgunmk2'},
    ['WEAPON_SAWNOFFSHOTGUN'] = {propName = 'w_sg_sawnoff'},
    ['WEAPON_ASSAULTSHOTGUN'] = {propName = 'w_sg_assaultshotgun'},
    ['WEAPON_BULLPUPSHOTGUN'] = {propName = 'w_sg_bullpupshotgun'},
    ['WEAPON_MUSKET'] = {propName = 'w_ar_musket'},
    ['WEAPON_HEAVYSHOTGUN'] = {propName = 'w_sg_heavyshotgun'},
    ['WEAPON_DBSHOTGUN'] = {propName = 'w_sg_doublebarrel'},
    ['WEAPON_AUTOSHOTGUN'] = {propName = 'w_sg_autoshotgun'},
    ['WEAPON_COMBATSHOTGUN'] = {propName = 'w_sg_pumpshotgunh4'},
    ['WEAPON_ASSAULTRIFLE'] = {propName = 'w_ar_assaultrifle'},
    ['WEAPON_ASSAULTRIFLE_MK2'] = {propName = 'w_ar_assaultriflemk2'},
    ['WEAPON_CARBINERIFLE'] = {propName = 'w_ar_carbinerifle'},
    ['WEAPON_CARBINERIFLE_MK2'] = {propName = 'w_ar_carbineriflemk2'},
    ['WEAPON_ADVANCEDRIFLE'] = {propName = 'w_ar_advancedrifle'},
    ['WEAPON_SPECIALCARBINE'] = {propName = 'w_ar_specialcarbine'},
    ['WEAPON_SPECIALCARBINE_MK2'] = {propName = 'w_ar_specialcarbinemk2'},
    ['WEAPON_BULLPUPRIFLE'] = {propName = 'w_ar_bullpuprifle'},
    ['WEAPON_BULLPUPRIFLE_MK2'] = {propName = 'w_ar_bullpupriflemk2'},
    ['WEAPON_COMPACTRIFLE'] = {propName = 'w_ar_compactrifle'},
    ['WEAPON_MILITARYRIFLE'] = {propName = 'w_ar_militaryrifle'},
    ['WEAPON_HEAVYRIFLE'] = {propName = 'w_ar_heavyrifle'},
    ['WEAPON_TACTICALRIFLE'] = {propName = 'w_ar_carbinerifleh4'},
    ['WEAPON_GUSENBERG'] = {propName = 'w_sb_gusenberg'},
    ['WEAPON_A15RC'] = {propName = 'w_ar_a15rc'},
    ['WEAPON_HK416B'] = {propName = 'w_ar_HK416B'},
    ['WEAPON_G19'] = {propName = 'W_PI_G19'},
    ['WEAPON_MK18B'] = {propName = 'w_ar_mk18b'},
    ['WEAPON_MP5'] = {propName = 'w_sb_mp5'},
    ['WEAPON_LESSLETHAL'] = {propName = 'w_sg_lesslethal'},
    ['WEAPON_BREAD'] = {propName = 'w_me_bread'},
    ['WEAPON_DILDOCMG'] = {propName = 'w_me_dildo'},
    ['WEAPON_FIREAXECMG'] = {propName = 'w_me_fireaxe'},
    ['WEAPON_GUITARCMG'] = {propName = 'w_me_guitar'},
    ['WEAPON_MP7CMG'] = {propName = 'w_sb_mp7'},
    ['WEAPON_SHOVELCMG'] = {propName = 'w_me_shovel'},
    ['WEAPON_UMP45CMG'] = {propName = 'w_sb_ump45'},
    ['WEAPON_CHAINSAW'] = {propName = 'w_mg_chainsaw'},
    ['WEAPON_KARAMBIT'] = {propName = 'w_me_karambit'},
    ['WEAPON_ASSAULTRIFLELS'] = {propName = 'w_ar_assaultriflels'},
    ['WEAPON_CANDYKNIFE'] = {propName = 'w_me_candyknife_01'},
    ['WEAPON_KATANA'] = {propName = 'w_me_kattana_lr'},
    ['WEAPON_AXE'] = {propName = 'w_me_axe'},
    ['WEAPON_BARBEDBAT'] = {propName = 'w_me_barbedbat'},
    ['WEAPON_BATON'] = {propName = 'w_me_baton'},
    ['WEAPON_BLACKKATANA'] = {propName = 'w_me_blackkatana_lr'},
    ['WEAPON_BLUEZK'] = {propName = 'w_me_bluezombieknife_01'},
    ['WEAPON_BROWNMACHETE'] = {propName = 'w_me_brownhandlemachete_lr'},
    ['WEAPON_BUTCHER'] = {propName = 'w_me_butcher_lr'},
    ['WEAPON_CHAIR'] = {propName = 'w_me_chair'},
    ['WEAPON_CRUTCH'] = {propName = 'w_me_crutch'},
    ['WEAPON_DILDO'] = {propName = 'w_me_dildo'},
    ['WEAPON_EGUITAR'] = {propName = 'w_me_eguitar'},
    ['WEAPON_GUITAR'] = {propName = 'w_me_guitar'},
    ['WEAPON_HUNTERKNIFE'] = {propName = 'w_me_hunterknife_01'},
    ['WEAPON_ICECLIMBER'] = {propName = 'w_me_iceclimber_lr'},
    ['WEAPON_KITCHENKNIFE'] = {propName = 'w_me_kitchenknife_01'},
    ['WEAPON_KUKRI'] = {propName = 'w_me_kukri_lr'},
    ['WEAPON_LONGMACHETE'] = {propName = 'w_me_longmachete_lr'},
    ['WEAPON_MACE'] = {propName = 'w_me_mace'},
    ['WEAPON_PICKAXE'] = {propName = 'w_me_pickaxe'},
    ['WEAPON_PINKZK'] = {propName = 'w_me_pinkzombieknife_01'},
    ['WEAPON_PITCHFORK'] = {propName = 'w_me_pitchfork_01'},
    ['WEAPON_REDZK'] = {propName = 'w_me_redzombieknife_01'},
    ['WEAPON_SCIFISWORD'] = {propName = 'w_me_scifisword_01'},
    ['WEAPON_SCIMITAR'] = {propName = 'w_me_scimitar_01'},
    ['WEAPON_SCREWDRIVER'] = {propName = 'w_me_screwdriver_01'},
    ['WEAPON_SCYTHE'] = {propName = 'w_me_scythe'},
    ['WEAPON_SHOVEL'] = {propName = 'w_me_sovel'},
    ['WEAPON_SLEDGEHAMMER'] = {propName = 'w_me_sledgehammer'},
    ['WEAPON_SPIKEDKNUCKLES'] = {propName = 'w_me_knuckleduster'},
    ['WEAPON_SPIKEYBAT'] = {propName = 'w_me_spikeybat'},
    ['WEAPON_STOPSIGN'] = {propName = 'w_me_stopsign'},
    ['WEAPON_TACAXE'] = {propName = 'w_me_tacaxe'},
    ['WEAPON_TACCLEAVER'] = {propName = 'w_me_taccleaver'},
    ['WEAPON_TACTICALHATCHET'] = {propName = 'w_me_tacticalhatchet'},
    ['WEAPON_THORSHAMMER'] = {propName = 'w_me_thorshammer'},
    ['WEAPON_TWOHBATTLEAXE'] = {propName = 'w_me_twohbattleaxe'},
    ['WEAPON_WCLAWS'] = {propName = 'w_me_wolverineclaws'},
    ['WEAPON_ZK'] = {propName = 'w_me_zombieknife_01'},
    ['WEAPON_MACHINE_PISTOL_RED_CHR'] = {propName = 'w_machine_pistol_red_chromium'},
    ['WEAPON_BULLPUP_SMG'] = {propName = 'w_sb_bullpup_smg'},
    ['WEAPON_FRYINPAN'] = {propName = 'w_me_fryinpan'},
    ['WEAPON_MP9'] = {propName = 'w_sb_mp9'},
    ['WEAPON_EXTENDEDSMG'] = {propName = 'w_sb_extendedsmg'},
    ['WEAPON_GOLDSMG'] = {propName = 'w_sb_extendedsmg'},
    ['WEAPON_AK_SHORTSTOCK_CHR'] = {propName = 'w_ar_ak_shortstock_chromium'},
    ['WEAPON_M415'] = {propName = 'w_ar_m415'},
    ['WEAPON_PF940'] = {propName = 'w_pi_pf940'},
    ['WEAPON_MP7_CHROMIUM'] = {propName = 'w_sb_mp7_chromium'},
    ['WEAPON_VECTOR'] = {propName = 'w_sb_vector'},
    ['WEAPON_SB4S'] = {propName = 'w_sb_sb4s'},
    ['WEAPON_HKUSP'] = {propName = 'w_pi_hkusp'},
    ['WEAPON_UMP_CHR'] = {propName = 'w_sb_ump_chr'},
    ['WEAPON_SCAR-L'] = {propName = 'w_ar_scar-l'},
    ['WEAPON_DEAGLE'] = {propName = 'w_pi_pistol50'},
    ['WEAPON_PNONENTE'] = {propName = 'w_sb_assaultsmg'},
    ['WEAPON_CZ_SCORPION_EVO_CHR'] = {propName = 'w_ar_cz_sc_evo_chr'},
    ['WEAPON_SS2_2'] = {propName = 'w_ar_ss2_2'},
    ['WEAPON_VERESK'] = {propName = 'w_sb_veresk'},
    ['WEAPON_MLTM4R_CHR'] = {propName = 'w_ar_lmtm4r_chr'},
    ['WEAPON_FAMAS'] = {propName = 'w_ar_famas'},
    ['WEAPON_SPS_21_SG_CHR'] = {propName = 'did_sps_21_sg_chr'},
    ['WEAPON_MICRO_9_CHR'] = {propName = 'did_micro_9_chr'},
    ['WEAPON_VX_SCORPION_CHR'] = {propName = 'did_vx_scorpion_chr'},
    ['WEAPON_NVRIFLE_CHR'] = {propName = 'did_w_nvrifle_chr'},
    ['WEAPON_REDL'] = {propName = 'w_leogunsakred_assaultrifle'},
    ['WEAPON_M4_STORMBORN'] = {propName = 'did_stormborn_m4'},
    ['WEAPON_REDLINE_FANG'] = {propName = 'did_redline_fang'},
    ['WEAPON_TR_88_CHR'] = {propName = 'did_tr_88_chr'},
    ['WEAPON_M270D_CHR'] = {propName = 'did_m270d_chr'},
    ['WEAPON_M4BEAST'] = {propName = 'w_ar_m4beast'},
    ['WEAPON_TAR21'] = {propName = 'w_ar_tar21'},
    ['WEAPON_BAS_P_RED'] = {propName = 'w_sb_bas_p'},
    ['WEAPON_KS1'] = {propName = 'w_ar_ks1'},
    ['WEAPON_SMG9'] = {propName = 'w_sb_smg9'},
    ['WEAPON_L85_CHR'] = {propName = 'w_ar_l85_chr'},
    ['WEAPON_BUTERFLY'] = {propName = 'w_me_buterfly_01'},
    ['WEAPON_DIRTYSYRINGE'] = {propName = 'w_me_dirtysyringe_01'},
    ['WEAPON_PEELER'] = {propName = 'w_me_peeler_01'},
    ['WEAPON_RULER'] = {propName = 'w_me_ruler'},
    ['WEAPON_BIGSPOON'] = {propName = 'w_me_bigspoon'},
    ['WEAPON_JABSAW'] = {propName = 'w_me_jabsaw_01'},
    ['WEAPON_TELESCOPE'] = {propName = 'w_me_telescope'},
    ['WEAPON_MEATSKEWER'] = {propName = 'w_me_meatskewer'},
    ['WEAPON_SWORDFISH'] = {propName = 'w_me_swordfish_01'},
    ['WEAPON_LOBSTER'] = {propName = 'w_me_lobster'},
    ['WEAPON_PLIERS'] = {propName = 'w_me_pliers'},
    ['WEAPON_HANDDRILL'] = {propName = 'w_me_handdrill_01'},
    ['WEAPON_TWISTEDSPEAR'] = {propName = 'w_me_twistedspear_01'},
    ['WEAPON_SNAKEKNIFE'] = {propName = 'w_me_snakeknife_01'},
    ['WEAPON_CRUTCHKNIFE'] = {propName = 'w_me_crutchknife_01'},
    ['WEAPON_SHARPARROW'] = {propName = 'w_me_sharparrow_01'},
    ['WEAPON_95SIGN'] = {propName = 'w_me_95sign'},
    ['WEAPON_ASSASINGUN'] = {propName = 'w_pi_assasingun'},
    ['WEAPON_BAGUETTE'] = {propName = 'w_me_baguette'},
    ['WEAPON_BANANA'] = {propName = 'w_me_banana'},
    ['WEAPON_BIKE'] = {propName = 'w_me_bike'},
    ['WEAPON_BONE'] = {propName = 'w_me_bone'},
    ['WEAPON_BONESWORD'] = {propName = 'w_me_bonesword'},
    ['WEAPON_BUTTPLUG'] = {propName = 'w_me_buttplug'},
    ['WEAPON_CACTUS'] = {propName = 'w_me_cactus'},
    ['WEAPON_CAMSHAFT'] = {propName = 'w_me_camshaft'},
    ['WEAPON_CARJACK'] = {propName = 'w_me_carjack'},
    ['WEAPON_CONE'] = {propName = 'w_me_cone'},
    ['WEAPON_CROSSSPANNER'] = {propName = 'w_me_crossspanner'},
    ['WEAPON_CUCUMBER'] = {propName = 'w_me_cucumber'},
    ['WEAPON_DISABLEDSIGN'] = {propName = 'w_me_disabledsign'},
    ['WEAPON_ELDERSWAND'] = {propName = 'w_me_elderswand_01'},
    ['WEAPON_MFIREEXTINGUISHER'] = {propName = 'w_me_mfireextinguisher'},
    ['WEAPON_FISHINGROD'] = {propName = 'w_me_fishingrod'},
    ['WEAPON_GASCYLINDER'] = {propName = 'w_me_gascylinder'},
    ['WEAPON_HOCKEYFSTICK'] = {propName = 'w_me_hockeyfieldstick'},
    ['WEAPON_HORN'] = {propName = 'w_me_horn'},
    ['WEAPON_JDBOTTLE'] = {propName = 'w_me_jdbottle'},
    ['WEAPON_KEYBOARD'] = {propName = 'w_me_keyboard'},
    ['WEAPON_KITCHENFORK'] = {propName = 'w_me_kitchenfork'},
    ['WEAPON_LACROSSESTICK'] = {propName = 'w_me_lacrossestick'},
    ['WEAPON_LADDER'] = {propName = 'w_me_ladder'},
    ['WEAPON_MAILBOX'] = {propName = 'w_me_mailbox'},
    ['WEAPON_MIC'] = {propName = 'w_me_mic'},
    ['WEAPON_NOPARKINGSIGN'] = {propName = 'w_me_noparkingsign'},
    ['WEAPON_PEN'] = {propName = 'w_me_pen_01'},
    ['WEAPON_PENCIL'] = {propName = 'w_me_pencil_01'},
    ['WEAPON_PROSLEG'] = {propName = 'w_me_prosleg'},
    ['WEAPON_ROLLINGPIN'] = {propName = 'w_me_rollingpin'},
    ['WEAPON_RONABOTTLE'] = {propName = 'w_me_ronabottle'},
    ['WEAPON_ROUTE66SIGN'] = {propName = 'w_me_route66sign'},
    ['WEAPON_SCOOTER'] = {propName = 'w_me_scooter'},
    ['WEAPON_SHOCKABSORBER'] = {propName = 'w_me_shockabsorber'},
    ['WEAPON_SKULLBAT'] = {propName = 'w_me_skullbat'},
    ['WEAPON_SPARTANSWORD'] = {propName = 'w_me_spartansword_01'},
    ['WEAPON_SPATULA'] = {propName = 'w_me_spatula'},
    ['WEAPON_STEPLADDER'] = {propName = 'w_me_stepladder'},
    ['WEAPON_STREETLIGHT'] = {propName = 'w_me_streetlight'},
    ['WEAPON_TOASTER'] = {propName = 'w_me_toaster'},
    ['WEAPON_VACUUM'] = {propName = 'w_me_vacuum'},
    ['WEAPON_WRONGWAYSIGN'] = {propName = 'w_me_wrongwaysign'},
    ['WEAPON_YARI'] = {propName = 'w_me_yari_lr'},
    ['WEAPON_BLACKBELT'] = {propName = 'w_me_blackbelt'},
    ['WEAPON_BENTFORK'] = {propName = 'w_me_bentfork_01'},
    ['WEAPON_BLACKBACKPACK'] = {propName = 'w_me_blackbackpack'},
    ['WEAPON_BRCHICKEN'] = {propName = 'w_me_brchicken'},
    ['WEAPON_DOORBARS'] = {propName = 'w_me_doorbars'},
    ['WEAPON_EARBUDBLADE'] = {propName = 'w_me_earbudblade_lr'},
    ['WEAPON_HONEYDIPPER'] = {propName = 'w_me_honeydipper'},
    ['WEAPON_KETTLE'] = {propName = 'w_me_kettle'},
    ['WEAPON_LEATHERBRIEFCASE'] = {propName = 'w_me_leatherbriefcase'},
    ['WEAPON_MAKESHIFTKNIFE'] = {propName = 'w_me_makeshiftknife_01'},
    ['WEAPON_MEASURINGCUP'] = {propName = 'w_me_measuringcup'},
    ['WEAPON_MODDEDNIGHTSTICK'] = {propName = 'w_me_moddednightstick'},
    ['WEAPON_TRAYRACK'] = {propName = 'w_me_trayrack'},
    ['WEAPON_POKER'] = {propName = 'w_me_poker_01'},
    ['WEAPON_PRISONKEY'] = {propName = 'w_me_prisonkey_01'},
    ['WEAPON_VIOBACKPACK'] = {propName = 'w_me_viobackpack'},
    ['WEAPON_REDBACKPACK'] = {propName = 'w_me_redbackpack'},
    ['WEAPON_TEAPOT'] = {propName = 'w_me_teapot'},
    ['WEAPON_PRISTOI'] = {propName = 'w_me_prisontoilete'},
    ['WEAPON_SHIV'] = {propName = 'w_me_shiv_01'},
    ['WEAPON_FETE21'] = {propName = 'w_me_knifecustom_01'},
    ['WEAPON_GK47'] = {propName = 'w_ar_gk47'},
    ['WEAPON_COMBAT_SG_CHR'] = {propName = 'did_combat_sg_chr'},
    ['WEAPON_R90_CHR'] = {propName = 'w_ar_r90_chr'},
    ['WEAPON_G3_2'] = {propName = 'w_ar_g3_2'},
    ['WEAPON_AUG'] = {propName = 'w_ar_aug'},
    ['WEAPON_MINISMG_PINKSPIKE'] = {propName = 'did_minismg_pinkspike'},
    ['WEAPON_M16A1_CHR'] = {propName = 'did_m16a1_chr'},
    ['WEAPON_HX_15_CHR'] = {propName = 'did_hx_15_chr'},
    ['WEAPON_KITTBOWYAXE'] = {propName = 'w_me_kittybowaxe'},
    ['WEAPON_UNICORNHORN'] = {propName = 'w_me_unicornhorn_01'},
    ['WEAPON_BRUNETTEDOLL'] = {propName = 'w_me_brunettedoll'},
    ['WEAPON_BLONDEDOLL'] = {propName = 'w_me_blondedoll'},
    ['WEAPON_ANIMEDOLL'] = {propName = 'w_me_animedoll'},
    ['WEAPON_WEDDINGRING'] = {propName = 'w_me_weddingring'},
    ['WEAPON_FEGUITAR'] = {propName = 'w_me_feguitar'},
    ['WEAPON_FGUITAR'] = {propName = 'w_me_fguitar'},
    ['WEAPON_BABYCHAIRFOOD'] = {propName = 'w_me_eatchairbaby'},
    ['WEAPON_TWEEZERS'] = {propName = 'w_me_tweezers_01'},
    ['WEAPON_PINKSWITCHBLADE'] = {propName = 'w_me_pinkswitchblade'},
    ['WEAPON_KITTYAXE'] = {propName = 'w_me_kittyaxe'},
    ['WEAPON_BABYSEAT'] = {propName = 'w_me_babyseat'},
    ['WEAPON_TWIRLPOP'] = {propName = 'w_me_twirlpop_01'},
    ['WEAPON_ROUNDLOLLY'] = {propName = 'w_me_roundlolly_01'},
    ['WEAPON_HSLOLLY'] = {propName = 'w_me_halfstarlolly_01'},
    ['WEAPON_BUTTERLOLLY'] = {propName = 'w_me_butterlolly_01'},
    ['WEAPON_STEAMIRON'] = {propName = 'w_me_steamiron'},
    ['WEAPON_HAIRBRUSH'] = {propName = 'w_me_hairbrush'},
    ['WEAPON_PINKLOLLY'] = {propName = 'w_me_pinklolly'},
    ['WEAPON_LOLLYBAT'] = {propName = 'w_me_lollybat'},
    ['WEAPON_CANDYKNIFE'] = {propName = 'w_me_candyknife_01'},
    ['WEAPON_ROSEKNIFE'] = {propName = 'w_me_roseknife_01'},
    ['WEAPON_LIPSTICK'] = {propName = 'w_me_lipstick_01'},
    ['WEAPON_BLPURSE'] = {propName = 'w_me_blackpurse'},
    ['WEAPON_PINKPOOLNOODLE'] = {propName = 'w_me_poolnoodlepink'},
    ['WEAPON_WHITEPILLOW'] = {propName = 'w_me_whitepillow'},
    ['WEAPON_PINKPILLOW'] = {propName = 'w_me_pinkpillow'},
    ['WEAPON_FTEDDYPINK'] = {propName = 'w_me_fteddypink'},
    ['WEAPON_FTEDDY'] = {propName = 'w_me_fteddy'},
    ['WEAPON_VIBRATOR'] = {propName = 'w_me_vibrator'},
    ['WEAPON_FDUALSWORD'] = {propName = 'w_me_fdualsword_01'},
    ['WEAPON_CRYSTALROD'] = {propName = 'w_me_crystalrod'},
    ['WEAPON_FZVTWO'] = {propName = 'w_me_fzombieknifevtwo_01'},
    ['WEAPON_FSLIPPERS'] = {propName = 'w_me_fslip'},
    ['WEAPON_BLOSSOMKNIFE'] = {propName = 'w_me_fknife_01'},
    ['WEAPON_BLOSSOMKATANA'] = {propName = 'w_me_fkattana_lr'},
    ['WEAPON_FHATCHET'] = {propName = 'w_me_fhatchet'},
    ['WEAPON_FKNUCKLE'] = {propName = 'w_me_fknuckle'},
    ['WEAPON_CHRIBAG'] = {propName = 'w_me_chribag'},
    ['WEAPON_FBLACKHEEL'] = {propName = 'w_me_fblackheel'},
    ['WEAPON_FPINKHEEL'] = {propName = 'w_me_fpinkheel'},
    ['WEAPON_FREDHEEL'] = {propName = 'w_me_fredheel'},
    ['WEAPON_FBAT'] = {propName = 'w_me_fbat'},
    ['WEAPON_FSPIKEBAT'] = {propName = 'w_me_fspikebat'},
    ['WEAPON_FPICKAXE'] = {propName = 'w_me_fpickaxe'},
    ['WEAPON_FCOMB'] = {propName = 'w_me_fcomb_01'},
    ['WEAPON_PINKKEYBOARD'] = {propName = 'w_me_pinkkeyboard'},
    ['WEAPON_SPIKEDCHOKER'] = {propName = 'w_me_spikedchoker'},
    ['WEAPON_PINKCHOKER'] = {propName = 'w_me_pinkchoker'},
    ['WEAPON_PINKPEPPERSPRAY'] = {propName = 'w_pi_pinkpepperspray'},
    ['WEAPON_BLOWDRYER'] = {propName = 'w_me_blowdryer'},
    ['WEAPON_BOBSFISHINGNET'] = {propName = 'w_me_bobsfishingnet'},
    ['WEAPON_DRAGONDOLL'] = {propName = 'w_me_dragondoll'},
    ['WEAPON_WEAPON_FCLOSEDUMBRELLA'] = {propName = 'w_me_fclosedumbrella_01'},
    ['WEAPON_FLAMINGO'] = {propName = 'w_me_flamingo'},
    ['WEAPON_FSCEPTER'] = {propName = 'w_me_fscepter_01'},
    ['WEAPON_FUMBRELLA'] = {propName = 'w_me_fumbrella'},
    ['WEAPON_GOLDDIGGER'] = {propName = 'w_me_golddigger'},
    ['WEAPON_HAIRPIN'] = {propName = 'w_me_hairpin_01'},
    ['WEAPON_HEARTBAG'] = {propName = 'w_me_heartbag'},
    ['WEAPON_KERBSDOLL'] = {propName = 'w_me_kerbsdoll'},
    ['WEAPON_KETTLEBALL'] = {propName = 'w_me_kettleball'},
    ['WEAPON_MARSHSTICK'] = {propName = 'w_me_marshstick_01'},
    ['WEAPON_MERMAID'] = {propName = 'w_me_mermaiddoll'},
    ['WEAPON_MOUSEDOLL'] = {propName = 'w_me_mousedoll'},
    ['WEAPON_OCTOPUSDOLL'] = {propName = 'w_me_octopusdoll'},
    ['WEAPON_PINKBOLTCUTTERS'] = {propName = 'w_me_pinkboltcutters'},
    ['WEAPON_PINKFAXE'] = {propName = 'w_me_pinkfaxe'},
    ['WEAPON_PINKFPICKAXE'] = {propName = 'w_me_pinkfpickaxe'},
    ['WEAPON_PINKHAMMER'] = {propName = 'w_me_pinkhammer'},
    ['WEAPON_PINKHANDFAN'] = {propName = 'w_me_pinkhandfan'},
    ['WEAPON_PINKKNIGHTSTICK'] = {propName = 'w_me_pinknightstick'},
    ['WEAPON_PINKSCREWDRIVER'] = {propName = 'w_me_pinkscrewdriver_01'},
    ['WEAPON_PSLEDGE'] = {propName = 'w_me_pinksledgehammer'},
    ['WEAPON_TIARA'] = {propName = 'w_me_tiara'},
    ['WEAPON_LUUBAG'] = {propName = 'w_me_luubag'},
    ['WEAPON_PINKCUTTER'] = {propName = 'w_me_pinkcutter_01'},
    ['WEAPON_PINKCYBERSWORD'] = {propName = 'w_me_pinkcybersword_01'},
    ['WEAPON_RADABAG'] = {propName = 'w_me_radabag'},
    ['WEAPON_R90_CHR'] = {propName = 'w_ar_r90_chr'},
    ['WEAPON_VX_47_CHR'] = {propName = 'did_vx_47_chr'},
    ['WEAPON_SB_SD_CHR'] = {propName = 'did_sbsd_chr'},
    ['WEAPON_BONECLUB'] = {propName = 'w_me_boneclub'},
    ['WEAPON_BUCKET'] = {propName = 'w_me_bucket'},
    ['WEAPON_COFFIN'] = {propName = 'w_me_coffin'},
    ['WEAPON_DEATHNOTE'] = {propName = 'w_me_deathnote'},
    ['WEAPON_HELLFIRESWORD'] = {propName = 'w_me_hellfiresword'},
    ['WEAPON_INFERNO'] = {propName = 'w_me_inferno'},
    ['WEAPON_PUMPKIN'] = {propName = 'w_me_pumpkin'},
    ['WEAPON_PUMPKIN2'] = {propName = 'w_me_pumpkin2'},
    ['WEAPON_PUMPKINBAT'] = {propName = 'w_me_pumpkinbat'},
    ['WEAPON_ARM'] = {propName = 'w_me_arm'},
    ['WEAPON_LEG'] = {propName = 'w_me_leg'},
    ['WEAPON_STAKE'] = {propName = 'w_me_stake_01'},
    ['WEAPON_TRIPLEBLADEDSCYTHE'] = {propName = 'w_me_triplescythe'},
    ['WEAPON_VOODOO'] = {propName = 'w_me_voodoodoll'},
    ['WEAPON_WITCHBROOM'] = {propName = 'w_me_witchbroom'},
    ['WEAPON_SOULSCYTHE'] = {propName = 'w_me_soulscythe'},
    ['WEAPON_GRAVESTONE'] = {propName = 'w_me_gravestone'},
	['WEAPON_COMBAT_MP7'] = {propName = 'did_combat_mp7'},
    ['WEAPON_G36'] = {propName = 'w_ar_g36'},
    ['WEAPON_COMBAT_PISTOL_CHROMIUM'] = {propName = 'w_pi_combat_pistol_chromium'},
    ['WEAPON_SHOTGUN_CHROMIUM'] = {propName = 'w_sg_shotgun_chromium'},
    ['WEAPON_G3_2'] = {propName = 'w_ar_g3_2'},
	['WEAPON_ASSAULTRIFLECUPID'] = {propName = 'w_ar_assaultriflecupid'},
	['WEAPON_ASSAULTRIFLE_MK2_DARKMATTER'] = {propName = 'w_ar_assaultriflemk2_darkmatter'},
    ['WEAPON_CARBINERIFLE_MK2_DARKMATTER'] = {propName = 'w_ar_carbineriflemk2_darkmatter'},
    ['WEAPON_SPECIALCARBINE_MK2_DARKMATTER'] = {propName = 'w_ar_specialcarbinemk2_darkmatter'},
    ['WEAPON_MICROSMG_DARKMATTER'] = {propName = 'w_sb_microsmg_darkmatter'},
    ['WEAPON_REVOLVER_MK2_DARKMATTER'] = {propName = 'w_pi_revolvermk2_darkmatter'},
    ['WEAPON_KNUCKLE_DARKMATTER'] = {propName = 'w_me_knuckle_darkmatter'},
    ['WEAPON_RRT14_GANG'] = {propName = 'did_rrt14_gang'},
    ['WEAPON_P320_GANG'] = {propName = 'did_p320_gang'},
}

local BackWeaponItems = {
    ["WEAPON_SMG"] = GetHashKey("WEAPON_SMG"),
    ["WEAPON_M16A1_CHR"] = GetHashKey("WEAPON_M16A1_CHR"),
    ["WEAPON_TR_88_CHR"] = GetHashKey("WEAPON_TR_88_CHR"),
    ["WEAPON_R90_CHR"] = GetHashKey("WEAPON_R90_CHR"),
    ["WEAPON_HEAVYSHOTGUN"] = GetHashKey("WEAPON_HEAVYSHOTGUN"),
    ["WEAPON_PUMPSHOTGUN"] = GetHashKey("WEAPON_PUMPSHOTGUN"),
    ["WEAPON_MUSKET"] = GetHashKey("WEAPON_MUSKET"),
    ["WEAPON_FIREWORK"] = GetHashKey("WEAPON_FIREWORK"),
    ["WEAPON_BAT"] = GetHashKey("WEAPON_BAT"),
    ["WEAPON_PETROLCAN"] = GetHashKey("WEAPON_PETROLCAN"),
}

local SETTINGS = {
    back_bone = 24818,
    x = 0.075,
    y = -0.15,
    z = -0.02,
    x_rotation = 0.0,
    y_rotation = 165.0,
    z_rotation = 0.0,
    compatable_weapon_hashes = {}
}

for weaponName, data in pairs(WeaponsBackWeaponList) do
    if data.propName then
        SETTINGS.compatable_weapon_hashes[data.propName] = GetHashKey(weaponName)
    end
end

SETTINGS.compatable_weapon_hashes["prop_ld_jerrycan_01"] = GetHashKey("WEAPON_PETROLCAN")
SETTINGS.compatable_weapon_hashes["w_lr_firework"] = GetHashKey("WEAPON_FIREWORK")

local attached_weapons = {}

local function isMeleeWeapon(attachModel)
    if attachModel == "prop_golf_iron_01" then
        return true
    elseif attachModel == "prop_ld_jerrycan_01" then
        return true
    elseif string.sub(attachModel, 1, 5) == "w_me_" then
        return true
    else
        return false
    end
end

local function ForceNoCollision(ent)
    if not ent or not DoesEntityExist(ent) then return end
    SetEntityCollision(ent, false, false)
    if SetEntityCompletelyDisableCollision then SetEntityCompletelyDisableCollision(ent, true, true) end
    SetEntityHasGravity(ent, false)
    SetCanClimbOnEntity(ent, false)
    SetEntityNoCollisionEntity(ent, PlayerPedId(), true)
    local veh = GetVehiclePedIsIn(PlayerPedId(), false)
    if veh ~= 0 then SetEntityNoCollisionEntity(ent, veh, true) end
end

local function DetachByHash(hash)
    for attachModel, data in pairs(attached_weapons) do
        if data.hash == hash then
            DetachOne(attachModel)
        end
    end
end

local function AttachWeapon(attachModel, modelHash, boneNumber, x, y, z, xR, yR, zR)
    local existing = attached_weapons[attachModel]
    if existing and DoesEntityExist(existing.handle) then
        DetachOne(attachModel)
    end

    local bone = GetPedBoneIndex(PlayerPedId(), boneNumber)
    local model = GetHashKey(attachModel)

    RequestModel(model)
    while not HasModelLoaded(model) do
        Wait(0)
    end

    print(('^2[NETDIAG][OBJET]^7 %s cl_f5menu.lua:491 CreateObject NETWORKED model=%s'):format(GetCurrentResourceName(), tostring(model)))
    local objHandle = CreateObject(model, 1.0, 1.0, 1.0, true, true, false)
    local netId = NetworkGetNetworkIdFromEntity(objHandle)

    attached_weapons[attachModel] = { hash = modelHash, handle = objHandle, netId = netId }
    spawnedAttachedEntities[objHandle] = netId

    SetEntityAsMissionEntity(objHandle, true, false)

    AttachEntityToEntity(objHandle, PlayerPedId(), bone, x, y, z, xR, yR, zR, true, true, false, true, 1, true)
    TriggerServerEvent('backweapons:register', netId)
end

AddEventHandler('gameEventTriggered', function(name, args)
    if name == 'CEventNetworkPlayerEnteredVehicle' and args[1] == PlayerPedId() then
        for _, data in pairs(attached_weapons) do
            if data and DoesEntityExist(data.handle) then
                ForceNoCollision(data.handle)
            end
        end
    elseif name == 'CEventNetworkPlayerExitedVehicle' and args[1] == PlayerPedId() then
        for _, data in pairs(attached_weapons) do
            if data and DoesEntityExist(data.handle) then
                ForceNoCollision(data.handle)
            end
        end
    end
end)

local function GetOffsetsForWeapon(weaponHash, isMelee, attachModel)
    local base = {}
    if isMelee then
        base.x = 0.11
        base.y = -0.14
        base.z = 0.0
        base.xR = -75.0
        base.yR = 185.0
        base.zR = 92.0
    else
        base.x = SETTINGS.x
        base.y = SETTINGS.y
        base.z = SETTINGS.z
        base.xR = SETTINGS.x_rotation
        base.yR = SETTINGS.y_rotation
        base.zR = SETTINGS.z_rotation
    end

    local custom = BackWeaponOffsets[weaponHash]
    if custom then
        if custom.x ~= nil then base.x = custom.x end
        if custom.y ~= nil then base.y = custom.y end
        if custom.z ~= nil then base.z = custom.z end
        if custom.xR ~= nil then base.xR = custom.xR end
        if custom.yR ~= nil then base.yR = custom.yR end
        if custom.zR ~= nil then base.zR = custom.zR end
    end

    if attachModel == "prop_ld_jerrycan_01" then
        base.x = base.x + 0.3
    end

    return base
end

local function clamp(v, min, max)
    if v < min then
        return min
    end
    if v > max then
        return max
    end
    return v
end

local function ReattachHashNow(hash)
    DetachByHash(hash)
    for propModelName, weaponHash in pairs(SETTINGS.compatable_weapon_hashes) do
        if weaponHash == hash then
            local base = GetOffsetsForWeapon(weaponHash, isMeleeWeapon(propModelName), propModelName)
            AttachWeapon(propModelName, weaponHash, SETTINGS.back_bone, base.x, base.y, base.z, base.xR, base.yR, base.zR)
            local data = attached_weapons[propModelName]
            if data and DoesEntityExist(data.handle) then ForceNoCollision(data.handle) end
        end
    end
end

local function UpdateBackWeaponAttachmentForHash(hash)
    for propModelName, data in pairs(attached_weapons) do
        if data.hash == hash and DoesEntityExist(data.handle) then
            local base = GetOffsetsForWeapon(hash, isMeleeWeapon(propModelName), propModelName)
            local bone = GetPedBoneIndex(PlayerPedId(), SETTINGS.back_bone)

            AttachEntityToEntity(
                data.handle,
                PlayerPedId(),
                bone,
                base.x, base.y, base.z,
                base.xR, base.yR, base.zR,
                true, true, false, true, 1, true
            )

            ForceNoCollision(data.handle)
        end
    end
end

function DetachOne(attachModel)
    local data = attached_weapons[attachModel]
    if data then
        if data.netId then
            TriggerServerEvent('backweapons:unregister', data.netId)
        end
        if DoesEntityExist(data.handle) then
            DetachEntity(data.handle, true, true)
            DeleteObject(data.handle)
        end
        spawnedAttachedEntities[data.handle] = nil
        attached_weapons[attachModel] = nil
    end
end

local function DetachByHash(hash)
    for attachModel, data in pairs(attached_weapons) do
        if data.hash == hash then
            DetachOne(attachModel)
        end
    end
end

RegisterNetEvent("playerPeds:send")
AddEventHandler("playerPeds:send", function(data)
    playerPeds = data or {}
end)

local function GetMyBackableWeapons()
    local result = {}
    local plyData = ESX.GetPlayerData()
    if not plyData or not plyData.inventory then
        return result
    end

    local seen = {}

    for _, item in ipairs(plyData.inventory) do
        local count = item.count or 0
        if count > 0 then
            if string.sub(item.name, 1, 7) == "WEAPON_" then
                local weaponHash = GetHashKey(item.name)

                for _, compatHash in pairs(SETTINGS.compatable_weapon_hashes) do
                    if compatHash == weaponHash then
                        if not seen[weaponHash] then
                            table.insert(result, {
                                itemName = item.name,
                                label = item.label or item.name,
                                hash = weaponHash
                            })
                            seen[weaponHash] = true
                        end
                    end
                end
            end
        end
    end

    return result
end

function DetachBackWeaponByHash(hash)
    for attachModel, info in pairs(attached_weapons) do
        if info.hash == hash then
            if DoesEntityExist(info.handle) then
                DeleteObject(info.handle)
            end
            attached_weapons[attachModel] = nil
        end
    end
end

Citizen.CreateThread(function()
	while ESX == nil do
		TriggerEvent('esx:getShtozaredObjtozect', function(obj) ESX = obj end)
		Citizen.Wait(0)
	end
end)

Citizen.CreateThread(function()
	RMenu.Add('menu', 'f5menumain', RageUI.CreateMenu("SunLife", "Menu Personnel", 1, 100))
	RMenu.Add('menu', 'portefeuille', RageUI.CreateSubMenu(RMenu:Get('menu', 'f5menumain'), "SunLife", "Mes Informations"))
	RMenu.Add('menu', 'report', RageUI.CreateSubMenu(RMenu:Get('menu', 'f5menumain'), "SunLife", "Report"))
	RMenu.Add('menu', 'territory', RageUI.CreateSubMenu(RMenu:Get('menu', 'f5menumain'), "SunLife", "Territoires"))

	RMenu.Add('menu', 'portefeuille_work', RageUI.CreateSubMenu(RMenu:Get('menu', 'portefeuille'), "SunLife", "Mes Informations"))
	RMenu.Add('menu', 'myid', RageUI.CreateSubMenu(RMenu:Get('menu', 'portefeuille'), "SunLife", "Mes Informations"))
	RMenu.Add('menu', 'mypc', RageUI.CreateSubMenu(RMenu:Get('menu', 'portefeuille'), "SunLife", "Mes Informations"))
	RMenu.Add('menu', 'myppa', RageUI.CreateSubMenu(RMenu:Get('menu', 'portefeuille'), "SunLife", "Mes Informations"))
	RMenu.Add('menu', 'vip', RageUI.CreateSubMenu(RMenu:Get('menu', 'f5menumain'), "SunLife", "VIP"))
	RMenu.Add('menu', 'divers_options', RageUI.CreateSubMenu(RMenu:Get('menu', 'f5menumain'), "SunLife", "Divers"))
	RMenu.Add('menu', 'divers_vues', RageUI.CreateSubMenu(RMenu:Get('menu', 'divers_options'), "SunLife", "Vues"))
	RMenu.Add('menu', 'divers_touches', RageUI.CreateSubMenu(RMenu:Get('menu', 'divers_options'), "SunLife", "Divers"))
	RMenu.Add('menu', 'divers_radio', RageUI.CreateSubMenu(RMenu:Get('menu', 'divers_options'), "SunLife", "Paramètres radio"))
	RMenu.Add('menu', 'illegal', RageUI.CreateSubMenu(RMenu:Get('menu', 'f5menumain'), "SunLife", "Illegal"))
	RMenu.Add('menu', 'vehicule', RageUI.CreateSubMenu(RMenu:Get('menu', 'f5menumain'), "SunLife", "Menu Véhicule"))
	RMenu.Add('menu', 'vehicule_portes', RageUI.CreateSubMenu(RMenu:Get('menu', 'vehicule'), "SunLife", "Menu Véhicule"))
	RMenu.Add('menu', 'facture', RageUI.CreateSubMenu(RMenu:Get('menu', 'portefeuille'), "SunLife", "Historique de Facturation"))
	RMenu.Add('menu', 'avantages', RageUI.CreateSubMenu(RMenu:Get('menu', 'f5menumain'), "SunLife", "Mes Avantages"))
	RMenu.Add('menu', 'accdarmes', RageUI.CreateSubMenu(RMenu:Get('menu', 'avantages'), "SunLife", "Mes Accessoires"))

	RMenu.Add('menu', 'backweapons', RageUI.CreateSubMenu(RMenu:Get('menu', 'divers_options'), "Menu Personnel", "Armes dans le dos"))

	RMenu.Add('menu', 'avantages_peds', RageUI.CreateSubMenu(RMenu:Get('menu', 'avantages'), "Menu Personnel", "Mes Peds"))
	RMenu.Add('menu', 'avantages_peds_sub', RageUI.CreateSubMenu(RMenu:Get('menu', 'avantages_peds'), "Menu Personnel", "Actions"))

	RMenu.Add('menu', 'mySanctions', RageUI.CreateSubMenu(RMenu:Get('menu', 'f5menumain'), "SunLife", "Mes Avertissements"))
	RMenu.Add('menu', 'entreprises', RageUI.CreateSubMenu(RMenu:Get('menu', 'f5menumain'), "SunLife", "Entreprises"))

	RMenu:Get('menu', 'f5menumain'):SetRectangleBanner(255, 117, 31, 225)
	RMenu:Get('menu', 'territory'):SetRectangleBanner(255, 117, 31, 225)

	RMenu:Get('menu', 'report'):SetRectangleBanner(255, 117, 31, 225)
	RMenu:Get('menu', 'portefeuille'):SetRectangleBanner(255, 117, 31, 225)
	RMenu:Get('menu', 'myid'):SetRectangleBanner(255, 117, 31, 225)
	RMenu:Get('menu', 'mypc'):SetRectangleBanner(255, 117, 31, 225)
	RMenu:Get('menu', 'myppa'):SetRectangleBanner(255, 117, 31, 225)
	RMenu:Get('menu', 'vip'):SetRectangleBanner(255, 117, 31, 225)
	RMenu:Get('menu', 'divers_options'):SetRectangleBanner(255, 117, 31, 225)
	RMenu:Get('menu', 'illegal'):SetRectangleBanner(255, 117, 31, 225)
	RMenu:Get('menu', 'divers_vues'):SetRectangleBanner(255, 117, 31, 225)
	RMenu:Get('menu', 'divers_touches'):SetRectangleBanner(255, 117, 31, 225)
	RMenu:Get('menu', 'divers_radio'):SetRectangleBanner(255, 117, 31, 225)
	RMenu:Get('menu', 'vehicule'):SetRectangleBanner(255, 117, 31, 225)
	RMenu:Get('menu', 'vehicule_portes'):SetRectangleBanner(255, 117, 31, 225)
	RMenu:Get('menu', 'facture'):SetRectangleBanner(255, 117, 31, 225)
	RMenu:Get('menu', 'avantages'):SetRectangleBanner(255, 117, 31, 225)
	RMenu:Get('menu', 'accdarmes'):SetRectangleBanner(255, 117, 31, 225)
	RMenu:Get('menu', 'avantages_peds'):SetRectangleBanner(255, 117, 31, 225)
	RMenu:Get('menu', 'avantages_peds_sub'):SetRectangleBanner(255, 117, 31, 225)
	RMenu:Get('menu', 'backweapons'):SetRectangleBanner(255, 117, 31, 225)
	RMenu:Get('menu', 'portefeuille_work'):SetRectangleBanner(255, 117, 31, 225)
	RMenu:Get('menu', 'mySanctions'):SetRectangleBanner(255, 117, 31, 225)
	RMenu:Get('menu', 'entreprises'):SetRectangleBanner(255, 117, 31, 225)

    RMenu:Get('menu', 'f5menumain').EnableMouse = false
    RMenu:Get('menu', 'f5menumain').Closed = function()
		MenuOpened = false
    end
end)

RegisterNetEvent('esx:playerLoaded')
AddEventHandler('esx:playerLoaded', function(xPlayer)
	ESX.PlayerData = xPlayer
	MenuOpened = true
	TriggerServerEvent("ranks:getMine")
	Citizen.Wait(20000)
	MenuOpened = false
end)

RegisterNetEvent('esx:affiliateJob')
AddEventHandler('esx:affiliateJob', function(job)
	PlayerData.job = job
end)

RegisterNetEvent('esx:setAccountMoney')
AddEventHandler('esx:setAccountMoney', function(account)
	for i=1, #ESX.PlayerData.accounts, 1 do
		if ESX.PlayerData.accounts[i].name == account.name then
			ESX.PlayerData.accounts[i] = account
			break
		end
	end
end)

local territoriesToCatch = {}

local doorStates = {
	["Capot"] = {index = 4, isOpen = false},
	["Coffre"] = {index = 5, isOpen = false},
	["Porte avant-gauche"] = {index = 0, isOpen = false},
	["Porte avant-droite"] = {index = 1, isOpen = false},
	["Porte arrière-gauche"] = {index = 2, isOpen = false},
	["Porte arrière-droite"] = {index = 3, isOpen = false}
}

function firstToUpper(str)
    return (str:gsub("^%l", string.upper))
end

mySanctionsCache       = nil
mySanctionsCachedAt    = 0
mySanctionsFetching    = false
mySanctionsLastForceAt = 0
local MY_SANCTIONS_TTL          = 60
local MY_SANCTIONS_REFRESH_CD   = 10

function FetchMySanctions(force)
    if mySanctionsFetching then return end

    local now = GetGameTimer() / 1000
    if not force and mySanctionsCache and (now - mySanctionsCachedAt) < MY_SANCTIONS_TTL then
        return
    end

    if force then
        mySanctionsLastForceAt = now
    end

    mySanctionsFetching = true
    ESX.TriggerServerCallback('f5menu:getMySanctions', function(data)
        mySanctionsCache    = data or {}
        mySanctionsCachedAt = GetGameTimer() / 1000
        mySanctionsFetching = false
    end)
end

function MySanctionsRefreshCooldown()
    local now = GetGameTimer() / 1000
    local elapsed = now - mySanctionsLastForceAt
    if elapsed >= MY_SANCTIONS_REFRESH_CD then return 0 end
    return math.ceil(MY_SANCTIONS_REFRESH_CD - elapsed)
end

businessesCache       = nil
businessesList        = {}
businessesCachedAt    = 0
businessesFetching    = false
businessesLastForceAt = 0
local BUSINESSES_TTL        = 10
local BUSINESSES_REFRESH_CD = 5

local function businessesSortByLabel(a, b) return (a.label or "") < (b.label or "") end

function FetchBusinesses(force)
    if businessesFetching then return end

    local now = GetGameTimer() / 1000
    if not force and businessesCache and (now - businessesCachedAt) < BUSINESSES_TTL then
        return
    end

    if force then
        businessesLastForceAt = now
    end

    businessesFetching = true
    ESX.TriggerServerCallback('f5menu:getBusinessesStatus', function(data)
        businessesCache    = data or {}
        businessesCachedAt = GetGameTimer() / 1000
        businessesFetching = false

        local list = {}
        for i = 1, #businessesCache do
            list[i] = businessesCache[i]
        end
        table.sort(list, businessesSortByLabel)
        businessesList = list
    end)
end

function BusinessesRefreshCooldown()
    local now = GetGameTimer() / 1000
    local elapsed = now - businessesLastForceAt
    if elapsed >= BUSINESSES_REFRESH_CD then return 0 end
    return math.ceil(BUSINESSES_REFRESH_CD - elapsed)
end

local SANCTION_TYPE_LABELS = {
    jail = { prefix = "Jail", emoji = "🔒" },
    warn = { prefix = "Warn", emoji = "⚠️" },
    ban  = { prefix = "Ban",  emoji = "⛔" },
}

function FormatSanctionDuration(t, secondsValue)
    if t == 'jail' then
        local s = tonumber(secondsValue)
        if s and s > 0 then
            local mins = math.floor(s / 60)
            return mins .. " min"
        end
        return "—"
    elseif t == 'ban' then
        local d = tonumber(secondsValue)
        if d and d > 0 then return d .. " j" end
        return "Permanent"
    end
    return ""
end

local doorOptions = {"Capot", "Coffre", "Porte avant-gauche", "Porte avant-droite", "Porte arrière-gauche", "Porte arrière-droite"}
local currentDoorIndex = 1

-- Etat de la case "Afficher le boitier LVC" (F5 > Options). nil = a relire
-- depuis various_items a la prochaine ouverture du menu.
f5LvcShown = nil

function OpenF5Menu()
	if exports["sunlife"]:inJail() then
		MenuOpened = false
		return
	end

    if MenuOpened then
        MenuOpened = false
        return
    else
        MenuOpened = true
        f5LvcShown = nil
        RageUI.Visible(RMenu:Get('menu', 'f5menumain'), true)
		ESX.PlayerData = ESX.GetPlayerData()

		local ranks = ESX.PlayerData.rank or {}
		local hasDiamond = false
		local hasGold = false
		local hasPlatinium = false
		local hasLegendary = false

		for _, rankInfo in ipairs(ranks) do
			if rankInfo.name == "legendary" then
				hasLegendary = true
				break
			elseif rankInfo.name == "platinium" then
				hasPlatinium = true
				break
			elseif rankInfo.name == "diamond" then
				hasDiamond = true
				break
			elseif rankInfo.name == "gold" then
				hasGold = true
				break
			end
		end

        Citizen.CreateThread(function()
            while MenuOpened do
                RageUI.IsVisible(RMenu:Get('menu', 'f5menumain'), true, true, true, function()
					if hasDiamond == true then
						RageUI.Separator("Grade: VIP Diamond")
					elseif hasGold == true then
						RageUI.Separator("Grade: VIP Gold")
					elseif hasPlatinium == true then
						RageUI.Separator("Grade: VIP Platinium")
					elseif hasLegendary == true then
						RageUI.Separator("Grade: VIP Legendary")
					else
						RageUI.Separator("Grade: Aucun")
					end
                    RageUI.ButtonWithStyle("Portefeuille", "", { RightLabel = "📋" },true, function()
                    end, RMenu:Get('menu', 'portefeuille'))
					RageUI.ButtonWithStyle("Mes avantages boutique", "", { RightLabel = "✨" },true, function(h, a, s)
                    end, RMenu:Get('menu', 'avantages'))
					RageUI.ButtonWithStyle("Mes animaux", "", { RightLabel = "🐶" },true, function(Hovered, Active, Selected)
						if Selected then
							RageUI.CloseAll()
							MenuOpened = false
							TriggerEvent("playerPets:openMenu")
						end
                    end)
					RageUI.ButtonWithStyle("Mes quêtes", "", { RightLabel = "📈" },true, function(Hovered, Active, Selected)
						if Selected then
							RageUI.CloseAll()
							MenuOpened = false
							ExecuteCommand('quete')
						end
                    end)
					RageUI.ButtonWithStyle("Mes avertissements", "", { RightLabel = "⚖️" }, true, function(h, a, s)
						if s then
							FetchMySanctions(false)
						end
					end, RMenu:Get('menu', 'mySanctions'))
					RageUI.ButtonWithStyle("Entreprises", "", { RightLabel = "🏢" }, true, function(h, a, s)
						if s then
							FetchBusinesses(false)
						end
					end, RMenu:Get('menu', 'entreprises'))
					if IsPedSittingInAnyVehicle(PlayerPedId()) then
						RageUI.ButtonWithStyle("Gestion Véhicule", "", { RightLabel = "🚘" },true, function()
                    	end, RMenu:Get('menu', 'vehicule'))
					end
					RageUI.ButtonWithStyle("Options", nil, { RightLabel = "⚙️" }, true, function(Hovered, Active, Selected)
                    end, RMenu:Get('menu', 'divers_options'))
					RageUI.ButtonWithStyle("Illégal", nil, { RightLabel = "💣" },true, function(Hovered, Active, Selected)
                    end, RMenu:Get('menu', 'illegal'))

					if ActiveNote then
						RageUI.ButtonWithStyle("Notez votre dernier report", "", { RightLabel = "🚘" },true, function()
						end, RMenu:Get('menu', 'report'))
					end
                end, function()
                end)

				RageUI.IsVisible(RMenu:Get('menu', 'portefeuille'), true, true, true, function()
					RageUI.ButtonWithStyle("Emploi", nil, {RightLabel = ""..ESX.PlayerData.job.label.. " / " ..ESX.PlayerData.job.grade_label}, true, function(Hovered, Active, Selected)
                    end)

					RageUI.ButtonWithStyle("Organisation", nil, {RightLabel = firstToUpper(exports["sunlife_ui"]:GetMyGangName() or "Sans gang")}, true, function(Hovered, Active, Selected)
                    end)

					RageUI.ButtonWithStyle("Nom complet ", nil, {RightLabel = ESX.PlayerData.firstname.." "..ESX.PlayerData.lastname}, true, function(Hovered, Active, Selected)
                    end)

					if ESX.PlayerData.job ~= nil and ESX.PlayerData.job.grade_name == 'boss' then
						RageUI.ButtonWithStyle("Gestion d'entreprise", nil, {RightLabel = ""}, true, function(Hovered, Active, Selected)
                    	end, RMenu:Get('menu', 'portefeuille_work'))
					else
						RageUI.ButtonWithStyle("Gestion d'entreprise", nil, {RightBadge = RageUI.BadgeStyle.Lock}, true, function(Hovered, Active, Selected)
                    	end)
					end
					RageUI.ButtonWithStyle("Historique de Facturation", nil, { RightLabel = "📜" },true, function(h, a, s)
                    end, RMenu:Get('menu', 'facture'))
                end, function()
                end)

				RageUI.IsVisible(RMenu:Get('menu', 'mypc'), true, true, true, function()
					RageUI.ButtonWithStyle(('Montrer'), nil, {RightLabel = ""}, true, function(Hovered, Active, Selected)
						if (Active) then
							MarquerJoueur()
						end
						if (Selected) then
							local closestPlayer, closestDistance = ESX.Game.GetClosestPlayer()

							if closestDistance ~= -1 and closestDistance <= 3.0 then
								TriggerServerEvent('jsfour-idcard:open', GetPlayerServerId(PlayerId()), GetPlayerServerId(closestPlayer), 'drive')
							else
								ESX.ShowNotification(('Aucun joueur à proximité'))
							end
						end
					end)
					RageUI.ButtonWithStyle(('Regarder'), nil, {RightLabel = ""}, true, function(Hovered, Active, Selected)
						if (Active) then
							MarquerJoueur()
						end
						if (Selected) then
							TriggerServerEvent('jsfour-idcard:open', GetPlayerServerId(PlayerId()), GetPlayerServerId(PlayerId()), 'drive')
						end
					end)
				end, function()
				end)

				RageUI.IsVisible(RMenu:Get('menu', 'myppa'), true, true, true, function()
					RageUI.ButtonWithStyle(('Montrer'), nil, {RightLabel = ""}, true, function(Hovered, Active, Selected)
						if (Active) then
							MarquerJoueur()
						end
						if (Selected) then
							local closestPlayer, closestDistance = ESX.Game.GetClosestPlayer()

							if closestDistance ~= -1 and closestDistance <= 3.0 then
								TriggerServerEvent('jsfour-idcard:open', GetPlayerServerId(PlayerId()), GetPlayerServerId(closestPlayer), 'weapon')
							else
								ESX.ShowNotification(('Aucun joueur à proximité'))
							end
						end
					end)
					RageUI.ButtonWithStyle(('Regarder'), nil, {RightLabel = ""}, true, function(Hovered, Active, Selected)
						if (Active) then
							MarquerJoueur()
						end
						if (Selected) then
							TriggerServerEvent('jsfour-idcard:open', GetPlayerServerId(PlayerId()), GetPlayerServerId(PlayerId()), 'weapon')
						end
					end)
				end, function()
				end)

				RageUI.IsVisible(RMenu:Get('menu', 'portefeuille_work'), true, true, true, function()

					RageUI.Separator("Grade: " ..ESX.PlayerData.job.grade_label)

                    RageUI.ButtonWithStyle(('Recruter'), nil, {RightLabel = ""}, true, function(Hovered, Active, Selected)
						if (Selected) then
							local job =  ESX.PlayerData.job.name
							local grade = 0
							local closestPlayer, closestDistance = ESX.Game.GetClosestPlayer()
							if closestPlayer == -1 or closestDistance > 3.0 then
								ESX.ShowNotification("~r~Aucun joueur proche !")
						  	else
							  	TriggerServerEvent('inventory:recruterplayer', GetPlayerServerId(closestPlayer), job,grade)
						  	end
						end
					end)

					RageUI.ButtonWithStyle(('Virer'), nil, {RightLabel = ""}, true, function(Hovered, Active, Selected)
						if (Selected) then
							local job =  ESX.PlayerData.job.name
							local grade = 0
							local closestPlayer, closestDistance = ESX.Game.GetClosestPlayer()
							if closestPlayer == -1 or closestDistance > 3.0 then
								ESX.ShowNotification("~r~Aucun joueur proche !")
						  	else
							 	TriggerServerEvent('inventory:virerplayer', GetPlayerServerId(closestPlayer))
						  	end
						end
					end)

					RageUI.ButtonWithStyle(('Promouvoir'), nil, {RightLabel = ""}, true, function(Hovered, Active, Selected)
						if (Selected) then
							local job =  ESX.PlayerData.job.name
							local grade = 0
							local closestPlayer, closestDistance = ESX.Game.GetClosestPlayer()
							if closestPlayer == -1 or closestDistance > 3.0 then
								ESX.ShowNotification("~r~Aucun joueur proche !")
						  	else
							 	TriggerServerEvent('inventory:promouvoirplayer', GetPlayerServerId(closestPlayer))
						  	end
						end
					end)

					RageUI.ButtonWithStyle(('Destituer'), nil, {RightLabel = ""}, true, function(Hovered, Active, Selected)
						if (Selected) then
							local job =  ESX.PlayerData.job.name
							local grade = 0
							local closestPlayer, closestDistance = ESX.Game.GetClosestPlayer()
							if closestPlayer == -1 or closestDistance > 3.0 then
								ESX.ShowNotification("~r~Aucun joueur proche !")
						  	else
							 	TriggerServerEvent('inventory:destituerplayer', GetPlayerServerId(closestPlayer))
						  	end
						end
					end)

				end, function()
				end)

				RageUI.IsVisible(RMenu:Get('menu', 'territory'), true, true, true, function()
					for key, value in pairs(territoriesToCatch) do
						if value == "none" then
							RageUI.ButtonWithStyle((key).." Leader: Aucun", "", {}, true, function()
							end)
						elseif  value == "unemployed2" then
							RageUI.ButtonWithStyle((key).." Leader: Sans groupe", "", {}, true, function()
							end)
						else
							RageUI.ButtonWithStyle((key).." Leader: "..value, "", {}, true, function()
							end)
						end
					end
				end,function()
				end)

				RageUI.IsVisible(RMenu:Get('menu', 'facture'), true, true, true, function()
					local paidBills = exports.sCore:getPaidBills()

					if paidBills and #paidBills > 0 then
						for _, bill in ipairs(paidBills) do
							local buttonText = "Facture: " .. bill.jobLabel
							local buttonDescription = "Montant: " .. bill.amount .. " $"

							RageUI.ButtonWithStyle(buttonText, buttonDescription, {RightLabel = "✔️"}, true, function()
							end, nil)
						end
					else
						RageUI.ButtonWithStyle("Aucune facture", "Vous n'avez aucune facture payée.", {RightLabel = "❌"}, true, function()
						end, nil)
					end
				end,function()
				end)

				RageUI.IsVisible(RMenu:Get('menu', 'mySanctions'), true, true, true, function()
					if mySanctionsFetching and not mySanctionsCache then
						RageUI.Separator("Chargement...")
						return
					end

					local sanctions = mySanctionsCache or {}

					local nbJail, nbWarn, nbBan = 0, 0, 0
					for i = 1, #sanctions do
						local t = sanctions[i].type
						if t == 'jail' then nbJail = nbJail + 1
						elseif t == 'warn' then nbWarn = nbWarn + 1
						elseif t == 'ban' then nbBan = nbBan + 1 end
					end

					RageUI.Separator(("%d Jail  |  %d Warn  |  %d Ban"):format(nbJail, nbWarn, nbBan))

					if nbJail >= 15 then
						RageUI.Separator("⚠ Ban permanent automatique à 20 jails / 2 mois")
					end

					local cdLeft = MySanctionsRefreshCooldown()
					RageUI.ButtonWithStyle(
						"Actualiser",
						"",
						{ RightLabel = cdLeft > 0 and (cdLeft .. "s") or "🔄" },
						cdLeft == 0,
						function(h, a, s)
							if s and MySanctionsRefreshCooldown() == 0 then
								FetchMySanctions(true)
							end
						end
					)

					if #sanctions == 0 then
						RageUI.ButtonWithStyle("Aucune sanction", "Vous n'avez aucune sanction sur les 2 derniers mois.", { RightLabel = "✅" }, true, function() end)
					else
						for i = 1, #sanctions do
							local s = sanctions[i]
							local meta = SANCTION_TYPE_LABELS[s.type] or { prefix = s.type or "?", emoji = "•" }
							local reason = s.reason or "Aucune raison"
							local staff = s.staff_name or "Inconnu"
							local date = s.timestamp or "Date inconnue"
							local expires = s.expires or "—"
							local durStr = FormatSanctionDuration(s.type, s.duration)
							local title = ("%s %s : %s"):format(meta.emoji, meta.prefix, reason)
							local desc = ("Date: %s~n~Expire le: %s~n~Staff: %s~n~Durée: %s"):format(date, expires, staff, durStr ~= "" and durStr or "—")

							RageUI.ButtonWithStyle(title, desc, { RightLabel = durStr }, true, function() end)
						end
					end
				end, function()
				end)

				RageUI.IsVisible(RMenu:Get('menu', 'entreprises'), true, true, true, function()
					if businessesFetching and not businessesCache then
						RageUI.Separator("Chargement...")
						return
					end

					local cdLeft = BusinessesRefreshCooldown()
					RageUI.ButtonWithStyle(
						"Actualiser",
						"",
						{ RightLabel = cdLeft > 0 and (cdLeft .. "s") or "🔄" },
						cdLeft == 0,
						function(h, a, s)
							if s and BusinessesRefreshCooldown() == 0 then
								FetchBusinesses(true)
							end
						end
					)

					if #businessesList == 0 then
						RageUI.ButtonWithStyle("Aucune entreprise", "", { RightLabel = "" }, true, function() end)
					else
						for i = 1, #businessesList do
							local b = businessesList[i]
							local statusLabel = b.open and "~g~Ouvert" or "~r~Fermé"
							RageUI.ButtonWithStyle(b.label or "?", "", { RightLabel = statusLabel }, true, function() end)
						end
					end
				end, function()
				end)

				RageUI.IsVisible(RMenu:Get('menu', 'avantages'), true, true, true, function()
					local ranks = ESX.PlayerData.rank or {}
					local diamond = false
					local gold = false
					local platinium = false
					local legendary = false
					local garageillimite = false
					local boostfarm125 = false
					local boostfarmx2 = false
					local tourderouex2 = false
					local accarmes = false
					local hasAdvantage = false
					local hasCardGreen = false
					local hasCardBlue = false
					local hasCardGold = false

					for _, rankInfo in ipairs(ranks) do
						if rankInfo.name == "diamond" then
							diamond = true
							hasAdvantage = true
						elseif rankInfo.name == "legendary" then
							legendary = true
							hasAdvantage = true
						elseif rankInfo.name == "platinium" then
							platinium = true
							hasAdvantage = true
						elseif rankInfo.name == "gold" then
							gold = true
							hasAdvantage = true
						elseif rankInfo.name == "garageillimite" then
							garageillimite = true
							hasAdvantage = true
						elseif rankInfo.name == "tourderouex2" then
							tourderouex2 = true
							hasAdvantage = true
						elseif rankInfo.name == "boostfarmx2" then
							boostfarmx2 = true
							hasAdvantage = true
						elseif rankInfo.name == "boostfarm125" then
							boostfarmx125 = true
							hasAdvantage = true
						elseif rankInfo.name == "accarmes" then
							accarmes = true
							hasAdvantage = true
						elseif rankInfo.name == "cardgreen" then
							hasCardGreen = true
							hasAdvantage = true
						elseif rankInfo.name == "cardblue" then
							hasCardBlue = true
							hasAdvantage = true
						elseif rankInfo.name == "cardgold" then
							hasCardGold = true
							hasAdvantage = true
						end
					end

					RageUI.ButtonWithStyle("Mes peds jouables", nil, { RightLabel = "👤" }, true, function(Hovered, Active, Selected)
						if Selected then
							TriggerServerEvent("playerPeds:get")
						end
					end, RMenu:Get('menu', 'avantages_peds'))

					if legendary == true then
						RageUI.ButtonWithStyle("~h~VIP Legendary", "", { RightLabel = "👑" },true, function(Hovered, Active, Selected)
						end, RMenu:Get('menu', 'vip'))
					else
						RageUI.ButtonWithStyle("~c~VIP Legendary", "", { RightLabel = "🔒" },true, function(Hovered, Active, Selected)
						end)
					end

					if platinium == true then
						RageUI.ButtonWithStyle("~h~VIP Platinium", "", { RightLabel = "⚡" },true, function(Hovered, Active, Selected)
						end, RMenu:Get('menu', 'vip'))
					else
						RageUI.ButtonWithStyle("~c~VIP Platinium", "", { RightLabel = "🔒" },true, function(Hovered, Active, Selected)
						end)
					end

					if diamond == true then
						RageUI.ButtonWithStyle("~h~VIP Diamant", "", { RightLabel = "💎" },true, function(Hovered, Active, Selected)
						end, RMenu:Get('menu', 'vip'))
					else
						RageUI.ButtonWithStyle("~c~VIP Diamant", "", { RightLabel = "🔒" },true, function(Hovered, Active, Selected)
						end)
					end

					if gold == true then
						RageUI.ButtonWithStyle("~h~VIP Gold", "", { RightLabel = "🏅" },true, function(Hovered, Active, Selected)
						end, RMenu:Get('menu', 'vip'))
					else
						RageUI.ButtonWithStyle("~c~VIP Gold", "", { RightLabel = "🔒" },true, function(Hovered, Active, Selected)
						end)
					end

					if garageillimite == true then
						RageUI.ButtonWithStyle("~h~Garage Illimité", "", { RightLabel = "🚘" },true, function()
						end)
					else
						RageUI.ButtonWithStyle("~c~Garage Illimité", "", { RightLabel = "🔒" },true, function()
						end)
					end

					if accarmes == true then
						RageUI.ButtonWithStyle("~h~Menu des accessoires d'armes", "", { RightLabel = "⚔️" },true, function()
						end, RMenu:Get('menu', 'accdarmes'))
					else
						RageUI.ButtonWithStyle("~c~Menu des accessoires d'armes", "", { RightLabel = "🔒" },true, function()
						end)
					end

					if hasCardGreen == true then
						RageUI.ButtonWithStyle("~h~Green card", "", { RightLabel = "💚" },true, function()
						end)
					else
						RageUI.ButtonWithStyle("~c~Green card", "", { RightLabel = "🔒" },true, function()
						end)
					end

					if hasCardBlue == true then
						RageUI.ButtonWithStyle("~h~Blue card", "", { RightLabel = "💙" },true, function()
						end)
					else
						RageUI.ButtonWithStyle("~c~Blue card", "", { RightLabel = "🔒" },true, function()
						end)
					end

					if hasCardGold == true then
						RageUI.ButtonWithStyle("~h~Gold Card", "", { RightLabel = "💛" },true, function()
						end)
					else
						RageUI.ButtonWithStyle("~c~Gold Card", "", { RightLabel = "🔒" },true, function()
						end)
					end

				end,function()
				end)

				RageUI.IsVisible(RMenu:Get('menu', 'avantages_peds'), true, true, true, function()
					if #playerPeds == 0 then
						RageUI.ButtonWithStyle("Aucun ped acheté", nil, {RightLabel = "❌"}, true, function() end)
					else
						for _, v in pairs(playerPeds) do
							RageUI.ButtonWithStyle(v.label or v.model or "Ped", v.model or "", {RightLabel = "→→→"}, true, function(Hovered, Active, Selected)
								if Selected then
									myPedItem = v
								end
							end, RMenu:Get('menu', 'avantages_peds_sub'))
						end
					end
				end, function() end)

				RageUI.IsVisible(RMenu:Get('menu', 'avantages_peds_sub'), true, true, true, function()
					RageUI.Separator((myPedItem.label or myPedItem.model or "Ped"))
					RageUI.ButtonWithStyle("Devenir ce ped", nil, {RightLabel = "✔️"}, myPedItem.model ~= nil, function(Hovered, Active, Selected)
						if Selected then
							if #(GetEntityCoords(PlayerPedId()) - vector3(211.236557, -816.063660, 30.746836)) > 100.0 then
								ESX.ShowNotification("~r~Vous devez être au ~y~Parking Central ~r~pour changer de ped")
								return
							end
							BecomePedModel(myPedItem.model)
						end
					end)
					RageUI.ButtonWithStyle("Revenir à mon skin", nil, {RightLabel = "→"}, true, function(Hovered, Active, Selected)
						if Selected then
							if #(GetEntityCoords(PlayerPedId()) - vector3(211.236557, -816.063660, 30.746836)) > 100.0 then
								ESX.ShowNotification("~r~Vous devez être au ~y~Parking Central ~r~pour changer de ped")
								return
							end
							RestoreMySkin()
						end
					end)
				end, function() end)

				RageUI.IsVisible(RMenu:Get('menu', 'vip'), true, true, true, function()

					RageUI.ButtonWithStyle("Sortir une boombox", nil, {RightLabel = "~y~VIP"}, true, function(Hovered, Active, Selected)
						if (Selected) then
							TriggerEvent("item:useBoombox")
                        	RageUI.CloseAll()
                        	MenuOpened = false
                        end
                    end)

					RageUI.ButtonWithStyle("Sortir un scooter d'urgence", nil, {RightLabel = "~y~VIP"}, true, function(Hovered, Active, Selected)
						if (Selected) then
							local ped = PlayerPedId()
							local PlayerScoot = GetEntityCoords(ped)

							if scoot == true then
								ESX.ShowNotification('~r~Vous avez déja sorti le véhicule !')
							else
								ESX.Game.SpawnVehicle("faggio", PlayerScoot, 180.0, function(vehicle)
									SetVehicleNumberPlateText(vehicle, "FAGGIO")
									scoot = true
									CreateThread(function ()
										Wait(30* 60 * 1000)
										scoot = false
									end)
								end)
							end
                        end
                    end)

					RageUI.ButtonWithStyle("Pot d'échappement Sport+", nil, {RightLabel = "~y~VIP"}, true, function(Hovered, Active, Selected)
						if (Selected) then
							ExecuteCommand("antilag")
                        end
                    end)

					RageUI.ButtonWithStyle("Activer/Désactiver le mode drift", nil, {RightLabel = "~y~VIP Diamond ou +"}, true, function(Hovered, Active, Selected)
						if (Selected) then
							ExecuteCommand("toggleDriftMode")
                        end
                    end)
					RageUI.ButtonWithStyle("Activer/Désactiver l'autopilote normal", nil, {RightLabel = "~y~VIP Legendary"}, true, function(Hovered, Active, Selected)
						if (Selected) then
							ExecuteCommand("+normalautopilot")
                        end
                    end)
					RageUI.ButtonWithStyle("Activer/Désactiver l'autopilote agressif", nil, {RightLabel = "~y~VIP Legendary"}, true, function(Hovered, Active, Selected)
						if (Selected) then
							ExecuteCommand("+crazyautopilot")
                        end
                    end)
					RageUI.ButtonWithStyle("Activer/Désactiver le Nitro", nil, {RightLabel = "~y~VIP Platinium ou +"}, true, function(Hovered, Active, Selected)
						if (Selected) then
							ExecuteCommand("+toggleNitro")
                        end
                    end)

					RageUI.ButtonWithStyle("Mode photo", "Également accessible sur ~y~F3~s~.", {RightLabel = "~y~VIP Gold ou +"}, true, function(Hovered, Active, Selected)
						if (Selected) then
							RageUI.CloseAll()
							MenuOpened = false
							TriggerServerEvent("photomode:openPhotoMode")
						end
					end)
                end, function()
				end)

				RageUI.IsVisible(RMenu:Get('menu', 'accdarmes'), true, true, true, function()
					local weapon     = GetAccWeapon()
					local weaponName = weapon and weapon.name

					-- L'arme doit etre en main : c'est elle que le ped porte, et
					-- c'est la seule sur laquelle l'accessoire est visible tout de suite.
					if type(weaponName) ~= "string" or GetSelectedPedWeapon(PlayerPedId()) ~= GetHashKey(weaponName) then
						RageUI.Separator("~r~Aucune arme en main")
						RageUI.ButtonWithStyle("Sortez une arme du jeu", "Equipez l'arme puis revenez dans ce menu.", { RightLabel = "❌" }, true, function() end)
						return
					end

					-- Catalogue vanilla uniquement : une arme addon (boutique) n'y
					-- figure pas, ses accessoires s'achetent dans la boutique.
					local list = F5WeaponAcc.Get(weaponName)
					if not list or #list == 0 then
						RageUI.Separator("~o~Arme non compatible")
						RageUI.ButtonWithStyle("Aucun accessoire disponible", "Cet avantage ne couvre que les armes du jeu. Pour une arme boutique, passez par la boutique.", { RightLabel = "🔒" }, true, function() end)
						return
					end

					local metadatas   = weapon.metadatas or {}
					local attachments = metadatas.attachments or {}

					RageUI.Separator((weaponName:gsub("^WEAPON_", "")))

					for i = 1, #list do
						local acc       = list[i]
						local installed = attachments[acc.category] == acc.hash

						RageUI.ButtonWithStyle(
							acc.name,
							installed and "Sélectionnez pour retirer cet accessoire." or "Sélectionnez pour poser cet accessoire.",
							{ RightLabel = installed and "✅" or "⚔️" },
							true,
							function(Hovered, Active, Selected)
								if Selected then
									InvalidateAccWeapon()
									TriggerServerEvent('sunlife:weaponAcc:toggle', {
										weapon      = weaponName,
										id          = metadatas.id,
										category    = acc.category,
										componentID = acc.hash,
										remove      = installed,
									})
								end
							end
						)
					end
				end, function()
				end)

				RageUI.IsVisible(RMenu:Get('menu', 'illegal'), true, true, true, function()
					RageUI.ButtonWithStyle("Territoires illégaux", nil, { RightLabel = "🗺️" },true, function(Hovered, Active, Selected)
						if Selected then
							TriggerEvent("rg_core:client:actdeactterritory")
							if current == nil then current = false end
							current = not current
							exports.sunlife:SetTerritorieMap(current)
						end
					end)
					RageUI.Checkbox("Vente de drogues", false, drugSell, { RightLabel = "  🧪" }, function ()
					end, function ()
						drugSell = true
						TriggerEvent("DRUGTERRAIN.onOpen")
					end, function ()
						drugSell = false
						TriggerEvent("DRUGTERRAIN.forceClose")
					end)
				end, function()
				end)

				RageUI.IsVisible(RMenu:Get('menu', 'report'), true, true, true, function()
					RageUI.ButtonWithStyle("⭐️", nil, {}, true, function(Hovered, Active, Selected)
						if (Selected) then
							TriggerServerEvent("SendAvis", StaffName, messagereport, "⭐️")
							ESX.ShowNotification("Merci pour votre retour!")
                        	RageUI.CloseAll()
                        	MenuOpened = false
							ActiveNote = false
                        end
                    end)
					RageUI.ButtonWithStyle("⭐️⭐️", nil, {}, true, function(Hovered, Active, Selected)
						if (Selected) then
							TriggerServerEvent("SendAvis", StaffName, messagereport, "⭐️⭐️")
							ESX.ShowNotification("Merci pour votre retour!")
                        	RageUI.CloseAll()
                        	MenuOpened = false
							ActiveNote = false
                        end
                    end)
					RageUI.ButtonWithStyle("⭐️⭐️⭐️", nil, {}, true, function(Hovered, Active, Selected)
						if (Selected) then
							TriggerServerEvent("SendAvis", StaffName, messagereport, "⭐️⭐️⭐️")
							ESX.ShowNotification("Merci pour votre retour!")
                        	RageUI.CloseAll()
                        	MenuOpened = false
							ActiveNote = false
                        end
                    end)
					RageUI.ButtonWithStyle("⭐️⭐️⭐️⭐️", nil, {}, true, function(Hovered, Active, Selected)
						if (Selected) then
							TriggerServerEvent("SendAvis", StaffName, messagereport, "⭐️⭐️⭐️⭐️")
							ESX.ShowNotification("Merci pour votre retour!")
                        	RageUI.CloseAll()
							MenuOpened = false
							ActiveNote = false
						end
                    end)
					RageUI.ButtonWithStyle("⭐️⭐️⭐️⭐️⭐️", nil, {}, true, function(Hovered, Active, Selected)
						if (Selected) then
							TriggerServerEvent("SendAvis", StaffName, messagereport, "⭐️⭐️⭐️⭐️⭐️")
							ESX.ShowNotification("Merci pour votre retour!")
                        	RageUI.CloseAll()
                        	MenuOpened = false
							ActiveNote = false
                        end
                    end)
                end, function()
				end)

				RageUI.IsVisible(RMenu:Get('menu', 'divers_options'), true, true, true, function()

					RageUI.ButtonWithStyle("Armes dans le dos", "Choisir quelles armes restent visibles dans ton dos", { RightLabel = "🎒" }, true, function(Hovered, Active, Selected)
					end, RMenu:Get('menu', 'backweapons'))

					RageUI.ButtonWithStyle("Paramètres radio", nil, { RightLabel = "📻" }, true, function() end, RMenu:Get('menu', 'divers_radio'))

					-- Boitier LVC (sirenes + radars) : affiche / masque. Etat persistant
					-- cote various_items (KVP), lu a chaque ouverture du menu.
					if f5LvcShown == nil then
						f5LvcShown = true
						if GetResourceState('various_items') == 'started' then
							local ok, v = pcall(function() return exports['various_items']:GetLvcHudVisible() end)
							if ok and v == false then f5LvcShown = false end
						end
					end
					RageUI.Checkbox("Afficher le boîtier LVC", "Panneau sirènes / radars des véhicules d'urgence", f5LvcShown, { RightLabel = "🚨" }, function() end, function()
						f5LvcShown = true
						pcall(function() exports['various_items']:SetLvcHudVisible(true) end)
						ESX.ShowNotification("Boîtier LVC ~g~affiché~s~.")
					end, function()
						f5LvcShown = false
						pcall(function() exports['various_items']:SetLvcHudVisible(false) end)
						ESX.ShowNotification("Boîtier LVC ~r~masqué~s~.")
					end)

					RageUI.Slider("Performance (LOD)", lod, 55, "Chargement des LOD, plus bas = + FPS, mais un jeu moins beau", false, {}, true, function(Hovered, Active, Selected, value)
						if lod ~= value then
							lod = value
							TriggerEvent("F5:client:PerfChangeLod", 0.45 + (lod / 100))
						end
					end)

					RageUI.ButtonWithStyle("Touches par défaut", nil, {}, true, function(Hovered, Active, Selected)
                    end, RMenu:Get('menu', 'divers_touches'))
					RageUI.ButtonWithStyle("Activer/Désactiver l'HUD", nil, {}, true, function(Hovered, Active, Selected)
						if (Selected) then
							-- On lit l'etat reel du HUD au lieu d'un drapeau local qui
							-- demarrait a "cache" alors que le HUD est affiche par defaut
							-- (il fallait appuyer 2 fois pour le cacher).
							local visible = hud
							local ok, v = pcall(function() return exports['sunlife_ui']:IsStatusHUDVisible() end)
							if ok and v ~= nil then visible = v == true end

							if visible then
								TriggerEvent("statushud:all:hide")
								hud = false
								ESX.ShowNotification("HUD ~r~masqué~s~.")
							else
								TriggerEvent("statushud:all:show")
								hud = true
								ESX.ShowNotification("HUD ~g~affiché~s~.")
							end
                        end
                    end)
					RageUI.ButtonWithStyle("Activer/Désactiver la minimap", nil, {}, true, function(Hovered, Active, Selected)
						if (Selected) then
							if minimap == false then
								DisplayRadar(false)
								minimap = true
							elseif minimap == true then
								DisplayRadar(true)
								minimap = false
							end
                        end
                    end)
					RageUI.ButtonWithStyle("Voir mon niveau", nil, {}, true, function(Hovered, Active, Selected)
						if (Selected) then
							ExecuteCommand("seemylevel")
                        end
                    end)
					RageUI.ButtonWithStyle("Vues", nil, {}, true, function(Hovered, Active, Selected)
                    end, RMenu:Get('menu', 'divers_vues'))

					RageUI.ButtonWithStyle("Voir mes compétences", nil, {}, true, function(Hovered, Active, Selected)
						if Selected then
							local s = exports['sunlife_ui']:GetGymStats()
							if s then
								ESX.ShowNotification(("~o~Compétences salle de sport~s~\nForce: ~o~%d~s~\nVitesse: ~o~%d~s~\nEndurance: ~o~%d"):format(
									s.strength or 0,
									s.speed or 0,
									s.stamina or 0
								))
							else
								ESX.ShowNotification("~r~Impossible de récupérer tes compétences.")
							end
						end
					end)

					RageUI.ButtonWithStyle("Activer/Désactiver le mode drift", nil, {}, true, function(Hovered, Active, Selected)
						if (Selected) then
							ExecuteCommand("toggleDriftMode")
                        end
                    end)
					RageUI.ButtonWithStyle("Activer/Désactiver l'autopilote normal", nil, {}, true, function(Hovered, Active, Selected)
						if (Selected) then
							ExecuteCommand("+normalautopilot")
                        end
                    end)
					RageUI.ButtonWithStyle("Activer/Désactiver l'autopilote agressif", nil, {}, true, function(Hovered, Active, Selected)
						if (Selected) then
							ExecuteCommand("+crazyautopilot")
                        end
                    end)
					RageUI.ButtonWithStyle("Activer/Désactiver le Nitro", nil, {}, true, function(Hovered, Active, Selected)
						if (Selected) then
							ExecuteCommand("+toggleNitro")
                        end
                    end)
					RageUI.ButtonWithStyle("Rockstar Editor", nil, {}, true, function(Hovered, Active, Selected)
						if (Selected) then
							-- Fermer le F5 AVANT d'ouvrir le sous-menu : dans l'autre sens, CloseAll()
							-- refermait aussitôt le menu Rockstar Editor qui venait de s'ouvrir.
							RageUI.CloseAll()
                        	MenuOpened = false
							openRockstarEditorMenu()
                        end
                    end)
					RageUI.Checkbox("Activer/Désactiver les sons ambiants", false, drugSell, { RightLabel = "" }, function()
					end, function ()
						ambiantSounds = true
						Citizen.CreateThread(function()
							    SetStaticEmitterEnabled("LOS_SANTOS_VANILLA_UNICORN_01_STAGE", true)
							    SetStaticEmitterEnabled("LOS_SANTOS_VANILLA_UNICORN_02_MAIN_ROOM", true)
							    SetStaticEmitterEnabled("LOS_SANTOS_VANILLA_UNICORN_03_BACK_ROOM", true)
							    SetAmbientZoneListStatePersistent("AZL_DLC_Hei4_Island_Disabled_Zones", true, false)
							    SetAmbientZoneListStatePersistent("AZL_DLC_Hei4_Island_Zones", false, false)
							    SetScenarioTypeEnabled("WORLD_VEHICLE_STREETRACE", true)
							    SetScenarioTypeEnabled("WORLD_VEHICLE_SALTON_DIRT_BIKE", true)
							    SetScenarioTypeEnabled("WORLD_VEHICLE_SALTON", true)
							    SetScenarioTypeEnabled("WORLD_VEHICLE_POLICE_NEXT_TO_CAR", true)
							    SetScenarioTypeEnabled("WORLD_VEHICLE_POLICE_CAR", true)
							    SetScenarioTypeEnabled("WORLD_VEHICLE_POLICE_BIKE", true)
							    SetScenarioTypeEnabled("WORLD_VEHICLE_MILITARY_PLANES_SMALL", true)
							    SetScenarioTypeEnabled("WORLD_VEHICLE_MILITARY_PLANES_BIG", true)
							    SetScenarioTypeEnabled("WORLD_VEHICLE_MECHANIC", true)
							    SetScenarioTypeEnabled("WORLD_VEHICLE_EMPTY", true)
							    SetScenarioTypeEnabled("WORLD_VEHICLE_BUSINESSMEN", true)
							    SetScenarioTypeEnabled("WORLD_VEHICLE_BIKE_OFF_ROAD_RACE", true)
							    StartAudioScene("FBI_HEIST_H5_MUTE_AMBIENCE_SCENE")
							    StartAudioScene("CHARACTER_CHANGE_IN_SKY_SCENE")
							    SetAudioFlag("PoliceScannerDisabled", false)
							    SetAudioFlag("DisableFlightMusic", false)
							    SetPlayerCanUseCover(PlayerId(), true)
							    SetRandomEventFlag(true)
							    SetDeepOceanScaler(1.0)
							end)
					end, function ()
						ambiantSounds = false
						Citizen.CreateThread(function()
							StartAudioScene("DLC_MPHEIST_TRANSITION_TO_APT_FADE_IN_RADIO_SCENE")
							SetStaticEmitterEnabled("LOS_SANTOS_VANILLA_UNICORN_01_STAGE", false)
							SetStaticEmitterEnabled("LOS_SANTOS_VANILLA_UNICORN_02_MAIN_ROOM", false)
							SetStaticEmitterEnabled("LOS_SANTOS_VANILLA_UNICORN_03_BACK_ROOM", false)
							SetAmbientZoneListStatePersistent("AZL_DLC_Hei4_Island_Disabled_Zones", false, true)
							SetAmbientZoneListStatePersistent("AZL_DLC_Hei4_Island_Zones", true, true)
							SetScenarioTypeEnabled("WORLD_VEHICLE_STREETRACE", false)
							SetScenarioTypeEnabled("WORLD_VEHICLE_SALTON_DIRT_BIKE", false)
							SetScenarioTypeEnabled("WORLD_VEHICLE_SALTON", false)
							SetScenarioTypeEnabled("WORLD_VEHICLE_POLICE_NEXT_TO_CAR", false)
							SetScenarioTypeEnabled("WORLD_VEHICLE_POLICE_CAR", false)
							SetScenarioTypeEnabled("WORLD_VEHICLE_POLICE_BIKE", false)
							SetScenarioTypeEnabled("WORLD_VEHICLE_MILITARY_PLANES_SMALL", false)
							SetScenarioTypeEnabled("WORLD_VEHICLE_MILITARY_PLANES_BIG", false)
							SetScenarioTypeEnabled("WORLD_VEHICLE_MECHANIC", false)
							SetScenarioTypeEnabled("WORLD_VEHICLE_EMPTY", false)
							SetScenarioTypeEnabled("WORLD_VEHICLE_BUSINESSMEN", false)
							SetScenarioTypeEnabled("WORLD_VEHICLE_BIKE_OFF_ROAD_RACE", false)
							StartAudioScene("FBI_HEIST_H5_MUTE_AMBIENCE_SCENE")
							StartAudioScene("CHARACTER_CHANGE_IN_SKY_SCENE")
							SetAudioFlag("PoliceScannerDisabled", true)
							SetAudioFlag("DisableFlightMusic", true)
							SetPlayerCanUseCover(PlayerId(), false)
							SetRandomEventFlag(false)
							SetDeepOceanScaler(0.0)
						end)
					end)
                end, function()
				end)

				RageUI.IsVisible(RMenu:Get('menu', 'backweapons'), true, true, true, function()
					local ownedBackables = GetMyBackableWeapons()
					if #ownedBackables == 0 then
						RageUI.ButtonWithStyle("Aucune arme compatible", "Tu n'as pas d'arme longue sur toi", {RightLabel = "❌"}, true, function() end)
					else
						for _, w in ipairs(ownedBackables) do
							local state = BackWeaponAllowed[w.hash] == true
							RageUI.Checkbox(w.label, false, state, { RightLabel = "" }, function() end, function()
								BackWeaponAllowed[w.hash] = true
							end, function()
								BackWeaponAllowed[w.hash] = false
								DetachBackWeaponByHash(w.hash)
								if EditingBackWeaponHash == w.hash then
									EditingBackWeaponHash = nil
								end
							end)

							if state then
								local editing = (EditingBackWeaponHash == w.hash)
								local rl = editing and "~g~[EDITION]" or "🛠"
								RageUI.ButtonWithStyle(
									"Ajuster "..w.label,
									"↑↓←→ pour déplacer l'arme sur ton dos\nEntrée pour valider",
									{ RightLabel = rl },
									true,
									function(Hovered, Active, Selected)
										if Selected then
											if EditingBackWeaponHash == w.hash then
												EditingBackWeaponHash = nil
											else
												EditingBackWeaponHash = w.hash

												if not BackWeaponOffsets[w.hash] then
													BackWeaponOffsets[w.hash] = {
														x = SETTINGS.x,
														y = SETTINGS.y,
														z = SETTINGS.z,
														xR = SETTINGS.x_rotation,
														yR = SETTINGS.y_rotation,
														zR = SETTINGS.z_rotation
													}
												end

												ReattachHashNow(w.hash)

												RageUI.CloseAll()
												MenuOpened = false
											end
										end
									end
								)
							end
						end
					end
				end, function() end)

				RageUI.IsVisible(RMenu:Get('menu', 'divers_radio'), true, true, true, function()

					if not radioOptions then
						radioOptions = exports['sunlife']:GetRadioAnimOptions() or {}
						radioLabels = {}
						for i,v in ipairs(radioOptions) do radioLabels[i] = v.label end
						local currentKey = exports['sunlife']:GetRadioAnim() or 'shoulder'
						radioIndex = findIndexByKey(radioOptions, currentKey)
					end

					RageUI.List("Animation radio", radioLabels or {"…"}, radioIndex, "Animation jouée quand tu parles à la radio", {}, true,
						function(Hovered, Active, Selected, Index)
							radioIndex = Index
							if Selected and radioOptions[radioIndex] then
								local ok = exports['sunlife']:SetRadioAnim(radioOptions[radioIndex].key)
								if ok then
									ESX.ShowNotification(("Animation radio: ~y~%s~s~"):format(radioOptions[radioIndex].label))
								else
									ESX.ShowNotification("~r~Impossible de changer l'animation.")
								end
							end
						end
					)
				end, function()
				end)

				RageUI.IsVisible(RMenu:Get('menu', 'divers_touches'), true, true, true, function()
					RageUI.ButtonWithStyle("Menu principal", nil, { RightLabel = "F5"}, true, function()end)
					RageUI.ButtonWithStyle("Inventaire", nil, { RightLabel = "TAB"}, true, function()end)
					RageUI.ButtonWithStyle("Boutique", nil, { RightLabel = "F1"}, true, function()end)
					RageUI.ButtonWithStyle("Téléphone", nil, { RightLabel = "F2"}, true, function()end)
					RageUI.ButtonWithStyle("Roulette de vêtements", nil, { RightLabel = "F3"}, true, function()end)
					RageUI.ButtonWithStyle("Radio", nil, { RightLabel = "F4"}, true, function()end)
					RageUI.ButtonWithStyle("Menu job", nil, { RightLabel = "F6"}, true, function()end)
					RageUI.ButtonWithStyle("Menu d'animations", nil, { RightLabel = "F7"}, true, function()end)
					RageUI.ButtonWithStyle("Console", nil, { RightLabel = "F8"}, true, function()end)
					RageUI.ButtonWithStyle("Menu illégal", nil, { RightLabel = "F9"}, true, function()end)
					RageUI.ButtonWithStyle("Menu staff", nil, { RightLabel = "F10"}, true, function()end)
					RageUI.ButtonWithStyle("Roulette d'armes", nil, { RightLabel = "TAB"}, true, function()end)
					RageUI.ButtonWithStyle("Clé du véhicule", nil, { RightLabel = "U"}, true, function()end)
					RageUI.ButtonWithStyle("Coffre de véhicule", nil, { RightLabel = "F5"}, true, function()end)
					RageUI.ButtonWithStyle("Changement de voix", nil, { RightLabel = "F11"}, true, function()end)
					RageUI.ButtonWithStyle("Pointer du doigt", nil, { RightLabel = "B"}, true, function()end)
					RageUI.ButtonWithStyle("Annuler une animation", nil, { RightLabel = "X"}, true, function()end)
					RageUI.ButtonWithStyle("Changer de vue", nil, { RightLabel = "V"}, true, function()end)
					RageUI.ButtonWithStyle("Menu contextuel", nil, { RightLabel = "CONFIGURATION REQUISE"}, true, function()end)
					RageUI.ButtonWithStyle("S'accroupir", nil, { RightLabel = "CONFIGURATION REQUISE"}, true, function()end)
                end, function()
				end)

				RageUI.IsVisible(RMenu:Get('menu', 'divers_vues'), true, true, true, function()

					RageUI.ButtonWithStyle("Vue Classique", nil, {}, true, function(Hovered, Active, Selected)
						if (Selected) then
							SetTimecycleModifier('default')
                        end
                    end)
					RageUI.ButtonWithStyle("Vue #1", nil, {}, true, function(Hovered, Active, Selected)
						if (Selected) then
							SetTimecycleModifier('rply_contrast_neg')
                        end
                    end)
					RageUI.ButtonWithStyle("Vue #2", nil, {}, true, function(Hovered, Active, Selected)
						if (Selected) then
							SetTimecycleModifier('rply_vignette')
                        end
                    end)
					RageUI.ButtonWithStyle("Vue #3", nil, {}, true, function(Hovered, Active, Selected)
						if (Selected) then
							SetTimecycleModifier('yell_tunnel_nodirect')
                        end
                    end)
					RageUI.ButtonWithStyle("Vue #4", nil, {}, true, function(Hovered, Active, Selected)
						if (Selected) then
							SetTimecycleModifier('PPPurple01')
                        end
                    end)
					RageUI.ButtonWithStyle("Vue #5", nil, {}, true, function(Hovered, Active, Selected)
						if (Selected) then
							SetTimecycleModifier('BombCamFlash')
                        end
                    end)
					RageUI.ButtonWithStyle("Vue #6", nil, {}, true, function(Hovered, Active, Selected)
						if (Selected) then
							SetTimecycleModifier('canyon_mission')
                        end
                    end)
					RageUI.ButtonWithStyle("Vue #7", nil, {}, true, function(Hovered, Active, Selected)
						if (Selected) then
							SetTimecycleModifier('player_transition_no_scanlines')
                        end
                    end)
					RageUI.ButtonWithStyle("Vue #8", nil, {}, true, function(Hovered, Active, Selected)
						if (Selected) then
							SetTimecycleModifier('New_sewers')
                        end
                    end)
					RageUI.ButtonWithStyle("Vue #9", nil, {}, true, function(Hovered, Active, Selected)
						if (Selected) then
							SetTimecycleModifier('NG_filmic20')
                        end
                    end)
					RageUI.ButtonWithStyle("Vue #10", nil, {}, true, function(Hovered, Active, Selected)
						if (Selected) then
							SetTimecycleModifier('BeastIntro01')
                        end
                    end)
					RageUI.ButtonWithStyle("Vue #11", nil, {}, true, function(Hovered, Active, Selected)
						if (Selected) then
							SetTimecycleModifier('spectator2')
                        end
                    end)
					RageUI.ButtonWithStyle("Vue #12", nil, {}, true, function(Hovered, Active, Selected)
						if (Selected) then
							SetTimecycleModifier('v_abattoir')
                        end
                    end)
					RageUI.ButtonWithStyle("Vue #13", nil, {}, true, function(Hovered, Active, Selected)
						if (Selected) then
							SetTimecycleModifier('v_bahama')
                        end
                    end)
					RageUI.ButtonWithStyle("Vue #14", nil, {}, true, function(Hovered, Active, Selected)
						if (Selected) then
							SetTimecycleModifier('v_cashdepot')
                        end
                    end)
					RageUI.ButtonWithStyle("Vue #15", nil, {}, true, function(Hovered, Active, Selected)
						if (Selected) then
							SetTimecycleModifier('Tunnel')
                        end
                    end)
					RageUI.ButtonWithStyle("Vue #16", nil, {}, true, function(Hovered, Active, Selected)
						if (Selected) then
							SetTimecycleModifier('rply_saturation')
                        end
                    end)
					RageUI.ButtonWithStyle("Vue #17", nil, {}, true, function(Hovered, Active, Selected)
						if (Selected) then
							SetTimecycleModifier('rply_saturation_neg')
                        end
                    end)
					RageUI.ButtonWithStyle("Vue #18", nil, {}, true, function(Hovered, Active, Selected)
						if (Selected) then
							SetTimecycleModifier('cinema')
                        end
                    end)

                end, function()
				end)

				RageUI.IsVisible(RMenu:Get('menu', 'vehicule'), true, true, true, function()
					local moteurveh = math.floor(GetVehicleEngineHealth(GetVehiclePedIsIn(PlayerPedId(), false)) / 10,2)
                    local carosserieVeh = math.floor(GetVehicleBodyHealth(GetVehiclePedIsIn(PlayerPedId(), false)) / 10,2)
                    local etat = (moteurveh + carosserieVeh) /2

					RageUI.Separator("Options")

					if GetVehicleNumberPlateText(GetVehiclePedIsIn(PlayerPedId(), false)) and moteurveh and carosserieVeh and etat then
						RageUI.ButtonWithStyle("Plaque", nil, {RightLabel = "[ ~r~"..GetVehicleNumberPlateText(GetVehiclePedIsIn(PlayerPedId(), false)).."~s~ ]"}, true, function(Hovered, Active, Selected)
                    	end)
						RageUI.ButtonWithStyle("État du moteur", nil, {RightLabel = "[ ~y~"..moteurveh.."~s~ ]"}, true, function(Hovered, Active, Selected)
                    	end)
						RageUI.ButtonWithStyle("État de la carosserie", nil, {RightLabel = "[ ~o~"..carosserieVeh.."~s~ ]"}, true, function(Hovered, Active, Selected)
                    	end)

						RageUI.ButtonWithStyle("Démarrer/Éteindre le moteur", nil, {}, true, function(Hovered, Active, Selected)
							if (Selected) then
								if moteur == false then
									SetVehicleEngineOn(GetVehiclePedIsIn( PlayerPedId(), false ), false, false, true)
                    	        	SetVehicleUndriveable(GetVehiclePedIsIn( PlayerPedId(), false ), true)
									moteur = true
								elseif moteur == true then
									SetVehicleEngineOn(GetVehiclePedIsIn( PlayerPedId(), false ), true, false, true)
                    	        	SetVehicleUndriveable(GetVehiclePedIsIn( PlayerPedId(), false ), false)
									moteur = false
								end
                    	    end
                    	end)

						if IsThisModelABoat(GetEntityModel(GetVehiclePedIsIn(PlayerPedId(), false))) then
							RageUI.ButtonWithStyle("Ancre ("..(anchorDown and "remonter" or "déposer")..")", nil, { RightLabel = "⚓" }, true, function(Hovered, Active, Selected)
								if Selected then
									local boat = GetVehiclePedIsIn(PlayerPedId(), false)
									if anchorDown then
										anchorDown = false
										if anchoredBoat ~= 0 and DoesEntityExist(anchoredBoat) then
											FreezeEntityPosition(anchoredBoat, false)
											SetBoatAnchor(anchoredBoat, false)
										end
										anchoredBoat = 0
										ESX.ShowNotification("Ancre ~g~remontée")
									else
										anchorDown = true
										anchoredBoat = boat
										SetVehicleForwardSpeed(boat, 0.0)
										SetEntityVelocity(boat, 0.0, 0.0, 0.0)
										SetBoatAnchor(boat, true)
										FreezeEntityPosition(boat, true)
										ESX.ShowNotification("Ancre ~b~déposée")
									end
								end
							end)
						end

						RageUI.Separator("Portes")

						RageUI.List("Ouvrir/Fermer porte", doorOptions, currentDoorIndex, nil, {}, true, function(Hovered, Active, Selected, Index)
							currentDoorIndex = Index
							local doorName = doorOptions[currentDoorIndex]
							local door = doorStates[doorName]

							if Selected then
								if door.isOpen then
									SetVehicleDoorShut(GetVehiclePedIsIn(PlayerPedId(), false), door.index, false)
									door.isOpen = false
									ESX.ShowNotification('Vous avez fermé votre ~r~' .. doorName .. ' !')
								else
									SetVehicleDoorOpen(GetVehiclePedIsIn(PlayerPedId(), false), door.index, false, false)
									door.isOpen = true
									ESX.ShowNotification('Vous avez ouvert votre ~g~' .. doorName .. ' !')
								end
							end
						end)
					end

                end, function()
				end)
                Wait(0)
            end
        end, function()
        end, 1)
    end
end

RegisterCommand("menuf5open", function()
	if MenuOpened == false and not exports.sunlife.inJail() then
        OpenF5Menu()
    end
end, false)
RegisterKeyMapping('menuf5open', 'Menu Principal', 'keyboard', 'F5')

menu = {
    ItemSelected = {},
    ItemSelected2 = {},
    Menu = false,
    Ped = PlayerPedId(),
    bank = nil,
    sale = nil,
    map = true,
    billing = {},
    visual = false,
    visual2 = false,
    visual3 = false,
    visual5 = false,
    visual6 = false,
    visual7 = false,
    visual8 = false,
    list2 = 1,
    Filtres = {'normal', 'améliorees', 'amplifiees', 'noir/blanc'},
}

function CheckQuantityF5(number)
	number = tonumber(number)

	if type(number) == 'number' then
	  	number = ESX.Math.Round(number)

	  	if number > 0 then
			return true, number
	  	end
	end

	return false, number
end

function KeyboardInputF5(entryTitle, textEntry, inputText, maxLength)
    AddTextEntry(entryTitle, textEntry)
    DisplayOnscreenKeyboard(1, entryTitle, '', inputText, '', '', '', maxLength)

    while UpdateOnscreenKeyboard() ~= 1 and UpdateOnscreenKeyboard() ~= 2 do
      	Citizen.Wait(0)
    end

    if UpdateOnscreenKeyboard() ~= 2 then
      	local result = GetOnscreenKeyboardResult()
      	Citizen.Wait(500)
      	return result
    else
      	Citizen.Wait(500)
      	return nil
    end
end

RegisterNetEvent('inventory:addAmmo')
AddEventHandler('inventory:addAmmo', function(value, quantity)
  	local weaponHash = GetHashKey(value)
    if HasPedGotWeapon(PlayerPed, weaponHash, false) and value ~= 'WEAPON_UNARMED' then
        AddAmmoToPed(PlayerPed, value, quantity)
    end
end)

RegisterNetEvent('f5:medestruction')
AddEventHandler('f5:medestruction', function(item, quantity)
	ExecuteCommand("me détruit " ..quantity.. " " ..item.. "")
end)

RegisterNetEvent('f5:closeAll')
AddEventHandler('f5:closeAll', function()
	RageUI.CloseAll()
	MenuOpened = false
end)

local NumberCharset = {}
local Charset = {}

for i = 48,  57 do table.insert(NumberCharset, string.char(i)) end

for i = 65,  90 do table.insert(Charset, string.char(i)) end
for i = 97, 122 do table.insert(Charset, string.char(i)) end

function GetRandomNumber(length)
	local result = ''
	for i = 1, length do
		result = result .. NumberCharset[math.random(1, #NumberCharset)]
	end
	return result
end

function GetRandomLetter(length)
	local result = ''
	for i = 1, length do
		result = result .. Charset[math.random(1, #Charset)]
	end
	return result
end

function GeneratePlate()
	math.randomseed(GetGameTimer())
	local maxAttempts = 50
	for attempt = 1, maxAttempts do
		local generatedPlate = string.upper(GetRandomLetter(4) .. GetRandomNumber(4))
		local done = false
		local taken = true

		ESX.TriggerServerCallback('concess:isPlateTaken', function(isPlateTaken)
			taken = isPlateTaken
			done = true
		end, generatedPlate)

		while not done do
			Citizen.Wait(100)
		end

		if not taken then
			return generatedPlate
		end

		Citizen.Wait(200)
	end
	return string.upper(GetRandomLetter(4) .. GetRandomNumber(4))
end

function IsPlateTaken(plate)
	local done = false
	local result = false

	ESX.TriggerServerCallback('concess:isPlateTaken', function(isPlateTaken)
		result = isPlateTaken
		done = true
	end, plate)

	while not done do
		Citizen.Wait(100)
	end

	return result
end

function MarquerJoueur()
	local ped = GetPlayerPed(ESX.Game.GetClosestPlayer())
	local pos = GetEntityCoords(ped)
	local target, distance = ESX.Game.GetClosestPlayer()
	if distance <= 4.0 then
		DrawMarker(2, pos.x, pos.y, pos.z+1.3, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.3, 0.3, 0.3, 0, 255, 0, 170, 0, 1, 2, 1, nil, nil, 0)
	end
end

function GetCurrentWeight()
    local currentWeight = 0
    for i = 1, #ESX.PlayerData.inventory, 1 do
        if ESX.PlayerData.inventory[i].count > 0 then
            currentWeight = currentWeight + (ESX.PlayerData.inventory[i].weight * ESX.PlayerData.inventory[i].count)
        end
    end
    return currentWeight
end

CreateThread(function()
    while true do
        Citizen.Wait(80)
		local ped = PlayerPedId(), DecorGetInt(PlayerPedId())
		local health = GetEntityHealth(ped)
        inVeh = IsPedInVehicle(PlayerPedId(-1), GetVehiclePedIsIn(PlayerPedId(-1), false), false)

		if health <= 0 then
			ClearPedTasks(ped)
            SetEnableHandcuffs(ped, false)
			GangsterAS = false
			HillbillyAS = false
			break
		end

        if GangsterAS == true then
            local _, hash = GetCurrentPedWeapon(ped, 1)
            if not inVeh then
                loadAnimDict2("combat@aim_variations@1h@gang")
                if IsPlayerFreeAiming(PlayerId()) or (IsControlPressed(0, 24) and GetAmmoInClip(ped, hash) > 0) then
                    if not IsEntityPlayingAnim(ped, "combat@aim_variations@1h@gang", "aim_variation_a", 3) then
                        TaskPlayAnim(ped, "combat@aim_variations@1h@gang", "aim_variation_a", 8.0, -8.0, -1, 49, 0, 0, 0, 0)
                        SetEnableHandcuffs(ped, true)
                    end
                elseif IsEntityPlayingAnim(ped, "combat@aim_variations@1h@gang", "aim_variation_a", 3) then
                    ClearPedTasks(ped)
                    SetEnableHandcuffs(ped, false)
                end
            end
        elseif HillbillyAS == true then
            local _, hash = GetCurrentPedWeapon(ped, 1)
            if not inVeh then
                loadAnimDict2("combat@aim_variations@1h@hillbilly")
                if IsPlayerFreeAiming(PlayerId()) or (IsControlPressed(0, 24) and GetAmmoInClip(ped, hash) > 0) then
                    if not IsEntityPlayingAnim(ped, "combat@aim_variations@1h@hillbilly", "aim_variation_a", 3) then
                        TaskPlayAnim(ped, "combat@aim_variations@1h@hillbilly", "aim_variation_a", 8.0, -8.0, -1, 49, 0, 0, 0, 0)
                        SetEnableHandcuffs(ped, true)
                    end
                elseif IsEntityPlayingAnim(ped, "combat@aim_variations@1h@hillbilly", "aim_variation_a", 3) then
                    ClearPedTasks(ped)
                    SetEnableHandcuffs(ped, false)
                end
            end
        end
    end
end)

function loadAnimDict2(dict)
	while ( not HasAnimDictLoaded(dict)) do
		RequestAnimDict(dict)
		Citizen.Wait(0)
	end
end

RegisterNetEvent("f5:noteActive", function (name, message)
	ActiveNote = true
	StaffName = name
	messagereport = message
end)

Citizen.CreateThread(function()
    local MAX_BACKWEAPONS = 3

    while true do
        if EditingBackWeaponHash == nil then
            local ped = PlayerPedId()
            local currentWeaponHash = GetSelectedPedWeapon(ped)

            local invBackable = {}
            local ownedBackables = GetMyBackableWeapons()
            for _, w in ipairs(ownedBackables) do
                invBackable[w.hash] = true
            end

            local candidates = {}
            for propModelName, weaponHash in pairs(SETTINGS.compatable_weapon_hashes) do
                local allowedByPlayer = (BackWeaponAllowed[weaponHash] == true)
                local hasItem        = (invBackable[weaponHash] == true)
                local isInHands      = (currentWeaponHash == weaponHash)

                local shouldShowOnBack = (allowedByPlayer and hasItem and not isInHands)

                if shouldShowOnBack then
                    table.insert(candidates, {
                        propModelName = propModelName,
                        weaponHash    = weaponHash
                    })
                end
            end

            local keepMap = {}
            for i = 1, math.min(MAX_BACKWEAPONS, #candidates) do
                local entry = candidates[i]
                keepMap[entry.propModelName] = entry.weaponHash
            end

            for propModelName, weaponHash in pairs(SETTINGS.compatable_weapon_hashes) do
                if keepMap[propModelName] then
                    if not attached_weapons[propModelName] then
                        local base = GetOffsetsForWeapon(
                            weaponHash,
                            isMeleeWeapon(propModelName),
                            propModelName
                        )
                        AttachWeapon(
                            propModelName,
                            weaponHash,
                            SETTINGS.back_bone,
                            base.x, base.y, base.z,
                            base.xR, base.yR, base.zR
                        )
                    end
                else
                    if attached_weapons[propModelName] then
                        DetachOne(propModelName)
                    end
                end
            end
        end

        Wait(1500)
    end
end)

local function CleanupAllAttachments()
    for attachModel, data in pairs(attached_weapons) do
        if data then
            if data.netId then
                TriggerServerEvent('backweapons:unregister', data.netId)
            end
            if data.handle and DoesEntityExist(data.handle) then
                DetachEntity(data.handle, true, true)
                DeleteObject(data.handle)
            end
        end
        attached_weapons[attachModel] = nil
    end

    for handle, _ in pairs(spawnedAttachedEntities) do
        if DoesEntityExist(handle) then
            DetachEntity(handle, true, true)
            DeleteObject(handle)
        end
        spawnedAttachedEntities[handle] = nil
    end
end

AddEventHandler('onResourceStop', function(resourceName)
    if resourceName == GetCurrentResourceName() then
        CleanupAllAttachments()
    end
end)

Citizen.CreateThread(function()
    local stepPos = 0.005
    local stepRot = 1.0
    while true do
        if EditingBackWeaponHash ~= nil then
            if not BackWeaponOffsets[EditingBackWeaponHash] then
                BackWeaponOffsets[EditingBackWeaponHash] = {
                    x = SETTINGS.x,
                    y = SETTINGS.y,
                    z = SETTINGS.z,
                    xR = SETTINGS.x_rotation,
                    yR = SETTINGS.y_rotation,
                    zR = SETTINGS.z_rotation
                }
            end

            local o = BackWeaponOffsets[EditingBackWeaponHash]
            local changed = false

            local shift = IsControlPressed(0, 21)

            if not shift then
                if IsControlPressed(0, 172) then
                    o.z = (o.z or 0.0) + stepPos
                    changed = true
                end
                if IsControlPressed(0, 173) then
                    o.z = (o.z or 0.0) - stepPos
                    changed = true
                end
                if IsControlPressed(0, 174) then
                    o.x = (o.x or 0.0) - stepPos
                    changed = true
                end
                if IsControlPressed(0, 175) then
                    o.x = (o.x or 0.0) + stepPos
                    changed = true
                end

                if IsControlPressed(0, 44) then
                    o.y = (o.y or SETTINGS.y) + stepPos
                    changed = true
                end
                if IsControlPressed(0, 38) then
                    o.y = (o.y or SETTINGS.y) - stepPos
                    changed = true
                end
            else
                if IsControlPressed(0, 172) then
                    o.xR = (o.xR or 0.0) + stepRot
                    changed = true
                end
                if IsControlPressed(0, 173) then
                    o.xR = (o.xR or 0.0) - stepRot
                    changed = true
                end
                if IsControlPressed(0, 174) then
                    o.yR = (o.yR or 0.0) - stepRot
                    changed = true
                end
                if IsControlPressed(0, 175) then
                    o.yR = (o.yR or 0.0) + stepRot
                    changed = true
                end
                if IsControlPressed(0, 44) then
                    o.zR = (o.zR or 0.0) - stepRot
                    changed = true
                end
                if IsControlPressed(0, 38) then
                    o.zR = (o.zR or 0.0) + stepRot
                    changed = true
                end
            end

			if changed then
				o.x = clamp(o.x or 0.0, -0.5, 0.5)
				o.y = clamp(o.y or SETTINGS.y, -0.5, 0.5)
				o.z = clamp(o.z or 0.0, -0.5, 0.5)

				o.xR = (o.xR or 0.0) % 360.0
				o.yR = (o.yR or 0.0) % 360.0
				o.zR = (o.zR or 0.0) % 360.0

				UpdateBackWeaponAttachmentForHash(EditingBackWeaponHash)
			end

            ESX.ShowHelpNotification((
                "Réglage arme dans le dos\n" ..
                "Pos X %.3f | Y %.3f | Z %.3f\n" ..
                "Rot X %.1f | Y %.1f | Z %.1f\n" ..
                "Flèches = déplacer X/Z\n" ..
                "Q/E = avancer/reculer (Y)\n" ..
                "MAJ + Flèches = rotation X/Y\n" ..
                "MAJ + Q/E = rotation Z\n" ..
                "ENTRÉE pour valider"
            ):format(
                o.x or 0.0,
                o.y or SETTINGS.y,
                o.z or 0.0,
                o.xR or 0.0,
                o.yR or 0.0,
                o.zR or 0.0
            ))

			if IsControlJustPressed(0, 191) then
				local hash = EditingBackWeaponHash
				EditingBackWeaponHash = nil

				ClearAllHelpMessages()

				if hash then
					DetachBackWeaponByHash(hash)

					Citizen.CreateThread(function()
						Wait(2000)
						ReattachHashNow(hash)
					end)
				end
			end

            Wait(0)
        else
            Wait(250)
        end
    end
end)

function BecomePedModel(modelName)
    if not modelName then return end
    local model = GetHashKey(modelName)
    RequestModel(model)
    while not HasModelLoaded(model) do
        Wait(0)
    end
    SetPlayerModel(PlayerId(), model)
    SetPedDefaultComponentVariation(PlayerPedId())
    SetModelAsNoLongerNeeded(model)
end

function RestoreMySkin()
    exports['esx_skin']:GetCachedSkin(function(skin, jobSkin)
        local isMale = false
        if skin and (skin.sex == 0 or skin.sex == "m" or skin.sex == "mp_m_freemode_01") then
            isMale = true
        end
        TriggerEvent('skinchanger:loadDefaultModel', isMale, function()
            Wait(100)
            if skin then
                TriggerEvent('skinchanger:loadSkin', skin)
            elseif jobSkin then
                TriggerEvent('skinchanger:loadSkin', jobSkin)
            end
        end)
    end)
end

function ActivateAmbiantSounds()

end

function DesactivateAmbiantSounds()

end
