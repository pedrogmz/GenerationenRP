ESX = nil

TriggerEvent('esx:getSharedObject', function(obj)
	ESX = obj
end)

AddEventHandler('esx:onAddInventoryItem', function(source, item, count)
	if item.name == 'ogrillad' then
	  TriggerClientEvent('esx_didrik_bbc:hasKorv', source)
	end
  end)
  
  AddEventHandler('esx:onRemoveInventoryItem', function(source, item, count)
	if item.name == 'ogrillad' and item.count < 1 then
	  TriggerClientEvent('esx_didrik_bbc:hasNotKorv', source)
	end
	end)
	
RegisterServerEvent('esx_didrik_bbc:giveGrillad')
AddEventHandler('esx_didrik_bbc:giveGrillad', function()

  local xPlayer = ESX.GetPlayerFromId(source)
	local seed = xPlayer.getInventoryItem('ogrillad').count
	local seed = xPlayer.getInventoryItem('grillad').count
	
	xPlayer.removeInventoryItem('ogrillad', 1)
	xPlayer.addInventoryItem('grillad', 1)
end)

-- item 
ESX.RegisterUsableItem('grillad', function(source)

	local xPlayer = ESX.GetPlayerFromId(source)

	xPlayer.removeInventoryItem('grillad', 1)

	TriggerClientEvent('esx_status:add', source, 'hunger', 700000)
	TriggerClientEvent('esx_didrik_bbc:onEat', source)
	TriggerClientEvent('esx:showNotification', source, 'Du förtärde en korv.')

end)