ESX				= nil
local IsLocked	= nil
local doorList	= {1,2,3,4,5,6,7,8,9,10,11,12,13,14,15,16,17,18,19,20,21,22}

TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)

--har item
AddEventHandler('esx:onAddInventoryItem', function(source, item, count)
  if item.name == 'policecard' then
    TriggerClientEvent('celldoors:hasKey', source)
  end
end)

--har inte item
AddEventHandler('esx:onRemoveInventoryItem', function(source, item, count)
  if item.name == 'policecard' and item.count < 1 then
    TriggerClientEvent('celldoors:hasNotKey', source)
  end
end)

RegisterServerEvent('esx_celldoors:update')
AddEventHandler('esx_celldoors:update', function(id, IsLocked)
	if id ~= nil and IsLocked ~= nil then -- Make sure values got sent
		TriggerClientEvent('esx_celldoors:state', -1, id, IsLocked)
	end
end)

AddEventHandler('esx:playerLoaded', function(source)
	local IsLocked = true
	local id = doorList[i]
	TriggerClientEvent('esx_celldoors:state', -1, id, IsLocked)
end)

function RemoveKeys(source)

local xPlayers = ESX.GetPlayers()

	for i=1, #xPlayers, 1 do

		local xPlayer = ESX.GetPlayerFromId(xPlayers[i])
		local cardQuantity = xPlayer.getInventoryItem(Config.Item).count

		if cardQuantity > 0 then
			if xPlayer.job.name == 'police' then
				--
			else
				xPlayer.removeInventoryItem(Config.Item, cardQuantity)
				sendNotification(xPlayer.source, 'Dina passerkort har inaktiverats.', 'error', 2500)
			end
		end
	end
end

function sendNotification(xSource, message, messageType, messageTimeout)
	TriggerClientEvent("pNotify:SendNotification", xSource, {
		text = message,
		type = messageType,
		queue = "qalle",
		timeout = messageTimeout,
		layout = "bottomCenter"
	})
end

TriggerEvent('cron:runAt', 16, 30, RemoveKeys)
