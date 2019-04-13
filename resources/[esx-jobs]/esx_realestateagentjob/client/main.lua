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

local HasAlreadyEnteredMarker = false
local LastZone                = nil
local CurrentAction           = nil
local CurrentActionMsg        = ''
local CurrentActionData       = {}

ESX                           = nil

Citizen.CreateThread(function()
	while ESX == nil do
		TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)
		Citizen.Wait(0)
	end

	while ESX.GetPlayerData().job == nil do
		Citizen.Wait(100)
	end

	ESX.PlayerData = ESX.GetPlayerData()

	if ESX.PlayerData.job.name == 'realestateagent' then
		Config.Zones.OfficeActions.Type = 1
	else
		Config.Zones.OfficeActions.Type = -1
	end
end)

function OpenRealestateAgentMenu()
	local elements = {
		{label = _U('properties'), value = 'properties'},
		{label = _U('clients'),    value = 'customers'},
	}

	if ESX.PlayerData.job ~= nil and ESX.PlayerData.job.name == 'realestateagent' and ESX.PlayerData.job.grade_name == 'boss' then
		table.insert(elements, {
			label = _U('boss_action'),
			value = 'boss_actions'
		})
	end

	ESX.UI.Menu.CloseAll()

	ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'realestateagent', {
		title    = _U('realtor'),
		align    = 'top-left',
		elements = elements
	}, function(data, menu)

		if data.current.value == 'properties' then
			OpenPropertyMenu()
		elseif data.current.value == 'customers' then
			OpenCustomersMenu()
		elseif data.current.value == 'boss_actions' then
			TriggerEvent('esx_society:openBossMenu', 'realestateagent', function(data, menu)
				menu.close()
			end)
		end

	end, function(data, menu)
		menu.close()

		CurrentAction     = 'realestateagent_menu'
		CurrentActionMsg  = _U('press_to_access')
		CurrentActionData = {}
	end)

end

function OpenPropertyMenu()
	TriggerEvent('esx_property:getProperties', function(properties)

		local elements = {
			head = {_U('property_name'), _U('property_actions')},
			rows = {}
		}

		for i=1, #properties, 1 do
			table.insert(elements.rows, {
				data = properties[i],
				cols = {
					properties[i].label,
					_U('property_actionbuttons')
				}
			})
		end

		ESX.UI.Menu.Open('list', GetCurrentResourceName(), 'properties', elements, function(data, menu)

			if data.value == 'sell' then

				menu.close()

				ESX.UI.Menu.Open('dialog', GetCurrentResourceName(), 'sell_property_amount', {
					title = _U('amount')
				}, function(data2, menu2)
					local amount = tonumber(data2.value)

					if amount == nil then
						ESX.ShowNotification(_U('invalid_amount'))
					else
						local closestPlayer, closestDistance = ESX.Game.GetClosestPlayer()
						if closestPlayer == -1 or closestDistance > 3.0 then
							ESX.ShowNotification(_U('no_play_near'))
							menu2.close()
						else
							TriggerServerEvent('esx_realestateagentjob:sell', GetPlayerServerId(closestPlayer), data.data.name, amount)
							menu2.close()
						end

						OpenPropertyMenu()
					end
				end, function(data2, menu2)
					menu2.close()
				end)

			elseif data.value == 'rent' then

				menu.close()

				ESX.UI.Menu.Open('dialog', GetCurrentResourceName(), 'rent_property_amount', {
					title = _U('amount')
				}, function(data2, menu2)
					local amount = tonumber(data2.value)

					if amount == nil then
						ESX.ShowNotification(_U('invalid_amount'))
					else
						local closestPlayer, closestDistance = ESX.Game.GetClosestPlayer()
						if closestPlayer == -1 or closestDistance > 3.0 then
							ESX.ShowNotification(_U('no_play_near'))
							menu2.close()
						else
							TriggerServerEvent('esx_realestateagentjob:rent', GetPlayerServerId(closestPlayer), data.data.name, amount)
							menu2.close()
						end

						OpenPropertyMenu()
					end
				end, function(data2, menu2)
					menu2.close()
				end)

			elseif data.value == 'gps' then

				TriggerEvent('esx_property:getProperty', data.data.name, function(property)
					if property.isSingle then
						SetNewWaypoint(property.entering.x, property.entering.y)
					else
						TriggerEvent('esx_property:getGateway', property, function(gateway)
							SetNewWaypoint(gateway.entering.x, gateway.entering.y)
						end)
					end
				end)

			end

		end, function(data, menu)
			menu.close()
		end)

	end)

end

