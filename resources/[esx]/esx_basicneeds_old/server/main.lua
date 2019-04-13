ESX = nil

TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)

ESX.RegisterUsableItem('bread', function(source)

	local xPlayer = ESX.GetPlayerFromId(source)

	xPlayer.removeInventoryItem('bread', 1)

	TriggerClientEvent('esx_status:add', source, 'hunger', 200000)
	TriggerClientEvent('esx_status:add', source, 'shit', -250000)
	TriggerClientEvent('esx_basicneeds:onEat', source)
	TriggerClientEvent('esx:showNotification', source, _U('used_bread'))

end)

ESX.RegisterUsableItem('hamburgare', function(source)

	local xPlayer = ESX.GetPlayerFromId(source)

	xPlayer.removeInventoryItem('hamburgare', 1)

	TriggerClientEvent('esx_status:add', source, 'hunger', 200000)
	TriggerClientEvent('esx_status:add', source, 'shit', -250000)
	TriggerClientEvent('esx_basicneeds:onEat', source)
end)

ESX.RegisterUsableItem('klubba', function(source)

	local xPlayer = ESX.GetPlayerFromId(source)

	xPlayer.removeInventoryItem('klubba', 1)

	TriggerClientEvent('esx_status:add', source, 'hunger', 200000)
	TriggerClientEvent('esx_status:add', source, 'shit', -250000)
	TriggerClientEvent('esx_basicneeds:onEat', source)

end)

ESX.RegisterUsableItem('korv', function(source)

	local xPlayer = ESX.GetPlayerFromId(source)

	xPlayer.removeInventoryItem('korv', 1)

	TriggerClientEvent('esx_status:add', source, 'hunger', 200000)
	TriggerClientEvent('esx_status:add', source, 'shit', -250000)
	TriggerClientEvent('esx_basicneeds:onEat', source)

end)

ESX.RegisterUsableItem('potatis', function(source)

	local xPlayer = ESX.GetPlayerFromId(source)

	xPlayer.removeInventoryItem('potatis', 1)

	TriggerClientEvent('esx_status:add', source, 'hunger', 200000)
	TriggerClientEvent('esx_status:add', source, 'shit', -250000)
	TriggerClientEvent('esx_basicneeds:onEat', source)

end)

ESX.RegisterUsableItem('steak', function(source)

	local xPlayer = ESX.GetPlayerFromId(source)

	xPlayer.removeInventoryItem('steak', 1)

	TriggerClientEvent('esx_status:add', source, 'hunger', 200000)
	TriggerClientEvent('esx_status:add', source, 'shit', -250000)
	TriggerClientEvent('esx_basicneeds:onEat', source)

end)

ESX.RegisterUsableItem('munk', function(source)

	local xPlayer = ESX.GetPlayerFromId(source)

	xPlayer.removeInventoryItem('munk', 1)

	TriggerClientEvent('esx_status:add', source, 'hunger', 200000)
	TriggerClientEvent('esx_status:add', source, 'shit', -250000)
	TriggerClientEvent('esx_basicneeds:onEat', source)

end)

ESX.RegisterUsableItem('water', function(source)

	local xPlayer = ESX.GetPlayerFromId(source)

	xPlayer.removeInventoryItem('water', 1)

	TriggerClientEvent('esx_status:add', source, 'thirst', 50000)
	TriggerClientEvent('esx_status:add', source, 'pee', -250000)
	TriggerClientEvent('esx_basicneeds:onDrink', source)
	TriggerClientEvent('esx:showNotification', source, _U('used_water'))

end)

ESX.RegisterUsableItem('cola', function(source)

	local xPlayer = ESX.GetPlayerFromId(source)

	xPlayer.removeInventoryItem('cola', 1)

	TriggerClientEvent('esx_status:add', source, 'thirst', 50000)
	TriggerClientEvent('esx_status:add', source, 'pee', -250000)
	TriggerClientEvent('esx_basicneeds:onDrink', source)

end)

ESX.RegisterUsableItem('kaffe', function(source)

	local xPlayer = ESX.GetPlayerFromId(source)

	xPlayer.removeInventoryItem('kaffe', 1)

	TriggerClientEvent('esx_status:add', source, 'thirst', 50000)
	TriggerClientEvent('esx_status:add', source, 'pee', -250000)
	TriggerClientEvent('esx_basicneeds:onDrink', source)

end)

ESX.RegisterUsableItem('sprite', function(source)

	local xPlayer = ESX.GetPlayerFromId(source)

	xPlayer.removeInventoryItem('sprite', 1)

	TriggerClientEvent('esx_status:add', source, 'thirst', 50000)
	TriggerClientEvent('esx_status:add', source, 'pee', -250000)
	TriggerClientEvent('esx_basicneeds:onDrink', source)

end)