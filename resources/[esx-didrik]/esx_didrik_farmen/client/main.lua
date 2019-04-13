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

local PlayerData                = {}
local GUI                       = {}
local HasAlreadyEnteredMarker   = false
local LastStation               = nil
local LastPart                  = nil
local LastPartNum               = nil
local CurrentAction             = nil
local CurrentActionMsg          = ''
local CurrentActionData         = {}
local playerId = PlayerId()
local serverId = GetPlayerServerId(localPlayerId)
local PlayerData	= {}
local apple = false
local AnimalsInSession = {}
local OnGoingHuntSession = false

local AnimalPositions = {
  { x = 2384.537, y = 5058.561, z = 46.444 },
  { x = 2376.740, y = 5058.970, z = 46.444 },
}
    
ESX                             = nil
GUI.Time                        = 0

Citizen.CreateThread(function()
  while ESX == nil do
    TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)
    Citizen.Wait(0)
  end
end)

RegisterNetEvent('gps')
AddEventHandler('gps', function(x, y)
    SetNewWaypoint(x, y)
end)

RegisterNetEvent('esx:playerLoaded')
AddEventHandler('esx:playerLoaded', function(xPlayer)
  PlayerData = xPlayer
end)

RegisterNetEvent('esx:setJob')
AddEventHandler('esx:setJob', function(job)
  PlayerData.job = job
end)

RegisterNetEvent('esx_didrik_farmen:truekappa')
AddEventHandler('esx_didrik_farmen:truekappa', function()
	apple = true
end)

