ESX = nil
local PlayersOmvandlaapple  = {}
PlayersHarvesting  = {}
PlayersCrafting    = {}

TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)

function getPlayerID(source)
    local identifiers = GetPlayerIdentifiers(source)
    local player = getIdentifiant(identifiers)
    return player
end

function get3DDistance(x1, y1, z1, x2, y2, z2)
	return math.sqrt(math.pow(x1 - x2, 2) + math.pow(y1 - y2, 2) + math.pow(z1 - z2, 2))
end

AddEventHandler('esx:onAddInventoryItem', function(source, item, count)
  if item.name == 'water' then
    TriggerClientEvent('esx_didrik_farmen:hasWater', source)
  end
end)

AddEventHandler('esx:onRemoveInventoryItem', function(source, item, count)
  if item.name == 'water' and item.count < 1 then
    TriggerClientEvent('esx_didrik_farmen:hasNotWater', source)
  end
end)

RegisterServerEvent('esx_didrik_farmen:giveApple')
AddEventHandler('esx_didrik_farmen:giveApple', function()
 
    local _source = source
    local xPlayer = ESX.GetPlayerFromId(_source)
    local luck = math.random(0, 50)
    local randomApple = math.random(1, 3)

    if luck >= 0 and luck <= 35 then
      TriggerClientEvent("esx:showNotification", source, 'Du tappade ~r~äpplet~w~, Försök igen.')
    end
    if luck >= 35 and luck < 50 then
      xPlayer.addInventoryItem('apple', randomApple)
      TriggerClientEvent("esx:showNotification", source, 'Bra jobbat, Du hittade ' ..randomApple.. ' st äpplen.')
    end
end)

RegisterServerEvent('esx_didrik_farmen:removeWater')
AddEventHandler('esx_didrik_farmen:removeWater', function()

  local xPlayer = ESX.GetPlayerFromId(source)
  local seed = xPlayer.getInventoryItem('water').count
  
      xPlayer.removeInventoryItem('water', 1)
end)


---

RegisterServerEvent('esx_didrik_farmen:Omvandlaapple')
AddEventHandler('esx_didrik_farmen:Omvandlaapple', function()

  local xPlayer  = ESX.GetPlayerFromId(source)

    xPlayer.removeInventoryItem('apple', 5)
    xPlayer.addInventoryItem('applemos', 1)

end)


RegisterServerEvent('esx_didrik_farmen:test')
AddEventHandler('esx_didrik_farmen:test', function()
    local _source = source
    local xPlayer = ESX.GetPlayerFromId(_source)
    local oneQuantity = xPlayer.getInventoryItem('apple').count
    
    if oneQuantity > 4 then
        TriggerClientEvent('esx_didrik_farmen:truekappa', source) -- true
    else
        TriggerClientEvent('esx_didrik_farmen:falsekappa', source) -- false
    end
end)

RegisterServerEvent('esx_didrik_farmen:gps')
AddEventHandler('esx_didrik_farmen:gps', function()
 
local xPlayers = ESX.GetPlayers()

    for player = 1, #xPlayers, 1 do
        local newxPlayer = ESX.GetPlayerFromId(xPlayers[player])

        if newxPlayer ~= nil then
            if newxPlayer.job.name == 'farmen' then
            	TriggerClientEvent('gps', newxPlayer.source, 1797.384, 4592.406)
            end
        end
    end
end)    


local function Craft(source)

  SetTimeout(4000, function()

      if PlayersCrafting[source] == true then

          local xPlayer  = ESX.GetPlayerFromId(source)
          local AppleQuantity = xPlayer.getInventoryItem('applemos').count              
          local randomNumber = math.random(5, 15)

          if AppleQuantity <= 0 then
              TriggerClientEvent('esx:showNotification', source, 'Du har inget äppelmos i ditt inventory.')            
          else   
              xPlayer.removeInventoryItem('applemos', AppleQuantity)
              xPlayer.addMoney(randomNumber * AppleQuantity)
              TriggerClientEvent('esx:showNotification', source, 'Du sålde ditt äppelmos.') 
          end      
              Craft(source)
      end
  end)
end

RegisterServerEvent('esx_didrik_farmen:startSell')
AddEventHandler('esx_didrik_farmen:startSell', function()
    local _source = source
    PlayersCrafting[_source] = true
    TriggerClientEvent('esx:showNotification', _source, 'Påbörjar försäljning av ditt ~r~äppelmos.')
    Craft(_source)
end)

RegisterServerEvent('esx_didrik_farmen:stopSell')
AddEventHandler('esx_didrik_farmen:stopSell', function()
    local _source = source
    PlayersCrafting[_source] = false
end)

RegisterServerEvent('esx_didrik_farmen:reward')
AddEventHandler('esx_didrik_farmen:reward', function(Weight)
    local xPlayer = ESX.GetPlayerFromId(source)

    if Weight >= 1 then
        xPlayer.addInventoryItem('meat', 1)
    elseif Weight >= 9 then
        xPlayer.addInventoryItem('meat', 2)
    elseif Weight >= 15 then
        xPlayer.addInventoryItem('meat', 3)
    end
        
end)

function sendNotification(xsource, message, messageType, messageTimeout)
    TriggerClientEvent('notification', xsource, message)
end

