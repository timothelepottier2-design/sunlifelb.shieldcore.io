ESX                  = nil
local FirstSpawn     = true
local LastSkin       = nil
local PlayerLoaded   = false
local cam            = nil
local isCameraActive = false
local zoomOffset     = 0.0
local camOffset      = 0.0
local heading        = 90.0

-- =====================================================================
-- Cache local du skin push-based : evite TOTALEMENT les RPC
-- 'esx_skin:getPlayerSkin' (callbacks ESX = round-trip event + dispatch
-- + closure alloc + reply event). Le serveur push automatiquement le
-- skin au esx:playerLoaded via 'esx_skin:syncSkin'. Toutes les ressources
-- consommatrices (tattooshop, barber, sJobs, sunlife, sCore...) doivent
-- preferer GetCachedPlayerSkin() / exports['esx_skin']:GetCachedSkin().
-- =====================================================================
local _cachedSkin = nil
local _cachedJobSkin = nil
local _skinReady = false
local _skinWaiters = {}

RegisterNetEvent('esx_skin:syncSkin', function(skin, jobSkin)
  _cachedSkin = skin
  -- Si jobSkin est explicitement envoyé, on l'update. Sinon (cas du push
  -- post-save : voir esx_skin/server/main.lua bloc IMPORTANT) on préserve
  -- l'existant pour ne pas l'effacer en réécrivant nil par-dessus.
  if jobSkin ~= nil then
    _cachedJobSkin = jobSkin
  end
  _skinReady = true
  -- Reveille tous les waiters en attente
  if next(_skinWaiters) then
    for i = 1, #_skinWaiters do
      local cb = _skinWaiters[i]
      pcall(cb, _cachedSkin, _cachedJobSkin)
    end
    _skinWaiters = {}
  end
end)

-- Helper global : appelable de n'importe ou (autres ressources via export
-- aussi). Si le cache est pret -> cb instant. Sinon -> mise en file
-- d'attente, le cb sera appele des reception du sync.
function GetCachedPlayerSkin(cb)
  if _skinReady then
    cb(_cachedSkin, _cachedJobSkin)
    return
  end
  _skinWaiters[#_skinWaiters + 1] = cb
end

exports('GetCachedSkin', GetCachedPlayerSkin)

-- Mise a jour locale du cache quand le client modifie son skin (creator
-- save, tattoo apply, etc.) pour rester coherent sans round-trip serveur.
RegisterNetEvent('skinchanger:loadSkin', function(skin)
  if type(skin) == 'table' then
    _cachedSkin = skin
    _skinReady = true
  end
end)

Citizen.CreateThread(function()
  while ESX == nil do
    TriggerEvent('esx:getShtozaredObjtozect', function(obj) ESX = obj end)
    Citizen.Wait(0)
  end
end)

function OpenMenu(submitCb, cancelCb, restrict)

  local playerPed = PlayerPedId()

  TriggerEvent('skinchanger:getSkin', function(skin)
    LastSkin = skin
  end)

  TriggerEvent('skinchanger:getData', function(components, maxVals)

    local elements    = {}
    local _components = {}

    -- Restrict menu
    if restrict == nil then
      for i=1, #components, 1 do
        _components[i] = components[i]
      end
    else
      for i=1, #components, 1 do

        local found = false

        for j=1, #restrict, 1 do
          if components[i].name == restrict[j] then
            found = true
          end
        end

        if found then
          table.insert(_components, components[i])
        end

      end
    end

    -- Insert elements
    for i=1, #_components, 1 do

      local value       = _components[i].value
      local componentId = _components[i].componentId

      if componentId == 0 then
        value = GetPedPropIndex(playerPed,  _components[i].componentId)
      end

      local data = {
        label     = _components[i].label,
        name      = _components[i].name,
        value     = value,
        min       = _components[i].min,
        textureof = _components[i].textureof,
        zoomOffset= _components[i].zoomOffset,
        camOffset = _components[i].camOffset,
        type      = 'slider'
      }

      for k,v in pairs(maxVals) do
        if k == _components[i].name then
          data.max = v
        end
      end

      table.insert(elements, data)

    end

    CreateSkinCam()
    zoomOffset = _components[1].zoomOffset
    camOffset = _components[1].camOffset

    ESX.UI.Menu.Open(
      'default', GetCurrentResourceName(), 'skin',
      {
        title = _U('skin_menu'),
        align = 'top-left',
        elements = elements
      },
      function(data, menu)

        TriggerEvent('skinchanger:getSkin', function(skin)
          LastSkin = skin
        end)

        submitCb(data, menu)
        DeleteSkinCam()
      end, function(data, menu)
		ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'confirm_escape', {
			title = _U('confirm_escape'),
			align = 'top-left',
			elements = {
				{label = _U('no'),  value = 'no'},
				{label = _U('yes'), value = 'yes'}
			}
		}, function(data2, menu2)
			if data2.current.value == 'yes' then
				menu.close()
				DeleteSkinCam()
				TriggerEvent('skinchanger:loadSkin', LastSkin)
			end
			menu2.close()
		end)

		if cancelCb ~= nil then
			cancelCb(data, menu)
		end
      end,function(data, menu)
        TriggerEvent('skinchanger:getSkin', function(skin)

          zoomOffset = data.current.zoomOffset
          camOffset = data.current.camOffset

          if skin[data.current.name] ~= data.current.value then

            -- Change skin element
            TriggerEvent('skinchanger:change', data.current.name, data.current.value)

            -- Update max values
            TriggerEvent('skinchanger:getData', function(components, maxVals)

              for i=1, #elements, 1 do

                local newData = {}

                newData.max = maxVals[elements[i].name]

                if elements[i].textureof ~= nil and data.current.name == elements[i].textureof then
                  newData.value = 0
                end

                menu.update({name = elements[i].name}, newData)

              end

              menu.refresh()

            end)

          end

        end)

      end,
      function()
        DeleteSkinCam()
      end
    )

  end)

