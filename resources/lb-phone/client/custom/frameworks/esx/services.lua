if Config.Framework ~= "esx" then
    return
end

while not ESX do
    Wait(500)
    debugprint("Services: Waiting for ESX to load")
end

---@return string
function GetJob()
    return ESX.PlayerData?.job?.name or "unemployed"
end

---@return number
function GetJobGrade()
    return ESX.PlayerData?.job?.grade or 0
end

RegisterNetEvent("esx:affiliateJob", function(job)
    local oldJob = ESX.PlayerData.job

    ESX.PlayerData.job = job

    if oldJob.name ~= job.name or oldJob.grade ~= job.grade then
        SendReactMessage("services:setCompany", GetCompanyData())
    else
        SendReactMessage("services:setDuty", job.onDuty)
    end

    TriggerEvent("lb-phone:jobUpdated", {
        job = job.name,
        grade = job.grade
    })
end)

-- =========================================================================
-- Etat "en service" reel.
--
-- ESX legacy n'a pas de champ `job.onDuty` : il valait donc toujours nil, et
-- l'app Services affichait l'employe hors service en permanence, meme apres
-- une prise de service F6. La verite est portee par sJobs (globale
-- `inService`, exposee via l'export client `inService`).
--
-- Cout : un appel d'export local, uniquement quand l'app Services est
-- ouverte ou qu'un changement de job est pousse. Aucun polling.
-- =========================================================================
local function GetRealDuty()
    if GetResourceState("sJobs") ~= "started" then
        return ESX.PlayerData?.job?.onDuty
    end

    local ok, duty = pcall(function()
        return exports["sJobs"]:inService()
    end)

    if ok and duty ~= nil then
        return duty and true or false
    end

    return ESX.PlayerData?.job?.onDuty
end

function GetCompanyData()
    local companyData = {
        job = ESX.PlayerData.job.name,
        jobLabel = ESX.PlayerData.job.label,
        isBoss = ESX.PlayerData.job.grade_name == "boss",
        duty = GetRealDuty()
    }

    if not companyData.isBoss then
        for cId = 1, #Config.Companies.Services do
            local company = Config.Companies.Services[cId]

            if company.job == companyData.job then
                if not company.bossRanks then
                    break
                end

                companyData.isBoss = table.contains(company.bossRanks, ESX.PlayerData.job.grade_name)

                break
            end
        end
    end

    if not companyData.isBoss then
        return companyData
    end

    ESX.TriggerServerCallback("esx_society:getSocietyMoney", function(money)
        companyData.balance = money
    end, companyData.job)

    ESX.TriggerServerCallback("esx_society:getEmployees", function(employees)
        for i = 1, #employees do
            local employee = employees[i]

            employees[i] = {
                name = employee.name,
                id = employee.identifier,

                gradeLabel = employee.job.grade_label,
                grade = employee.job.grade,

                canInteract = employee.job.grade_name ~= "boss"
            }
        end

        companyData.employees = employees
    end, companyData.job)

    ESX.TriggerServerCallback("esx_society:getJob", function(job)
        local grades = {}

        for i = 1, #job.grades do
            local grade = job.grades[i]

            grades[i] = {
                label = grade.label,
                grade = grade.grade
            }
        end

        companyData.grades = grades
    end, companyData.job)

    local timeout = GetGameTimer() + 2000

    while not companyData.balance or not companyData.employees or not companyData.grades do
        Wait(0)

        if GetGameTimer() > timeout then
            infoprint("error", "Failed to get company data (timed out after 2s)")
            print("balance: " .. tostring(companyData.balance))
            print("employees: " .. tostring(companyData.employees))
            print("grades: " .. tostring(companyData.grades))

            companyData.employees = companyData.employees or {}
            companyData.balance = companyData.balance or 0
            companyData.grades = companyData.grades or {}
            break
        end
    end

    return companyData
end

function DepositMoney(amount, cb)
    TriggerServerEvent("esx_society:depositMoney", ESX.PlayerData.job.name, amount)
    Wait(500) -- Wait for the server to update the balance

    ESX.TriggerServerCallback("esx_society:getSocietyMoney", cb, ESX.PlayerData.job.name)
end

function WithdrawMoney(amount, cb)
    TriggerServerEvent("esx_society:withdrawMoney", ESX.PlayerData.job.name, amount)
    Wait(500) -- Wait for the server to update the balance

    ESX.TriggerServerCallback("esx_society:getSocietyMoney", cb, ESX.PlayerData.job.name)
end

function HireEmployee(source, cb)
    local playersPromise = promise.new()

    ESX.TriggerServerCallback("esx_society:getOnlinePlayers", function(players)
        playersPromise:resolve(players)
    end)

    local players = Citizen.Await(playersPromise)
    local player

    for i = 1, #players do
        if players[i].source == source then
            player = players[i]
            break
        end
    end

    if not player then
        return false
    end

    local hirePromise = promise.new()

    ESX.TriggerServerCallback("esx_society:setJob", function()
        hirePromise:resolve(true)
    end, player.identifier, ESX.PlayerData.job.name, 0, "hire")

    if not Citizen.Await(hirePromise) then
        return
    end

    return {
        id = player.identifier,
        name = player.name,
    }
end

function FireEmployee(identifier, cb)
    local firePomise = promise.new()

    ESX.TriggerServerCallback("esx_society:setJob", function()
        firePomise:resolve(true)
    end, identifier, "unemployed", 0, "fire")

    return Citizen.Await(firePomise)
end

function SetGrade(identifier, newGrade, cb)
    local promotePromise = promise.new()

    ESX.TriggerServerCallback("esx_society:getJob", function(jobData)
        if newGrade > #jobData.grades - 1 then
            return cb(false)
        end

        ESX.TriggerServerCallback("esx_society:setJob", function()
            promotePromise:resolve(true)
        end, identifier, ESX.PlayerData.job.name, newGrade, "promote")
    end, ESX.PlayerData.job.name)

    return Citizen.Await(promotePromise)
end

-- Miroir de la prise de service faite AILLEURS que dans le telephone (F6
-- sJobs, menu bar, EMS, LSFD) : on rejoue exactement ce que fait la bascule
-- de l'app, cote coeur lb-phone (phone:services:toggleDuty) et cote UI, sans
-- re-emettre sJobs.service (deja fait par l'origine : pas de boucle).
RegisterNetEvent("lb-phone:mirrorDuty", function(duty)
    duty = duty == true
    TriggerServerEvent("phone:services:toggleDuty", duty)
    if ESX and ESX.PlayerData and ESX.PlayerData.job then
        ESX.PlayerData.job.onDuty = duty
    end
    SendReactMessage("services:setDuty", duty)
end)

---@param duty boolean
function ToggleDuty(duty)
    TriggerServerEvent("phone:services:toggleDuty", duty)

    -- La bascule du telephone doit piloter la MEME prise de service que le
    -- menu F6, sinon on se retrouve avec deux etats de service divergents et
    -- l'employe reste injoignable alors que son telephone l'affiche en
    -- service.
    --
    -- Garde-fou obligatoire : `sJobs.service` DropPlayer les joueurs sans
    -- emploi. Un joueur licencie pendant que l'app est ouverte serait donc
    -- kicke sur un simple clic -- on verifie le job avant d'emettre.
    local job = ESX.PlayerData?.job?.name
    if not job or job == "unemployed" then
        return
    end

    TriggerServerEvent("sJobs.service", duty and "on" or "off")

    -- Miroir de l'etat cote client sJobs (pilote l'affichage du menu F6 et
    -- les options ox_target du job), sinon les deux menus se contrediraient.
    if GetResourceState("sJobs") == "started" then
        pcall(function() exports["sJobs"]:setInService(duty) end)
    end
end
