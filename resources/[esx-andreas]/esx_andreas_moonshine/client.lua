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

local menuIsShowed 				 = false
local hasEnteredMarker 	         = false
local isInMarker 		         = false
local blockinput				 = false
local cinema					 = false
local isSelling					 = false

ESX = nil

Citizen.CreateThread(function()
	while ESX == nil do
		TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)
		Citizen.Wait(0)
	end
end)

-------------------------------------------------------------------------------

AddEventHandler('esx_andreas_moonshine:hasExitedMarker', function(zone)
	ESX.UI.Menu.CloseAll()
end)

--------------------------- CREATE MARKERS -----------------------------------

Citizen.CreateThread(function()
	while true do
		Citizen.Wait(1)
		local coords = GetEntityCoords(GetPlayerPed(-1))
		for i=1, #Config.Zones, 1 do
			if(GetDistanceBetweenCoords(coords, Config.Zones[i].x, Config.Zones[i].y, Config.Zones[i].z, true) < Config.DrawDistance) then
				DrawMarker(Config.MarkerType, Config.Zones[i].x, Config.Zones[i].y, Config.Zones[i].z, 0.0, 0.0, 0.0, 0, 0.0, 0.0, Config.ZoneSize.x, Config.ZoneSize.y, Config.ZoneSize.z, Config.MarkerColor.r, Config.MarkerColor.g, Config.MarkerColor.b, 100, false, true, 2, false, false, false, false)
			end
		end
	end
end)

Citizen.CreateThread(function()
	while true do
		Citizen.Wait(1)
		local coords         = GetEntityCoords(GetPlayerPed(-1))
		isInMarker = false
		local currentZone    = nil
		for i=1, #Config.Zones, 1 do
			if(GetDistanceBetweenCoords(coords, Config.Zones[i].x, Config.Zones[i].y, Config.Zones[i].z, true) < Config.ZoneSize.x / 2) then
				isInMarker  = true
				SetTextComponentFormat('STRING')
				AddTextComponentString('Tryck på ~INPUT_CONTEXT~ för att öppna menyn')
				DisplayHelpTextFromStringLabel(0, 0, 1, -1)
			end
		end
		if isInMarker and not hasEnteredMarker then
			hasEnteredMarker = true
		end
		if not isInMarker and hasEnteredMarker then
			hasEnteredMarker = false
			TriggerEvent('esx_andreas_moonshine:hasExitedMarker')
		end
	end
end)

----------------------------------- FUNKTIONER -------------------------------

Citizen.CreateThread(function()
	local count
	while true do
		Citizen.Wait(0)
		if blockinput then
			count = 1
			DisableAllControlActions(1)
			DisableAllControlActions(2)
			DisableAllControlActions(3)
			DisableAllControlActions(4)
			DisableAllControlActions(5)
			DisableAllControlActions(6)
			DisableAllControlActions(7)
			DisableAllControlActions(8)
			DisableAllControlActions(9)
			DisableAllControlActions(10)
			DisableAllControlActions(11)
			DisableAllControlActions(12)
			DisableAllControlActions(13)
			DisableAllControlActions(14)
			DisableAllControlActions(15)
			DisableAllControlActions(16)
			DisableAllControlActions(17)
			DisableAllControlActions(18)
			DisableAllControlActions(19)
			DisableAllControlActions(20)
			DisableAllControlActions(21)
			DisableAllControlActions(22)
			DisableAllControlActions(23)
			DisableAllControlActions(24)
			DisableAllControlActions(25)
			DisableAllControlActions(26)
			DisableAllControlActions(27)
			DisableAllControlActions(28)
			DisableAllControlActions(29)
			DisableAllControlActions(30)
			DisableAllControlActions(31)
		else
		Citizen.Wait(500)
		end
	end
end)

Citizen.CreateThread(function()
	while true do
		Citizen.Wait(500)
		if cinema then
		local hasCinema = false
			while cinema do
				Wait(5)
				DrawRect(0.5, 0.075, 1.0, 0.15, 0, 0, 0, 255)
				DrawRect(0.5, 0.925, 1.0, 0.15, 0, 0, 0, 255)
				SetDrawOrigin(0.0, 0.0, 0.0, 0)
				DisplayRadar(false)
			end
		end
	end
end)

function Draw3DText(x, y, z, text)
    local onScreen,_x,_y=World3dToScreen2d(x,y,z)
    local px,py,pz=table.unpack(GetGameplayCamCoords())
    local dist = GetDistanceBetweenCoords(px,py,pz, x,y,z, 1)
  
    local scale = 0.5
   
    if onScreen then
        SetTextScale(scale, scale)
        SetTextFont(0)
        SetTextProportional(1)
        SetTextColour(255, 255, 255, 255)
        SetTextDropshadow(0, 0, 0, 0, 255)
        SetTextEdge(2, 0, 0, 0, 150)
        SetTextDropShadow()
        SetTextOutline()
        SetTextEntry("STRING")
        SetTextCentre(1)
        AddTextComponentString(text)
        DrawText(_x,_y)
    end
end

------------------------ EVENTS ----------------------

