KnockoutHandler = {}
KnockoutHandler.__index = KnockoutHandler

function KnockoutHandler:new()
    local instance = setmetatable({}, self)

    instance.knockedOut = false
    instance.wait = 15
    instance.count = 60
    instance.injuredApplied = false
    return instance
end

function KnockoutHandler:Monitor()
    while true do
        local ped = PlayerPedId()
        local sleep = 1000
        local health = GetEntityHealth(ped)
        local walkstyle = Entity(ped).state.walkstyle

        if IsPedInMeleeCombat(ped) then
            sleep = 0
            if health < 115 then
                self:TriggerKnockout(ped)
            end
        end

        if not self.knockedOut and health > 0 and health < 130 then
            if (not walkstyle or walkstyle == "") and not self.injuredApplied then
                RequestAnimSet("move_m@injured")
                while not HasAnimSetLoaded("move_m@injured") do Wait(10) end
                SetPedMovementClipset(ped, "move_m@injured", 1.0)
                self.injuredApplied = true
            end
        elseif not self.knockedOut and health >= 130 and self.injuredApplied then

            if not walkstyle or walkstyle == "" then
                ResetPedMovementClipset(ped, 0.0)
            else
                RequestAnimSet(walkstyle)
                while not HasAnimSetLoaded(walkstyle) do Wait(10) end
                SetPedMovementClipset(ped, walkstyle, 1.0)
            end
            self.injuredApplied = false
        end

        if self.knockedOut then
            sleep = 0
            self:HandleKnockout(ped)
        end

        Wait(sleep)
    end
end

function KnockoutHandler:TriggerKnockout(ped)
    if not self.knockedOut then
        self.knockedOut = true
        self.wait = 15
        self.count = 60

        SetEntityHealth(ped, 116)
        SetPlayerInvincible(PlayerId(), true)
        SetPedToRagdoll(ped, 1000, 1000, 0, false, false, false)
    end
end

function KnockoutHandler:HandleKnockout(ped)
    DisablePlayerFiring(PlayerId(), true)
    SetPedToRagdoll(ped, 1000, 1000, 0, false, false, false)
    ResetPedRagdollTimer(ped)

    if self.wait >= 0 then
        self.count = self.count - 1
        if self.count <= 0 then
            self.count = 60
            self.wait = self.wait - 1
            if GetEntityHealth(ped) < 200 then
                SetEntityHealth(ped, GetEntityHealth(ped) + 4)
            end
        end
    else
        self:Recover(ped)
    end
end

function KnockoutHandler:Recover(ped)
    self.knockedOut = false
    SetPlayerInvincible(PlayerId(), false)
end

local knockoutHandler = KnockoutHandler:new()

CreateThread(function()
    knockoutHandler:Monitor()
end)

exports("IsKnockedOut", function()
    return knockoutHandler and knockoutHandler.knockedOut or false
end)
