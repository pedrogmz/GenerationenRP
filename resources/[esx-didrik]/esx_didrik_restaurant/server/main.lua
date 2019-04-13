ESX = nil

TriggerEvent('esx:getSharedObject', function(obj)
	ESX = obj
end)

RegisterServerEvent('esx_didrik_restaurant:openMenu')
AddEventHandler('esx_didrik_restaurant:openMenu', function()
	local _source = source

	TriggerClientEvent('esx_didrik_restaurant:openMenuToPlayer', source)
end)

--item hamburgare
ESX.RegisterUsableItem('hamburgare', function(source)

	local xPlayer = ESX.GetPlayerFromId(source)

	xPlayer.removeInventoryItem('hamburgare', 1)

	TriggerClientEvent('esx_status:add', source, 'hunger', 700000)
	TriggerClientEvent('esx_didrik_hamburgare:onEat', source)

end)

function notification(text)
	TriggerClientEvent('esx:showNotification', source, text)
end

function sendNotification(message, messageType, messageTimeout)
    TriggerClientEvent("pNotify:SendNotification", source, {
        text = message,
        type = messageType,
        queue = "didrik",
        timeout = messageTimeout,
        layout = "bottomCenter"
    })
end