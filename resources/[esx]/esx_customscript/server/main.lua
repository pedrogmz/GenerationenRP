ESX               = nil

TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)

-------------------------------- ESX_CIGARETTE -------------------------------------------------------

ESX.RegisterUsableItem('cigarett', function(source)
	local xPlayer = ESX.GetPlayerFromId(source)
	local lighter = xPlayer.getInventoryItem('lighter')
	
		if lighter.count > 0 then
			xPlayer.removeInventoryItem('cigarett', 1)
			TriggerClientEvent('esx_cigarett:startSmoke', source)
		else
			TriggerClientEvent('esx:showNotification', source, ('Du har ingen ~r~tändare'))
		end
end)

----------------------------------------------------------------------------------------------------------------------


---------------------------------------- VK_HANDSUP -----------------------------------------------------


RegisterServerEvent('vk_handsup:getSurrenderStatus')
AddEventHandler('vk_handsup:getSurrenderStatus', function(event,targetID)
	TriggerClientEvent("vk_handsup:getSurrenderStatusPlayer",targetID,event,source)
end)

RegisterServerEvent('vk_handsup:sendSurrenderStatus')
AddEventHandler('vk_handsup:sendSurrenderStatus', function(event,targetID,handsup)
	TriggerClientEvent(event,targetID,handsup)
end)

RegisterServerEvent('vk_handsup:reSendSurrenderStatus')
AddEventHandler('vk_handsup:reSendSurrenderStatus', function(event,targetID,handsup)
	TriggerClientEvent(event,targetID,handsup)
end)

-------------------------------------------------------------------------------------------------------

------------------------------------------------------

RegisterServerEvent("esx_didrik:togglePhone")
AddEventHandler("esx_didrik:togglePhone", function()
    local src = source
    local xPlayer = ESX.GetPlayerFromId(src)

    local phoneQ = xPlayer.getInventoryItem('phone').count
    local phoneOffQ = xPlayer.getInventoryItem('phoneoff').count

    if phoneQ > 0 then
        TriggerClientEvent("esx:showNotification", src, "Du ~r~stängde~s~ av telefonen")
        xPlayer.addInventoryItem('phoneoff', phoneQ)
        xPlayer.removeInventoryItem('phone', phoneQ)
    elseif phoneOffQ > 0 then
        TriggerClientEvent("esx:showNotification", src, "Du ~g~satte~s~ på telefonen")
        xPlayer.addInventoryItem('phone', phoneOffQ)
        xPlayer.removeInventoryItem('phoneoff', phoneOffQ)
    end
end)

------------------------------------------------------

--- esx_ciggarett

ESX.RegisterUsableItem('cigarett', function(source)
	local xPlayer = ESX.GetPlayerFromId(source)
	local lighter = xPlayer.getInventoryItem('lighter')
	
		if lighter.count > 0 then
			xPlayer.removeInventoryItem('cigarett', 1)
			TriggerClientEvent('esx_cigarett:startSmoke', source)
		else
			TriggerClientEvent('esx:showNotification', source, ('Du har ingen ~r~tändare'))
		end
end)

---