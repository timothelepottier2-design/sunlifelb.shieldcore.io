-- Blip du Fight Club (MLO sc_fightclub_free). Simple blip statique.
local FIGHTCLUB_BLIP <const> = {
    label  = "Fight Club",
    coords = vector3(-493.906738, -42.5369644, 43.51529),
    sprite = 311,   -- poing / gants de boxe
    color  = 1,     -- rouge
    scale  = 0.85,
}

CreateThread(function()
    local c = FIGHTCLUB_BLIP.coords
    local blip = AddBlipForCoord(c.x, c.y, c.z)
    SetBlipSprite(blip, FIGHTCLUB_BLIP.sprite)
    SetBlipDisplay(blip, 4)
    SetBlipScale(blip, FIGHTCLUB_BLIP.scale)
    SetBlipColour(blip, FIGHTCLUB_BLIP.color)
    SetBlipAsShortRange(blip, true)

    BeginTextCommandSetBlipName("STRING")
    AddTextComponentString(FIGHTCLUB_BLIP.label)
    EndTextCommandSetBlipName(blip)
end)
