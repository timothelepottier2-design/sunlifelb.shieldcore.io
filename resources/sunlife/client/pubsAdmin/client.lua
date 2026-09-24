local OPEN = false
local DATA = {}
local DUI = {}

local BILLBOARD_PAGE = ('https://cfx-nui-%s/html/pubs/billboard.html'):format(GetCurrentResourceName())

local function destroyDuis()
    for k, v in pairs(DUI) do

        if v.ytd and v.asset then
            RemoveReplaceTexture(v.ytd, v.asset)
        end
        if v.dui and IsDuiAvailable(v.dui) then
            DestroyDui(v.dui)
        end
    end
    DUI = {}
end

local function hasUrl(ad)
    return ad and ad.url and type(ad.url) == 'string' and #ad.url > 5
end

local function applyAdverts(list)
    destroyDuis()
    DATA = list or {}
    for id, ad in ipairs(DATA) do
        if hasUrl(ad) then
            local txd = 'ap_txd_' .. id
            local tex = 'ap_tex_' .. id

            local entry = {
                txdName = txd,
                texName = tex,
                ytd     = ad.ytd,
                asset   = ad.asset,
                url     = ad.url,
            }
            entry.txd = CreateRuntimeTxd(txd)

            entry.dui = CreateDui(BILLBOARD_PAGE, ad.width, ad.height)
            DUI[id] = entry

            local duiObj = entry.dui
            Citizen.CreateThread(function()

                local tries = 0
                while not IsDuiAvailable(duiObj) and tries < 1000 do
                    Citizen.Wait(10)
                    tries = tries + 1
                end
                if not IsDuiAvailable(duiObj) then return end

                CreateRuntimeTextureFromDuiHandle(entry.txd, tex, GetDuiHandle(duiObj))
                AddReplaceTexture(ad.ytd, ad.asset, txd, tex)
                SendDuiMessage(duiObj, json.encode({ url = ad.url }))
            end)
        else

            RemoveReplaceTexture(ad.ytd, ad.asset)
        end
    end
end

RegisterNetEvent('admin_pubs:broadcast', function(list)
    applyAdverts(list)
end)

Citizen.CreateThread(function()
    Citizen.Wait(5000)
    TriggerServerEvent('admin_pubs:syncMe')
    while true do
        Citizen.Wait(15000)

        for _, entry in pairs(DUI) do
            if entry.dui and IsDuiAvailable(entry.dui) then
                AddReplaceTexture(entry.ytd, entry.asset, entry.txdName, entry.texName)
                if entry.url then
                    SendDuiMessage(entry.dui, json.encode({ url = entry.url }))
                end
            end
        end
    end
end)

RegisterCommand('pubs', function()
    TriggerServerEvent('admin_pubs:requestOpen')
end)

local selectedAd = nil

RegisterNetEvent('admin_pubs:open', function(allowed, list)
    if not allowed then
        TriggerEvent('chat:addMessage', {args={'^1Admin', 'Accès refusé'}})
        return
    end
    DATA = list or {}
    if OPEN then return end

    RMenu.Add('adminpubs', 'main', RageUI.CreateMenu('SunLife', 'Panneaux publicitaires', 1, 100))
    RMenu:Get('adminpubs', 'main'):SetRectangleBanner(255, 106, 0, 225)
    RMenu:Get('adminpubs', 'main').Closed = function()
        OPEN = false
        RMenu:Delete('adminpubs', 'main')
        RMenu:Delete('adminpubs', 'edit')
    end

    RMenu.Add('adminpubs', 'edit', RageUI.CreateSubMenu(RMenu:Get('adminpubs', 'main'), 'SunLife', 'Modifier le panneau'))
    RMenu:Get('adminpubs', 'edit'):SetRectangleBanner(255, 106, 0, 225)

    OPEN = true
    RageUI.Visible(RMenu:Get('adminpubs', 'main'), true)

    Citizen.CreateThread(function()
        while OPEN do
            Citizen.Wait(1)

            RageUI.IsVisible(RMenu:Get('adminpubs', 'main'), true, true, true, function()
                RageUI.Separator('Sélectionnez un panneau à modifier')
                for i, ad in ipairs(DATA) do
                    local has = hasUrl(ad)
                    local rl = has and '🖼 Image' or '⚪ Défaut'
                    local desc = ('Asset ciblé: ~b~%s~s~ / ~b~%s~s~~n~Dimensions: %dx%d~n~%s'):format(
                        ad.ytd, ad.asset, ad.width or 0, ad.height or 0,
                        has and ('~o~URL:~s~ '..tostring(ad.url)) or '~c~Aucune image (texture par défaut)'
                    )
                    RageUI.ButtonWithStyle(ad.name, desc, {RightLabel = rl..' →→'}, true, function(h, a, s)
                        if s then selectedAd = i end
                    end, RMenu:Get('adminpubs', 'edit'))
                end
            end)

            RageUI.IsVisible(RMenu:Get('adminpubs', 'edit'), true, true, true, function()
                local ad = selectedAd and DATA[selectedAd]
                if not ad then
                    RageUI.Separator('~r~Aucun panneau sélectionné')
                    return
                end
                local has = hasUrl(ad)
                RageUI.Separator('Panneau: ~o~'..ad.name)
                RageUI.Separator('Asset: ~b~'..ad.ytd..'~s~ / ~b~'..ad.asset)
                RageUI.Separator(has and ('~o~URL:~s~ '..tostring(ad.url)) or '~c~Aucune image (défaut)')

                RageUI.ButtonWithStyle("Définir / changer l'URL de l'image", "Lien direct vers une image (https://... .png/.jpg/.gif).", {RightLabel = '✏️'}, true, function(h, a, s)
                    if s then
                        local url = exports["sJobs"]:KeyboardInput("URL de l'image", ad.url or "", 300)
                        if url and type(url) == 'string' and #url > 5 then
                            TriggerServerEvent('admin_pubs:updateAdvert', ad.id, url)
                        end
                    end
                end)

                RageUI.ButtonWithStyle("Réinitialiser (image par défaut)", "Retire l'image et remet la texture d'origine du panneau.", {RightLabel = '♻️'}, has, function(h, a, s)
                    if s then
                        TriggerServerEvent('admin_pubs:clearAdvert', ad.id)
                    end
                end)
            end)
        end
    end)
end)
