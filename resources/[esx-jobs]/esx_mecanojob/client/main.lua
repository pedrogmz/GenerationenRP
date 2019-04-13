local Keys = {
  ["ESC"] = 322, ["F1"] = 288, ["F2"] = 289, ["F3"] = 170, ["F5"] = 166, ["F6"] = 167, ["F7"] = 168, ["F8"] = 169, ["F9"] = 56, ["F10"] = 57,
  ["~"] = 243, ["1"] = 157, ["2"] = 158, ["3"] = 160, ["4"] = 164, ["5"] = 165, ["6"] = 159, ["7"] = 161, ["8"] = 162, ["9"] = 163, ["-"] = 84, ["="] = 83, ["BACKSPACE"] = 177,
  ["TAB"] = 37, ["Q"] = 44, ["W"] = 32, ["E"] = 38, ["R"] = 45, ["T"] = 245, ["Y"] = 246, ["U"] = 303, ["P"] = 199, ["["] = 39, ["]"] = 40, ["ENTER"] = 18,
  ["CAPS"] = 137, ["A"] = 34, ["S"] = 8, ["D"] = 9, ["F"] = 23, ["G"] = 47, ["H"] = 74, ["K"] = 311, ["L"] = 182,
  ["LEFTSHIFT"] = 21, ["Z"] = 20, ["X"] = 73, ["C"] = 26, ["V"] = 0, ["B"] = 29, ["N"] = 249, ["M"] = 244, [","] = 82, ["."] = 81,
  ["LEFTCTRL"] = 36, ["LEFTALT"] = 19, ["SPACE"] = 22, ["RIGHTCTRL"] = 70,
  ["HOME"] = 213, ["PAGEUP"] = 10, ["PAGEDOWN"] = 11, ["DELETE"] = 178,
  ["LEFT"] = 174, ["RIGHT"] = 175, ["TOP"] = 27, ["DOWN"] = 173,
  ["NENTER"] = 201, ["N4"] = 108, ["N5"] = 60, ["N6"] = 107, ["N+"] = 96, ["N-"] = 97, ["N7"] = 117, ["N8"] = 61, ["N9"] = 118
}

local PlayerData              = {}
local HasAlreadyEnteredMarker = false
local LastZone                = nil
local CurrentAction           = nil
local CurrentActionMsg        = ''
local CurrentActionData       = {}
local CurrentlyTowedVehicle   = nil
local Blips                   = {}
local IsDead                  = false
local IsBusy                  = false
ESX                           = nil

Citizen.CreateThread(function()
	while ESX == nil do
		TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)
		Citizen.Wait(0)
	end

	Citizen.Wait(5000)
	PlayerData = ESX.GetPlayerData()
end)

RegisterNetEvent("mt:missiontext") -- Original script: https://github.com/schneehaze/fivem_missiontext/blob/master/MissionText/missiontext.lua
AddEventHandler("mt:missiontext", function(text, time)
    ClearPrints()
    SetTextEntry_2("STRING")
    AddTextComponentString(text)
    DrawSubtitleTimed(time, 1)
end)

function OpenMecanoCarMenu()

	local elements = {
		{label = ('Arbetsfordon'),   value = 'vehicle_list'}	
	}

	ESX.UI.Menu.CloseAll()

	ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'mecano_car', {
		title    = _U('mechanic'),
		align    = 'top-left',
		elements = elements
	}, function(data, menu)
		if data.current.value == 'vehicle_list' then

			if Config.EnableSocietyOwnedVehicles then

				local elements = {}

				ESX.TriggerServerCallback('esx_society:getVehiclesInGarage', function(vehicles)
					for i=1, #vehicles, 1 do
						table.insert(elements, {
							label = GetDisplayNameFromVehicleModel(vehicles[i].model) .. ' [' .. vehicles[i].plate .. ']',
							value = vehicles[i]
						})
					end

					ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'vehicle_spawner', {
						title    = ('Arbetsfordon'),
						align    = 'top-left',
						elements = elements
					}, function(data, menu)
						menu.close()
						local vehicleProps = data.current.value

						ESX.Game.SpawnVehicle(vehicleProps.model, Config.Zones.VehicleSpawnPoint.Pos, 270.0, function(vehicle)
							ESX.Game.SetVehicleProperties(vehicle, vehicleProps)
							local playerPed = PlayerPedId()
							TaskWarpPedIntoVehicle(playerPed,  vehicle,  -1)
						end)

						TriggerServerEvent('esx_society:removeVehicleFromGarage', 'mecano', vehicleProps)
					end, function(data, menu)
						menu.close()
					end)
				end, 'mecano')

			else

				local elements = {
					{label = ('Bärgningsbil - Arbetsbil'),  value = 'flatbed'}
				}

				ESX.UI.Menu.CloseAll()

				ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'spawn_vehicle', {
					title    = ('Arbetsfordon'),
					align    = 'top-left',
					elements = elements
				}, function(data, menu)
					if Config.MaxInService == -1 then
						ESX.Game.SpawnVehicle(data.current.value, Config.Zones.VehicleSpawnPoint.Pos, 90.0, function(vehicle)
							local playerPed = PlayerPedId()
							TaskWarpPedIntoVehicle(playerPed, vehicle, -1)
						end)
					end

					menu.close()
				end, function(data, menu)
					menu.close()
					OpenMecanoCarMenu()
				end)
			end
		end

	end, function(data, menu)
		menu.close()

		CurrentAction     = 'mecano_car_menu'
		CurrentActionMsg  = _U('open_actions')
		CurrentActionData = {}
	end)
