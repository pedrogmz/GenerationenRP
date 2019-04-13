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

local PlayerData = {}

-- Lock

local playerCars = {}
local PlayerData = {}

-- Belt

local speedBuffer  = {}
local velBuffer    = {}
local beltOn       = false
local wasInCar     = false

-- Motor

local MotorAv = false

----------------------------------------------------------------------

Citizen.CreateThread(function()
  while ESX == nil do
    TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)
    Citizen.Wait(0)
  end
end)

RegisterNetEvent('esx:setJob')
AddEventHandler('esx:setJob', function(job)
  PlayerData.job = job
end)

function drawTxt(x,y ,width,height,scale, text, r,g,b,a, outline)
	SetTextFont(0)
	SetTextProportional(0)
	SetTextScale(scale, scale)
	SetTextColour(r, g, b, a)
	SetTextDropShadow(0, 0, 0, 0,255)
	SetTextEdge(1, 0, 0, 0, 255)
	SetTextDropShadow()
	if(outline)then
		SetTextOutline()
	end
	SetTextEntry("STRING")
	AddTextComponentString(text)
	DrawText(x - width/2, y - height/2 + 0.005)
end

function SendNotification(message, messageType, messageTimeout)
	TriggerEvent("pNotify:SendNotification", {
		text = message,
		type = messageType,
		queue = "global",
		timeout = messageTimeout,
		layout = "bottomCenter"
		})
end

-- SendNotification("meddelande", "typ", tid)
-- SendNotification("meddelande", "error", tid)
-- SendNotification("", "success", tid)

-----------------------------------------------------------------------

function OpenMenu()

  ESX.UI.Menu.CloseAll()

  ESX.UI.Menu.Open(
    'default', GetCurrentResourceName(), 'actionmenu',
    {
      title    = 'FORDONS MENY',
      align    = 'top-left',
      elements = {
        {label = 'Ta På / Av bältet',    value = 'beltOn'},
        {label = 'Lås / Lås Upp',		value = 'las'},
        {label = 'Motor På / Av',				value = 'motor'},
        {label = 'Dörrar',		value = 'dorrar'},
        {label = 'Farthållare',		value = 'hastighet'},
      },
    },
    function(data, menu)
	local player, distance = ESX.Game.GetClosestPlayer()
	local pP = GetPlayerPed(-1)
	local vehicle = GetVehiclePedIsIn(pP,false)

		if data.current.value == 'las' then
            OpenLas()
		end

		if data.current.value == 'motor' then
		local vehicle = GetVehiclePedIsIn(GetPlayerPed(-1), false)
			if IsPedInVehicle(pP, vehicle, false) then
				if IsDriver() then
					if not GetIsVehicleEngineRunning(vehicle) then 
						SendNotification("Startar motor", "error", 5000)
						Citizen.Wait(2500)
						SetVehicleEngineOn(vehicle, true, true, false)
						SendNotification("Motor på", "error", 2500)
					else 
						SendNotification("Stänger av motor", "error", 4000)
						Citizen.Wait(1500)
						SetVehicleEngineOn(vehicle, false, false, true)
						SendNotification("Motor av", "error", 2500)
					end
				else
					SendNotification("Du måste sitta i förarsätet", 'error', 2500)
				end
			else
				SendNotification("Du sitter inte i ett fordon", "error", 2500)
			end
		end

		if data.current.value == 'dorrar' then
			if IsPedInVehicle(pP, vehicle, false) then
				OpenDorrar()
			else
				SendNotification("Du sitter inte i ett fordon", "error", 2500)
			end
		end

    if data.current.value == 'beltOn' then
		 TriggerEvent('sexigaalbin:belt') 
		 SendNotification("Du satte på / tog av bältet.", "error", 2500)
		end  
		
		if data.current.value == 'hastighet' then
			if IsPedInVehicle(pP, vehicle, false) then
				OpenHastighet()
			else
				SendNotification("Du sitter inte i ett fordon", "error", 2500)
			end
		end

    end,
    function(data, menu)

      menu.close()

    end
  )

