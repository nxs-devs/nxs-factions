
local jsn = LoadResourceFile(GetCurrentResourceName(), 'config/data.json')
local dcd = json.decode(jsn)
CreateThread(function()
    for k,v in pairs(dcd) do 
        for a,b in pairs(v.inv) do 
            exports.ox_inventory:RegisterStash(v.job..a,b.nomedeposito, tonumber(b.slots), b.peso, false)
        end
    end
end)

RegisterNetEvent('creafaz', function(data, modifica)
    local xPlayer = ESX.GetPlayerFromId(source)
    if CheckPerms(source) then 
        print(ESX.DumpTable(data))
        if modifica then
            MySQL.Async.execute('DELETE FROM jobs WHERE name = @job', { ['@job'] = data.job })
            MySQL.Async.execute('DELETE FROM job_grades WHERE job_name = @job', { ['@job'] = data.job })
            for c,grado in pairs(data.gradi) do 
                MySQL.insert('INSERT IGNORE INTO jobs (name, label) VALUES (?, ?)', { data.job, data.label })
                MySQL.prepare('INSERT INTO job_grades (job_name, grade, name, label, salary) VALUES (?, ?, ?, ?, ?)', {data.job, grado.grade, grado.name, grado.label, grado.salary})
            end
            Wait(500)
            ESX.RefreshJobs()
            if Config.AutoSetJob then
                xPlayer.setJob(data.job, 0)
            end
            table.remove(dcd, old)
            table.insert(dcd, data)
            SaveResourceFile(GetCurrentResourceName(), "config/data.json", json.encode(dcd, { indent = true }), -1)
            TriggerClientEvent('creafaz-cl', -1, dcd)
            for k,v in pairs(data) do 
                for a,b in pairs(data.inv) do 
                    exports.ox_inventory:RegisterStash(data.job..a,b.nomedeposito, tonumber(b.slots), b.peso, false)
                end
            end
        else
            for c,grado in pairs(data.gradi) do 
                MySQL.insert('INSERT IGNORE INTO jobs (name, label) VALUES (?, ?)', { data.job, data.label })
                MySQL.prepare('INSERT INTO job_grades (job_name, grade, name, label, salary) VALUES (?, ?, ?, ?, ?)', {data.job, grado.grade, grado.name, grado.label, grado.salary})
            end
            Wait(500)
            ESX.RefreshJobs()
            if Config.AutoSetJob then
                xPlayer.setJob(data.job, 0)
            end
            table.insert(dcd, data)
            SaveResourceFile(GetCurrentResourceName(), "config/data.json", json.encode(dcd, { indent = true }), -1)
            TriggerClientEvent('creafaz-cl', -1, dcd)
            for k,v in pairs(data) do 
                for a,b in pairs(data.inv) do 
                    exports.ox_inventory:RegisterStash(data.job..a,b.nomedeposito, tonumber(b.slots), b.peso, false)
                end
            end
        end
    end

end)

RegisterNetEvent('eliminafaz', function(data, selezionata)
    local xPlayer = ESX.GetPlayerFromId(source)
    if xPlayer.group ~= 'user' then 
        MySQL.Async.execute('DELETE FROM jobs WHERE name = @job', { ['@job'] = data.job })
        MySQL.Async.execute('DELETE FROM job_grades WHERE job_name = @job', { ['@job'] = data.job })
        TriggerClientEvent('eliminafaz-cl', -1, data)
        Wait(500)
        table.remove(dcd, selezionata)
        SaveResourceFile(GetCurrentResourceName(), "config/data.json", json.encode(dcd, { indent = true }), -1)
        ESX.RefreshJobs()
    end
end)

RegisterCommand(Config.EditCommand, function(source)
    if CheckPerms(source) then
        local jsn = LoadResourceFile(GetCurrentResourceName(), 'config/data.json')
        local dcd = json.decode(jsn)
        TriggerClientEvent("modificafaz", source, dcd)
    end
end)

RegisterCommand(Config.CreateCommand, function(source)
    if CheckPerms(source) then
        TriggerClientEvent("creafazione", source)
    end
end)

CheckPerms = function(source)
    local xPlayer = ESX.GetPlayerFromId(source)
    for k,v in pairs(Config.AdminGroups) do 
        if v == xPlayer.getGroup() then 
            return true
        end
    end
    xPlayer.showNotification(locale('perms'))
end

AddEventHandler('onResourceStart', function(resourceName)
    
    local function printa()
        while true do
            print('^1Resource Name needs to be: ^5nxs-factions')
            Citizen.Wait(300)
        end
    end
    if (GetCurrentResourceName() ~= 'nxs-factions') then
        printa()
        return
    end
    print('^5The resource ' .. resourceName .. ' has been successfully started.^0')
end)
