local eventPrefix = '__PolyZone__:'

local _lastTrig = {}
local _globalBucket = {}

local GLOBAL_WINDOW_MS   = 1000
local GLOBAL_MAX         = 10
local MAX_EVENTNAME_LEN  = 100

local function triggerZoneEvent(eventName, ...)
  if type(eventName) ~= 'string' or #eventName == 0 or #eventName > MAX_EVENTNAME_LEN then return end

  local src = source or 0
  if src and src > 0 then
    local now = GetGameTimer()

    local g = _globalBucket[src]
    if not g or (now - g.start) > GLOBAL_WINDOW_MS then
      _globalBucket[src] = { start = now, count = 1 }
    else
      g.count = g.count + 1
      if g.count > GLOBAL_MAX then return end
    end

    local key = src .. ':' .. eventName
    local last = _lastTrig[key]
    if last and (now - last) < 200 then return end
    _lastTrig[key] = now
  end
  TriggerClientEvent(eventPrefix .. eventName, -1, ...)
end

AddEventHandler('playerDropped', function()
  local src = source
  if not src then return end
  _globalBucket[src] = nil
  for k in pairs(_lastTrig) do
    if k:sub(1, #tostring(src) + 1) == (tostring(src) .. ':') then
      _lastTrig[k] = nil
    end
  end
end)

CreateThread(function()
  while true do
    Wait(120 * 1000)
    local count = 0
    for _ in pairs(_lastTrig) do count = count + 1 end
    if count > 5000 then _lastTrig = {} end
  end
end)

RegisterNetEvent("PolyZone:TriggerZoneEvent")
AddEventHandler("PolyZone:TriggerZoneEvent", triggerZoneEvent)

exports("TriggerZoneEvent", triggerZoneEvent)