end

function CreateSkinCam()
  --if not DoesCamExist(cam) then
  --  cam = CreateCam('DEFAULT_SCRIPTED_CAMERA', true)
  --end
  --SetCamActive(cam, true)
  --RenderScriptCams(true, true, 500, true, true)
  --isCameraActive = true
  --SetCamRot(cam, 0.0, 0.0, 270.0, true)
  --SetEntityHeading(playerPed, 90.0)
end

function DeleteSkinCam()
  --isCameraActive = false
  --SetCamActive(cam, false)
  --RenderScriptCams(false, true, 500, true, true)
  --cam = nil
end

Citizen.CreateThread(function()
  while true do
    Citizen.Wait(0)
    if isCameraActive then
      DisableControlAction(2, 30, true)
      DisableControlAction(2, 31, true)
      DisableControlAction(2, 32, true)
      DisableControlAction(2, 33, true)
      DisableControlAction(2, 34, true)
      DisableControlAction(2, 35, true)

      DisableControlAction(0, 25,   true) -- Input Aim
        DisableControlAction(0, 24,   true) -- Input Attack

      local playerPed = PlayerPedId()
      local coords    = GetEntityCoords(playerPed)

      local angle = heading * math.pi / 180.0
      local theta = {
        x = math.cos(angle),
        y = math.sin(angle)
      }
      local pos = {
        x = coords.x + (zoomOffset * theta.x),
        y = coords.y + (zoomOffset * theta.y),
      }

      local angleToLook = heading - 140.0
      if angleToLook > 360 then
        angleToLook = angleToLook - 360
      elseif angleToLook < 0 then
        angleToLook = angleToLook + 360
      end
      angleToLook = angleToLook * math.pi / 180.0
      local thetaToLook = {
        x = math.cos(angleToLook),
        y = math.sin(angleToLook)
      }
      local posToLook = {
        x = coords.x + (zoomOffset * thetaToLook.x),
        y = coords.y + (zoomOffset * thetaToLook.y),
      }

      SetCamCoord(cam, pos.x, pos.y, coords.z + camOffset)
      PointCamAtCoord(cam, posToLook.x, posToLook.y, coords.z + camOffset)

      SetTextComponentFormat("STRING")
      AddTextComponentString(_U('use_rotate_view'))
      DisplayHelpTextFromStringLabel(0, 0, 0, -1)
    end
  end
end)