function OpenCustomersMenu()
	ESX.TriggerServerCallback('esx_realestateagentjob:getCustomers', function(customers)
		local elements = {
			head = {_U('customer_client'), _U('customer_property'), _U('customer_agreement'), _U('customer_actions')},
			rows = {}
		}

		for i=1, #customers, 1 do
			table.insert(elements.rows, {
				data = customers[i],
				cols = {
					customers[i].name,
					customers[i].propertyLabel,
					(customers[i].propertyRented and _U('customer_rent') or _U('customer_sell')),
					_U('customer_contractbuttons')
				}
			})
		end

		ESX.UI.Menu.Open('list', GetCurrentResourceName(), 'customers', elements, function(data, menu)

			if data.value == 'revoke' then
				TriggerServerEvent('esx_realestateagentjob:revoke', data.data.propertyName, data.data.propertyOwner)
				OpenCustomersMenu()
			elseif data.value == 'gps' then
				TriggerEvent('esx_property:getProperty', data.data.propertyName, function(property)
					if property.isSingle then
						SetNewWaypoint(property.entering.x, property.entering.y)
					else
						TriggerEvent('esx_property:getGateway', property, function(gateway)
							SetNewWaypoint(gateway.entering.x, gateway.entering.y)
						end)
					end
				end)
			end

		end, function(data, menu)
			menu.close()
		end)
	end)
end

RegisterNetEvent('esx:setJob')
AddEventHandler('esx:setJob', function(job)
	ESX.PlayerData.job = job

	if ESX.PlayerData.job.name == 'realestateagent' then
		Config.Zones.OfficeActions.Type = 1
	else
		Config.Zones.OfficeActions.Type = -1
	end
end)

AddEventHandler('esx_realestateagentjob:hasEnteredMarker', function(zone)
	if zone == 'OfficeEnter' then
		local playerPed = PlayerPedId()
		SetEntityCoords(playerPed, Config.Zones.OfficeInside.Pos.x, Config.Zones.OfficeInside.Pos.y, Config.Zones.OfficeInside.Pos.z)
	elseif zone == 'OfficeExit' then
		local playerPed = PlayerPedId()
		SetEntityCoords(playerPed, Config.Zones.OfficeOutside.Pos.x, Config.Zones.OfficeOutside.Pos.y, Config.Zones.OfficeOutside.Pos.z)
	elseif zone == 'OfficeActions' and ESX.PlayerData.job ~= nil and ESX.PlayerData.job.name == 'realestateagent' then
		CurrentAction     = 'realestateagent_menu'
		CurrentActionMsg  = _U('press_to_access')
		CurrentActionData = {}
	end
end)

AddEventHandler('esx_realestateagentjob:hasExitedMarker', function(zone)
	ESX.UI.Menu.CloseAll()
	CurrentAction = nil
end)

-- Create Blips
Citizen.CreateThread(function()
	local blip = AddBlipForCoord(Config.Zones.OfficeEnter.Pos.x, Config.Zones.OfficeEnter.Pos.y, Config.Zones.OfficeEnter.Pos.z)

	SetBlipSprite (blip, 357)
	SetBlipDisplay(blip, 4)
	SetBlipScale  (blip, 0.8)
	SetBlipColour (blip, 59)
	SetBlipAsShortRange(blip, true)

	BeginTextCommandSetBlipName("STRING")
	AddTextComponentString(_U('realtors'))
	EndTextCommandSetBlipName(blip)
end)

-- Display markers
Citizen.CreateThread(function()
	while true do

		Citizen.Wait(0)

		local coords = GetEntityCoords(PlayerPedId())

		for k,v in pairs(Config.Zones) do
			if(v.Type ~= -1 and GetDistanceBetweenCoords(coords, v.Pos.x, v.Pos.y, v.Pos.z, true) < Config.DrawDistance) then
				DrawMarker(v.Type, v.Pos.x, v.Pos.y, v.Pos.z, 0.0, 0.0, 0.0, 0, 0.0, 0.0, v.Size.x, v.Size.y, v.Size.z, Config.MarkerColor.r, Config.MarkerColor.g, Config.MarkerColor.b, 100, false, true, 2, false, false, false, false)
			end
		end

	end
end)

-- Enter / Exit marker events
Citizen.CreateThread(function()
	while true do

		Citizen.Wait(0)

		local coords      = GetEntityCoords(PlayerPedId())
		local isInMarker  = false
		local currentZone = nil

		for k,v in pairs(Config.Zones) do
			if GetDistanceBetweenCoords(coords, v.Pos.x, v.Pos.y, v.Pos.z, true) < v.Size.x then
				isInMarker  = true
				currentZone = k
			end
		end

		if (isInMarker and not HasAlreadyEnteredMarker) or (isInMarker and LastZone ~= currentZone) then
			HasAlreadyEnteredMarker = true
			LastZone                = currentZone
			TriggerEvent('esx_realestateagentjob:hasEnteredMarker', currentZone)
		end

		if not isInMarker and HasAlreadyEnteredMarker then
			HasAlreadyEnteredMarker = false
			TriggerEvent('esx_realestateagentjob:hasExitedMarker', LastZone)
		end

	end
end)

-- Key controls
Citizen.CreateThread(function()
	while true do
		Citizen.Wait(0)

		if CurrentAction ~= nil then
			ESX.ShowHelpNotification(CurrentActionMsg)

			if IsControlJustReleased(0, Keys['E']) then
				if CurrentAction == 'realestateagent_menu' then
					OpenRealestateAgentMenu()
				end

				CurrentAction = nil
			end
		else
			Citizen.Wait(500)
		end
	end
end)

-- Load IPLS
Citizen.CreateThread(function()
	LoadMpDlcMaps()
	EnableMpDlcMaps(true)
	RequestIpl('ex_dt1_02_office_02c')
end)

TriggerServerEvent("player:serviceOn", "realestateagent")