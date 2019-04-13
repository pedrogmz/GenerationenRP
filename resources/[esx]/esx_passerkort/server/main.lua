local ESX = nil

TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)

RegisterServerEvent('card:giveItem')
AddEventHandler('card:giveItem', function()
  local xPlayer = ESX.GetPlayerFromId(source)

  if xPlayer.job.name == 'police' then

    if xPlayer.getInventoryItem('policecard')['count'] == 0 then
        xPlayer.setInventoryItem('policecard', 1)
      else
        xPlayer.setInventoryItem('policecard', 0)
    end
  end
end)
