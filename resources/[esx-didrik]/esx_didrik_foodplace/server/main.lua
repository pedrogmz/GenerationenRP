ESX = nil

TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)

--item hamburgare
ESX.RegisterUsableItem('hamburgare', function(source)

	local xPlayer = ESX.GetPlayerFromId(source)

	xPlayer.removeInventoryItem('hamburgare', 1)

	TriggerClientEvent('esx_status:add', source, 'hunger', 700000)
	TriggerClientEvent('esx_didrik_hamburgare:onEat', source)
	TriggerClientEvent('esx:showNotification', source, 'Du förtärde en hamburgare.')

end)

--item potatis
ESX.RegisterUsableItem('potatis', function(source)

	local xPlayer = ESX.GetPlayerFromId(source)

	xPlayer.removeInventoryItem('potatis', 1)

	TriggerClientEvent('esx_status:add', source, 'hunger', 300000)
	TriggerClientEvent('esx_didrik_potatis:onEat', source)
	TriggerClientEvent('esx:showNotification', source, 'Du förtärde en potatis.')

end)

--item korv
ESX.RegisterUsableItem('korv', function(source)

	local xPlayer = ESX.GetPlayerFromId(source)

	xPlayer.removeInventoryItem('korv', 1)

	TriggerClientEvent('esx_status:add', source, 'hunger', 400000)
	TriggerClientEvent('esx_didrik_korv:onEat', source)
	TriggerClientEvent('esx:showNotification', source, 'Du förtärde en korv.')

end)

--item steak
ESX.RegisterUsableItem('steak', function(source)

	local xPlayer = ESX.GetPlayerFromId(source)

	xPlayer.removeInventoryItem('steak', 1)

	TriggerClientEvent('esx_status:add', source, 'hunger', 900000)
	TriggerClientEvent('esx_didrik_steak:onEat', source)
	TriggerClientEvent('esx:showNotification', source, 'Du förtärde en oxfilé.')

end)

--item munk
ESX.RegisterUsableItem('munk', function(source)

	local xPlayer = ESX.GetPlayerFromId(source)

	xPlayer.removeInventoryItem('munk', 1)

	TriggerClientEvent('esx_status:add', source, 'hunger', 400000)
	TriggerClientEvent('esx_didrik_munk:onEat', source)
	TriggerClientEvent('esx:showNotification', source, 'Du förtärde en munk.')

end)

--item kycklingklubba
ESX.RegisterUsableItem('klubba', function(source)

	local xPlayer = ESX.GetPlayerFromId(source)

	xPlayer.removeInventoryItem('klubba', 1)

	TriggerClientEvent('esx_status:add', source, 'hunger', 700000)
	TriggerClientEvent('esx_didrik_klubba:onEat', source)
	TriggerClientEvent('esx:showNotification', source, 'Du förtärde en kycklingklubba.')

end)

--item Kaffe
ESX.RegisterUsableItem('kaffe', function(source)

	local xPlayer = ESX.GetPlayerFromId(source)

	xPlayer.removeInventoryItem('kaffe', 1)

	TriggerClientEvent('esx_status:add', source, 'thirst', 300000)
	TriggerClientEvent('esx_didrik_kaffe:onDrink', source)
	TriggerClientEvent('esx:showNotification', source, 'Du drack en kaffe.')

end)

--item Cola
ESX.RegisterUsableItem('cola', function(source)

	local xPlayer = ESX.GetPlayerFromId(source)

	xPlayer.removeInventoryItem('cola', 1)

	TriggerClientEvent('esx_status:add', source, 'thirst', 200000)
	TriggerClientEvent('esx_didrik_cola:onDrink', source)
	TriggerClientEvent('esx:showNotification', source, 'Du drack en Coca Cola.')

end)

--item Sprite
ESX.RegisterUsableItem('sprite', function(source)

	local xPlayer = ESX.GetPlayerFromId(source)

	xPlayer.removeInventoryItem('sprite', 1)

	TriggerClientEvent('esx_status:add', source, 'thirst', 200000)
	TriggerClientEvent('esx_didrik_sprite:onDrink', source)
	TriggerClientEvent('esx:showNotification', source, 'Du drack en Päronläsk.')

end)

RegisterServerEvent('esx_didrik_matvagn:buy')
AddEventHandler('esx_didrik_matvagn:buy', function(item, price)
	local _source = source
	local xPlayer = ESX.GetPlayerFromId(_source)
	
	if(xPlayer.getMoney() >= price) then
		xPlayer.removeMoney(price)
		
		xPlayer.addInventoryItem(item, 1)
	else
		notification("~r~Köp medges ej, ~w~Du har inte tillräckligt med ~r~pengar~w~.")
	end
end)

function notification(text)
	TriggerClientEvent('esx:showNotification', source, text)
end