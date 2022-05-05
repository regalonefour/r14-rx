local QBCore = exports['qb-core']:GetCoreObject()
local writingrx = false

RegisterNetEvent('r14-rx:client:WriteRx', function()
    if writingrx then return end        
    writingrx = true

    local rx = exports["qb-input"]:ShowInput({
        header = "Prescription Pad",
        submitText = "Write",
        inputs = {
            {
                text = "Patient Name",
                name = "patient",
                type = "text",
                isRequired = true
            },
            {
                text = "Refills",
                name = "refills",
                type = "number",
                isRequired = true
            },
            {
                text = "Prescription",
                name = "rx",
                type = "text",
                isRequired = true
            },
            {
                text = "Directions",
                name = "directions",
                type = "text",
                isRequired = true
            },
        }
    })


    CreateThread(function()
        while writingrx do
            Wait(100)
            if not IsNuiFocused() then
                TriggerEvent('r14-rx:client:RxAnimation')
                writingrx = false
            end
        end   
    end)

    if rx then
        TriggerEvent('r14-rx:client:CreateRx', rx)
    else
        return
    end
end)

RegisterNetEvent('r14-rx:client:CreateRx', function(rx)
    exports['qb-menu']:openMenu({
        {
            header = "Write Prescription",
            isMenuHeader = true
        },
        {
            header = "Create Rx",
            params = {
                isServer = true,
                event = 'r14-rx:server:CreateRx',
                args = rx
            }
        },
        {
            header = "Give Rx",
            params = {
                event = 'r14-rx:client:GiveRx',
                args = rx
            }
        },

        {
            header = "Cancel (ESC)",
            params = {
                event = exports['qb-menu']:closeMenu(),
            }
        },
    })
end)

RegisterNetEvent('r14-rx:client:GiveRx', function(rx)
    local player, distance = QBCore.Functions.GetClosestPlayer(GetEntityCoords(PlayerPedId()))
    if player ~= -1 and distance < 3 then
            local playerId = GetPlayerServerId(player)
            SetCurrentPedWeapon(PlayerPedId(),'WEAPON_UNARMED',true)
            TriggerServerEvent('r14-rx:server:GiveRx', playerId, rx)
    else
        QBCore.Functions.Notify("No one nearby!", "error")
    end
end)

RegisterNetEvent('r14-rx:client:tickRx', function(item)
    TriggerEvent('animations:client:EmoteCommandStart', {"notepad"})
    QBCore.Functions.Progressbar("tickrx", "Updating prescription...", 1500, false, true, {
        disableMovement = false,
        disableCarMovement = false,
        disableMouse = false,
        disableCombat = true,
    }, {}, {}, {}, function() -- Done
        TriggerEvent('animations:client:EmoteCommandStart', {"c"})
        TriggerServerEvent('r14-rx:server:tickRx', item)
    end, function() -- Cancel
        TriggerEvent('animations:client:EmoteCommandStart', {"c"})
    end)
end)

RegisterNetEvent('r14-rx:client:RxAnimation', function()
    local player = PlayerPedId()
    local ad = "missheistdockssetup1clipboard@base"
                
    local prop_name = prop_name or 'prop_notepad_01'
    local secondaryprop_name = secondaryprop_name or 'prop_pencil_01'
    
    if ( DoesEntityExist( player ) and not IsEntityDead( player )) then 
        loadAnimDict( ad )
        if ( IsEntityPlayingAnim( player, ad, "base", 3 ) ) then 
            TaskPlayAnim( player, ad, "exit", 8.0, 1.0, -1, 49, 0, 0, 0, 0 )
            Citizen.Wait(100)
            ClearPedSecondaryTask(PlayerPedId())
            DetachEntity(prop, 1, 1)
            DeleteObject(prop)
            DetachEntity(secondaryprop, 1, 1)
            DeleteObject(secondaryprop)
        else
            local x,y,z = table.unpack(GetEntityCoords(player))
            prop = CreateObject(GetHashKey(prop_name), x, y, z+0.2,  true,  true, true)
            secondaryprop = CreateObject(GetHashKey(secondaryprop_name), x, y, z+0.2,  true,  true, true)
            AttachEntityToEntity(prop, player, GetPedBoneIndex(player, 18905), 0.1, 0.02, 0.05, 10.0, 0.0, 0.0, true, true, false, true, 1, true) -- lkrp_notepadpad
            AttachEntityToEntity(secondaryprop, player, GetPedBoneIndex(player, 58866), 0.11, -0.02, 0.001, -120.0, 0.0, 0.0, true, true, false, true, 1, true) -- pencil
            TaskPlayAnim( player, ad, "base", 8.0, 1.0, -1, 49, 0, 0, 0, 0 )
        end     
    end
end)

function loadAnimDict(dict)
    while (not HasAnimDictLoaded(dict)) do
        RequestAnimDict(dict)
        Citizen.Wait(5)
    end
end

function openRx()
    SetNuiFocus(false, false)
end
