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

ESX                           = nil

local PlayerData              = {}

local HasAlreadyEnteredMarker   = false

local CurrentAction             = nil
local CurrentActionMsg          = ''
local CurrentActionData         = {}
local LastZone                = nil

---------------------------------------------------------------------------------------------

Citizen.CreateThread(function()
	while ESX == nil do
		TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)
		Citizen.Wait(0)
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

-----------------------------------------------------------------------------------------------

function OpenMenu()

  ESX.UI.Menu.CloseAll()

  ESX.UI.Menu.Open(
    'default', GetCurrentResourceName(), 'actionmenu',
    {
      title    = 'Polisdator',
      align    = 'top-left',
      elements = {
        {label = 'Övervakningskamera',		value = 'kamera'}
      },
    },
    function(data, menu)
	local player, distance = ESX.Game.GetClosestPlayer()
	
		if data.current.value == 'kamera' then
      if PlayerData.job ~= nil and PlayerData.job.name == 'police' then
        OpenKamera()
      else
        SendNotification("Ogiltigt inloggning", "error", 2500)
      end
		end

		if data.current.value == 'riksbank' then
			OpenRiksbank()
		end

    end,
    function(data, menu)
    	menu.close()
      CurrentAction     = 'cams'
      CurrentActionMsg  = 'Tryck ~INPUT_CONTEXT~ för att öppna datorn'
      CurrentActionData = {zone = zone}
    end
  )

end

function OpenKamera()

  ESX.UI.Menu.CloseAll()

  ESX.UI.Menu.Open(
    'default', GetCurrentResourceName(), 'actionmenu',
    {
      title    = 'Övervakningskamera',
      align    = 'top-left',
      elements = {
        {label = 'Fängelset',   value = 'prison'},
        {label = 'Riksbanken',    value = 'riksbank'},
        {label = 'Polisstationen',    value = 'station'}
      },
    },
    function(data, menu)
  local player, distance = ESX.Game.GetClosestPlayer()
  
    if data.current.value == 'prison' then
      OpenPrison()
    end

    if data.current.value == 'riksbank' then
      OpenRiksbank()
    end

    if data.current.value == 'station' then
      OpenStation()
    end

    end,
    function(data, menu)
    local pP = GetPlayerPed(-1)
    local cam = CreateCam('DEFAULT_SCRIPTED_CAMERA', true)
    local Hx = 437.125
    local Hy = -996.431
    local Hz = 29.789
    local Hh = 6.408

      -- Göm
      menu.close()
      DoScreenFadeOut(2000)
      Citizen.Wait(3000)

      -- Funktioner
      SetEntityCollision(pP,  true,  true)
      SetEntityVisible(pP,  true)
      SetEntityCoords(pP, Hx, Hy, Hz)
      FreezeEntityPosition(pP, false)
      SetEntityHeading(pP, Hh)

      -- Cam  
      SetCamActive(cam,  false)
      RenderScriptCams(false,  false,  0,  true,  true)

      --Visa
      Citizen.Wait(2000)
      DoScreenFadeIn(2000)
      OpenMenu()
    end
  )

end

function OpenPrison()

  ESX.UI.Menu.CloseAll()

  ESX.UI.Menu.Open(
    'default', GetCurrentResourceName(), 'prison',
    {
      title    = 'Fängelset',
      align    = 'top-left',
      elements = {
        {label = 'Fängelset (Cellarna)',	value = 'prison_cell'},
      },
    },
    function(data, menu)
	local player, distance = ESX.Game.GetClosestPlayer()
	local pP = GetPlayerPed(-1)
	
		if data.current.value == 'prison_cell' then
      OpenCells()
		end

    if data.current.value == 'prison_visit' then
      OpenVisit()
    end

    end,
    function(data, menu)
      OpenKamera()
    end
  )

end