end

function OpenDorrar()

  ESX.UI.Menu.CloseAll()

  ESX.UI.Menu.Open(
    'default', GetCurrentResourceName(), 'dorrar',
    {
      title    = 'DÖRRAR',
      align    = 'top-left',
      elements = {
        {label = 'Vänster fram',	value = 'vf'},
        {label = 'Höger fram',		value = 'hf'},
        {label = 'Vänster bak',		value = 'vb'},
        {label = 'Höger bak',		value = 'hb'},
        {label = 'Baklucka',		value = 'bak'},
        {label = 'Huv',				value = 'huv'},
        {label = 'Alla',			value = 'alla'},
        {label = 'Tillbaka',		value = 'tbx'}

      },
    },
    function(data, menu)
	local player, distance = ESX.Game.GetClosestPlayer()
	local pP = GetPlayerPed(-1)
	local vehicle = GetVehiclePedIsIn(pP,false)
		
		if data.current.value == 'tbx' then
            OpenMenu()
		end

		if data.current.value == 'vf' then
		local isopen = GetVehicleDoorAngleRatio(vehicle,0)
			if (isopen == 0) then 
				SetVehicleDoorOpen(vehicle,0,0,0)
			else 
				SetVehicleDoorShut(vehicle,0,0) 
			end
		end

		if data.current.value == 'hf' then
		local isopen = GetVehicleDoorAngleRatio(vehicle,1)
			if (isopen == 0) then 
				SetVehicleDoorOpen(vehicle,1,0,0)
			else 
				SetVehicleDoorShut(vehicle,1,0) 
			end
		end

		if data.current.value == 'vb' then
		local isopen = GetVehicleDoorAngleRatio(vehicle,2)
			if (isopen == 0) then 
				SetVehicleDoorOpen(vehicle,2,0,0)
			else 
				SetVehicleDoorShut(vehicle,2,0) 
			end
		end

		if data.current.value == 'hb' then
		local isopen = GetVehicleDoorAngleRatio(vehicle,3)
			if (isopen == 0) then 
				SetVehicleDoorOpen(vehicle,3,0,0)
			else 
				SetVehicleDoorShut(vehicle,3,0) 
			end
		end

		if data.current.value == 'huv' then
		local isopen = GetVehicleDoorAngleRatio(vehicle,4)
			if (isopen == 0) then 
				SetVehicleDoorOpen(vehicle,4,0,0)
			else 
				SetVehicleDoorShut(vehicle,4,0) 
			end
		end

		if data.current.value == 'bak' then
		local isopen = GetVehicleDoorAngleRatio(vehicle,5)
			if (isopen == 0) then 
				SetVehicleDoorOpen(vehicle,5,0,0)
			else 
				SetVehicleDoorShut(vehicle,5,0) 
			end
		end

		if data.current.value == 'alla' then
		local isopen = GetVehicleDoorAngleRatio(vehicle,5) and GetVehicleDoorAngleRatio(vehicle,4) and GetVehicleDoorAngleRatio(vehicle,3) and GetVehicleDoorAngleRatio(vehicle,2) and GetVehicleDoorAngleRatio(vehicle,1) and GetVehicleDoorAngleRatio(vehicle,0)
			if (isopen == 0) then 
				SetVehicleDoorOpen(vehicle,0,0,0)
				SetVehicleDoorOpen(vehicle,1,0,0)
				SetVehicleDoorOpen(vehicle,2,0,0)
				SetVehicleDoorOpen(vehicle,3,0,0)
				SetVehicleDoorOpen(vehicle,4,0,0)
				SetVehicleDoorOpen(vehicle,5,0,0)
			else 
				SetVehicleDoorShut(vehicle,0,0)
				SetVehicleDoorShut(vehicle,1,0)
				SetVehicleDoorShut(vehicle,2,0)
				SetVehicleDoorShut(vehicle,3,0)
				SetVehicleDoorShut(vehicle,4,0)				
				SetVehicleDoorShut(vehicle,5,0) 
			end
		end

    end,
    function(data, menu)

      OpenMenu()

    end
  )