RegisterNetEvent('esx_andreas_moonshine:createMoonshine')
AddEventHandler('esx_andreas_moonshine:createMoonshine', function()
	ESX.TriggerServerCallback('esx_andreas_moonshine:checkIng', function(hasItem)
		if hasItem then
			SetEntityCoords(GetPlayerPed(-1), 279.97, 6785.22, 14.7)
			SetEntityHeading(GetPlayerPed(-1), 358.8)
			blockinput = true
			local pP = GetPlayerPed(-1)
			TaskPlayAnim(pP, "amb@prop_human_bum_bin@enter", "enter", 3.5, -8, -1, 2, 0, 0, 0, 0, 0)
			TaskStartScenarioInPlace(pP, "PROP_HUMAN_BUM_BIN", 0, true)	
			TriggerServerEvent('esx_andreas_moonshine:createMoonshine')
			Citizen.Wait(12000)
			ClearPedTasksImmediately(pP)
			blockinput = false
		else
			ESX.ShowNotification('Du har inte ingredienserna som behövs')
		end
	end)
end)

RegisterNetEvent('esx_andreas_moonshine:sellMoonshine')
AddEventHandler('esx_andreas_moonshine:sellMoonshine', function()
	ESX.TriggerServerCallback('esx_andreas_moonshine:checkBottles', function(hasItem)
		if hasItem then
			cinema = true
			blockinput = true
			RequestModel(-1251702741)
			while not HasModelLoaded(-1251702741) do
				Citizen.Wait(1)
			end
			SetEntityCoords(GetPlayerPed(-1), 283.71, 6795.07, 13.69)
			SetEntityHeading(GetPlayerPed(-1), 192.29)
			FreezeEntityPosition(GetPlayerPed(-1), true)
			local SpawnObject = CreatePed(4, -1251702741, 284.21, 6793.42, 14.7)
			SetEntityHeading(SpawnObject, 0)
			local cam = CreateCam("DEFAULT_SCRIPTED_CAMERA", 1)
			SetCamCoord(cam, 284.89, 6795.67, 15.99)
   		 	SetCamRot(cam, 0.0, 0.0, 296.06, 2)
			RenderScriptCams(1, 0, 0, 0, 0)
				Citizen.Wait(5000)
			DestroyCam(createdCamera, 0)
			RenderScriptCams(0, 0, 0, 0, 1)
			createdCamera = 0
			DeleteEntity(SpawnObject)
			FreezeEntityPosition(GetPlayerPed(-1), false)
			cinema = false
			blockinput = false
			SetNewWaypoint(3725.29, 4525.18)
			ESX.ShowNotification('Åk upp till säljaren på din ~g~GPS')
		else
			ESX.ShowNotification('Du har inte tilltäckligt med flaskor')
		end
	end)
end)
		
-------------------------------- KEY CONTROLS -------------------------------

Citizen.CreateThread(function()
	while true do
		Citizen.Wait(10)
		if IsControlJustReleased(0, Keys['E']) and isInMarker and not menuIsShowed then
			OpenMenu()
		end
	end
end)

------------------------------------ MENUS -----------------------------------


function OpenMenu()
    ESX.UI.Menu.CloseAll()

    ESX.UI.Menu.Open(
        'default', GetCurrentResourceName(), 'menu_menu',
        {
            title    = 'Hembränt',
            elements = {
				{label = 'Tillverka hembränt', value = 'create'},
                {label = 'Sälj moonshine', value = 'sell'},
            }
        },
        function(data, menu)
            
            if data.current.value == 'create' then
				TriggerEvent('esx_andreas_moonshine:createMoonshine')
            end

			if data.current.value == 'sell' then
				TriggerEvent('esx_andreas_moonshine:sellMoonshine')
            end
        end,
        function(data, menu)
            menu.close()
        end
    )
end




------------------------ FÖRSÄLJNING ------------------------

Citizen.CreateThread(function()
	while true do Citizen.Wait(0)
		if (GetDistanceBetweenCoords(GetEntityCoords(GetPlayerPed(-1)), 3725.29, 4525.18, 22.47, true) <= 2.1 ) then
			if IsControlPressed(0, Keys['E']) then
				if not selling then
					selling = true
					TriggerServerEvent('esx_andreas_moonshine:startSell')
					Wait(2000)
					selling = false
					Wait(7000)
					TriggerServerEvent('esx_andreas_moonshine:stopSell')
				end
			end
		end
	end
 end)
  
  --- Försäljning
  
  Citizen.CreateThread(function()
  while true do
	Citizen.Wait(1)
  
		if (GetDistanceBetweenCoords(GetEntityCoords(GetPlayerPed(-1)), 3725.29, 4525.18, 21.60, true) <= 500 ) then
			DrawMarker(27, 3725.29, 4525.18, 21.60, 0, 0, 0, 0, 0, 0, 1.001, 1.0001, 0.5001, 255, 0, 0, 200, 0, 0, 0, 0)
		end
  
		if GetDistanceBetweenCoords(GetEntityCoords(GetPlayerPed(-1)), 3725.29, 4525.18, 21.60, true) <= 6.5 then
			Draw3DText(3725.29,4525.18, 21.60, '[~g~E~w~] för att sälja ditt ~r~hembränt~w~')
		end
	end
  end)