RegisterNetEvent('esx_didrik_farmen:falsekappa')
AddEventHandler('esx_didrik_farmen:falsekappa', function()
	apple = false
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

function OpenCloakroomMenu()

  local elements = {
    { label = ('Personliga'), value = 'citizen_wear' },
    { label = ('Arbetskläder'), value = 'work_wear' }
  }

  ESX.UI.Menu.CloseAll()

  ESX.UI.Menu.Open(
    'default', GetCurrentResourceName(), 'cloakroom',
    {
      title    = _U('cloakroom'),
      align    = 'top-left',
      elements = elements,
    },
    function(data, menu)
      menu.close()

      if data.current.value == 'work_wear' then
        TriggerEvent('skinchanger:getSkin', function(skin)
        
            if skin.sex == 0 then

                local clothesSkin = {
                  ['tshirt_1'] = 59, ['tshirt_2'] = 1,
                  ['torso_1'] = 97, ['torso_2'] = 1,
                  ['arms'] = 0,
                  ['pants_1'] = 36, ['pants_2'] = 0,
                  ['shoes_1'] = 1, ['shoes_2'] = 0
                }
                TriggerEvent('skinchanger:loadClothes', skin, clothesSkin)

            else

                local clothesSkin = {
                    ['tshirt_1'] = 36, ['tshirt_2'] = 1,
                    ['torso_1'] = 88, ['torso_2'] = 1,
                    ['arms'] = 0,
                    ['pants_1'] = 35, ['pants_2'] = 0,
                    ['shoes_1'] = 25, ['shoes_2'] = 0
                }
                TriggerEvent('skinchanger:loadClothes', skin, clothesSkin)

            end

            local playerPed = GetPlayerPed(-1)
            SetPedArmour(playerPed, 0)
            ClearPedBloodDamage(playerPed)
            ResetPedVisibleDamage(playerPed)
            ClearPedLastWeaponDamage(playerPed)
            
        end)
      end

      if data.current.value == 'citizen_wear' then
        ESX.TriggerServerCallback('esx_skin:getPlayerSkin', function(skin, jobSkin)
          local model = nil

          if skin.sex == 0 then
            model = GetHashKey("mp_m_freemode_01")
          else
            model = GetHashKey("mp_f_freemode_01")
          end

          RequestModel(model)
          while not HasModelLoaded(model) do
            RequestModel(model)
            Citizen.Wait(1)
          end

          SetPlayerModel(PlayerId(), model)
          SetModelAsNoLongerNeeded(model)

          TriggerEvent('skinchanger:loadSkin', skin)
          TriggerEvent('esx:restoreLoadout')
          local playerPed = GetPlayerPed(-1)
          SetPedArmour(playerPed, 0)
          ClearPedBloodDamage(playerPed)
          ResetPedVisibleDamage(playerPed)
          ClearPedLastWeaponDamage(playerPed)
        end)
      end

      CurrentAction     = 'menu_cloakroom'
      CurrentActionMsg  = _U('open_cloackroom')
      CurrentActionData = {}

    end,
    function(data, menu)

      menu.close()

      CurrentAction     = 'menu_cloakroom'
      CurrentActionMsg  = _U('open_cloackroom')
      CurrentActionData = {}
    end
  )

end

function OpenAppleMenu()

  local elements = {
    { label = ('Plocka äpplen'), value = 'grab_apple' },
    { label = ('Vattna äppelträdet'), value = 'water_tree' }
  }

  ESX.UI.Menu.CloseAll()

  ESX.UI.Menu.Open(
    'default', GetCurrentResourceName(), 'apple',
    {
      title    = ('Äppelträd'),
      align    = 'top-left',
      elements = elements,
    },
    function(data, menu)
      menu.close()

      if data.current.value == 'grab_apple' then
        local pP = GetPlayerPed(-1)
        TaskPlayAnim(pP, "world_human_gardener_plant@enter", "enter", 3.5, -8, -1, 2, 0, 0, 0, 0, 0)
        TaskStartScenarioInPlace(pP, "world_human_gardener_plant", 0, true)	
        TimeLeft = Config.TimeToPlocka
        repeat                                	
        TriggerEvent("mt:missiontext", 'Du plockar ~g~äpplen~w~. Tid kvar: ~r~' .. TimeLeft .. ' ~w~sekunder', 1000)
        TimeLeft = TimeLeft - 1
        Citizen.Wait(1000)
        until(TimeLeft == 0)
        ClearPedTasksImmediately(pP)
        TriggerServerEvent('esx_didrik_farmen:giveApple')
      end

      if data.current.value == 'water_tree' then 
        if hasWater then
           local pP = GetPlayerPed(-1)
           TriggerServerEvent('esx_didrik_farmen:vattna')
           TriggerServerEvent('esx_didrik_farmen:removeWater')
           TaskPlayAnim(pP, "WORLD_HUMAN_BUM_WASH@enter", "enter", 3.5, -8, -1, 2, 0, 0, 0, 0, 0)
           TaskStartScenarioInPlace(pP, "WORLD_HUMAN_BUM_WASH", 0, true)	
           TimeLeft = Config.TimeToPlocka
           repeat                                	
           TriggerEvent("mt:missiontext", 'Du vattnar ~g~äppelträdet~w~. Tid kvar: ~r~' .. TimeLeft .. ' ~w~sekunder', 1000)
           TimeLeft = TimeLeft - 1
           Citizen.Wait(1000)
           until(TimeLeft == 0)
           ClearPedTasksImmediately(pP)
           sendNotification('Bra jobbat, Du vattnade trädet.', 'error', 2500)
        else
          sendNotification('Du har inte vatten i ditt inventory, Skaffa det.', 'error', 2500)
        end
      end

      CurrentAction     = 'menu_appleroom'
      CurrentActionMsg  = _U('open_appleroom')
      CurrentActionData = {}

    end,
    function(data, menu)

      menu.close()

      CurrentAction     = 'menu_appleroom'
      CurrentActionMsg  = _U('open_appleroom')
      CurrentActionData = {}
    end
  )

end

function OpenOmvandlaMenu()

  local elements = {
    { label = ('Tillaga Äppelmos'), value = 'create_apple_sauce' },
    { label = ('GPS-Destination till försäljningen'), value = 'gps' }
  }

  ESX.UI.Menu.CloseAll()

  ESX.UI.Menu.Open(
    'default', GetCurrentResourceName(), 'Omvandla',
    {
      title    = ('Tillverkaren'),
      align    = 'top-left',
      elements = elements,
    },
    function(data, menu)
      menu.close()

    if data.current.value == 'create_apple_sauce' then

      TriggerServerEvent('esx_didrik_farmen:test')
      sendNotification('Förbereder ingredienserna...', 'error', 2500)
      Citizen.Wait(2000)

      if apple == true then

        local pP = GetPlayerPed(-1)
        TaskPlayAnim(pP, "amb@prop_human_bum_bin@enter", "enter", 3.5, -8, -1, 2, 0, 0, 0, 0, 0)
        TaskStartScenarioInPlace(pP, "PROP_HUMAN_BUM_BIN", 0, true)	
        TimeLeft = Config.TimeToOmvandla
        repeat                                	
        TriggerEvent("mt:missiontext", 'Du tillverkar ~g~äpplemos~w~. Tid kvar: ~r~' .. TimeLeft .. ' ~w~sekunder', 1000)
        TimeLeft = TimeLeft - 1
        Citizen.Wait(1000)
        until(TimeLeft == 0)
        TriggerServerEvent('esx_didrik_farmen:Omvandlaapple')
        ClearPedTasksImmediately(pP)

      elseif apple == false then

        sendNotification('Du har inte tillräckligt med Äpplen, Du behöver minst 5 stycken.', 'error', 2500)

      end
    end

    if data.current.value == 'gps' then
      TriggerServerEvent('esx_didrik_farmen:gps')
      sendNotification('GPS-Destinationen är tillagd i din GPS, Lycka till.', 'error', 2500)
    end

      CurrentAction     = 'menu_Omvandlaroom'
      CurrentActionMsg  = _U('open_Omvandlaroom')
      CurrentActionData = {}

    end,
    function(data, menu)

      menu.close()

      CurrentAction     = 'menu_Omvandlaroom'
      CurrentActionMsg  = _U('open_Omvandlaroom')
      CurrentActionData = {}
    end
  )

end

AddEventHandler('esx_didrik_farmen:hasEnteredMarker', function(station, part, partNum)

  if part == 'Cloakroom' then
    CurrentAction     = 'menu_cloakroom'
    CurrentActionMsg  = _U('open_cloackroom')
    CurrentActionData = {}
  end

  if part == 'Appleroom' then
    CurrentAction     = 'menu_appleroom'
    CurrentActionMsg  = _U('open_appleroom')
    CurrentActionData = {}
  end

  if part == 'Omvandlaroom' then
    CurrentAction     = 'menu_omvandlaroom'
    CurrentActionMsg  = _U('open_omvandlaroom')
    CurrentActionData = {}
  end

  if part == 'BossActions' then
    CurrentAction     = 'menu_boss_actions'
    CurrentActionMsg  = _U('open_bossmenu')
    CurrentActionData = {}
  end

end)

AddEventHandler('esx_didrik_farmen:hasExitedMarker', function(station, part, partNum)
  ESX.UI.Menu.CloseAll()
  CurrentAction = nil
end)

-- Display markers
Citizen.CreateThread(function()
  while true do

    Wait(0)

    if PlayerData.job ~= nil and PlayerData.job.name == 'farmen' then

      local playerPed = GetPlayerPed(-1)
      local coords    = GetEntityCoords(playerPed)

      for k,v in pairs(Config.FarmenStations) do

        for i=1, #v.Cloakrooms, 1 do
          if GetDistanceBetweenCoords(coords,  v.Cloakrooms[i].x,  v.Cloakrooms[i].y,  v.Cloakrooms[i].z,  true) < Config.DrawDistance then
            DrawMarker(Config.MarkerType, v.Cloakrooms[i].x, v.Cloakrooms[i].y, v.Cloakrooms[i].z, 0.0, 0.0, 0.0, 0, 0.0, 0.0, Config.MarkerSize.x, Config.MarkerSize.y, Config.MarkerSize.z, Config.MarkerColor.r, Config.MarkerColor.g, Config.MarkerColor.b, 100, false, true, 2, false, false, false, false)
          end
        end

        for i=1, #v.Applerooms, 1 do
          if GetDistanceBetweenCoords(coords,  v.Applerooms[i].x,  v.Applerooms[i].y,  v.Applerooms[i].z,  true) < Config.DrawDistance then
            DrawMarker(Config.MarkerType, v.Applerooms[i].x, v.Applerooms[i].y, v.Applerooms[i].z, 0.0, 0.0, 0.0, 0, 0.0, 0.0, Config.MarkerSize.x, Config.MarkerSize.y, Config.MarkerSize.z, Config.MarkerColor.r, Config.MarkerColor.g, Config.MarkerColor.b, 100, false, true, 2, false, false, false, false)
          end
        end

        for i=1, #v.Omvandlarooms, 1 do
          if GetDistanceBetweenCoords(coords,  v.Omvandlarooms[i].x,  v.Omvandlarooms[i].y,  v.Omvandlarooms[i].z,  true) < Config.DrawDistance then
            DrawMarker(Config.MarkerType, v.Omvandlarooms[i].x, v.Omvandlarooms[i].y, v.Omvandlarooms[i].z, 0.0, 0.0, 0.0, 0, 0.0, 0.0, Config.MarkerSize.x, Config.MarkerSize.y, Config.MarkerSize.z, Config.MarkerColor.r, Config.MarkerColor.g, Config.MarkerColor.b, 100, false, true, 2, false, false, false, false)
          end
        end

        if Config.EnablePlayerManagement and PlayerData.job ~= nil and PlayerData.job.name == 'farmen' and PlayerData.job.grade_name == 'boss' then

          for i=1, #v.BossActions, 1 do
            if not v.BossActions[i].disabled and GetDistanceBetweenCoords(coords,  v.BossActions[i].x,  v.BossActions[i].y,  v.BossActions[i].z,  true) < Config.DrawDistance then
              DrawMarker(Config.MarkerType, v.BossActions[i].x, v.BossActions[i].y, v.BossActions[i].z, 0.0, 0.0, 0.0, 0, 0.0, 0.0, Config.MarkerSize.x, Config.MarkerSize.y, Config.MarkerSize.z, Config.MarkerColor.r, Config.MarkerColor.g, Config.MarkerColor.b, 100, false, true, 2, false, false, false, false)
            end
          end
        end
      end
    end
  end
end)

-- Enter / Exit marker events
Citizen.CreateThread(function()

  while true do

    Wait(0)

    if PlayerData.job ~= nil and PlayerData.job.name == 'farmen' then

      local playerPed      = GetPlayerPed(-1)
      local coords         = GetEntityCoords(playerPed)
      local isInMarker     = false
      local currentStation = nil
      local currentPart    = nil
      local currentPartNum = nil

      for k,v in pairs(Config.FarmenStations) do

        for i=1, #v.Cloakrooms, 1 do
          if GetDistanceBetweenCoords(coords,  v.Cloakrooms[i].x,  v.Cloakrooms[i].y,  v.Cloakrooms[i].z,  true) < Config.MarkerSize.x then
            isInMarker     = true
            currentStation = k
            currentPart    = 'Cloakroom'
            currentPartNum = i
          end
        end

        for i=1, #v.Applerooms, 1 do
          if GetDistanceBetweenCoords(coords,  v.Applerooms[i].x,  v.Applerooms[i].y,  v.Applerooms[i].z,  true) < Config.MarkerSize.x then
            isInMarker     = true
            currentStation = k
            currentPart    = 'Appleroom'
            currentPartNum = i
          end
        end

        for i=1, #v.Omvandlarooms, 1 do
          if GetDistanceBetweenCoords(coords,  v.Omvandlarooms[i].x,  v.Omvandlarooms[i].y,  v.Omvandlarooms[i].z,  true) < Config.MarkerSize.x then
            isInMarker     = true
            currentStation = k
            currentPart    = 'Omvandlaroom'
            currentPartNum = i
          end
        end

        if Config.EnablePlayerManagement and PlayerData.job ~= nil and PlayerData.job.name == 'farmen' and PlayerData.job.grade_name == 'boss' then

          for i=1, #v.BossActions, 1 do
            if GetDistanceBetweenCoords(coords,  v.BossActions[i].x,  v.BossActions[i].y,  v.BossActions[i].z,  true) < Config.MarkerSize.x then
              isInMarker     = true
              currentStation = k
              currentPart    = 'BossActions'
              currentPartNum = i
            end
          end
        end
      end

      local hasExited = false

      if isInMarker and not HasAlreadyEnteredMarker or (isInMarker and (LastStation ~= currentStation or LastPart ~= currentPart or LastPartNum ~= currentPartNum) ) then

        if
          (LastStation ~= nil and LastPart ~= nil and LastPartNum ~= nil) and
          (LastStation ~= currentStation or LastPart ~= currentPart or LastPartNum ~= currentPartNum)
        then
          TriggerEvent('esx_didrik_farmen:hasExitedMarker', LastStation, LastPart, LastPartNum)
          hasExited = true
        end

        HasAlreadyEnteredMarker = true
        LastStation             = currentStation
        LastPart                = currentPart
        LastPartNum             = currentPartNum

        TriggerEvent('esx_didrik_farmen:hasEnteredMarker', currentStation, currentPart, currentPartNum)
      end

      if not hasExited and not isInMarker and HasAlreadyEnteredMarker then

        HasAlreadyEnteredMarker = false

        TriggerEvent('esx_didrik_farmen:hasExitedMarker', LastStation, LastPart, LastPartNum)
      end
    end
  end
end)

-- Key Controls
Citizen.CreateThread(function()
  while true do

    Citizen.Wait(0)

    if CurrentAction ~= nil then

      if IsControlPressed(0,  Keys['E']) and PlayerData.job ~= nil and PlayerData.job.name == 'farmen' and (GetGameTimer() - GUI.Time) > 150 then

        if CurrentAction == 'menu_cloakroom' then
          OpenCloakroomMenu()
        end

        if CurrentAction == 'menu_appleroom' then
          OpenAppleMenu()
        end

        if CurrentAction == 'menu_omvandlaroom' then
          OpenOmvandlaMenu()
        end

        if CurrentAction == 'menu_boss_actions' then

          ESX.UI.Menu.CloseAll()

          TriggerEvent('esx_society:openBossMenu', 'farmen', function(data, menu)

            menu.close()

            CurrentAction     = 'menu_boss_actions'
            CurrentActionMsg  = _U('open_bossmenu')
            CurrentActionData = {}

          end)
        end
      end
    end
  end
end)

-- Vatten koderna.
RegisterNetEvent('esx:playerLoaded')
AddEventHandler('esx:playerLoaded', function(xPlayer)
	PlayerData = xPlayer

	TriggerEvent('esx_didrik_farmen:hasNotWater')

	for i=1, #PlayerData.inventory, 1 do
		if PlayerData.inventory[i].name == 'water' then
			if PlayerData.inventory[i].count > 0 then
				TriggerEvent('esx_didrik_farmen:hasWater')
			end
		end
	end
end)


RegisterNetEvent('esx_didrik_farmen:hasNotWater')
AddEventHandler('esx_didrik_farmen:hasNotWater', function()
	hasWater = false
end)

RegisterNetEvent('esx_didrik_farmen:hasWater')
AddEventHandler('esx_didrik_farmen:hasWater', function()
	hasWater = true
end)

------------------------ FÖRSÄLJNING ------------------------

Citizen.CreateThread(function()
  while true do Citizen.Wait(0)
      if (GetDistanceBetweenCoords(GetEntityCoords(GetPlayerPed(-1)), 1797.248, 4592.705, 36.782, true) <= 2.1 ) then
          if IsControlPressed(0, Keys['E']) then
              if not selling then
                  selling = true
                  TriggerServerEvent('esx_didrik_farmen:startSell')
                  Wait(2000)
                  selling = false
                  Wait(7000)
                  TriggerServerEvent('esx_didrik_farmen:stopSell')
              end
          end
      end
  end
end)

--- Försäljning

Citizen.CreateThread(function()
while true do
  Citizen.Wait(1)

    if PlayerData.job ~= nil and PlayerData.job.name == 'farmen' then
      if (GetDistanceBetweenCoords(GetEntityCoords(GetPlayerPed(-1)), 1797.248, 4592.705, 36.782, true) <= 1000 ) then
          DrawMarker(27, 1797.248, 4592.705, 36.782, 0, 0, 0, 0, 0, 0, 2.001, 2.0001, 0.5001, 246, 255, 0, 200, 0, 0, 0, 0)
      end
    end

    if PlayerData.job ~= nil and PlayerData.job.name == 'farmen' then
      if GetDistanceBetweenCoords(GetEntityCoords(GetPlayerPed(-1)), 1797.248, 4592.705, 37.682, true) <= 6.5 then
          Draw3DText(1797.248, 4592.705, 37.682, '[~g~E~w~] för att sälja ditt ~r~äppelmos~w~')

    end
      end
  end
end)

-- Omklädningsrum

Citizen.CreateThread(function()
  while true do
    Citizen.Wait(1)
  
      if PlayerData.job ~= nil and PlayerData.job.name == 'farmen' then
        if GetDistanceBetweenCoords(GetEntityCoords(GetPlayerPed(-1)), 2431.814, 4962.951, 46.810, true) <= 6.5 then
            Draw3DText(2431.814, 4962.951, 46.810, '[~g~E~w~] för att byta ~r~outfit~w~')
  
      end
        end
    end
  end)

-- Tillverkaren

Citizen.CreateThread(function()
  while true do
    Citizen.Wait(1)
  
      if PlayerData.job ~= nil and PlayerData.job.name == 'farmen' then
        if GetDistanceBetweenCoords(GetEntityCoords(GetPlayerPed(-1)), 2433.474, 4968.939, 42.347, true) <= 6.5 then
            Draw3DText(2433.474, 4968.939, 42.347, '[~g~E~w~] för att öppna ~r~tillverkaren~w~')
  
      end
        end
    end
  end)


--- Slakta djuren 
  
function LoadBasics()
	LoadModel('a_c_cow')
	LoadAnimDict('amb@medic@standing@kneel@base')
  LoadAnimDict('anim@gangops@facility@servers@bodysearch@')
end

Citizen.CreateThread(function()
while true do
  Citizen.Wait(1)

    if PlayerData.job ~= nil and PlayerData.job.name == 'farmen' then
      if (GetDistanceBetweenCoords(GetEntityCoords(GetPlayerPed(-1)), 2402.117, 5015.021, 45.196, true) <= 1000 ) then
          DrawMarker(27, 2402.117, 5015.021, 45.196, 0, 0, 0, 0, 0, 0, 2.001, 2.0001, 0.5001, 214, 217, 219, 200, 0, 0, 0, 0)
      end
    end

    if PlayerData.job ~= nil and PlayerData.job.name == 'farmen' then
      if GetDistanceBetweenCoords(GetEntityCoords(GetPlayerPed(-1)), 2402.117, 5015.021, 46.097, true) <= 6.5 then
          Draw3DText(2402.117, 5015.021, 46.097, '[~g~E~w~] för att påbörja / avsluta ~r~slaktning~w~')
    end
      end
  end
end)  
  
Citizen.CreateThread(function()
  while true do Citizen.Wait(0)
      if (GetDistanceBetweenCoords(GetEntityCoords(GetPlayerPed(-1)), 2402.117, 5015.021, 46.097, true) <= 2.1 ) then
          if IsControlPressed(0, Keys['E']) then
            Wait(1000)
            StartHuntingSession()
            LoadBasics()
            sendNotification('Du påbörjade / avslutade slaktningen, Gå fram till buren och slakta kossorna.', 'error', 4500)
            Wait(1000)
          end
      end
  end
end)

function StartHuntingSession()

  if OnGoingHuntSession then

    OnGoingHuntSession = false

    RemoveWeaponFromPed(PlayerPedId(), GetHashKey("WEAPON_MUSKET"), true, true)

  else
    OnGoingHuntSession = true
    GiveWeaponToPed(PlayerPedId(), GetHashKey("WEAPON_MUSKET"),45, true, false)

    --Animals
    Citizen.CreateThread(function()

      for index, value in pairs(AnimalPositions) do
        local Animal = CreatePed(5, GetHashKey('a_c_cow'), value.x, value.y, value.z, 0.0, true, false)
        TaskWanderStandard(Animal, true, true)
        SetEntityAsMissionEntity(Animal, true, true)

				table.insert(AnimalsInSession, {id = Animal, x = value.x, y = value.y, z = value.z})
      end
      
      while OnGoingHuntSession do
        local sleep = 500
        for index, value in ipairs(AnimalsInSession) do
          if DoesEntityExist(value.id) then
            local AnimalCoords = GetEntityCoords(value.id)
            local PlyCoords = GetEntityCoords(PlayerPedId())
            local AnimalHealth = GetEntityHealth(value.id)
            
            local PlyToAnimal = GetDistanceBetweenCoords(PlyCoords, AnimalCoords, true)

              if PlyToAnimal < 2.0 then
                sleep = 5

                ESX.Game.Utils.DrawText3D({x = AnimalCoords.x, y = AnimalCoords.y, z = AnimalCoords.z + 1}, '[E] Flå djur', 0.4)

                if IsControlJustReleased(0, Keys['E']) then
                    if DoesEntityExist(value.id) then
                      table.remove(AnimalsInSession, index)
                      SlaughterAnimal(value.id)
                    end
                end
              end
          end
        end

        Citizen.Wait(sleep)

      end
        
    end)
  end
end
  
function SlaughterAnimal(AnimalId)

  TaskPlayAnim(PlayerPedId(), "amb@medic@standing@kneel@base" ,"base" ,8.0, -8.0, -1, 1, 0, false, false, false )
  TaskPlayAnim(PlayerPedId(), "anim@gangops@facility@servers@bodysearch@" ,"player_search" ,8.0, -8.0, -1, 48, 0, false, false, false )

  Citizen.Wait(5000)

  ClearPedTasksImmediately(PlayerPedId())

  local AnimalWeight = math.random(10, 160) / 10

  sendNotification('Du flådde djuret, Bra jobbat.', 'error', 2500)

  TriggerServerEvent('esx_didrik_farmen:reward', AnimalWeight)

  DeleteEntity(AnimalId)
end
  
function LoadAnimDict(dict)
    while (not HasAnimDictLoaded(dict)) do
        RequestAnimDict(dict)
        Citizen.Wait(10)
    end    
end
  
function LoadModel(model)
    while not HasModelLoaded(model) do
          RequestModel(model)
          Citizen.Wait(10)
    end
end
  
function DrawM(hint, type, x, y, z)
  ESX.Game.Utils.DrawText3D({x = x, y = y, z = z + 1.0}, hint, 0.4)
  DrawMarker(type, x, y, z, 0.0, 0.0, 0.0, 0, 0.0, 0.0, 1.5, 1.5, 1.5, 255, 255, 255, 100, false, true, 2, false, false, false, false)
end

--- Blip
Citizen.CreateThread(function()
  local blip = AddBlipForCoord(2430.601, 4983.363, 45.841)

  SetBlipSprite (blip, 442)
  SetBlipDisplay(blip, 4)
  SetBlipScale  (blip, 0.8)
  SetBlipColour (blip, 66)
  SetBlipAsShortRange(blip, true)

  BeginTextCommandSetBlipName("STRING")
  AddTextComponentString('Farmen')
  EndTextCommandSetBlipName(blip)
end)