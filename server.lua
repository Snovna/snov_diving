local hookId = exports.ox_inventory:registerHook('swapItems', function(payload)
    if Player(payload.source).state.diving then
        return false
    end
    return true
end, {
    itemFilter = {
        diving_gear = true,
    },
})

RegisterNetEvent('snov_diving:dive', function(bool)
    Player(source).state.diving = bool
end)

RegisterNetEvent('snov_diving:degrade', function(slot)
    local slotData = exports.ox_inventory:GetSlot(source, slot)
    local durability = slotData.metadata.durability

    if durability == nil then durability = 100 end
    
    if durability == 30 then
        TriggerClientEvent('snov_diving:warn', source, durability)
    elseif durability == 20 then
        TriggerClientEvent('snov_diving:warn', source,  durability)
    elseif durability == 10 then
        TriggerClientEvent('snov_diving:warn', source,  durability)
    elseif durability == 5 then
        TriggerClientEvent('snov_diving:warn', source,  durability)
    elseif durability == 0 then
        TriggerClientEvent('snov_diving:drown', source)
        return
    end
    
    exports.ox_inventory:SetDurability(source, slot, durability - 1)
end)

function checkVersion(initial)
    PerformHttpRequest('https://raw.githubusercontent.com/Snovna/fivem_updates/main/updates.json', function(statusCode, responseText, headers)
        local resourceName = GetCurrentResourceName()
        local fxVersion = GetResourceMetadata(resourceName, 'version', 0)
        local gitResponse = json.decode(responseText)

        if statusCode ~= 200 then print('^3version check failed, response error code '..statusCode) return end
        if not gitResponse then print('^3version check failed') return end
        if not gitResponse[resourceName] then print('^3version check failed, did you rename this resource?') return end
        if fxVersion ~= gitResponse[resourceName].currentVersion then
            print('^3'..resourceName..' is outdated (your version: '..fxVersion..' - current version: '..gitResponse[resourceName].currentVersion..')')
            print('^3'..gitResponse[resourceName].updateNotes)
            if gitResponse[resourceName].updateUrl then
                print('^3update it now from: '..gitResponse[resourceName].updateUrl)
            else
                print('^3update it now from your Keymaster')
            end
        else
            if not initial then return end
            print('^2'..resourceName .. ' is up to date ('..fxVersion..')')
        end
    end, 'GET')
end
CreateThread(function()
    Wait(15 * 1000)
    checkVersion(true)
    while true do
        Wait(30 * 60 * 1000)
        checkVersion(false)
    end
end)