end

function OpenHastighet()

  ESX.UI.Menu.CloseAll()

  ESX.UI.Menu.Open(
    'default', GetCurrentResourceName(), 'hastighet',
    {
      title    = 'FARTHÅLLARE',
      align    = 'top-left',
      elements = {
        {label = 'Stäng av',			value = 'av'},
        {label = '15km/h',				value = '15'},
        {label = '30km/h',				value = '30'},
        {label = '50km/h',				value = '50'},
        {label = '70km/h',				value = '70'},
        {label = '90km/h',				value = '90'},
        {label = '110km/h',				value = '110'},
        {label = 'Tillbaka',			value = 'tbx'}
      },
    },
    function(data, menu)
	local player, distance = ESX.Game.GetClosestPlayer()
	local pP = GetPlayerPed(-1)
	local vehicle = GetVehiclePedIsIn(pP,false)
	local vehicleModel = GetEntityModel(vehicle)
    local max = GetVehicleMaxSpeed(vehicleModel)

		if data.current.value == 'av' then
            OpenMenu()
            SetEntityMaxSpeed(vehicle, 10000/3.65)
            SendNotification("Farthållare av", "error", 2500)
        elseif data.current.value == 'tbx' then
            OpenMenu()
		else
            SetEntityMaxSpeed(vehicle, data.current.value/3.65)
            SendNotification("Farthållare ".. data.current.value .."km/h", "success", 2500)
		end

    end,
    function(data, menu)

      OpenMenu()

    end
  )

end

function OpenLas()
	local playerPed = GetPlayerPed(-1)
	local coords    = GetEntityCoords(playerPed)

	local vehicle = nil

	if IsPedInAnyVehicle(playerPed,  false) then
		vehicle = GetVehiclePedIsIn(playerPed, false)
	else
		vehicle = GetClosestVehicle(coords.x, coords.y, coords.z, 7.0, 0, 70)
	end

	ESX.TriggerServerCallback('esx_albin_fordonmenu:requestPlayerCars', function(isOwnedVehicle)
		
		if isOwnedVehicle then
			local locked = GetVehicleDoorLockStatus(vehicle)
			if locked == 1 then -- if unlocked
				SetVehicleDoorsLocked(vehicle, 2)
				PlayVehicleDoorCloseSound(vehicle, 1)
				SendNotification("Du har låst ditt fordon", "error", 2500)
			elseif locked == 2 then -- if locked
				SetVehicleDoorsLocked(vehicle, 1)
				PlayVehicleDoorOpenSound(vehicle, 0)
				SendNotification("Du har låst upp ditt fordon", "success", 2500)
			end
		else
			SendNotification("Du saknar nycklar till detta fordon", "error", 2500)
		end
	end, GetVehicleNumberPlateText(vehicle))
end

-- ÄNDRA VILKEN KNAPP DET ÄR HÄRR
Citizen.CreateThread(function()
  while true do

    Citizen.Wait(0)

    if IsControlJustReleased(0,  Keys['M']) and not ESX.UI.Menu.IsOpen('default', GetCurrentResourceName(), 'actionmenu') then
		OpenMenu()
    end


  end
end)

function IsDriver ()
  return GetPedInVehicleSeat(GetVehiclePedIsIn(GetPlayerPed(-1), false), -1) == GetPlayerPed(-1)
end

-- Belt

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

RegisterNetEvent('esx_didrik_fordonmenu:openMenu')
AddEventHandler('esx_didrik_fordonmenu:openMenu', function()
    OpenMenu()
end)