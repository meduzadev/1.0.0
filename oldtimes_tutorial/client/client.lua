ESX = nil
local inTutorial = false
local tutorialSteps = {
    {
        title = "Welcome to Our Server",
        message = "Get ready to experience an amazing adventure in our FiveM server.",
        camCoords = vector3(-425.0, 1120.0, 325.0),
        camRotation = vector3(-35.0, 0.0, 28.0)
    },
    {
        title = "Job Center",
        message = "Visit the Job Center to find work and earn money.",
        camCoords = vector3(-265.0, -960.0, 30.0),
        camRotation = vector3(-20.0, 0.0, 40.0)
    },
    {
        title = "Vehicle Shop",
        message = "Buy your dream car at our Vehicle Shop and customize it.",
        camCoords = vector3(230.0, -800.0, 30.0),
        camRotation = vector3(-30.0, 0.0, 160.0)
    },
    {
        title = "Police Department",
        message = "Join the force and protect the city at the Police Department.",
        camCoords = vector3(430.0, -980.0, 30.0),
        camRotation = vector3(-20.0, 0.0, 70.0)
    },
    {
        title = "Hospital",
        message = "Get medical assistance at the hospital when you're injured.",
        camCoords = vector3(310.0, -580.0, 43.0),
        camRotation = vector3(-20.0, 0.0, 70.0)
    }
}

local function startPresentationTutorial()
    inTutorial = true
    SetNuiFocus(true, true)
    SendNUIMessage({action = "showTutorial", steps = tutorialSteps})
end

local function stopPresentationTutorial()
    SetNuiFocus(false, false)
    SendNUIMessage({action = "hideTutorial"})
    inTutorial = false
end

RegisterNUICallback('nextStep', function(data, cb)
    -- Logic to move camera to the next step
end)

RegisterNUICallback('finishTutorial', function(data, cb)
    stopPresentationTutorial()
end)

RegisterNUICallback('loaded', function(data, cb)
    -- Set initial step data
    local step = tutorialSteps[1]
    SendNUIMessage({
        action = "setStep",
        title = step.title,
        message = step.message,
        isFirst = true,
        isLast = #tutorialSteps == 1
    })
end)

RegisterNUICallback('nextStep', function(data, cb)
    local newIndex = data.index + 1
    local step = tutorialSteps[newIndex]
    SendNUIMessage({
        action = "setStep",
        title = step.title,
        message = step.message,
        isFirst = newIndex == 1,
        isLast = newIndex == #tutorialSteps
    })
end)

RegisterNUICallback('previousStep', function(data, cb)
    local newIndex = data.index - 1
    local step = tutorialSteps[newIndex]
    SendNUIMessage({
        action = "setStep",
        title = step.title,
        message = step.message,
        isFirst = newIndex == 1,
        isLast = newIndex == #tutorialSteps
    })
end)


Citizen.CreateThread(function()
    while ESX == nil do
        TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)
        Citizen.Wait(0)
    end

    Citizen.Wait(5000) -- Wait for ESX to be initialized

    ESX.TriggerServerCallback('oldtimes_tutorial:isFirstTime', function(firstTime)
        if firstTime then
            startPresentationTutorial()
        end
    end)
end)
