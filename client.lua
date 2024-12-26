local slot = 0

function equipScubaGear()
    LoadAnim("clothingshirt")
	TaskPlayAnim(cache.ped, "clothingshirt", "try_shirt_positive_d", 8.0, 1.0, 1200, 49, 0, 0, 0, 0)

    SetEnableScuba(cache.ped, true)
    SetPedScubaGearVariation(cache.ped)
    SetPedConfigFlag(cache.ped, 409, true)
    TriggerServerEvent('snov_diving:dive', true)

    lib.notify({description = "Du hast die Taucherausrüstung angelegt", type="success"})
    
    while slot ~= 0 do
        Wait(7000)
        if IsPedSwimmingUnderWater(cache.ped) then
            TriggerServerEvent('snov_diving:degrade', slot)
        end
    end
end

function unequipScubaGear()
    LoadAnim("clothingshirt")
	TaskPlayAnim(cache.ped, "clothingshirt", "try_shirt_positive_d", 8.0, 1.0, 1200, 49, 0, 0, 0, 0)

    SetEnableScuba(cache.ped, false)
    ClearPedScubaGearVariation(cache.ped)
    TriggerServerEvent('snov_diving:dive', false)
    
    lib.notify({description = "Du hast die Taucherausrüstung abgelegt"})
end

function LoadAnim(dict)
    RequestAnimDict(dict)
    while not HasAnimDictLoaded(dict) do
        Wait(1)
    end
end

AddEventHandler('snov_diving:use', function(args)
    if LocalPlayer.state.diving then
        if IsPedSwimmingUnderWater(cache.ped) then
            lib.notify({description = "Du kannst deine Taucherausrüstung jetzt nicht ablegen", type = "error"})
            return
        end
        slot = 0
        unequipScubaGear()
    else
        slot = args.slot
        equipScubaGear()
    end
end)

RegisterNetEvent('snov_diving:equip', function()
    equipScubaGear()
end)

RegisterNetEvent('snov_diving:unequip', function()
    unequipScubaGear()
end)

RegisterNetEvent('snov_diving:warn', function(value)
    lib.notify({description = string.format('Du hast nur noch %d%s Luft verbleibend.',value,'%'), type='warning', duration = 5000})
end)

RegisterNetEvent('snov_diving:drown', function()
    SetEntityHealth(cache.ped, 0)
    unequipScubaGear()
    lib.notify({description = 'Du bist ertrunken', type='error', duration = 5000})
end)