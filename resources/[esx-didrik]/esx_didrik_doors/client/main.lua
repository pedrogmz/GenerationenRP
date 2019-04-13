local Keys = {
    ["E"] = 38,
}

ESX					= nil
local PlayerData	= {}
local IsCop			= false

Citizen.CreateThread(function()
	while ESX == nil do
		TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)
		Citizen.Wait(0)
	end

	Citizen.Wait(5000)
	PlayerData = ESX.GetPlayerData()
	if PlayerData.job.name == 'police' then
		IsCop = true
	end
end)

RegisterNetEvent('esx:setJob')
AddEventHandler('esx:setJob', function(job)
	PlayerData.job = job

	IsCop = (job.name == 'police') or false
end)

Citizen.CreateThread(function()
	while true do
		Citizen.Wait(10)
		for i=1, #Config.DoorList do
			local playerCoords = GetEntityCoords(GetPlayerPed(-1))
			local closeDoor    = GetClosestObjectOfType(Config.DoorList[i].objCoords.x, Config.DoorList[i].objCoords.y, Config.DoorList[i].objCoords.z, 1.0, GetHashKey(Config.DoorList[i].objName), false, false, false)
			local distance     = GetDistanceBetweenCoords(playerCoords, Config.DoorList[i].objCoords.x, Config.DoorList[i].objCoords.y, Config.DoorList[i].objCoords.z, true)
			
			local maxDistance = 1.25
			if Config.DoorList[i].distance then
				maxDistance = Config.DoorList[i].distance
			end
			
			if distance < maxDistance then
				local size = 1
				if Config.DoorList[i].size then
					size = Config.DoorList[i].size
				end

				local displayText = _U('unlocked')
				if Config.DoorList[i].locked then
					displayText = _U('locked')
				end

				if hasKey then
					displayText = _U('press_button') .. displayText
				end

				ESX.Game.Utils.DrawText3D(Config.DoorList[i].textCoords, displayText, size)
				
				if IsControlJustReleased(0, Keys['E']) then
					if hasKey then
						if Config.DoorList[i].locked then
							FreezeEntityPosition(closeDoor, false)
							Config.DoorList[i].locked = false
						else
							FreezeEntityPosition(closeDoor, true)
							Config.DoorList[i].locked = true
						end
						TriggerServerEvent('esx_celldoors:update', i, Config.DoorList[i].locked) -- Broadcast new state of the door to everyone
					else
						sendNotification('Du har inget passerkort som fungerar till denna dörr.', 'error', 2500)
					end
				end
			else
				FreezeEntityPosition(closeDoor, Config.DoorList[i].locked)
			end
		end
	end
end)


RegisterNetEvent('esx_celldoors:state')
AddEventHandler('esx_celldoors:state', function(id, isLocked)
	if id ~= nil and type(Config.DoorList[id]) ~= nil ~= nil then -- Check if door exists
		Config.DoorList[id].locked = isLocked -- Change state of door
	end
end)

---alla grejer
RegisterNetEvent('esx:playerLoaded')
AddEventHandler('esx:playerLoaded', function(xPlayer)
	PlayerData = xPlayer

	TriggerEvent('celldoors:hasNotKey')

	for i=1, #PlayerData.inventory, 1 do
		if PlayerData.inventory[i].name == 'policecard' then
			if PlayerData.inventory[i].count > 0 then
				TriggerEvent('celldoors:hasKey')
			end
		end
	end
end)


RegisterNetEvent('celldoors:hasNotKey')
AddEventHandler('celldoors:hasNotKey', function()
	hasKey = false
end)

RegisterNetEvent('celldoors:hasKey')
AddEventHandler('celldoors:hasKey', function()
	hasKey = true
end)

-- notification
function sendNotification(message, messageType, messageTimeout)
	TriggerEvent("pNotify:SendNotification", {
		text = message,
		type = messageType,
		queue = "qalle",
		timeout = messageTimeout,
		layout = "bottomCenter"
	})
end