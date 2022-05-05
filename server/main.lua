local QBCore = exports['qb-core']:GetCoreObject()

RegisterNetEvent('r14-rx:server:CreateRx', function(rx)
	local src = source
	local Player = QBCore.Functions.GetPlayer(src)

	local info = rx

	info.doctor = Player.PlayerData.charinfo.firstname..' '.. Player.PlayerData.charinfo.lastname
	info.date = os.date('%d %B %Y')
	info.refilled = 0

	if not Player.Functions.AddItem("prescription", 1, false, info) then
		TriggerClientEvent('QBCore:Notify', source,  "Ain't even got space for a note in these pockets, damn bruh.", "error")
		TriggerClientEvent('inventory:client:ItemBox', src, QBCore.Shared.Items["prescription"], "add")
	end
end)

RegisterServerEvent('r14-rx:server:GiveRx', function(target, rx)
    local src = source
    local Player = QBCore.Functions.GetPlayer(src)
    local OtherPlayer = QBCore.Functions.GetPlayer(tonumber(target))
    local dist = #(GetEntityCoords(GetPlayerPed(src))-GetEntityCoords(GetPlayerPed(target)))

	local info = rx

	info.doctor = Player.PlayerData.charinfo.firstname..' '.. Player.PlayerData.charinfo.lastname
	info.date = os.date('%d %B %Y')
	info.refilled = 0

	if Player == OtherPlayer then return TriggerClientEvent('QBCore:Notify', src, "You can't give yourself an item?") end
	if dist > 2 then return TriggerClientEvent('QBCore:Notify', src, "You are too far away to give items!") end
	if OtherPlayer.Functions.AddItem("prescription", 1, false, info) then
		TriggerClientEvent('inventory:client:ItemBox', target, QBCore.Shared.Items["prescription"], "add")
		TriggerClientEvent('QBCore:Notify', src, ('You pass %s their prescription.'):format(target))
		TriggerClientEvent('QBCore:Notify', target, ('%s passes you a written prescription.'):format(src))
		TriggerClientEvent("inventory:client:UpdatePlayerInventory", target, true)
		TriggerClientEvent('qb-inventory:client:giveAnim', src)
		TriggerClientEvent('qb-inventory:client:giveAnim', target)
	else
		TriggerClientEvent('QBCore:Notify', src,  "The other players inventory is full!", "error")
		TriggerClientEvent('QBCore:Notify', target,  "Your inventory is full!", "error")
		TriggerClientEvent("inventory:client:UpdatePlayerInventory", src, false)
		TriggerClientEvent("inventory:client:UpdatePlayerInventory", target, false)
	end
end)

QBCore.Functions.CreateUseableItem("prescriptionpad", function(source, item)
	local src = source
    local Player = QBCore.Functions.GetPlayer(src)

	if Player.PlayerData.job.name == 'ambulance' then	
		TriggerClientEvent('r14-rx:client:RxAnimation', src)
		TriggerClientEvent('r14-rx:client:WriteRx', src, item.info)
	else
		TriggerClientEvent('QBCore:Notify', src,  'Your hand stops and you think to yourself; "Maybe I should put some effort into forging this signature instead of going to jail forever."', "error")
	end
end)

QBCore.Functions.CreateUseableItem("prescription", function(source, item)
	local src = source
    local Player = QBCore.Functions.GetPlayer(src)

	if Player.PlayerData.job.name == 'ambulance' then
			if tonumber(item.info.refilled) >= tonumber(item.info.refills) then
				TriggerClientEvent('QBCore:Notify', src,  'Your hand stops and you think to yourself; "Maybe I shouldn\'t leave a paper trail that i\'m overfilling this prescription"', "error")	
			else
				TriggerClientEvent('r14-rx:client:tickRx', src, item)
			end
	else
		TriggerClientEvent('QBCore:Notify', src,  "You a doctor now, breh?", "error")		
	end
end)

RegisterNetEvent('r14-rx:server:tickRx', function(item)
	local src = source
    local Player = QBCore.Functions.GetPlayer(src)
	print('rxtick')

	if Player.PlayerData.job.name == 'ambulance' then
        Player.PlayerData.items[item.slot].info.refilled = Player.PlayerData.items[item.slot].info.refilled + 1
        Player.Functions.SetInventory(Player.PlayerData.items)
	end
end)
