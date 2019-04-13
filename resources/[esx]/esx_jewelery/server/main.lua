ESX = nil

TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)

-- Pay
RegisterServerEvent('esx_jewelery:pay')
AddEventHandler('esx_jewelery:pay', function()
    local _source = source
    local xPlayer = ESX.GetPlayerFromId(_source)
    xPlayer.removeMoney(Config.Price)
    TriggerClientEvent('esx:showNotification', _source, _U('you_paid') .. '$' .. Config.Price)
end)

-- Check Money
ESX.RegisterServerCallback('esx_jewelery:checkMoney', function(source, cb)

    local xPlayer = ESX.GetPlayerFromId(source)

    if xPlayer.get('money') >= Config.Price then
        cb(true)
    else
        cb(false)
    end
end)

-- Property data
ESX.RegisterServerCallback('esx_jewelery:checkPropertyDataStore', function(source, cb)

    local xPlayer    = ESX.GetPlayerFromId(source)
    local foundStore = false

    TriggerEvent('esx_datastore:getDataStore', 'property', xPlayer.identifier, function(store)
        foundStore = true
    end)

    cb(foundStore)
end)
