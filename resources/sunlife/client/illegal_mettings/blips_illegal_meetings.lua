local BLIP_CAT_ILLEGAL_MEETINGS <const> = 48

local MEETING_BLIP_SPRITE       <const> = 491
local MEETING_BLIP_COLOR        <const> = 1
local MEETING_BLIP_SCALE        <const> = 0.85
local MEETING_RADIUS_METERS     <const> = 120.0
local MEETING_RADIUS_COLOR      <const> = 1
local MEETING_RADIUS_ALPHA      <const> = 80

local MEETING_POINTS <const> = {
    { label = "Point de rendez-vous - Port",        coords = vector3(-408.466278, -2276.728027, 7.608503) },
    { label = "Point de rendez-vous - Orange", coords = vector3(-430.59234619141,  1581.0666503906, 357.11752319336)  },
    { label = "Point de rendez-vous - Paleto Bay",  coords = vector3(144.878433, 6417.503906, 31.263784) },
    { label = "Point de rendez-vous - Usine",        coords = vector3(2722.6694335938,   1362.9343261719,  24.523986816406) },
    { label = "Point de rendez-vous - Aéroport abandonné",        coords = vector3(1075.501953125, 3081.0368652344, 40.680751800537) },
}

local function registerLegend()
    AddTextEntry("BLIP_CAT_" .. BLIP_CAT_ILLEGAL_MEETINGS, "Points de réunion")
end

local function createMeetingBlips(point)
    local x, y, z = point.coords.x, point.coords.y, point.coords.z

    local radius = AddBlipForRadius(x, y, z, MEETING_RADIUS_METERS)
    SetBlipHighDetail(radius, true)
    SetBlipColour(radius, MEETING_RADIUS_COLOR)
    SetBlipAlpha(radius, MEETING_RADIUS_ALPHA)
    SetBlipCategory(radius, BLIP_CAT_ILLEGAL_MEETINGS)

    local marker = AddBlipForCoord(x, y, z)
    SetBlipSprite(marker, MEETING_BLIP_SPRITE)
    SetBlipDisplay(marker, 4)
    SetBlipScale(marker, MEETING_BLIP_SCALE)
    SetBlipColour(marker, MEETING_BLIP_COLOR)
    SetBlipAsShortRange(marker, true)
    SetBlipCategory(marker, BLIP_CAT_ILLEGAL_MEETINGS)

    BeginTextCommandSetBlipName("STRING")
    AddTextComponentString(point.label)
    EndTextCommandSetBlipName(marker)
end

CreateThread(function()
    registerLegend()
    for i = 1, #MEETING_POINTS do
        createMeetingBlips(MEETING_POINTS[i])
    end
end)
