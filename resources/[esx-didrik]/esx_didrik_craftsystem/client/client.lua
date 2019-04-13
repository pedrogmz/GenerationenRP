ESX                         = nil
inMenu                      = true
local atCraft = false
local craftMenu = true
local TimeToGrilla = 60
local plats = {
  {name="Tillverkaren", x=737.846, y=-1077.954, z=22.168},
}	

Citizen.CreateThread(function()
  while ESX == nil do
    TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)
    Citizen.Wait(0)
  end
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

Citizen.CreateThread(function()
    local count
    while true do
      Citizen.Wait(0)
        if blockinput then
          count = 1
					DisableControlAction(0, 73, true)
					DisableControlAction(0, 56, true)
					DisableControlAction(0, 38, true) 
        else
          Citizen.Wait(500)
        end
    end
end)  

Citizen.CreateThread(function()
	while true do
		Citizen.Wait(1)
		
		   if (GetDistanceBetweenCoords(GetEntityCoords(GetPlayerPed(-1)), 737.846, -1077.954, 21.268, true) <= 1000 ) then
		     DrawMarker(27, 737.846, -1077.954, 21.268, 0, 0, 0, 0, 0, 0, 2.001, 2.0001, 0.5001, 214, 217, 219, 200, 0, 0, 0, 0)
       end

       if GetDistanceBetweenCoords(GetEntityCoords(GetPlayerPed(-1)), 737.846, -1077.954, 22.168, true) <= 2.5 then
			     Draw3DText(737.846, -1077.954, 22.168, '[~g~E~w~] för att öppna ~r~tillverkningsstationen')
       end
    end
end)

if craftMenu then
	Citizen.CreateThread(function()
  while true do
    Wait(0)
	if nearCraft() then
	
		if IsControlJustPressed(1, 38) then
			inMenu = true
			SetNuiFocus(true, true)
			SendNUIMessage({type = 'openGeneral'})
			local ped = GetPlayerPed(-1)
		end
	end
        
    if IsControlJustPressed(1, 322) then
	    inMenu = false
      SetNuiFocus(false, false)
      SendNUIMessage({type = 'close'})
    end
	end
  end)
end

RegisterNUICallback('kniv1', function()

    ESX.TriggerServerCallback('esx_didrik_craft:checkKnife', function(hasItem)
			if hasItem then

				local pP = GetPlayerPed(-1)

				blockinput = true
			  TaskPlayAnim(pP, "amb@prop_human_bum_bin@enter", "enter", 3.5, -8, -1, 2, 0, 0, 0, 0, 0)
			  TaskStartScenarioInPlace(pP, "PROP_HUMAN_BUM_BIN", 0, true)
			  TimeLeft = TimeToGrilla
			  repeat                                	
			  TriggerEvent("mt:missiontext", 'Du tillverkar ditt föremål. Tid kvar: ~r~' .. TimeLeft .. ' ~w~sekunder', 1000)
			  TimeLeft = TimeLeft - 1
			  Citizen.Wait(1000)
				until(TimeLeft == 0)
				ClearPedTasksImmediately(pP)
				blockinput = false
				TriggerServerEvent('esx_didrik_craft:knife')
				sendNotification('Bra jobbat, Du tillverkade en fällkniv.', 'error', 2500)

      else
      	sendNotification('Du har inte tillräckligt med föremål som krävs.', 'error', 2500)
      end
    end)
end)

RegisterNUICallback('batong1', function()

    ESX.TriggerServerCallback('esx_didrik_craft:checkBatong', function(hasItem)
			if hasItem then

				local pP = GetPlayerPed(-1)
				
			  blockinput = true
			  TaskPlayAnim(pP, "amb@prop_human_bum_bin@enter", "enter", 3.5, -8, -1, 2, 0, 0, 0, 0, 0)
			  TaskStartScenarioInPlace(pP, "PROP_HUMAN_BUM_BIN", 0, true)
			  TimeLeft = TimeToGrilla
			  repeat                                	
			  TriggerEvent("mt:missiontext", 'Du tillverkar ditt föremål. Tid kvar: ~r~' .. TimeLeft .. ' ~w~sekunder', 1000)
			  TimeLeft = TimeLeft - 1
			  Citizen.Wait(1000)
			  until(TimeLeft == 0)
			  ClearPedTasksImmediately(pP)
			  blockinput = false
				TriggerServerEvent('esx_didrik_craft:Batong')
				sendNotification('Bra jobbat, Du tillverkade en batong.', 'error', 2500)

      else
      	sendNotification('Du har inte tillräckligt med föremål som krävs.', 'error', 2500)
      end
    end)
end)