function OpenCells()

  ESX.UI.Menu.CloseAll()

  ESX.UI.Menu.Open(
    'default', GetCurrentResourceName(), 'prison',
    {
      title    = 'Fängelset (Cellarna)',
      align    = 'top-left',
      elements = {
        {label = 'Kamera 1',  value = '1'},
        {label = 'Kamera 2', value = '2'}
      },
    },
    function(data, menu)
  local player, distance = ESX.Game.GetClosestPlayer()
  local pP = GetPlayerPed(-1)
  
    if data.current.value == '1' then

      -- Göm
      menu.close()
      DoScreenFadeOut(1000)
      Citizen.Wait(1000)

      --Funktioner
      kamera(1787.149, 2486.339, -116.976, 1801.133, 2479.641, -123.529)

      --Visa
      Citizen.Wait(1000)
      DoScreenFadeIn(1000)
      OpenCells()

    end

    if data.current.value == '2' then

      -- Göm
      menu.close()
      DoScreenFadeOut(1000)
      Citizen.Wait(1000)

      --Funktioner
      kamera(1799.793, 2480.697, -116.976, 1787.149, 2486.339, -123.529)

      --Visa
      Citizen.Wait(1000)
      DoScreenFadeIn(1000)
      OpenCells()

    end

    end,
    function(data, menu)
      OpenPrison()
    end
  )

end

function OpenVisit()

  ESX.UI.Menu.CloseAll()

  ESX.UI.Menu.Open(
    'default', GetCurrentResourceName(), 'prison',
    {
      title    = 'Fängelset (Besöksrum)',
      align    = 'top-left',
      elements = {
        {label = 'Kamera 1',  value = '1'},
        {label = 'Kamera 2', value = '2'},
        {label = 'Kamera 3', value = '3'}
      },
    },
    function(data, menu)
  local player, distance = ESX.Game.GetClosestPlayer()
  local pP = GetPlayerPed(-1)
  
    if data.current.value == '1' then

      -- Göm
      menu.close()
      DoScreenFadeOut(1000)
      Citizen.Wait(1000)

      --Funktioner
      kamera(1706.407, 2582.017, -68.162, 1699.525, 2580.644, -69.396)

      --Visa
      Citizen.Wait(1000)
      DoScreenFadeIn(1000)
      OpenVisit()

    end

    if data.current.value == '2' then

      -- Göm
      menu.close()
      DoScreenFadeOut(1000)
      Citizen.Wait(1000)

      --Funktioner
      kamera(1694.971, 2582.035, -68.162, 1705.863, 2578.046, -69.396)

      --Visa
      Citizen.Wait(1000)
      DoScreenFadeIn(1000)
      OpenVisit()

    end

    if data.current.value == '3' then

      -- Göm
      menu.close()
      DoScreenFadeOut(1000)
      Citizen.Wait(1000)

      --Funktioner
      kamera(1702.441, 2568.790, -68.162, 1707.616, 2576.321, -69.396)

      --Visa
      Citizen.Wait(1000)
      DoScreenFadeIn(1000)
      OpenVisit()

    end

    end,
    function(data, menu)
      OpenPrison()
    end
  )

end

