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

ESX = nil
local isDead = false
local inAnim = false

Citizen.CreateThread(function()
	while ESX == nil do
		TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)
		Citizen.Wait(0)
	end
end)

AddEventHandler('esx:onPlayerDeath', function(data)
	isDead = true
end)

AddEventHandler('playerSpawned', function(spawn)
	isDead = false
end)

function startAttitude(lib, anim)
	ESX.Streaming.RequestAnimSet(lib, function()
		SetPedMovementClipset(PlayerPedId(), anim, true)
	end)
end

function startAnim(lib, anim)
	ESX.Streaming.RequestAnimDict(lib, function()
		TaskPlayAnim(PlayerPedId(), lib, anim, 8.0, -8.0, -1, 1, 0, false, false, false)
	end)
end

function startScenario(anim)
	TaskStartScenarioInPlace(PlayerPedId(), anim, 0, false)
end

function OpenAnimationsMenu()
	local elements = {}

	for i=1, #Config.Animations, 1 do
		table.insert(elements, {label = Config.Animations[i].label, value = Config.Animations[i].name})
	end
	table.insert(elements, {label = 'Synkade animationer', value = 'sync'})
	table.insert(elements, {label = 'Välj favorit [Z]', value = 'favorite'})

	ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'animations',
	{
		title    = 'Animations',
		align    = 'top-left',
		elements = elements
	}, function(data, menu)
		if data.current.value == 'favorite' then
			OpenFavoriteMenu()
		elseif data.current.value == 'sync' then
			OpenSyncedMenu()
		else
			OpenAnimationsSubMenu(data.current.value)
		end
	end, function(data, menu)
		menu.close()
	end)
end

RegisterNetEvent('esx_animations:syncTarget')
AddEventHandler('esx_animations:syncTarget', function(target, animationLib, animation2, distans, distans2, height, spin)
	local playerPed = GetPlayerPed(-1)
	local targetPed = GetPlayerPed(GetPlayerFromServerId(target))

	RequestAnimDict(animationLib)

	while not HasAnimDictLoaded(animationLib) do
		Citizen.Wait(10)
	end
	
	AttachEntityToEntity(GetPlayerPed(-1), targetPed, 0, distans2, distans, height, 0.5, 0.5, 180.0, false, false, false, false, 2, false)
	Wait(500)
	DetachEntity(GetPlayerPed(-1), true, false)
	TaskPlayAnim(playerPed, animationLib, animation2, 8.0, -8.0, 3000, 0, 0, false, false, false)

	Citizen.Wait(3000)
	DetachEntity(GetPlayerPed(-1), true, false)
end)

RegisterNetEvent('esx_animations:syncMe')
AddEventHandler('esx_animations:syncMe', function(animationLib, animation)
	local playerPed = GetPlayerPed(-1)

	RequestAnimDict(animationLib)

	while not HasAnimDictLoaded(animationLib) do
		Citizen.Wait(10)
	end
	Wait(500)
	TaskPlayAnim(playerPed, animationLib, animation, 8.0, -8.0, 3000, 0, 0, false, false, false)

	Citizen.Wait(3000)

end)

function OpenSyncedMenu()
	local title    = nil
	local elements = {}

	for i=1, #Config.SyncAnimations, 1 do
			title = Config.SyncAnimations[i].label

			for j=1, #Config.SyncAnimations[i].items, 1 do
				table.insert(elements, {
					label = Config.SyncAnimations[i].items[j].label,
					value = Config.SyncAnimations[i].items[j].data
					-- lib = 'mp_ped_interaction', anim1 = 'hugs_guy_a', anim2 = 'hugs_guy_a', distans = 0.65, distans2 = 0.0, height = 0.0, spin = 180.0
					-- target, animationLib, animation, animation2, distans, distans2, height
				})
			end

			break

	end

	ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'animations_sub',
	{
		title    = title,
		align    = 'top-left',
		elements = elements
	}, function(data, menu)
		local lib  = data.current.value.lib
		local anim1  = data.current.value.anim1
		local anim2  = data.current.value.anim2
		local distans  = data.current.value.distans
		local distans2 = data.current.value.distans2
		local height  = data.current.value.height
		local closestPlayer, distance = ESX.Game.GetClosestPlayer()
	
		if distance ~= -1 and distance <= 3.0 and not IsPedInAnyVehicle(GetPlayerPed(-1)) and not IsPedInAnyVehicle(GetPlayerPed(closestPlayer)) then

			TriggerServerEvent('esx_animations:sync', GetPlayerServerId(closestPlayer), lib, anim1, anim2, distans, distans2, height)
		else
			sendNotification('Ingen spelare i närheten', 'error', 2500)
		end
	end, function(data, menu)
		menu.close()
	end)
