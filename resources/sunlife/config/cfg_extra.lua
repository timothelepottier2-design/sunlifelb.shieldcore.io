-- ============================================================================
-- Menu Extra (extras / livrees / vitres teintees sur un vehicule).
--
-- Sorti de client/extra/extra.lua : le serveur en a besoin pour revalider la
-- sauvegarde (metier autorise + joueur reellement sur un point). Charge des
-- deux cotes via le glob config/**.lua du fxmanifest.
-- ============================================================================
ConfigExtra = ConfigExtra or {}

ConfigExtra.positions = {
	{x = 903.02355957031, y = -186.97975158691, z = 72.928224182129, },
	{x = 444.20050048828, y = -1002.4445800781, z = 20.436065292358, },
	{x = -195.8442, y = -1327.5693, z = 29.9135, },
	{x = -689.0599, y = 352.279, z = 77.21832, },
	{x = -331.5077, y = -131.2779, z = 38.09126, },
	{x = -1830.771, y = -383.0683, z = 39.75248, },
	{x = 2802.7768554688, y = 4846.2666015625, z = 46.196125030518, },
	{x = -581.85675048828, y = 7388.455078125, z = 11.939551925659, },
	{x = 1182.408081, y = 2654.932861, z = 37.508470, },
	{x = -1035.4500, y = -1377.9806, z = 3.9719},
	{x = 1170.1879, y = 2624.7332, z = 37.3738},
	{x = -1078.647827, y = -790.885803, z = 3.964563},
	{x = 70.999298, y = 6492.104492, z = 31.012912}
}

ConfigExtra.jobs = {
	"police",
	"sheriff",
	"ems",
	"bennys",
	"hayes",
	"harmony",
	"taxi",
	"lsfd"
}

-- Rayon (m) autour d'un point sous lequel le serveur accepte une sauvegarde.
-- Large devant le rayon d'ouverture du menu (7 m) : le joueur peut avoir bouge
-- un peu dans son vehicule entre l'ouverture et la fermeture.
ConfigExtra.saveDistance = 20.0