function OpenRiksbank()

  ESX.UI.Menu.CloseAll()

  ESX.UI.Menu.Open(
    'default', GetCurrentResourceName(), 'riksbank',
    {
      title    = 'Fängelset',
      align    = 'top-left',
      elements = {
        {label = 'Riksbanken (Utomhus)',	value = 'riksbank_outside'},
        {label = 'Riksbanken (Lobby)',		value = 'riksbank_lobby'},
        {label = 'Riksbanken (Balkogen)', value = 'riksbank_balkong'},
        {label = 'Riksbanken (Valvet)',		value = 'riksbank_valvet'}
      },
    },
    function(data, menu)
	local player, distance = ESX.Game.GetClosestPlayer()
	
		if data.current.value == 'riksbank_outside' then

      -- Göm
      menu.close()
      DoScreenFadeOut(1000)
      Citizen.Wait(1000)

      --Funktioner
      kamera(180.055, 175.593, 126.813, 231.806, 209.642, 113.942)

      --Visa
      Citizen.Wait(1000)
      DoScreenFadeIn(1000)
      OpenRiksbank()

		end

    if data.current.value == 'riksbank_lobby' then

      -- Göm
      menu.close()
      DoScreenFadeOut(1000)
      Citizen.Wait(1000)

      --Funktioner
      kamera(239.865, 225.777, 108.862, 255.774, 210.122, 106.286)

      --Visa
      Citizen.Wait(1000)
      DoScreenFadeIn(1000)
      OpenRiksbank()

    end

    if data.current.value == 'riksbank_balkong' then

      -- Göm
      menu.close()
      DoScreenFadeOut(1000)
      Citizen.Wait(1000)

      --Funktioner
      kamera(255.290, 205.703, 112.557, 240.034, 214.666, 110.282)

      --Visa
      Citizen.Wait(1000)
      DoScreenFadeIn(1000)
      OpenRiksbank()

    end

    if data.current.value == 'riksbank_valvet' then

      -- Göm
      menu.close()
      DoScreenFadeOut(1000)
      Citizen.Wait(1000)

      --Funktioner
      kamera(260.190, 226.024, 104.260, 252.643, 225.429, 101.875)

      --Visa
      Citizen.Wait(1000)
      DoScreenFadeIn(1000)
      OpenRiksbank()

    end

    end,
    function(data, menu)
      OpenKamera()
    end
  )

end

function OpenStation()

  ESX.UI.Menu.CloseAll()

  ESX.UI.Menu.Open(
    'default', GetCurrentResourceName(), 'station',
    {
      title    = 'Polisstationen',
      align    = 'top-left',
      elements = {
        {label = 'Fängelset (Utomhus)',  value = 'station_outside'},
        {label = 'Fängelset (Inne)', value = 'station_inside'}
      },
    },
    function(data, menu)
  local player, distance = ESX.Game.GetClosestPlayer()
  local pP = GetPlayerPed(-1)
  
    if data.current.value == 'station_outside' then
      OpenOut()
    end

    if data.current.value == 'station_inside' then
      OpenVisit()
    end

    end,
    function(data, menu)
      OpenKamera()
    end
  )

end

function OpenOut()

  ESX.UI.Menu.CloseAll()

  ESX.UI.Menu.Open(
    'default', GetCurrentResourceName(), 'station_outside',
    {
      title    = 'Polisstationen (Utomhus)',
      align    = 'top-left',
      elements = {
        {label = 'Kamera 1',  value = '1'},
        {label = 'Kamera 2', value = '2'}
      },
    },
    function(data, menu)
  local player, distance = ESX.Game.GetClosestPlayer()
  local pP = GetPlayerPed(-1)
  
    if data.current.value == '1' then

      -- Göm
      menu.close()
      DoScreenFadeOut(1000)
      Citizen.Wait(1000)

      --Funktioner
      kamera(433.556, -987.885, 33.346, 421.926, -969.268, 32.388)

      --Visa
      Citizen.Wait(1000)
      DoScreenFadeIn(1000)
      OpenOut()

    end

    if data.current.value == '2' then

      -- Göm
      menu.close()
      DoScreenFadeOut(1000)
      Citizen.Wait(1000)

      --Funktioner
      kamera(443.993, -1006.191, 30.569, 458.129, -1021.822, 28.299)

      --Visa
      Citizen.Wait(1000)
      DoScreenFadeIn(1000)
      OpenOut()

    end

    end,
    function(data, menu)
      OpenStation()
    end
  )

end

-- Marker


local LastZone                = nil
AddEventHandler('esx_albin_kamera:hasEnteredMarker', function(zone)

  CurrentAction     = 'cams'
  CurrentActionMsg  = "Tryck ~INPUT_CONTEXT~ för att öppna övervakningskamerorna"
  CurrentActionData = {zone = zone}

end)

AddEventHandler('esx_albin_kamera:hasExitedMarker', function(zone)

  CurrentAction = nil
  ESX.UI.Menu.CloseAll()

end)

