local KV_KEY = 'radioanims:choice'
local isTalkingOnRadio = false
local lastAnimType = nil
local lastDict = nil
local lastAnim = nil

local OPTIONS = {
  { key = 'default', label = 'Par défaut' },
  { key = 'shoulder', label = 'Épaule (PTT)' },
  { key = 'ear',      label = 'Oreille' },
  { key = 'mouth',      label = 'Bouche' },
  { key = 'chest_right', label = 'Torse (droite)' },
  { key = 'chest_left',  label = 'Torse (gauche)' },
  { key = 'ear_right',   label = 'Oreillette (droite)' },
  { key = 'ear_left',    label = 'Oreillette (gauche)' },
  { key = 'watch_left',  label = 'Montre (gauche)' },
}

local ANIMS = {
  shoulder = { dict = 'random@arrests',         anim = 'generic_radio_chatter' },
  mouth    = { dict = 'anim@male@holding_radio',  anim = 'holding_radio_clip' },
  ear      = { dict = 'cellphone@',             anim = 'cellphone_call_listen_base' },
  chest_right = { dict = 'pazeee@radiok@animations',  anim = 'pazeee@radiok@clip' },
  chest_left  = { dict = 'pazeee@radiol@animations',  anim = 'pazeee@radiol@clip' },
  ear_right   = { dict = 'pazeee@radiom@animations',  anim = 'pazeee@radiom@clip' },
  ear_left    = { dict = 'pazeee@radion@animations',  anim = 'pazeee@radion@clip' },
  watch_left  = { dict = 'pazeee@radioo@animations',  anim = 'pazeee@radioo@clip' },
}

local current = nil

local function loadDict(dict)
  if not dict then return end
  if not HasAnimDictLoaded(dict) then
    RequestAnimDict(dict)
    local t0 = GetGameTimer()
    while not HasAnimDictLoaded(dict) and (GetGameTimer() - t0) < 5000 do
      Wait(0)
    end
  end
end

local function playChoice(ped, choice)
  lastAnimType = choice
  if choice == 'default' then

    return
  end
  local cfg = ANIMS[choice]
  if not cfg then return end
  loadDict(cfg.dict)
  lastDict, lastAnim = cfg.dict, cfg.anim

  TaskPlayAnim(ped, cfg.dict, cfg.anim, 8.0, -8.0, -1, 49, 0.0, false, false, false)
end

local function stopChoice(ped)
  if lastAnimType == 'default' then
    ExecuteCommand('emotecancel')
  else

    ClearPedSecondaryTask(ped)
  end
  lastAnimType, lastDict, lastAnim = nil, nil, nil
end

AddEventHandler('pma-voice:radioActive', function(active)
  local ped = PlayerPedId()
  if active and not isTalkingOnRadio then
    playChoice(ped, current or 'default')
    isTalkingOnRadio = true
  elseif (not active) and isTalkingOnRadio then
    stopChoice(ped)
    isTalkingOnRadio = false
  end
end)

local function loadChoice()
  local saved = GetResourceKvpString(KV_KEY)
  if saved and saved ~= '' then
    current = saved
  else
    current = 'shoulder'
  end
end

local function saveChoice()
  SetResourceKvp(KV_KEY, current or 'shoulder')
end

function GetRadioAnim()
  return current
end
exports('GetRadioAnim', GetRadioAnim)

function SetRadioAnim(key)

  local ok = false
  for _,opt in ipairs(OPTIONS) do
    if opt.key == key then ok = true break end
  end
  if not ok then return false end

  local ped = PlayerPedId()
  local wasTalking = isTalkingOnRadio
  if wasTalking then
    stopChoice(ped)
  end

  current = key
  saveChoice()

  if wasTalking then
    playChoice(ped, current)
  end
  return true
end
exports('SetRadioAnim', SetRadioAnim)

function GetRadioAnimOptions()
  return OPTIONS
end
exports('GetRadioAnimOptions', GetRadioAnimOptions)

CreateThread(function()
  loadChoice()
end)