end

function OpenMecanoCloakerMenu()

	local elements = {
		{label = _U('work_wear'),      value = 'cloakroom'},
		{label = _U('civ_wear'),       value = 'cloakroom2'},	
	}

	ESX.UI.Menu.CloseAll()

	ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'mecano_actions', {
		title    = _U('mechanic'),
		align    = 'top-left',
		elements = elements
	}, function(data, menu)
		if data.current.value == 'cloakroom' then

			menu.close()
			ESX.TriggerServerCallback('esx_skin:getPlayerSkin', function(skin, jobSkin)
				if skin.sex == 0 then
					TriggerEvent('skinchanger:loadClothes', skin, jobSkin.skin_male)
				else
					TriggerEvent('skinchanger:loadClothes', skin, jobSkin.skin_female)
				end
			end)

		elseif data.current.value == 'cloakroom2' then

			menu.close()
			ESX.TriggerServerCallback('esx_skin:getPlayerSkin', function(skin, jobSkin)
				TriggerEvent('skinchanger:loadSkin', skin)
			menu.close()
			end)
		end
	end)
end

function OpenMecanoActionsMenu()

	local elements = {
		{label = _U('deposit_stock'),  value = 'put_stock'},
		{label = _U('withdraw_stock'), value = 'get_stock'}		
	}

	if Config.EnablePlayerManagement and PlayerData.job ~= nil and PlayerData.job.grade_name == 'boss' then
		table.insert(elements, {label = _U('boss_actions'), value = 'boss_actions'})
	end

	ESX.UI.Menu.CloseAll()

	ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'mecano_actions', {
		title    = _U('mechanic'),
		align    = 'top-left',
		elements = elements
	}, function(data, menu)
		if data.current.value == 'put_stock' then
			OpenPutStocksMenu()
		elseif data.current.value == 'get_stock' then
			OpenGetStocksMenu()
		elseif data.current.value == 'boss_actions' then
			TriggerEvent('esx_society:openBossMenu', 'mecano', function(data, menu)
				menu.close()
			end)
		end

	end, function(data, menu)
		menu.close()

		CurrentAction     = 'mecano_actions_menu'
		CurrentActionMsg  = _U('open_actions')
		CurrentActionData = {}
	end)
end