-- Display markers
Citizen.CreateThread(function()
  while true do
    Wait(0)
    local coords = GetEntityCoords(GetPlayerPed(-1))
    for k,v in pairs(Config.Zones) do
      for i = 1, #v.Pos, 1 do
        if(Config.Type ~= -1 and GetDistanceBetweenCoords(coords, v.Pos[i].x, v.Pos[i].y, v.Pos[i].z, true) < Config.DrawDistance) then
          DrawMarker(Config.Type, v.Pos[i].x, v.Pos[i].y, v.Pos[i].z, 0.0, 0.0, 0.0, 0, 0.0, 0.0, Config.Size.x, Config.Size.y, Config.Size.z, Config.Color.r, Config.Color.g, Config.Color.b, 100, false, true, 2, false, false, false, false)
        end
      end
    end
  end
end)

-- Enter / Exit marker events
Citizen.CreateThread(function()
  while true do
    Wait(0)
    local coords      = GetEntityCoords(GetPlayerPed(-1))
    local isInMarker  = false
    local currentZone = nil

    for k,v in pairs(Config.Zones) do
      for i = 1, #v.Pos, 1 do
        if(GetDistanceBetweenCoords(coords, v.Pos[i].x, v.Pos[i].y, v.Pos[i].z, true) < Config.Size.x) then
          isInMarker  = true
          currentZone = k
          LastZone    = k

          if IsControlJustPressed(1, 38) then
            OpenMenu()
          end

        end
      end
    end
    if isInMarker and not HasAlreadyEnteredMarker then
      HasAlreadyEnteredMarker = true
      TriggerEvent('esx_albin_kamera:hasEnteredMarker', currentZone)
    end
    if not isInMarker and HasAlreadyEnteredMarker then
      HasAlreadyEnteredMarker = false
      TriggerEvent('esx_albin_kamera:hasExitedMarker', LastZone)
    end
  end
end)

-- Key Controls
Citizen.CreateThread(function()
  while true do
    Citizen.Wait(0)
    if CurrentAction ~= nil then

      if IsControlJustReleased(0, 38) then

        if CurrentAction == 'cams' then
          OpenMenu()
        end

        CurrentAction = nil

      end

    end
  end
end)


--Misc

function DisplayHelpText(str)
	SetTextComponentFormat("STRING")
	AddTextComponentString(str)
	DisplayHelpTextFromStringLabel(0, 0, 1, -1)
end

function getJob()
  if PlayerData.job ~= nil then
  return PlayerData.job.name  
  end  
end

function SendNotification(message, messageType, messageTimeout)
	TriggerEvent("pNotify:SendNotification", {
		text = message,
		type = messageType,
		queue = "Albin",
		timeout = messageTimeout,
		layout = "bottomCenter"
		})
end

-- SendNotification("meddelande", "typ", tid)
-- SendNotification("meddelande", "error", tid)
-- SendNotification("", "success", tid)

function kamera(x, y, z, px, py, pz)
  local pP = GetPlayerPed(-1)
  local cam = CreateCam('DEFAULT_SCRIPTED_CAMERA', true)
  SetEntityCoords(pP, x, y, z - 50)
  SetEntityCollision(pP,  false,  true)
  SetEntityVisible(pP,  false)
  FreezeEntityPosition(pP, true)
  -- Cam
  SetCamActive(cam,  true)
  RenderScriptCams(true,  false,  0,  true,  true)
  SetCamCoord(cam, x, y, z)
  PointCamAtCoord(cam, px, py, pz)
end

--- 3D Text

Citizen.CreateThread(function()
	while true do
		Citizen.Wait(1)
         if GetDistanceBetweenCoords(GetEntityCoords(GetPlayerPed(-1)), 436.9, -993.9, 30.9, true) <= 2.5 then
            Draw3DText(436.9, -993.9, 30.9, '[~g~E~w~] för hantera ~r~kamerorna~w~')
        end
    end
end)
