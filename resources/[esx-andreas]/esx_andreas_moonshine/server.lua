TriggerEvent('esx:getSharedObject', function(obj)
	ESX = obj
end)

function notification(text)
	TriggerClientEvent('esx:showNotification', source, text)
end

PlayersHarvesting  = {}
PlayersCrafting    = {}

--------------------------------------------------------------

RegisterServerEvent('esx_andreas_moonshine:createMoonshine')
AddEventHandler('esx_andreas_moonshine:createMoonshine', function()
    local xPlayer = ESX.GetPlayerFromId(source)
    local water = xPlayer.getInventoryItem('water').count
    local corn = xPlayer.getInventoryItem('corn').count
    local honey = xPlayer.getInventoryItem('honey').count

    if water > 0 and corn > 0 and honey > 0 then
        Citizen.Wait(2000)
        xPlayer.removeInventoryItem('water', 1)
        Citizen.Wait(2000)
        xPlayer.removeInventoryItem('corn', 1)
        Citizen.Wait(2000)
        xPlayer.removeInventoryItem('honey', 1)
        Citizen.Wait(5000)
        xPlayer.addInventoryItem('moonshine', 5)
    end
end)

ESX.RegisterServerCallback('esx_andreas_moonshine:checkIng', function(source, cb)
    local xPlayer = ESX.GetPlayerFromId(source)
    local water = xPlayer.getInventoryItem('water').count
    local corn = xPlayer.getInventoryItem('corn').count
    local honey = xPlayer.getInventoryItem('honey').count

    if water > 0 and corn > 0 and honey > 0 then
        cb(true)
    else
        cb(false)
    end
end)

ESX.RegisterServerCallback('esx_andreas_moonshine:checkBottles', function(source, cb)
    local xPlayer = ESX.GetPlayerFromId(source)
    local moonshine = xPlayer.getInventoryItem('moonshine').count

    if moonshine > 5 then
        cb(true)
    else
        cb(false)
    end
end)





local function Craft(source)

    SetTimeout(4000, function()
  
        if PlayersCrafting[source] == true then
  
            local xPlayer  = ESX.GetPlayerFromId(source)
            local AppleQuantity = xPlayer.getInventoryItem('moonshine').count              
            local randomNumber = math.random(25, 50)
  
            if AppleQuantity <= 0 then
                TriggerClientEvent('esx:showNotification', source, 'Du har inget hembränt.')            
            else   
                xPlayer.removeInventoryItem('moonshine', AppleQuantity)
                xPlayer.addMoney(randomNumber * AppleQuantity)
                TriggerClientEvent('esx:showNotification', source, 'Du sålde ditt hembränt.')
            end      
                Craft(source)
        end
    end)
  end
  
  RegisterServerEvent('esx_andreas_moonshine:startSell')
  AddEventHandler('esx_andreas_moonshine:startSell', function()
      local _source = source
      PlayersCrafting[_source] = true
      TriggerClientEvent('esx:showNotification', _source, 'Påbörjar försäljning av ditt ~r~hembränt.')
      Craft(_source)
  end)
  
  RegisterServerEvent('esx_andreas_moonshine:stopSell')
  AddEventHandler('esx_andreas_moonshine:stopSell', function()
      local _source = source
      PlayersCrafting[_source] = false
  end)