function OpenMobileMecanoActionsMenu()

	ESX.UI.Menu.CloseAll()

	ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'mobile_mecano_actions', {
		title    = _U('mechanic'),
		align    = 'top-left',
		elements = {		
			{label = _U('imp_veh'),       value = 'del_vehicle'},
			{label = _U('billing'),       value = 'billing'},
			{label = _U('place_objects'), value = 'object_spawner'}
		}
	}, function(data, menu)
		if IsBusy then return end

		if data.current.value == 'billing' then

			ESX.UI.Menu.Open('dialog', GetCurrentResourceName(), 'billing', {
				title = _U('invoice_amount')
			}, function(data, menu)
				local amount = tonumber(data.value)

				if amount == nil or amount < 0 then
					sendNotification('Ogiltligt belopp.', 'error', 2500)
				else
					local closestPlayer, closestDistance = ESX.Game.GetClosestPlayer()
					if closestPlayer == -1 or closestDistance > 3.0 then
						sendNotification('Ingen spelare i närheten.', 'error', 2500)
					else
						menu.close()
						TriggerServerEvent('esx_billing:sendBill', GetPlayerServerId(closestPlayer), 'society_mecano', _U('mechanic'), amount)
					end
				end
			end, function(data, menu)
				menu.close()
			end)

	elseif data.current.value == 'del_vehicle' then

		local playerPed = PlayerPedId()

		if IsPedSittingInAnyVehicle(playerPed) then
			local vehicle = GetVehiclePedIsIn(playerPed, false)

			if GetPedInVehicleSeat(vehicle, -1) == playerPed then
				ESX.ShowNotification(_U('vehicle_impounded'))
				ESX.Game.DeleteVehicle(vehicle)
			else
				ESX.ShowNotification(_U('must_seat_driver'))
			end
		else
			local vehicle = ESX.Game.GetVehicleInDirection()

			if DoesEntityExist(vehicle) then
				ESX.ShowNotification(_U('vehicle_impounded'))
				ESX.Game.DeleteVehicle(vehicle)
			else
				ESX.ShowNotification(_U('must_near'))
			end
		end

	elseif data.current.value == 'object_spawner' then

		local playerPed = PlayerPedId()

		if IsPedSittingInAnyVehicle(playerPed) then
			ESX.ShowNotification(_U('inside_vehicle'))
			return
		end

		ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'mobile_mecano_actions_spawn', {
			title    = _U('objects'),
			align    = 'top-left',
			elements = {
				{label = _U('roadcone'), value = 'prop_roadcone02a'},
				{label = ('Generator'),  value = 'prop_generator_01a'},
				{label = ('Verktygsbänk'), value = 'prop_toolchest_05'},
				{label = _U('toolbox'),  value = 'prop_toolchest_01'}
			}
		}, function(data2, menu2)
			local model   = data2.current.value
			local coords  = GetEntityCoords(playerPed)
			local forward = GetEntityForwardVector(playerPed)
			local x, y, z = table.unpack(coords + forward * 1.0)

			if model == 'prop_roadcone02a' then
				z = z - 2.0
			elseif model == 'prop_toolchest_01' then
				z = z - 2.0
			elseif model == 'prop_generator_01a' then
				z = z - 2.0	
			elseif model == 'prop_toolchest_05' then
				z = z - 2.0	
			end

			ESX.Game.SpawnObject(model, {
				x = x,
				y = y,
				z = z
			}, function(obj)
				SetEntityHeading(obj, GetEntityHeading(playerPed))
				PlaceObjectOnGroundProperly(obj)
			end)

		end, function(data2, menu2)
			menu2.close()
		end)

	end

	end, function(data, menu)
		menu.close()
	end)
end

function OpenGetStocksMenu()
	ESX.TriggerServerCallback('esx_mecanojob:getStockItems', function(items)

		local elements = {}

		for i=1, #items, 1 do
			table.insert(elements, {
				label = 'x' .. items[i].count .. ' ' .. items[i].label,
				value = items[i].name
			})
		end

		ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'stocks_menu',
		{
			title    = _U('mechanic_stock'),
			align    = 'top-left',
			elements = elements
		}, function(data, menu)

			local itemName = data.current.value

			ESX.UI.Menu.Open('dialog', GetCurrentResourceName(), 'stocks_menu_get_item_count', {
				title = _U('quantity')
			}, function(data2, menu2)
				local count = tonumber(data2.value)

				if count == nil then
					ESX.ShowNotification(_U('invalid_quantity'))
				else
					menu2.close()
					menu.close()
					TriggerServerEvent('esx_mecanojob:getStockItem', itemName, count)

					Citizen.Wait(1000)
					OpenGetStocksMenu()
				end
			end, function(data2, menu2)
				menu2.close()
			end)

		end, function(data, menu)
			menu.close()
		end)

	end)

end

