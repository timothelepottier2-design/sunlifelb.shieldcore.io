local ShopActif = false

Citizen.CreateThread(function()
     while not _sync do Wait(100) end
     for k,v in pairs(shopobject) do

          if not v.illegal then
               local blip = AddBlipForCoord(v.zone)
               SetBlipSprite(blip, v.BlipId)
               SetBlipScale(blip, 0.8)
               SetBlipColour(blip, 7)
               SetBlipAsShortRange(blip, true)
               SetBlipCategory(blip, 10)

               local _key = 'BN_SUNLIFE_SHOPS_1_' .. tostring(blip)
               AddTextEntry(_key, v.BlipName)
               BeginTextCommandSetBlipName(_key)
		     EndTextCommandSetBlipName(blip)
          end
     end
end)

Citizen.CreateThread(function()
     while true do
          local nearThing = false
          for k,v in pairs(shopobject) do
               local pPed = PlayerPedId()
               local pCoords = GetEntityCoords(pPed, true)
               local dst = GetDistanceBetweenCoords(pCoords, v.zone, true)

               if dst <= v.TailleZone then
                    nearThing = true
                    if ShopActif == false then
                         ESX.ShowHelpNotification(v.MessageZone)
                         if IsControlJustReleased(0, 38) then
                              MenuActuel = v.MenuId
                              if ShopActif == false then
                                   CreateShop()
                              end
                         end
                    end
               end
          end
          if nearThing then
               Citizen.Wait(0)
          else
               Citizen.Wait(500)
          end
     end
end)

function LoadModel(model)
     while not HasModelLoaded(model) do
          RequestModel(model)
          Wait(100)
     end
end

local shopSpawnedPeds = {}

Citizen.CreateThread(function()
     while not _sync do Wait(100) end
     for k, v in pairs(shopobject) do
          if v.spawnPed and v.ped then
               local model = GetHashKey(v.ped)
               LoadModel(model)
               local ped = CreatePed(4, model, v.zone.x, v.zone.y, v.zone.z - 1.0, v.heading or 0.0, false, true)
               SetEntityAsMissionEntity(ped, true, true)
               FreezeEntityPosition(ped, true)
               SetEntityInvincible(ped, true)
               SetBlockingOfNonTemporaryEvents(ped, true)
               TaskStartScenarioInPlace(ped, 'WORLD_HUMAN_STAND_IMPATIENT', 0, true)
               SetModelAsNoLongerNeeded(model)
               shopSpawnedPeds[k] = ped
          end
     end
end)

Citizen.CreateThread(function()
     while not _sync do Wait(100) end
     while true do
          local sleep = 1000
          local pCoords = GetEntityCoords(PlayerPedId())
          for k, v in pairs(shopobject) do
               if v.marker then
                    local dst = #(pCoords - v.zone)
                    if dst <= 15.0 then
                         sleep = 0

                         DrawMarker(
                              1,
                              v.zone.x, v.zone.y, v.zone.z - 1.0,
                              0.0, 0.0, 0.0,
                              0.0, 0.0, 0.0,
                              0.7, 0.7, 0.4,
                              255, 117, 31, 120,
                              false, false, 2, false, nil, nil, false
                         )
                    end
               end
          end
          Wait(sleep)
     end
end)

AddEventHandler('onResourceStop', function(res)
     if res ~= GetCurrentResourceName() then return end
     for _, ped in pairs(shopSpawnedPeds) do
          if ped and DoesEntityExist(ped) then
               DeleteEntity(ped)
          end
     end
     shopSpawnedPeds = {}
end)
