--[[

    TriggerEvent('ox_gridsystem:registerMarker', {
        name = 'a_unique_name_for_this_marker',
        pos = vector3(0.0, 0.0, 0.0),
        scale = vector3(1.5, 1.5, 1.5),
        control = 'E',
        type = 20,
        drawDistance = 5,
        interactDistance = 2,
        show3D  = true;
        msg = 'Press ~INPUT_CONTEXT~ to do something',
        shouldBob = true,
        shouldRotate = true,
        color = { r = 130, g = 120, b = 110 },
        action = function()
            print('This is executed when you press E in the marker')
        end,
        onEnter = function()
            print('This is executed when you enter a marker')
        end,
        onExit = function()
            print('This is executed when you eixit a marker')
        end,
        --For Custom Marker
        texture = "texture_name" or nil,  
        textureDict = "texture_dict" or nil,
        --For Marker only job (esx (1 and 2) or qbcore )
        permission = "police" or {"police","ambulance"},
        jobGrade = 0,
    })
    TriggerEvent('ox_gridsystem:unregisterMarker', 'name_of_the_marker')
]]
local Keys = {
    ["ESC"] = 322, ["F1"] = 288, ["F2"] = 289, ["F3"] = 170, ["F5"] = 166, ["F6"] = 167, ["F7"] = 168, ["F8"] = 169, ["F9"] = 56, ["F10"] = 57,
    ["~"] = 243, ["1"] = 157, ["2"] = 158, ["3"] = 160, ["4"] = 164, ["5"] = 165, ["6"] = 159, ["7"] = 161, ["8"] = 162, ["9"] = 163, ["-"] = 84, ["="] = 83, ["BACKSPACE"] = 177,
    ["TAB"] = 37, ["Q"] = 44, ["W"] = 32, ["E"] = 38, ["R"] = 45, ["T"] = 245, ["Y"] = 246, ["U"] = 303, ["P"] = 199, ["["] = 39, ["]"] = 40, ["ENTER"] = 18,
    ["CAPS"] = 137, ["A"] = 34, ["S"] = 8, ["D"] = 9, ["F"] = 23, ["G"] = 47, ["H"] = 74, ["K"] = 311, ["L"] = 182,
    ["LEFTSHIFT"] = 21, ["Z"] = 20, ["X"] = 73, ["C"] = 26, ["V"] = 0, ["B"] = 29, ["N"] = 249, ["M"] = 244, [","] = 82, ["."] = 81,
    ["LEFTCTRL"] = 36, ["LEFTALT"] = 19, ["SPACE"] = 22, ["RIGHTCTRL"] = 70,
    ["HOME"] = 213, ["PAGEUP"] = 10, ["PAGEDOWN"] = 11, ["DELETE"] = 178,
    ["LEFT"] = 174, ["RIGHT"] = 175, ["TOP"] = 27, ["DOWN"] = 173,
    ["NENTER"] = 201, ["N4"] = 108, ["N5"] = 60, ["N6"] = 107, ["N+"] = 96, ["N-"] = 97, ["N7"] = 117, ["N8"] = 61, ["N9"] = 118
}

local zoneRegistered = {}
CurrentJob = nil

local CurrenPlayerData = {
    job = {
        name = "//",
        grade = 0,
    }
}
local CurrenPlayerData2 = {
    job = {
        name = "//",
        grade = 0,
    }
}
local FrameWork = nil

local DrawText3D = function (x, y, z, text)
    SetTextScale(0.325, 0.325)
    SetTextFont(4)
    SetTextProportional(1)
    SetTextColour(255, 255, 255, 215)
    SetTextEntry("STRING")
    SetTextCentre(true)
    AddTextComponentString(text)
    SetDrawOrigin(x,y,z, 0)
    DrawText(0.0, 0.0)
    local factor = (string.len(text)) / 370
    DrawRect(0.0, 0.0+0.0125, 0.017+ factor, 0.03, 0, 0, 0, 68)
    ClearDrawOrigin()
end

FrameWork = exports["es_extended"]:getSharedObject()

RegisterNetEvent('esx:playerLoaded')
AddEventHandler('esx:playerLoaded', function(xPlayer)
    CurrenPlayerData.job = xPlayer.job
    if xPlayer.job then
        CurrenPlayerData.job = xPlayer.job
    end
end)

CreateThread(function ()
    while not ESX.IsPlayerLoaded() do
        Wait(10)
    end
    CurrentJob = ESX.GetPlayerData().job
    CurrentJob2 = ESX.GetPlayerData().job2
end)