function OpenPutStocksMenu()

	ESX.TriggerServerCallback('esx_mecanojob:getPlayerInventory', function(inventory)
		local elements = {}

		for i=1, #inventory.items, 1 do
			local item = inventory.items[i]

			if item.count > 0 then
				table.insert(elements, {
					label = item.label .. ' x' .. item.count,
					type  = 'item_standard',
					value = item.name
				})
			end
		end

		ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'stocks_menu', {
			title    = _U('inventory'),
			align    = 'top-left',
			elements = elements
		}, function(data, menu)

			local itemName = data.current.value

			ESX.UI.Menu.Open('dialog', GetCurrentResourceName(), 'stocks_menu_put_item_count', {
				title = _U('quantity')
			}, function(data2, menu2)
				local count = tonumber(data2.value)

				if count == nil then
					ESX.ShowNotification(_U('invalid_quantity'))
				else
					menu2.close()
					menu.close()
					TriggerServerEvent('esx_mecanojob:putStockItems', itemName, count)

					Citizen.Wait(1000)
					OpenPutStocksMenu()
				end
			end, function(data2, menu2)
				menu2.close()
			end)
		end, function(data, menu)
			menu.close()
		end)

	end)

end


RegisterNetEvent('esx_mecanojob:onHijack')
AddEventHandler('esx_mecanojob:onHijack', function()
	local playerPed = PlayerPedId()
	local coords    = GetEntityCoords(playerPed)

	if IsAnyVehicleNearPoint(coords.x, coords.y, coords.z, 5.0) then
		local vehicle = nil

		if IsPedInAnyVehicle(playerPed, false) then
			vehicle = GetVehiclePedIsIn(playerPed, false)
		else
			vehicle = GetClosestVehicle(coords.x, coords.y, coords.z, 5.0, 0, 71)
		end

		local chance = math.random(100)
		local alarm  = math.random(100)

		if DoesEntityExist(vehicle) then
			if alarm <= 33 then
				SetVehicleAlarm(vehicle, true)
				StartVehicleAlarm(vehicle)
			end

			TaskStartScenarioInPlace(playerPed, "WORLD_HUMAN_WELDING", 0, true)

			Citizen.CreateThread(function()
				Citizen.Wait(10000)
				if chance <= 66 then
					SetVehicleDoorsLocked(vehicle, 1)
					SetVehicleDoorsLockedForAllPlayers(vehicle, false)
					ClearPedTasksImmediately(playerPed)
					sendNotification('Fordon upplåst.', 'error', 2500)
				else
					sendNotification('Kapningen misslyckades, Försök igen.', 'error', 2500)
					ClearPedTasksImmediately(playerPed)
				end
			end)

		end
	end
end)


RegisterNetEvent('esx_mecanojob:onFixkit')
AddEventHandler('esx_mecanojob:onFixkit', function()
	local playerPed = PlayerPedId()
	local coords    = GetEntityCoords(playerPed)

	if IsAnyVehicleNearPoint(coords.x, coords.y, coords.z, 5.0) then
		local vehicle = nil

		if IsPedInAnyVehicle(playerPed, false) then
			vehicle = GetVehiclePedIsIn(playerPed, false)
		else
			vehicle = GetClosestVehicle(coords.x, coords.y, coords.z, 5.0, 0, 71)
		end

		if DoesEntityExist(vehicle) then
			TaskStartScenarioInPlace(playerPed, "PROP_HUMAN_BUM_BIN", 0, true)
			Citizen.CreateThread(function()
				Citizen.Wait(20000)
				SetVehicleFixed(vehicle)
				SetVehicleDeformationFixed(vehicle)
				SetVehicleUndriveable(vehicle, false)
				ClearPedTasksImmediately(playerPed)
				sendNotification('Fordon reparerat.', 'error', 2500)
			end)
		end
	end
end)

RegisterNetEvent('esx:playerLoaded')
AddEventHandler('esx:playerLoaded', function(xPlayer)
	PlayerData = xPlayer
end)

RegisterNetEvent('esx:setJob')
AddEventHandler('esx:setJob', function(job)
	PlayerData.job = job
end)

AddEventHandler('esx_mecanojob:hasEnteredMarker', function(zone)

	if zone == 'MecanoActions' then
		CurrentAction     = 'mecano_actions_menu'
		CurrentActionMsg  = _U('open_actions')
		CurrentActionData = {}
	elseif zone == 'MecanoCar' then
		CurrentAction     = 'mecano_car_menu'
		CurrentActionMsg  = _U('open_actions')
		CurrentActionData = {}	
	elseif zone == 'MecanoCloaker' then
		CurrentAction     = 'mecano_cloaker_menu'
		CurrentActionMsg  = _U('open_actions')
		CurrentActionData = {}		
	elseif zone == 'VehicleDeleter' then
		local playerPed = PlayerPedId()

		if IsPedInAnyVehicle(playerPed, false) then
			local vehicle = GetVehiclePedIsIn(playerPed,  false)

			CurrentAction     = 'delete_vehicle'
			CurrentActionMsg  = _U('veh_stored')
			CurrentActionData = {vehicle = vehicle}
		end
	end
end)

