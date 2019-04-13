--================================================================================================
--==                                VARIABLES - DO NOT EDIT                                     ==
--================================================================================================
ESX = nil

TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)

function notification(text)
	TriggerClientEvent('esx:showNotification', source, text)
end

RegisterServerEvent('esx_andreas_bankfack:buyKey')
AddEventHandler('esx_andreas_bankfack:buyKey', function()
	local xPlayer = ESX.GetPlayerFromId(source)

	if(xPlayer.getMoney() >= 1000) then

		xPlayer.removeMoney(1000)
		xPlayer.addInventoryItem('bankkey', 1)
		notification('Du köpte en ~g~bankfacksnyckel')
	else
		notification('Du har inte tillräckligt med ~g~pengar')
	end	
end)