RegisterNUICallback('elpistol1', function()

    ESX.TriggerServerCallback('esx_didrik_craft:checkElpistol', function(hasItem)
			if hasItem then

				local pP = GetPlayerPed(-1)
				
			  blockinput = true
			  TaskPlayAnim(pP, "amb@prop_human_bum_bin@enter", "enter", 3.5, -8, -1, 2, 0, 0, 0, 0, 0)
			  TaskStartScenarioInPlace(pP, "PROP_HUMAN_BUM_BIN", 0, true)
			  TimeLeft = TimeToGrilla
			  repeat                                	
			  TriggerEvent("mt:missiontext", 'Du tillverkar ditt föremål. Tid kvar: ~r~' .. TimeLeft .. ' ~w~sekunder', 1000)
			  TimeLeft = TimeLeft - 1
			  Citizen.Wait(1000)
			  until(TimeLeft == 0)
			  ClearPedTasksImmediately(pP)
			  blockinput = false
				TriggerServerEvent('esx_didrik_craft:elpistol')
				sendNotification('Bra jobbat, Du tillverkade en elpistol.', 'error', 2500)

      else
      	sendNotification('Du har inte tillräckligt med föremål som krävs.', 'error', 2500)
      end
    end)
end)

RegisterNUICallback('pistol1', function()

    ESX.TriggerServerCallback('esx_didrik_craft:checkPistol', function(hasItem)
			if hasItem then

				local pP = GetPlayerPed(-1)
				
			  blockinput = true
			  TaskPlayAnim(pP, "amb@prop_human_bum_bin@enter", "enter", 3.5, -8, -1, 2, 0, 0, 0, 0, 0)
			  TaskStartScenarioInPlace(pP, "PROP_HUMAN_BUM_BIN", 0, true)
			  TimeLeft = TimeToGrilla
			  repeat                                	
			  TriggerEvent("mt:missiontext", 'Du tillverkar ditt föremål. Tid kvar: ~r~' .. TimeLeft .. ' ~w~sekunder', 1000)
			  TimeLeft = TimeLeft - 1
			  Citizen.Wait(1000)
			  until(TimeLeft == 0)
			  ClearPedTasksImmediately(pP)
			  blockinput = false
				TriggerServerEvent('esx_didrik_craft:pistol')
				sendNotification('Bra jobbat, Du tillverkade en pistol.', 'error', 2500)

      else
      	sendNotification('Du har inte tillräckligt med föremål som krävs.', 'error', 2500)
      end
    end)
end)

RegisterNUICallback('slagtra1', function()

    ESX.TriggerServerCallback('esx_didrik_craft:checkSlagtra', function(hasItem)
			if hasItem then

				local pP = GetPlayerPed(-1)
				 
		   	blockinput = true
		   	TaskPlayAnim(pP, "amb@prop_human_bum_bin@enter", "enter", 3.5, -8, -1, 2, 0, 0, 0, 0, 0)
		   	TaskStartScenarioInPlace(pP, "PROP_HUMAN_BUM_BIN", 0, true)
		   	TimeLeft = TimeToGrilla
		   	repeat                                	
		   	TriggerEvent("mt:missiontext", 'Du tillverkar ditt föremål. Tid kvar: ~r~' .. TimeLeft .. ' ~w~sekunder', 1000)
		   	TimeLeft = TimeLeft - 1
		   	Citizen.Wait(1000)
		   	until(TimeLeft == 0)
		   	ClearPedTasksImmediately(pP)
		   	blockinput = false
				TriggerServerEvent('esx_didrik_craft:slagtra')
				sendNotification('Bra jobbat, Du tillverkade ett slagträ.', 'error', 2500)

      else
      	sendNotification('Du har inte tillräckligt med föremål som krävs.', 'error', 2500)
      end
    end)
end)