AddEventHandler('esx_mecanojob:hasEnteredEntityZone', function(entity)
	local playerPed = PlayerPedId()

	if PlayerData.job ~= nil and PlayerData.job.name == 'mecano' and not IsPedInAnyVehicle(playerPed, false) then
		CurrentAction     = 'remove_entity'
		CurrentActionMsg  = _U('press_remove_obj')
		CurrentActionData = {entity = entity}
	end
end)

AddEventHandler('esx_mecanojob:hasExitedEntityZone', function(entity)
	if CurrentAction == 'remove_entity' then
		CurrentAction = nil
	end
end)

-- Create Blips
Citizen.CreateThread(function()
	local blip = AddBlipForCoord(Config.Zones.MecanoActions.Pos.x, Config.Zones.MecanoActions.Pos.y, Config.Zones.MecanoActions.Pos.z)

	SetBlipSprite (blip, 446)
	SetBlipDisplay(blip, 4)
	SetBlipScale  (blip, 0.8)
	SetBlipColour (blip, 5)
	SetBlipAsShortRange(blip, true)

	BeginTextCommandSetBlipName("STRING")
	AddTextComponentString(_U('mechanic'))
	EndTextCommandSetBlipName(blip)
end)

-- Display markers
Citizen.CreateThread(function()
	while true do
		Citizen.Wait(0)
		if PlayerData.job ~= nil and PlayerData.job.name == 'mecano' then
			local coords = GetEntityCoords(PlayerPedId())

			for k,v in pairs(Config.Zones) do
				if(v.Type ~= -1 and GetDistanceBetweenCoords(coords, v.Pos.x, v.Pos.y, v.Pos.z, true) < Config.DrawDistance) then
					DrawMarker(v.Type, v.Pos.x, v.Pos.y, v.Pos.z, 0.0, 0.0, 0.0, 0, 0.0, 0.0, v.Size.x, v.Size.y, v.Size.z, v.Color.r, v.Color.g, v.Color.b, 100, false, true, 2, false, false, false, false)
				end
			end
		end
	end
end)

-- Enter / Exit marker events
Citizen.CreateThread(function()
	while true do
		Citizen.Wait(10)

		if PlayerData.job ~= nil and PlayerData.job.name == 'mecano' then

			local coords      = GetEntityCoords(PlayerPedId())
			local isInMarker  = false
			local currentZone = nil

			for k,v in pairs(Config.Zones) do
				if(GetDistanceBetweenCoords(coords, v.Pos.x, v.Pos.y, v.Pos.z, true) < v.Size.x) then
				isInMarker  = true
				currentZone = k
				end
			end

			if (isInMarker and not HasAlreadyEnteredMarker) or (isInMarker and LastZone ~= currentZone) then
				HasAlreadyEnteredMarker = true
				LastZone                = currentZone
				TriggerEvent('esx_mecanojob:hasEnteredMarker', currentZone)
			end

			if not isInMarker and HasAlreadyEnteredMarker then
				HasAlreadyEnteredMarker = false
				TriggerEvent('esx_mecanojob:hasExitedMarker', LastZone)
			end

		end
	end
end)

Citizen.CreateThread(function()
	local trackedEntities = {
		'prop_roadcone02a',
		'prop_generator_01a',
		'prop_toolchest_01',
		'prop_toolchest_05'
	}

	while true do
		Citizen.Wait(500)

		local playerPed = PlayerPedId()
		local coords    = GetEntityCoords(playerPed)

		local closestDistance = -1
		local closestEntity   = nil

		for i=1, #trackedEntities, 1 do
			local object = GetClosestObjectOfType(coords.x, coords.y, coords.z, 3.0, GetHashKey(trackedEntities[i]), false, false, false)

			if DoesEntityExist(object) then
				local objCoords = GetEntityCoords(object)
				local distance  = GetDistanceBetweenCoords(coords.x, coords.y, coords.z, objCoords.x, objCoords.y, objCoords.z, true)

				if closestDistance == -1 or closestDistance > distance then
					closestDistance = distance
					closestEntity   = object
				end
			end
		end

		if closestDistance ~= -1 and closestDistance <= 3.0 then
			if LastEntity ~= closestEntity then
				TriggerEvent('esx_mecanojob:hasEnteredEntityZone', closestEntity)
				LastEntity = closestEntity
			end
		else
			if LastEntity ~= nil then
				TriggerEvent('esx_mecanojob:hasExitedEntityZone', LastEntity)
				LastEntity = nil
			end
		end
	end
end)

