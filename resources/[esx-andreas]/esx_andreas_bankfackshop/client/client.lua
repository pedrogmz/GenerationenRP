local Keys = {
		["ESC"] = 322, 
		["E"] = 38
}

ESX                         = nil
local inMenu = false

Citizen.CreateThread(function()
  while ESX == nil do
    TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)
    Citizen.Wait(0)
  end
end)

RegisterNUICallback('yes', function()
	TriggerServerEvent('esx_andreas_bankfack:buyKey')
end)

--===============================================
--==               NUIFocusoff                 ==
--===============================================

RegisterNUICallback('NUIFocusOff', function()
  inMenu = false
  SetNuiFocus(false, false)
  SendNUIMessage({type = 'closeAll'})
end)

-- Marker --

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
	while true do
		Citizen.Wait(1)
			if (GetDistanceBetweenCoords(GetEntityCoords(GetPlayerPed(-1)), 253.47, 220.9, 105.29, true) <= 500 ) then
				inMenu = true 
				DrawMarker(27, 253.47, 220.9, 105.29, 0, 0, 0, 0, 0, 0, 1.001, 1.0001, 0.5001, 128, 128, 128, 200, 0, 0, 0, 0)
			end
	  
			if GetDistanceBetweenCoords(GetEntityCoords(GetPlayerPed(-1)), 253.47, 220.9, 106.29, true) <= 6.5 then
				Draw3DText(253.47, 220.9, 106.29, '[~g~E~w~] för att öppna menyn')
			end
	end
end)


Citizen.CreateThread(function()
	while true do Citizen.Wait(1)
		if (GetDistanceBetweenCoords(GetEntityCoords(GetPlayerPed(-1)), 253.47, 220.9, 106.29, true) <= 0.5 ) then
			if inMenu then
				if IsControlPressed(0, Keys['E']) then
					SetNuiFocus(true, true)
					SendNUIMessage({type = 'openGeneral'})
				end
			end
		end
	end
end)