Citizen.CreateThread(function()
  local angle = 90
  while true do
    Citizen.Wait(0)
    if isCameraActive then
      if IsControlPressed(0, 108) then
        angle = angle - 1
      elseif IsControlPressed(0, 109) then
        angle = angle + 1
      end
      if angle > 360 then
        angle = angle - 360
      elseif angle < 0 then
        angle = angle + 360
      end
      heading = angle + 0.0
    end
  end
end)

function OpenSaveableMenu(submitCb, cancelCb, restrict)

  TriggerEvent('skinchanger:getSkin', function(skin)
    LastSkin = skin
  end)

  OpenMenu(function(data, menu)

    menu.close()

    DeleteSkinCam()

    TriggerEvent('skinchanger:getSkin', function(skin)

      TriggerServerEvent('esx_skin:save', skin)

      if submitCb ~= nil then
        submitCb(data, menu)
      end

    end)

  end, cancelCb, restrict)

end

AddEventHandler('playerSpawned', function()

  Citizen.CreateThread(function()

    while not PlayerLoaded do
      Citizen.Wait(0)
    end

    if FirstSpawn then

      local ped = PlayerPedId()
      SetEntityVisible(ped, false, false)

      -- Bypass complet du callback ESX : le serveur a deja push le skin
      -- via 'esx_skin:syncSkin' au moment du esx:playerLoaded. Ici on lit
      -- juste le cache local. Si pas encore arrive (race), on attend via
      -- _skinWaiters (le cb sera execute des reception du sync).
      GetCachedPlayerSkin(function(skin, jobSkin)

        if skin == nil then
          TriggerEvent('core:creator')
        else
          TriggerEvent('skinchanger:loadSkin', skin)
        end

        Citizen.Wait(500)
        local p = PlayerPedId()
        SetEntityVisible(p, true, false)

      end)

      FirstSpawn = false

    end

  end)

end)

RegisterNetEvent('esx:playerLoaded')
AddEventHandler('esx:playerLoaded', function(xPlayer)
  PlayerLoaded = true
end)