-- Key Controls
Citizen.CreateThread(function()
	while true do
		Citizen.Wait(10)

		if CurrentAction ~= nil then

			if IsControlJustReleased(0, Keys['E']) and PlayerData.job ~= nil and PlayerData.job.name == 'mecano' then

				if CurrentAction == 'mecano_actions_menu' then
					OpenMecanoActionsMenu()
				elseif CurrentAction == 'mecano_car_menu' then
					OpenMecanoCarMenu()	
				elseif CurrentAction == 'mecano_cloaker_menu' then
					OpenMecanoCloakerMenu()					
				elseif CurrentAction == 'delete_vehicle' then

					if Config.EnableSocietyOwnedVehicles then

						local vehicleProps = ESX.Game.GetVehicleProperties(CurrentActionData.vehicle)
						TriggerServerEvent('esx_society:putVehicleInGarage', 'mecano', vehicleProps)

					else

						if
							GetEntityModel(vehicle) == GetHashKey('flatbed')   or
							GetEntityModel(vehicle) == GetHashKey('towtruck2')
						then
							TriggerServerEvent('esx_service:disableService', 'mecano')
						end

					end

					ESX.Game.DeleteVehicle(CurrentActionData.vehicle)

				elseif CurrentAction == 'remove_entity' then
					DeleteEntity(CurrentActionData.entity)
				end

				CurrentAction = nil
			end
		end

		if IsControlJustReleased(0, Keys['F6']) and not IsDead and PlayerData.job ~= nil and PlayerData.job.name == 'mecano' then
			OpenMobileMecanoActionsMenu()
		end
	end
end)

AddEventHandler('esx:onPlayerDeath', function()
	IsDead = true
end)

AddEventHandler('playerSpawned', function(spawn)
	IsDead = false
end)




--- Draw3D-TEXT --

-- Funktion

function Draw3DText(x, y, z, text)
	local onScreen,_x,_y=World3dToScreen2d(x,y,z)
	local px,py,pz=table.unpack(GetGameplayCamCoords())
  
	local scale = 0.45
   
	if onScreen then
		SetTextScale(scale, scale)
		SetTextFont(4)
		SetTextProportional(1)
		SetTextColour(255, 255, 255, 215)
		SetTextOutline()
		SetTextEntry("STRING")
		SetTextCentre(1)
		AddTextComponentString(text)
        DrawText(_x,_y)
        local factor = (string.len(text)) / 370
        DrawRect(_x, _y + 0.0150, 0.030 + factor , 0.030, 66, 66, 66, 150)
	end
end

---

--- *** ---

--- Car Menu ---

Citizen.CreateThread(function()
	while true do
		Citizen.Wait(1)
		    if PlayerData.job ~= nil and PlayerData.job.name == 'mecano' then
         if GetDistanceBetweenCoords(GetEntityCoords(GetPlayerPed(-1)), -205.883,  -1327.579, 30.890, true) <= 2.5 then
			Draw3DText(-205.883,  -1327.579, 30.890, '[~g~E~w~] för att ta ut ett ~r~tjänstefordon~w~.')
		    end
        end
    end
end)

--- Storage / Boss actions ---

Citizen.CreateThread(function()
	while true do
		Citizen.Wait(1)
		    if PlayerData.job ~= nil and PlayerData.job.name == 'mecano' then
         if GetDistanceBetweenCoords(GetEntityCoords(GetPlayerPed(-1)), -216.367, -1318.839, 30.890, true) <= 2.5 then
			Draw3DText(-216.367, -1318.839, 30.890, '[~g~E~w~] för att öppna ~r~förrådet ~w~/ ~r~chefsmeny~w~.')
		    end
        end
    end
end)

--- Cloakroom ---

