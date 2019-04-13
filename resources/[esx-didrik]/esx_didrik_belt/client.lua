local speedBuffer  = {}
local velBuffer    = {}
local beltOn       = false
local wasInCar     = false

local UI = { 

	x =  0.033 ,
	y =  -0.048 ,

}

IsCar = function(veh)
		    local vc = GetVehicleClass(veh)
		    return (vc >= 0 and vc <= 7) or (vc >= 9 and vc <= 12) or (vc >= 17 and vc <= 20)
        end	

Fwv = function (entity)
		    local hr = GetEntityHeading(entity) + 90.0
		    if hr < 0.0 then hr = 360.0 + hr end
		    hr = hr * 0.0174533
		    return { x = math.cos(hr) * 2.0, y = math.sin(hr) * 2.0 }
      end

Citizen.CreateThread(function()
	Citizen.Wait(500)
	while true do
		
		local ped = GetPlayerPed(-1)
		local car = GetVehiclePedIsIn(ped)
		
		if car ~= 0 and (wasInCar or IsCar(car)) then
		
			wasInCar = true
			
			if beltOn then DisableControlAction(0, 75) end
			
			speedBuffer[2] = speedBuffer[1]
			speedBuffer[1] = GetEntitySpeed(car)
			
			if speedBuffer[2] ~= nil 
			   and not beltOn
			   and GetEntitySpeedVector(car, true).y > 1.0  
			   and speedBuffer[1] > Cfg.MinSpeed 
			   and (speedBuffer[2] - speedBuffer[1]) > (speedBuffer[1] * Cfg.DiffTrigger) then
			   
				local co = GetEntityCoords(ped)
				local fw = Fwv(ped)
				SetEntityCoords(ped, co.x + fw.x, co.y + fw.y, co.z - 0.47, true, true, true)
				SetEntityVelocity(ped, velBuffer[2].x, velBuffer[2].y, velBuffer[2].z)
				Citizen.Wait(1)
				SetPedToRagdoll(ped, 1000, 1000, 0, 0, 0, 0)
			end
				
			velBuffer[2] = velBuffer[1]
			velBuffer[1] = GetEntityVelocity(car)
				
			if IsControlJustReleased(0, 311) then
				beltOn = not beltOn				  
				if beltOn then sendNotification('Du tog på dig bältet.', 'error', 2500)
				else sendNotification('Du tog av dig bältet.', 'error', 2500) end 
			end
			
		elseif wasInCar then
			wasInCar = false
			beltOn = false
			speedBuffer[1], speedBuffer[2] = 0.0, 0.0
		end
		Citizen.Wait(0)
	end
end)

Citizen.CreateThread(function()
	while true do
		Citizen.Wait(0)
		local ped = GetPlayerPed(-1)
		local car = GetVehiclePedIsIn(ped)
		if beltOn and IsPedInAnyVehicle(ped, false) then
			local betonoff = 'PÅ'
			drawTxt(UI.x + 0.632, 	UI.y + 1.477, 1.0,1.0,0.49 , "~y~BÄLTE: ~w~" .. betonoff, 255, 255, 255, 255)
		elseif not beltOn and IsPedInAnyVehicle(ped, false) then
			local betonoff = 'AV'
			drawTxt(UI.x + 0.632, 	UI.y + 1.477, 1.0,1.0,0.49 , "~y~BÄLTE: ~w~" .. betonoff, 255, 255, 255, 255)
		end
	end
end)

RegisterNetEvent('sexigadidrik:belt')
AddEventHandler('sexigadidrik:belt', function()
	if beltOn then
		TriggerEvent('sexigadidrik:beltOff')
	else
		TriggerEvent('sexigadidrik:beltOn')
	end
end)

RegisterNetEvent('sexigadidrik:beltOn')
AddEventHandler('sexigadidrik:beltOn', function()
	beltOn = true
end)

RegisterNetEvent('sexigadidrik:beltOff')
AddEventHandler('sexigadidrik:beltOff', function()
	beltOn = false
end)

function sendNotification(message, messageType, messageTimeout)
	TriggerEvent("pNotify:SendNotification", {
		text = message,
		type = messageType,
		queue = "qalle",
		timeout = messageTimeout,
		layout = "bottomCenter"
	})
end

function drawTxt(x,y ,width,height,scale, text, r,g,b,a)
    SetTextFont(4)
    SetTextProportional(0)
    SetTextScale(scale, scale)
    SetTextColour(r, g, b, a)
    SetTextDropShadow(0, 0, 0, 0,255)
    SetTextEdge(2, 0, 0, 0, 255)
    SetTextDropShadow()
    SetTextOutline()
    SetTextEntry("STRING")
    AddTextComponentString(text)
    DrawText(x - width/2, y - height/2 + 0.005)
end

----------------------------- KMH SPEEDOMETER / HASTIGHETSMATARE -----------------------------------------------------------

function drawTxt(x,y ,width,height,scale, text, r,g,b,a)
    SetTextFont(4)
    SetTextProportional(0)
    SetTextScale(0.5, 0.5)
    SetTextColour(r, g, b, a)
    SetTextDropShadow(0, 0, 0, 0,255)
    SetTextEdge(2, 0, 0, 0, 255)
    SetTextDropShadow()
    SetTextOutline()
    SetTextEntry("STRING")
    AddTextComponentString(text)
    DrawText(x - width/2, y - height/2 + 0.005)
end

function drawRct(x,y,width,height,r,g,b,a)
	DrawRect(x + width/2, y + height/2, width, height, r, g, b, a)
end

Citizen.CreateThread(function()
	while true do
	
		Citizen.Wait(1)
		local get_ped = GetPlayerPed(-1) -- current ped
		local get_ped_veh = GetVehiclePedIsIn(GetPlayerPed(-1),false) -- Current Vehicle ped is in


		if(IsPedInAnyVehicle(GetPlayerPed(-1), false))then
			local kmh = GetEntitySpeed(GetVehiclePedIsIn(GetPlayerPed(-1), false)) * 3.6			
			drawTxt(0.665, 1.397, 1.0,1.0,0.64 , "~y~KM/H: ~w~" .. math.ceil(kmh), 255, 131, 0, 255)  -- INT: kmh
		end		
	end
end)

Citizen.CreateThread(function()
    while true do
	Citizen.Wait(0)
	
		local playerPed = GetPlayerPed(-1)
		local playerVeh = GetVehiclePedIsIn(playerPed, false)

		if DoesEntityExist(playerVeh) then
			DisplayRadar(true)
		else
			DisplayRadar(false)
		end
    end
end)