-- =====================================================================
-- Filet de securite "perso non charge"
-- Si, peu apres le spawn, le ped du joueur reste bloque sur un modele
-- non-freemode (typiquement le ped de map "skater" jaune) alors qu'un
-- skin valide est en cache, on (re)applique le skin. Couvre les races
-- spawnmanager / esx_skin ou le skin n'a jamais ete applique, ou a ete
-- ecrase par le modele de map. S'arrete des que le modele freemode est en
-- place (pour ne pas interferer avec d'eventuels changements de ped legitimes).
-- =====================================================================
local _FREEMODE_M = GetHashKey('mp_m_freemode_01')
local _FREEMODE_F = GetHashKey('mp_f_freemode_01')

-- =====================================================================
-- Verifie si le skin en cache est REELLEMENT applique sur le ped.
-- On compare les composants de vetements/cheveux visibles du ped aux
-- valeurs du skin sauvegarde. Couvre le cas concret rapporte :
-- le joueur spawn en freemode mais avec les composants PAR DEFAUT
-- (mp_freemode : tshirt bleu + chauve) parce que ApplySkin n'a jamais
-- tourne (ou a ete ecrase par un resource qui a recharge le modele
-- par defaut APRES le premier loadSkin). Dans ce cas le modele est
-- bien freemode -> l'ancien filet abandonnait a tort.
--
-- Mapping composant GTA -> cle du skin (cf. ApplySkin) :
--   2 = hair (hair_1), 8 = tshirt (tshirt_1), 11 = torso (torso_1),
--   4 = pants (pants_1), 6 = shoes (shoes_1), 3 = arms (arms)
-- =====================================================================
local _SKIN_COMP_MAP = {
  { comp = 2,  key = 'hair_1' },
  { comp = 8,  key = 'tshirt_1' },
  { comp = 11, key = 'torso_1' },
  { comp = 4,  key = 'pants_1' },
  { comp = 6,  key = 'shoes_1' },
  { comp = 3,  key = 'arms' },
}

local function _skinLooksApplied(ped, skin)
  local checked, mismatches = 0, 0
  for i = 1, #_SKIN_COMP_MAP do
    local m = _SKIN_COMP_MAP[i]
    local want = skin[m.key]
    if type(want) == 'number' then
      checked = checked + 1
      if GetPedDrawableVariation(ped, m.comp) ~= want then
        mismatches = mismatches + 1
      end
    end
  end
  -- Rien de comparable (skin incomplet) : on ne prend aucune decision.
  if checked == 0 then return true end
  -- 2+ composants divergents => le skin n'est visiblement pas applique
  -- (une tenue de job legitime ne change en general pas cheveux+torse+
  --  pantalon+chaussures d'un coup au spawn ; on garde une marge de 2
  --  pour eviter les faux positifs sur un seul composant coincidant).
  return mismatches < 2
end

AddEventHandler('playerSpawned', function()
  Citizen.CreateThread(function()
    while not PlayerLoaded do Citizen.Wait(200) end

    local deadline = GetGameTimer() + 30000
    while GetGameTimer() < deadline do
      Citizen.Wait(1000)

      -- skin == nil => nouveau perso, le char creator gere ce cas, on n'y touche pas
      if _skinReady and type(_cachedSkin) == 'table' then
        local ped   = PlayerPedId()

        -- Staff en tenue de service : la tenue staff differe VOLONTAIREMENT du
        -- skin sauvegarde. Sans ce garde, ce filet la prend pour un skin "non
        -- applique" et re-applique le skin sauvegarde par-dessus apres un revive
        -- (RespawnPed -> playerSpawned) => la tenue staff disparait. On stoppe
        -- donc le filet tant que le mode staff est actif.
        if DecorExistOn(ped, "isStaffMode") and DecorGetBool(ped, "isStaffMode") then
          return
        end

        local model = GetEntityModel(ped)

        if model ~= _FREEMODE_M and model ~= _FREEMODE_F then
          -- Cas historique : ped bloque sur un modele non-freemode
          -- (ped de map "skater" jaune, etc.). On re-applique le skin.
          TriggerEvent('skinchanger:loadSkin', _cachedSkin)
        elseif not _skinLooksApplied(ped, _cachedSkin) then
          -- Cas rapporte : freemode mais composants par defaut
          -- (tshirt bleu + chauve). ApplySkin n'a pas pris -> on re-applique.
          TriggerEvent('skinchanger:loadSkin', _cachedSkin)
        else
          -- Skin correctement en place : plus rien a faire.
          return
        end
      end
    end
  end)
end)

AddEventHandler('esx_skin:getLastSkin', function(cb)
  cb(LastSkin)
end)

AddEventHandler('esx_skin:setLastSkin', function(skin)
  LastSkin = skin
end)

RegisterNetEvent('esx_skin:openMenu')
AddEventHandler('esx_skin:openMenu', function(submitCb, cancelCb)
  OpenMenu(submitCb, cancelCb, nil)
end)

RegisterNetEvent('esx_skin:openRestrictedMenu')
AddEventHandler('esx_skin:openRestrictedMenu', function(submitCb, cancelCb, restrict)
  OpenMenu(submitCb, cancelCb, restrict)
end)

RegisterNetEvent('esx_skin:openSaveableMenu')
AddEventHandler('esx_skin:openSaveableMenu', function(submitCb, cancelCb)
  OpenSaveableMenu(submitCb, cancelCb, nil)
end)

RegisterNetEvent('esx_skin:openSaveableRestrictedMenu')
AddEventHandler('esx_skin:openSaveableRestrictedMenu', function(submitCb, cancelCb, restrict)
  OpenSaveableMenu(submitCb, cancelCb, restrict)
end)

RegisterNetEvent('esx_skin:requestSaveSkin')
AddEventHandler('esx_skin:requestSaveSkin', function()
  TriggerEvent('skinchanger:getSkin', function(skin)
    TriggerServerEvent('esx_skin:responseSatozveSkin', skin)
  end)
end)