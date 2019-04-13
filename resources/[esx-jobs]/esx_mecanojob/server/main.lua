ESX                = nil

TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)

TriggerEvent('esx_phone:registerNumber', 'mecano', _U('mechanic_customer'), true, true)
TriggerEvent('esx_society:registerSociety', 'mecano', 'Mecano', 'society_mecano', 'society_mecano', 'society_mecano', {type = 'private'})


ESX.RegisterUsableItem('blowpipe', function(source)
	local _source = source
	local xPlayer  = ESX.GetPlayerFromId(source)

	xPlayer.removeInventoryItem('blowpipe', 1)

	TriggerClientEvent('esx_mecanojob:onHijack', _source)
	TriggerClientEvent('esx:showNotification', _source, _U('you_used_blowtorch'))
end)

ESX.RegisterUsableItem('fixkit', function(source)
	local _source = source
	local xPlayer  = ESX.GetPlayerFromId(source)

	xPlayer.removeInventoryItem('fixkit', 1)

	TriggerClientEvent('esx_mecanojob:onFixkit', _source)
	TriggerClientEvent('esx:showNotification', _source, _U('you_used_repair_kit'))
end)

RegisterServerEvent('esx_mecanojob:getStockItem')
AddEventHandler('esx_mecanojob:getStockItem', function(itemName, count)
	local xPlayer = ESX.GetPlayerFromId(source)

	TriggerEvent('esx_addoninventory:getSharedInventory', 'society_mecano', function(inventory)
		local item = inventory.getItem(itemName)
		local sourceItem = xPlayer.getInventoryItem(itemName)

		-- is there enough in the society?
		if count > 0 and item.count >= count then

			-- can the player carry the said amount of x item?
			if sourceItem.limit ~= -1 and (sourceItem.count + count) > sourceItem.limit then
				TriggerClientEvent('esx:showNotification', xPlayer.source, _U('player_cannot_hold'))
			else
				inventory.removeItem(itemName, count)
				xPlayer.addInventoryItem(itemName, count)
				TriggerClientEvent('esx:showNotification', xPlayer.source, _U('have_withdrawn', count, item.label))
			end
		else
			TriggerClientEvent('esx:showNotification', xPlayer.source, _U('invalid_quantity'))
		end
	end)
end)

ESX.RegisterServerCallback('esx_mecanojob:getStockItems', function(source, cb)
	TriggerEvent('esx_addoninventory:getSharedInventory', 'society_mecano', function(inventory)
		cb(inventory.items)
	end)
end)

RegisterServerEvent('esx_mecanojob:putStockItems')
AddEventHandler('esx_mecanojob:putStockItems', function(itemName, count)
	local xPlayer = ESX.GetPlayerFromId(source)

	TriggerEvent('esx_addoninventory:getSharedInventory', 'society_mecano', function(inventory)
		local item = inventory.getItem(itemName)
		local playerItemCount = xPlayer.getInventoryItem(itemName).count

		if item.count >= 0 and count <= playerItemCount then
			xPlayer.removeInventoryItem(itemName, count)
			inventory.addItem(itemName, count)
		else
			TriggerClientEvent('esx:showNotification', xPlayer.source, _U('invalid_quantity'))
		end

		TriggerClientEvent('esx:showNotification', xPlayer.source, _U('have_deposited', count, item.label))
	end)
end)

ESX.RegisterServerCallback('esx_mecanojob:getPlayerInventory', function(source, cb)
	local xPlayer    = ESX.GetPlayerFromId(source)
	local items      = xPlayer.inventory

	cb({items = items})
end)

RegisterServerEvent('esx_didrik_mekaniker:GiveFix')
AddEventHandler('esx_didrik_mekaniker:GiveFix', function(item, count)
	local _source = source
    local xPlayer  = ESX.GetPlayerFromId(_source)
	if xPlayer ~= nil then
		xPlayer.addInventoryItem('fixkit', 1)
	end
end)

RegisterServerEvent('esx_didrik_mekaniker:GiveBlow')
AddEventHandler('esx_didrik_mekaniker:GiveBlow', function(item, count)
	local _source = source
    local xPlayer  = ESX.GetPlayerFromId(_source)
	if xPlayer ~= nil then
		xPlayer.addInventoryItem('blowpipe', 1)
	end
end)