Citizen.CreateThread(function()
	while true do
		Citizen.Wait(1)
		    if PlayerData.job ~= nil and PlayerData.job.name == 'mecano' then
         if GetDistanceBetweenCoords(GetEntityCoords(GetPlayerPed(-1)), -206.644, -1341.803, 34.894, true) <= 2.5 then
			Draw3DText(-206.644, -1341.803, 34.894, '[~g~E~w~] för att byta ~r~outfit~w~.')
		    end
        end
    end
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







---- TEST

Citizen.CreateThread(function()
	while true do Citizen.Wait(0)
		if (GetDistanceBetweenCoords(GetEntityCoords(GetPlayerPed(-1)), -196.278, -1317.262, 30.189, true) <= 2.1 ) then
			if IsControlPressed(0, Keys['E']) then

				local elements = {
					{label = ('Tillverka reparationskit'),      value = 'craft_fixkit'},
					{label = ('Tillverka kapningsverktyg'),       value = 'craft_blow'},	
				}
			
				ESX.UI.Menu.CloseAll()
			
				ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'mecano_craft', {
					title    = ('TILLVERKAREN'),
					align    = 'top-left',
					elements = elements
				}, function(data, menu)

				    if data.current.value == 'craft_fixkit' then
					  ESX.UI.Menu.CloseAll()
					  local pP = GetPlayerPed(-1)
					  TaskPlayAnim(pP, "WORLD_HUMAN_WELDING@enter", "enter", 3.5, -8, -1, 2, 0, 0, 0, 0, 0)
					  TaskStartScenarioInPlace(pP, "WORLD_HUMAN_WELDING", 0, true)	
					  TimeLeft = Config.TimeToCraft
					  repeat                                	
					  TriggerEvent("mt:missiontext", 'Du tillverkar ett ~r~reparationskit~w~. Tid kvar: ~r~' .. TimeLeft .. ' ~w~sekunder', 1000)
					  TimeLeft = TimeLeft - 1
					  Citizen.Wait(1000)
					  until(TimeLeft == 0)
					  ClearPedTasksImmediately(pP)
					  TriggerServerEvent('esx_didrik_mekaniker:GiveFix')
					  ESX.UI.Menu.CloseAll()
					  sendNotification('Du tillverkade ett reparationskit, Bra jobbat.', 'error', 2500)
		  
				    elseif data.current.value == 'craft_blow' then
					  ESX.UI.Menu.CloseAll()
					  local pP = GetPlayerPed(-1)
					  TaskPlayAnim(pP, "WORLD_HUMAN_WELDING@enter", "enter", 3.5, -8, -1, 2, 0, 0, 0, 0, 0)
					  TaskStartScenarioInPlace(pP, "WORLD_HUMAN_WELDING", 0, true)	
					  TimeLeft = Config.TimeToCraft
					  repeat                                	
					  TriggerEvent("mt:missiontext", 'Du tillverkar ett ~r~kapningsverktyg~w~. Tid kvar: ~r~' .. TimeLeft .. ' ~w~sekunder', 1000)
					  TimeLeft = TimeLeft - 1
					  Citizen.Wait(1000)
					  until(TimeLeft == 0)
					  ClearPedTasksImmediately(pP)
					  TriggerServerEvent('esx_didrik_mekaniker:GiveBlow')
					  ESX.UI.Menu.CloseAll()
					  sendNotification('Du tillverkade ett kapningsverktyg, Bra jobbat.', 'error', 2500)			
				    end
			    end, function(data, menu)
				menu.close()

				end)
			end
		end
	end
  end)
  
  --- Tillverkaren
  
  Citizen.CreateThread(function()
  while true do
	Citizen.Wait(1)
  
	  if PlayerData.job ~= nil and PlayerData.job.name == 'mecano' then
		if (GetDistanceBetweenCoords(GetEntityCoords(GetPlayerPed(-1)), -196.278, -1317.262, 30.189, true) <= 1000 ) then
			DrawMarker(27, -196.278, -1317.262, 30.189, 0, 0, 0, 0, 0, 0, 2.001, 2.0001, 0.5001, 255, 0, 0, 200, 0, 0, 0, 0)
		end
	  end
  
	  if PlayerData.job ~= nil and PlayerData.job.name == 'mecano' then
		if GetDistanceBetweenCoords(GetEntityCoords(GetPlayerPed(-1)), -196.278, -1317.262, 31.099, true) <= 6.5 then
			Draw3DText(-196.278, -1317.262, 31.099, '[~g~E~w~] för att öppna ~r~tillverkaren~w~')
  
	  end
		end
	end
  end)
 

----