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
local PlayerData              = {}
local IsAnimated              = false

Citizen.CreateThread(function()
	while ESX == nil do
		TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)
		Citizen.Wait(200)
		PlayerData = ESX.GetPlayerData()
	end
end)

RegisterNetEvent('esx:playerLoaded')
AddEventHandler('esx:playerLoaded', function(xPlayer)
    PlayerData = xPlayer
end)

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

-- Pnotify
function sendNotification(message, messageType, messageTimeout)
	TriggerEvent("pNotify:SendNotification", {
		text = message,
		type = messageType,
		queue = "didrik",
		timeout = messageTimeout,
		layout = "bottomCenter"
	})
end

Citizen.CreateThread(function()
	while true do Citizen.Wait(0)
    if (GetDistanceBetweenCoords(GetEntityCoords(GetPlayerPed(-1)), 224.427, -913.361, 29.792, true) <= 1.5 ) then
      if IsControlPressed(0, Keys['E']) then
        Wait(500)
        if hasKorv then 
          blockinput = true
            local pP = GetPlayerPed(-1)
            TaskPlayAnim(pP, "PROP_HUMAN_BBQ", "enter", 3.5, -8, -1, 2, 0, 0, 0, 0, 0)
            TaskStartScenarioInPlace(pP, "PROP_HUMAN_BBQ", 0, true)
            TimeLeft = Config.TimeToGrilla
            repeat                                	
            TriggerEvent("mt:missiontext", 'Din mat grillas. Tid kvar: ~r~' .. TimeLeft .. ' ~w~sekunder', 1000)
            TimeLeft = TimeLeft - 1
            Citizen.Wait(1000)
            until(TimeLeft == 0)
          blockinput = false	  
            ClearPedTasksImmediately(pP)
            sendNotification('Du grillade din korv, Smaklig måltid.', 'error', 2500)
            TriggerServerEvent('esx_didrik_bbc:giveGrillad')
        else
           sendNotification('Du har ingen korv att grilla.', 'error', 2500)
           Wait(500)
        end
      end         

    elseif (GetDistanceBetweenCoords(GetEntityCoords(GetPlayerPed(-1)), 222.720, -915.897, 29.792, true) <= 1.5 ) then
          if IsControlPressed(0, Keys['E']) then
               Wait(500)
               if hasKorv then 
                 blockinput = true
                    local pP = GetPlayerPed(-1)
                    TaskPlayAnim(pP, "PROP_HUMAN_BBQ", "enter", 3.5, -8, -1, 2, 0, 0, 0, 0, 0)
                    TaskStartScenarioInPlace(pP, "PROP_HUMAN_BBQ", 0, true)
                    TimeLeft = Config.TimeToGrilla
                    repeat                                	
                    TriggerEvent("mt:missiontext", 'Din mat grillas. Tid kvar: ~r~' .. TimeLeft .. ' ~w~sekunder', 1000)
                    TimeLeft = TimeLeft - 1
                    Citizen.Wait(1000)
                    until(TimeLeft == 0)
                  blockinput = false	  
                    ClearPedTasksImmediately(pP)
                    sendNotification('Du grillade din korv, Smaklig måltid.', 'error', 2500)
                    TriggerServerEvent('esx_didrik_bbc:giveGrillad')
               else
                  sendNotification('Du har ingen korv att grilla.', 'error', 2500)
                  Wait(500)
               end
          end                
		end
	end
end)
  
--- Grill
  
Citizen.CreateThread(function()
while true do
Citizen.Wait(1)

	if (GetDistanceBetweenCoords(GetEntityCoords(GetPlayerPed(-1)), 224.427, -913.361, 29.792, true) <= 1000 ) then
    DrawMarker(27, 224.427, -913.361, 29.792, 0, 0, 0, 0, 0, 0, 2.001, 2.0001, 0.5001, 204, 204, 204, 200, 0, 0, 0, 0)
    DrawMarker(27, 222.720, -915.897, 29.792, 0, 0, 0, 0, 0, 0, 2.001, 2.0001, 0.5001, 204, 204, 204, 200, 0, 0, 0, 0)
	end

	if GetDistanceBetweenCoords(GetEntityCoords(GetPlayerPed(-1)), 224.427, -913.361, 30.6, true) <= 6.5 then
    Draw3DText(224.427, -913.361, 30.6, '[~g~E~w~] för att ~r~grilla~w~')
    Draw3DText(222.720, -915.897, 30.6, '[~g~E~w~] för att ~r~grilla~w~')
	end
end
end)


Citizen.CreateThread(function()
    local count
    while true do
        Citizen.Wait(0)
        if blockinput then
            count = 1
            DisableControlAction(0, 73, true) -- ENTER key
            DisableControlAction(0, 56, true) -- ENTER key
        else
        Citizen.Wait(500)
        end
    end
end)  

-- Har / har inte korv.
RegisterNetEvent('esx:playerLoaded')
AddEventHandler('esx:playerLoaded', function(xPlayer)
	PlayerData = xPlayer

	TriggerEvent('esx_didrik_bbc:hasNotKorv')

	for i=1, #PlayerData.inventory, 1 do
		if PlayerData.inventory[i].name == 'ogrillad' then
			if PlayerData.inventory[i].count > 0 then
				TriggerEvent('esx_didrik_bbc:hasKorv')
			end
		end
	end
end)

RegisterNetEvent('esx_didrik_bbc:hasNotKorv')
AddEventHandler('esx_didrik_bbc:hasNotKorv', function()
	hasKorv = false
end)

RegisterNetEvent('esx_didrik_bbc:hasKorv')
AddEventHandler('esx_didrik_bbc:hasKorv', function()
	hasKorv = true
end)

RegisterNetEvent('esx_didrik_bbc:onEat')
AddEventHandler('esx_didrik_bbc:onEat', function(prop_name)
    if not IsAnimated then
		local prop_name = prop_name or 'prop_cs_hotdog_01'
    	IsAnimated = true
	    local playerPed = GetPlayerPed(-1)
	    Citizen.CreateThread(function()
	        local x,y,z = table.unpack(GetEntityCoords(playerPed))
	        prop = CreateObject(GetHashKey(prop_name), x, y, z+0.2,  true,  true, true)
	        AttachEntityToEntity(prop, playerPed, GetPedBoneIndex(playerPed, 18905), 0.12, 0.028, 0.001, 10.0, 175.0, 0.0, true, true, false, true, 1, true)
	        RequestAnimDict('mp_player_inteat@burger')
	        while not HasAnimDictLoaded('mp_player_inteat@burger') do
	            Wait(0)
	        end
	        TaskPlayAnim(playerPed, 'mp_player_inteat@burger', 'mp_player_int_eat_burger_fp', 8.0, -8, -1, 49, 0, 0, 0, 0)
	        Wait(9000)
	        IsAnimated = false
	        ClearPedSecondaryTask(playerPed)
	        DeleteObject(prop)
	    end)
	end
end)