ESX               = nil
local ItemsLabels = {}

TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)

AddEventHandler('onMySQLReady', function()

	MySQL.Async.fetchAll(
		'SELECT * FROM items',
		{},
		function(result)

			for i=1, #result, 1 do
				ItemsLabels[result[i].name] = result[i].label
			end

		end
	)

end)

ESX.RegisterServerCallback('esx_shops:requestDBItems', function(source, cb)

	MySQL.Async.fetchAll(
		'SELECT * FROM shops',
		{},
		function(result)
			local shopItems  = {}
			for i=1, #result, 1 do
				if shopItems[result[i].name] == nil then
					shopItems[result[i].name] = {}
				end
				
				table.insert(shopItems[result[i].name], {
					name  = result[i].item,
					price = result[i].price,
					label = ItemsLabels[result[i].item]
				})
			end
			cb(shopItems)
		end
	)

end)

RegisterServerEvent('esx_shops:buyItem')
AddEventHandler('esx_shops:buyItem', function(itemName, quantity, price)

	local _source = source
	local xPlayer = ESX.GetPlayerFromId(_source)
	local sourceItem = xPlayer.getInventoryItem(itemName)

	-- can the player afford this item?
	if xPlayer.getMoney() >= price then
		
		-- can the player carry the said amount of x item?
		if sourceItem.limit ~= -1 and (sourceItem.count + 1) > sourceItem.limit then
			sendNotification(_source, _U('player_cannot_hold'), 'error', 2500)
		else
			xPlayer.removeMoney(price)
			xPlayer.addInventoryItem(itemName, quantity)
			sendNotification(_source, 'Du har handlat ' ..quantity.. 'st för ' ..price..  ' SEK', 'error', 5000)
		end
	else
		local missingMoney = price - xPlayer.getMoney()
		sendNotification(_source, _U('not_enough') ..missingMoney.. ' SEK', 'error', 5000)
	end

end)

--notification
function sendNotification(xSource, message, messageType, messageTimeout)
	TriggerClientEvent("pNotify:SendNotification", xSource, {
		text = message,
		type = messageType,
		queue = "qalle",
		timeout = messageTimeout,
		layout = "bottomCenter"
	})
end