RegisterNUICallback('telefon1', function()

    ESX.TriggerServerCallback('esx_didrik_craft:checkTelefon', function(hasItem)
			if hasItem then

				local pP = GetPlayerPed(-1)
				
			  blockinput = true
			  TaskPlayAnim(pP, "amb@prop_human_bum_bin@enter", "enter", 3.5, -8, -1, 2, 0, 0, 0, 0, 0)
			  TaskStartScenarioInPlace(pP, "PROP_HUMAN_BUM_BIN", 0, true)
			  TimeLeft = TimeToGrilla
			  repeat                                	
			  TriggerEvent("mt:missiontext", 'Du tillverkar ditt föremål. Tid kvar: ~r~' .. TimeLeft .. ' ~w~sekunder', 1000)
			  TimeLeft = TimeLeft - 1
			  Citizen.Wait(1000)
			  until(TimeLeft == 0)
			  ClearPedTasksImmediately(pP)
			  blockinput = false
				TriggerServerEvent('esx_didrik_craft:telefon')
				sendNotification('Bra jobbat, Du tillverkade en telefon.', 'error', 2500)

      else
      	sendNotification('Du har inte tillräckligt med föremål som krävs.', 'error', 2500)
      end
    end)
end)

RegisterNUICallback('dyrkset1', function()

    ESX.TriggerServerCallback('esx_didrik_craft:checkDyrkset', function(hasItem)
			if hasItem then

				local pP = GetPlayerPed(-1)
				
		  	blockinput = true
		  	TaskPlayAnim(pP, "amb@prop_human_bum_bin@enter", "enter", 3.5, -8, -1, 2, 0, 0, 0, 0, 0)
		  	TaskStartScenarioInPlace(pP, "PROP_HUMAN_BUM_BIN", 0, true)
		  	TimeLeft = TimeToGrilla
		  	repeat                                	
		  	TriggerEvent("mt:missiontext", 'Du tillverkar ditt föremål. Tid kvar: ~r~' .. TimeLeft .. ' ~w~sekunder', 1000)
		  	TimeLeft = TimeLeft - 1
		  	Citizen.Wait(1000)
		  	until(TimeLeft == 0)
		  	ClearPedTasksImmediately(pP)
		  	blockinput = false
				TriggerServerEvent('esx_didrik_craft:dyrkset')
				sendNotification('Bra jobbat, Du tillverkade ett dyrkset.', 'error', 2500)

			else			
				sendNotification('Du har inte tillräckligt med föremål som krävs.', 'error', 2500)
      end
    end)
end)

RegisterNUICallback('skottvest1', function()

    ESX.TriggerServerCallback('esx_didrik_craft:checkKofot', function(hasItem)
			if hasItem then

				local pP = GetPlayerPed(-1)
				
			  blockinput = true
			  TaskPlayAnim(pP, "amb@prop_human_bum_bin@enter", "enter", 3.5, -8, -1, 2, 0, 0, 0, 0, 0)
			  TaskStartScenarioInPlace(pP, "PROP_HUMAN_BUM_BIN", 0, true)
			  TimeLeft = TimeToGrilla
			  repeat                                	
			  TriggerEvent("mt:missiontext", 'Du tillverkar ditt föremål. Tid kvar: ~r~' .. TimeLeft .. ' ~w~sekunder', 1000)
			  TimeLeft = TimeLeft - 1
			  Citizen.Wait(1000)
			  until(TimeLeft == 0)
			  ClearPedTasksImmediately(pP)
			  blockinput = false
				TriggerServerEvent('esx_didrik_craft:kofot')
				sendNotification('Bra jobbat, Du tillverkade en kofot.', 'error', 2500)

      else
      	sendNotification('Du har inte tillräckligt med föremål som krävs.', 'error', 2500)
      end
    end)
end)

RegisterNUICallback('NUIFocusOff', function()
  inMenu = false
  SetNuiFocus(false, false)
  SendNUIMessage({type = 'closeAll'})
end)

function nearCraft()
	local player = GetPlayerPed(-1)
	local playerloc = GetEntityCoords(player, 0)
	
	for _, search in pairs(plats) do
		local distance = GetDistanceBetweenCoords(search.x, search.y, search.z, playerloc['x'], playerloc['y'], playerloc['z'], true)

		if distance <= 3 then
			return true
		end
	end
end

--- Blip
Citizen.CreateThread(function()
  local blip = AddBlipForCoord(737.805, -1077.992, 22.168)

  SetBlipSprite (blip, 566)
  SetBlipDisplay(blip, 4)
  SetBlipScale  (blip, 0.8)
  SetBlipColour (blip, 49)
  SetBlipAsShortRange(blip, true)

  BeginTextCommandSetBlipName("STRING")
  AddTextComponentString('Tillverknings station')
  EndTextCommandSetBlipName(blip)
end)

-- notification
function sendNotification(message, messageType, messageTimeout)
	TriggerEvent("pNotify:SendNotification", {
		text = message,
		type = messageType,
		queue = "didrik",
		timeout = messageTimeout,
		layout = "bottomCenter"
	})
end