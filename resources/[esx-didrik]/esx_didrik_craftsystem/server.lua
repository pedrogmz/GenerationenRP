ESX = nil
TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)

--

RegisterServerEvent('esx_didrik_craft:knife')
AddEventHandler('esx_didrik_craft:knife', function()

      local xPlayer = ESX.GetPlayerFromId(source)
    
      xPlayer.addWeapon("weapon_switchblade")
end)

ESX.RegisterServerCallback('esx_didrik_craft:checkKnife', function(source, cb)

    local xPlayer = ESX.GetPlayerFromId(source)
    local wood = xPlayer.getInventoryItem('wood').count
    local metall = xPlayer.getInventoryItem('metall').count
    local skruvar = xPlayer.getInventoryItem('skruvar').count

    if wood > 0 and metall > 1 and skruvar > 2 then
        cb(true)
        xPlayer.removeInventoryItem('wood', 1)
        xPlayer.removeInventoryItem('metall', 2)
        xPlayer.removeInventoryItem('skruvar', 3)
    else
        cb(false)
    end
end)


--


RegisterServerEvent('esx_didrik_craft:batong')
AddEventHandler('esx_didrik_craft:batong', function()

      local xPlayer = ESX.GetPlayerFromId(source)
    
      xPlayer.addWeapon("weapon_nightstick")
end)

ESX.RegisterServerCallback('esx_didrik_craft:checkBatong', function(source, cb)

    local xPlayer = ESX.GetPlayerFromId(source)
    local skinn = xPlayer.getInventoryItem('skinn').count
    local plast = xPlayer.getInventoryItem('plast').count
    local skruvar = xPlayer.getInventoryItem('skruvar').count

    if skinn > 0 and plast > 1 and skruvar > 2 then
        cb(true)
        xPlayer.removeInventoryItem('skinn', 1)
        xPlayer.removeInventoryItem('plast', 2)
        xPlayer.removeInventoryItem('skruvar', 3)
    else
        cb(false)
    end
end)


--


RegisterServerEvent('esx_didrik_craft:elpistol')
AddEventHandler('esx_didrik_craft:elpistol', function()

      local xPlayer = ESX.GetPlayerFromId(source)
    
      xPlayer.addWeapon("weapon_stungun")
end)

ESX.RegisterServerCallback('esx_didrik_craft:checkElpistol', function(source, cb)

    local xPlayer = ESX.GetPlayerFromId(source)
    local aluminium = xPlayer.getInventoryItem('aluminium').count
    local metall = xPlayer.getInventoryItem('metall').count
    local batteri = xPlayer.getInventoryItem('batteri').count

    if aluminium > 1 and metall > 1 and batteri > 2 then
        cb(true)
        xPlayer.removeInventoryItem('aluminium', 1)
        xPlayer.removeInventoryItem('metall', 2)
        xPlayer.removeInventoryItem('batteri', 3)
    else
        cb(false)
    end
end)


--


RegisterServerEvent('esx_didrik_craft:pistol')
AddEventHandler('esx_didrik_craft:pistol', function()

      local xPlayer = ESX.GetPlayerFromId(source)
    
      xPlayer.addWeapon("weapon_pistol", 30)
end)

ESX.RegisterServerCallback('esx_didrik_craft:checkPistol', function(source, cb)

    local xPlayer = ESX.GetPlayerFromId(source)
    local aluminium = xPlayer.getInventoryItem('aluminium').count
    local metall = xPlayer.getInventoryItem('metall').count
    local skruvar = xPlayer.getInventoryItem('skruvar').count

    if aluminium > 3 and metall > 2 and skruvar > 2 then
        cb(true)
        xPlayer.removeInventoryItem('aluminium', 4)
        xPlayer.removeInventoryItem('metall', 3)
        xPlayer.removeInventoryItem('skruvar', 10)
    else
        cb(false)
    end
end)


--


RegisterServerEvent('esx_didrik_craft:slagtra')
AddEventHandler('esx_didrik_craft:slagtra', function()

      local xPlayer = ESX.GetPlayerFromId(source)
    
      xPlayer.addWeapon("weapon_bat")
end)

ESX.RegisterServerCallback('esx_didrik_craft:checkSlagtra', function(source, cb)

    local xPlayer = ESX.GetPlayerFromId(source)
    local wood = xPlayer.getInventoryItem('wood').count
    local skruvar = xPlayer.getInventoryItem('skruvar').count

    if wood > 2 and skruvar > 9  then
        cb(true)
        xPlayer.removeInventoryItem('wood', 3)
        xPlayer.removeInventoryItem('skruvar', 10)
    else
        cb(false)
    end
end)


--


RegisterServerEvent('esx_didrik_craft:telefon')
AddEventHandler('esx_didrik_craft:telefon', function()

      local xPlayer = ESX.GetPlayerFromId(source)

      xPlayer.addInventoryItem("phone", 1)
end)

ESX.RegisterServerCallback('esx_didrik_craft:checkTelefon', function(source, cb)

    local xPlayer = ESX.GetPlayerFromId(source)
    local aluminium = xPlayer.getInventoryItem('aluminium').count
    local metall = xPlayer.getInventoryItem('metall').count
    local batteri = xPlayer.getInventoryItem('batteri').count

    if aluminium > 3 and metall > 2 and batteri > 0 then
        cb(true)
        xPlayer.removeInventoryItem('aluminium', 4)
        xPlayer.removeInventoryItem('metall', 3)
        xPlayer.removeInventoryItem('batteri', 1)
    else
        cb(false)
    end
end)


--


RegisterServerEvent('esx_didrik_craft:dyrkset')
AddEventHandler('esx_didrik_craft:dyrkset', function()

      local xPlayer = ESX.GetPlayerFromId(source)

      xPlayer.addInventoryItem("blowpipe", 1)
end)

ESX.RegisterServerCallback('esx_didrik_craft:checkDyrkset', function(source, cb)

    local xPlayer = ESX.GetPlayerFromId(source)
    local aluminium = xPlayer.getInventoryItem('aluminium').count
    local metall = xPlayer.getInventoryItem('metall').count

    if aluminium > 1 and metall > 0 then
        cb(true)
        xPlayer.removeInventoryItem('aluminium', 2)
        xPlayer.removeInventoryItem('metall', 1)
    else
        cb(false)
    end
end)


--


RegisterServerEvent('esx_didrik_craft:kofot')
AddEventHandler('esx_didrik_craft:kofot', function()

      local xPlayer = ESX.GetPlayerFromId(source)

      xPlayer.addWeapon("weapon_crowbar")
end)

ESX.RegisterServerCallback('esx_didrik_craft:checkKofot', function(source, cb)

    local xPlayer = ESX.GetPlayerFromId(source)
    local aluminium = xPlayer.getInventoryItem('aluminium').count
    local metall = xPlayer.getInventoryItem('metall').count

    if aluminium > 4 and metall > 2 then
        cb(true)
        xPlayer.removeInventoryItem('aluminium', 5)
        xPlayer.removeInventoryItem('metall', 3)
    else
        cb(false)
    end
end)