end

function OpenFavoriteMenu()

	local elements = {}

	for i=1, #Config.Animations, 1 do
		if Config.Animations[i].name ~= "attitudem" then
			table.insert(elements, {label = Config.Animations[i].label, value = Config.Animations[i].name})
		end
	end

	ESX.UI.Menu.Open(
	'default', GetCurrentResourceName(), 'favorite',
	{
		title    = 'Favorit',
		align = 'top-left',
		elements = elements
	},
	function(data, menu)
		OpenFavoriteSubMenu(data.current.value)
	end,
	function(data, menu)
		menu.close()
	end)

end

function OpenFavoriteSubMenu(menu)

	local title    = nil
	local elements = {}

	for i=1, #Config.Animations, 1 do
		
		if Config.Animations[i].name == menu then

			title = Config.Animations[i].label

			for j=1, #Config.Animations[i].items, 1 do
				table.insert(elements, {
					label = Config.Animations[i].items[j].label,
					type  = Config.Animations[i].items[j].type,
					value = Config.Animations[i].items[j].data
				})
			end

			break

		end

	end

	ESX.UI.Menu.Open(
		'default', GetCurrentResourceName(), 'favorite_submemu',
		{
			title = title,
			align = 'top-left',
			elements = elements
		},
		function(data, menu)

			local type = data.current.type
			local lib  = data.current.value.lib
			local anim = data.current.value.anim
			if type == 'scenario' then
				ESX.UI.Menu.CloseAll()
				TriggerServerEvent('esx_animations:newFavorite', 'null', anim, 1)
			else
			if type ~= 'attitude' then
				ESX.UI.Menu.CloseAll()
				TriggerServerEvent('esx_animations:newFavorite', lib, anim, 0)
			end
		end
		
	end,
	function(data, menu)
		menu.close()
	end)

end


function OpenAnimationsSubMenu(menu)
	local title    = nil
	local elements = {}

	for i=1, #Config.Animations, 1 do
		if Config.Animations[i].name == menu then
			title = Config.Animations[i].label

			for j=1, #Config.Animations[i].items, 1 do
				table.insert(elements, {
					label = Config.Animations[i].items[j].label,
					type  = Config.Animations[i].items[j].type,
					value = Config.Animations[i].items[j].data
				})
			end

			break

		end
	end

	ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'animations_sub',
	{
		title    = title,
		align    = 'top-left',
		elements = elements
	}, function(data, menu)
		local type = data.current.type
		local lib  = data.current.value.lib
		local anim = data.current.value.anim

		if type == 'scenario' then
			startScenario(anim)
		elseif type == 'attitude' then
			startAttitude(lib, anim)
		elseif type == 'anim' then
			startAnim(lib, anim)
		end
	end, function(data, menu)
		menu.close()
	end)
end

RegisterNetEvent('esx_animations')
AddEventHandler('esx_animations', function()
	OpenAnimationsMenu()
end)

-- Key Controls
Citizen.CreateThread(function()
	while true do
		Citizen.Wait(10)

		if IsControlJustReleased(0, Keys['X']) and GetLastInputMethod(2) and not isDead then
			ClearPedTasks(PlayerPedId())
		end
		
		if IsControlJustReleased(0, Keys['Z']) and not isDead and not IsPedInAnyVehicle(GetPlayerPed(-1)) then
			ESX.TriggerServerCallback('esx_animations:getFavorite', function(data)
				if data.scenario == true then
					startScenario(data.animation)
				else
					startAnim(data.lib, data.animation)
				end
			end)
		end

	end
end)

function sendNotification(message, messagetype, messagetimeout)
	TriggerEvent("pNotify:SendNotification",{
		text = (message),
		type = messagetype,
		timeout = (messagetimeout),
		layout = "bottomCenter",
		queue = "global"
	})
end

--[[
--]]

RegisterNetEvent('esx_animations:openMenu')
AddEventHandler('esx_animations:openMenu', function()
	ESX.UI.Menu.CloseAll()
	OpenAnimationsMenu()
end)