RegisterNetEvent("esx:setJob")
AddEventHandler("esx:setJob", function (job)
    CurrentJob = job
end)

RegisterNetEvent("esx:setJob2")
AddEventHandler("esx:setJob2", function (job)
    CurrentJob2 = job
end)

local function HasJob(data)
    local hasJob = false
    if type(data.job) == "table" then
        for i = 1, #data.job, 1 do
            if 
            data.job[i] == CurrentJob.name and CurrentJob.grade >= data.grade
            or 
            data.job[i] == CurrentJob2.name and CurrentJob2.grade >= data.grade
            then
                hasJob = true
            end
        end
    elseif type(data.job) == "string" then 
        if
        data.job == CurrentJob.name and CurrentJob.grade >= data.grade
        or
        data.job == CurrentJob2.name and CurrentJob2.grade >= data.grade
        then
            hasJob = true
        end
    end
    return hasJob
end



local registerMarker = function (data)
    if zoneRegistered[data.name] then
        if zoneRegistered[data.name].remove and type(zoneRegistered[data.name].remove) == "function" then
            local status, err = pcall(zoneRegistered[data.name].remove)     
        end
        zoneRegistered[data.name] = nil
    end
    
    local point = lib.points.new({

        coords = data.pos or GetEntityCoords(cache.ped),
        distance = data.drawDistance or 5,

        show3D = data.show3D or false,
        msg = data.msg or "",

        interactDistance = data.interactDistance or 2,

        control = data.control or "E",
        action = data.action,
    

        type = data.type or 1,
        scale = data.scale or vec3(1.5, 1.5, 1.5),
        color = data.color or { r = 130, g = 120, b = 110 },


        texture = data.texture,
        textureDict = data.textureDict,

        shouldBob = data.shouldBob or false,
        shouldRotate = data.shouldRotate or false,

        job = data.permission or false,
        grade = data.jobGrade or 0,
    })
    
    zoneRegistered[data.name] = point

    function point:onEnter()
        if self.onEnter and type(self.onEnter) == "function" then
            if self.job then
                if not HasJob(self) then
                    return
                end
            end
            local status, err = pcall(data.onEnter)
        end
    end
     
    function point:onExit()
        if self.onExit and type(self.onExit) == "function" then
            lib.hideTextUI()
            if self.job then
                if not HasJob(self) then
                    return
                end
            end
            local status, err = pcall(data.onExit)
        end
    end
     --
    function point:nearby()
        if self.job then
            if not HasJob(self) then
                return
            end
        end

        if self.msg ~= "" then
            FunzioneTextUI(self.msg)
        end

        if self.type ~= -1 then
            DrawMarker(self.type, self.coords, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, self.scale.x, self.scale.y, self.scale.z, self.color.r, self.color.g, self.color.b, 100, self.shouldBob or false, true, 2, self.shouldRotate or false, nil, nil, false)
        elseif self.texture ~= nil then 
            if not HasStreamedTextureDictLoaded(self.textureDict) then
                RequestStreamedTextureDict(self.textureDict, true)
                while not HasStreamedTextureDictLoaded(self.textureDict) do
                    Wait(1)
                end
            else
                DrawMarker(9, self.coords, 0.0, 0.0, 0.0, 90.0, 0.0, 0.0, self.scale.x, self.scale.y, self.scale.z, 255, 255, 255, 100, false, true, 2, true, self.textureDict, self.texture, false)
            end       
        end
        if self.currentDistance <= self.interactDistance and IsControlJustReleased(0, 38) then
            if self.action then
                local status, err = pcall(self.action)
            end
        end
    end
end

local unregisterMarker = function (name)
    if zoneRegistered[name] then
        if zoneRegistered[name].remove then
            local success, error_message = pcall(zoneRegistered[name].remove, zoneRegistered[name])
            if not success then
                print("Error during marker removal:", error_message)
            end
            print(name)
        end
        zoneRegistered[name] = nil
    else
        print("Marker with name", name, "not found.")
    end
    
end


RegisterNetEvent("ox_gridsystem:registerMarker")
AddEventHandler("ox_gridsystem:registerMarker",registerMarker)

RegisterNetEvent("gridsystem:registerMarker")
AddEventHandler("gridsystem:registerMarker",registerMarker)

RegisterNetEvent("ox_gridsystem:unregisterMarker")
AddEventHandler("ox_gridsystem:unregisterMarker",unregisterMarker)

RegisterNetEvent("gridsystem:unregisterMarker")
AddEventHandler("gridsystem:unregisterMarker",unregisterMarker)