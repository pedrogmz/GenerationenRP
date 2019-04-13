-- 2018 Henric 'zeb' Johansson

ESX = nil

TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)

RegisterServerEvent('esx_zeb_tackle:tryTackle')
AddEventHandler('esx_zeb_tackle:tryTackle', function(target)
	local targetPlayer = ESX.GetPlayerFromId(target)

	TriggerClientEvent('esx_zeb_tackle:getTackled', targetPlayer.source, source)
	TriggerClientEvent('esx_zeb_tackle:playTackle', source)
end)