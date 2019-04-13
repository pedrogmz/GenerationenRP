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

ESX                     = nil
local CurrentAction     = nil
local CurrentActionMsg  = nil
local CurrentActionData = nil
local Licenses          = {}
local CurrentTest       = nil
local CurrentTestType   = nil
local CurrentVehicle    = nil
local CurrentCheckPoint = 0
local LastCheckPoint    = -1
local CurrentBlip       = nil
local CurrentZoneType   = nil
local DriveErrors       = 0
local IsAboveSpeedLimit = false
local LastVehicleHealth = nil

Citizen.CreateThread(function()
  while ESX == nil do
    TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)
    Citizen.Wait(0)
  end
end)

function DrawMissionText(msg, time)
  ClearPrints()
  SetTextEntry_2('STRING')
  AddTextComponentString(msg)
  DrawSubtitleTimed(time, 1)
end

function StartTheoryTest()

  CurrentTest = 'theory'

  SendNUIMessage({
    openQuestion = true
  })

  ESX.SetTimeout(200, function()
    SetNuiFocus(true, true)
  end)

  TriggerServerEvent('esx_dmvschool:pay', Config.Prices['dmv'])

end

function StopTheoryTest(success)

  CurrentTest = nil

  SendNUIMessage({
    openQuestion = false
  })

  SetNuiFocus(false)

  if success then
    TriggerServerEvent('esx_dmvschool:addLicense', 'dmv')
    ESX.ShowNotification(_U('passed_test'))
  else
    ESX.ShowNotification(_U('failed_test'))
  end

end

function StartDriveTest(type)


  ESX.Game.SpawnVehicle(Config.VehicleModels[type], Config.Zones.VehicleSpawnPoint.Pos, 317.0, function(vehicle)
          CurrentTest       = 'drive'
    CurrentTestType   = type
    CurrentCheckPoint = 0
    LastCheckPoint    = -1
    CurrentZoneType   = 'residence'
    DriveErrors       = 0
    IsAboveSpeedLimit = false
    CurrentVehicle    = vehicle
    LastVehicleHealth = GetEntityHealth(vehicle)
    wanted_model="mp_m_freemode_01"
    modelHash = GetHashKey(wanted_model)
    RequestModel(modelHash)

    while not HasModelLoaded(modelHash) do
    Wait(1)
    end
    --[[local daviim = CreatePed(5, modelHash , 236.46, -1393.28, 30.51, 153.85, false, false)

    SetPedComponentVariation(daviim, 3, 25, 0, 0)--Tshirt
    SetPedComponentVariation(daviim, 0, 4, 0, 2)--Ansikte
    SetPedComponentVariation(daviim, 2, 11, 4, 2)--Hår
    SetPedComponentVariation(daviim, 4, 52, 2, 0)--Byxor
    SetPedComponentVariation(daviim, 5, 38, 0, 0)--Arms
    SetPedComponentVariation(daviim, 11, 111, 5, 0)--Tröja
    SetPedComponentVariation(daviim, 6, 21, 0, 0)--Skor
    ]]


    local props = ESX.Game.GetVehicleProperties(vehicle)
    --SetPedIntoVehicle(daviim, vehicle, 1)

    props.plate = 'GRP'

    ESX.Game.SetVehicleProperties(vehicle, props)

    TriggerEvent("advancedFuel:setEssence", 100, GetVehicleNumberPlateText(vehicle), GetDisplayNameFromVehicleModel(GetEntityModel(vehicle)))
    local playerPed   = GetPlayerPed(-1)
      TaskWarpPedIntoVehicle(playerPed,  vehicle,  -1)
  end)

  TriggerServerEvent('esx_dmvschool:pay', Config.Prices[type])

end

--[[        ['skin'] = 5, 
        ['hair_1'] = 11, ['hair_2'] = 10,
        ['beard_1'] = 14, ['beard_2'] = 10,
        ['tshirt_1'] = 57, ['tshirt_2'] = 0,
        ['torso_1'] = 55, ['torso_2'] = 0,
        ['decals_1'] = 0, ['decals_2'] = 0,
        ['arms'] = 30,
        ['pants_1'] = 31, ['pants_2'] = 0,
        ['shoes_1'] = 25, ['shoes_2'] = 0,
        ['helmet_1'] = -1, ['helmet_2'] = 0,
        ['chain_1'] = 0, ['chain_2'] = 0,
        ['ears_1'] = 2, ['ears_2'] = 0
    }]]

--"hair_color_1":5,"bproof_2":1,,"mask_2":0,"lipstick_1":0,"arms":30,"pants_2":0,"hair_1":11,"ears_1":-1,"glasses_2":5,"lipstick_2":0,"shoes_2":0,"beard_3":5,"decals_2":2,"decals_1":8,"eyebrows_4":0,"sex":0,"makeup_1":0,"torso_2":0,"beard_1":14,"ears_2":0,"makeup_3":0,"helmet_2":0,"mask_1":121,"bags_1":0,"age_2":0,"beard_2":10,"hair_color_2":10,"shoes_1":25,"pants_1":31,"skin":5,"makeup_2":0,"age_1":0,"hair_2":5,"lipstick_3":0,"beard_4":0,"tshirt_1":58,"eyebrows_3":0,"eyebrows_2":10,"eyebrows_1":4,"face":4,"torso_1":55,"chain_2":0,"lipstick_4":0,"glasses_1":5,"tshirt_2":0,"bags_2":0}

function StopDriveTest(success)

  if success then
    TriggerServerEvent('modifyLicense', CurrentTestType, 'yes')
    ESX.ShowNotification(_U('passed_test'))
  else
    ESX.ShowNotification(_U('failed_test'))
  end

  CurrentTest     = nil
  CurrentTestType = nil

end

function SetCurrentZoneType(type)
  CurrentZoneType = type
end

local driveLicense = false
local bikeLicense = false
local truckLicense = false

function OpenDMVSchoolMenu()

  ESX.TriggerServerCallback('esx_didrik:getLicenses', function (xd)

  for i=1, #xd, 1 do
    if xd[i].drive == 'yes' then
      driveLicense = true
    end
    if xd[i].bike == 'yes' then
      bikeLicense = true
    end
    if xd[i].truck == 'yes' then
      truckLicense = true
    end
  end

  local elements = {}

    if not driveLicense then
      table.insert(elements, {label = _U('road_test_car') .. Config.Prices['drive'], value = 'drive_test', type = 'drive'})
    end

    if not bikeLicense then
      table.insert(elements, {label = _U('road_test_bike') .. Config.Prices['drive_bike'], value = 'drive_test', type = 'drive_bike'})
    end

    if not truckLicense then
      table.insert(elements, {label = _U('road_test_truck') .. Config.Prices['drive_truck'], value = 'drive_test', type = 'drive_truck'})
    end

  ESX.UI.Menu.CloseAll()

  ESX.UI.Menu.Open(
    'default', GetCurrentResourceName(), 'dmvschool_actions',
    {
      title    = _U('driving_school'),
      elements = elements
    },
    function(data, menu)

      if data.current.value == 'theory_test' then
        menu.close()
        StartTheoryTest()
      end

      if data.current.value == 'drive_test' then
        menu.close()
        StartDriveTest(data.current.type)
      end

    end,
    function(data, menu)

      menu.close()

      CurrentAction     = 'dmvschool_menu'
      CurrentActionMsg  = _U('press_open_menu')
      CurrentActionData = {}

    end
  )

end, GetPlayerServerId(PlayerId()))
end

RegisterNUICallback('question', function(data, cb)

  SendNUIMessage({
    openSection = 'question'
  })

  cb('OK')
end)

RegisterNUICallback('close', function(data, cb)
  StopTheoryTest(true)
  cb('OK')
end)

RegisterNUICallback('kick', function(data, cb)
  StopTheoryTest(false)
  cb('OK')
end)

AddEventHandler('esx_dmvschool:hasEnteredMarker', function(zone)

  if zone == 'DMVSchool' then

    CurrentAction     = 'dmvschool_menu'
    CurrentActionMsg  = _U('press_open_menu')
    CurrentActionData = {}

  end

end)

AddEventHandler('esx_dmvschool:hasExitedMarker', function(zone)
  CurrentAction = nil
  ESX.UI.Menu.CloseAll()
end)

RegisterNetEvent('esx_dmvschool:loadLicenses')
AddEventHandler('esx_dmvschool:loadLicenses', function(licenses)
  Licenses = licenses
end)

-- Create Blips
Citizen.CreateThread(function()

  local blip = AddBlipForCoord(Config.Zones.DMVSchool.Pos.x, Config.Zones.DMVSchool.Pos.y, Config.Zones.DMVSchool.Pos.z)

  SetBlipSprite (blip, 498)
  SetBlipDisplay(blip, 4)
  SetBlipScale  (blip, 1.0)
  SetBlipAsShortRange(blip, true)

  BeginTextCommandSetBlipName("STRING")
  AddTextComponentString(_U('driving_school_blip'))
  EndTextCommandSetBlipName(blip)

end)

-- Display markers
Citizen.CreateThread(function()
  while true do

    Citizen.Wait(0)

    local coords = GetEntityCoords(GetPlayerPed(-1))

    for k,v in pairs(Config.Zones) do
      if(v.Type ~= -1 and GetDistanceBetweenCoords(coords, v.Pos.x, v.Pos.y, v.Pos.z, true) < Config.DrawDistance) then
        DrawMarker(v.Type, v.Pos.x, v.Pos.y, v.Pos.z, 0.0, 0.0, 0.0, 0, 0.0, 0.0, v.Size.x, v.Size.y, v.Size.z, v.Color.r, v.Color.g, v.Color.b, 100, false, true, 2, false, false, false, false)
      end
    end

  end
end)

-- Enter / Exit marker events
Citizen.CreateThread(function()
  while true do

    Citizen.Wait(0)

    local coords      = GetEntityCoords(GetPlayerPed(-1))
    local isInMarker  = false
    local currentZone = nil

    for k,v in pairs(Config.Zones) do
      if(GetDistanceBetweenCoords(coords, v.Pos.x, v.Pos.y, v.Pos.z, true) < v.Size.x) then
        isInMarker  = true
        currentZone = k
      end
    end

    if (isInMarker and not HasAlreadyEnteredMarker) or (isInMarker and LastZone ~= currentZone) then
      HasAlreadyEnteredMarker = true
      LastZone                = currentZone
      TriggerEvent('esx_dmvschool:hasEnteredMarker', currentZone)
    end

    if not isInMarker and HasAlreadyEnteredMarker then
      HasAlreadyEnteredMarker = false
      TriggerEvent('esx_dmvschool:hasExitedMarker', LastZone)
    end

  end
end)

-- Block UI
Citizen.CreateThread(function()
  while true do

    Citizen.Wait(0)

    if CurrentTest == 'theory' then

      local playerPed = GetPlayerPed(-1)

      DisableControlAction(0, 1, true) -- LookLeftRight
      DisableControlAction(0, 2, true) -- LookUpDown
      DisablePlayerFiring(playerPed, true) -- Disable weapon firing
      DisableControlAction(0, 142, true) -- MeleeAttackAlternate
      DisableControlAction(0, 106, true) -- VehicleMouseControlOverride

    end

  end
end)

-- Key Controls
Citizen.CreateThread(function()
  while true do

    Citizen.Wait(0)

    if CurrentAction ~= nil then

      SetTextComponentFormat('STRING')
      AddTextComponentString(CurrentActionMsg)
      DisplayHelpTextFromStringLabel(0, 0, 1, -1)

      if IsControlJustReleased(0,  Keys['E']) then

        if CurrentAction == 'dmvschool_menu' then
          OpenDMVSchoolMenu()
        end

        CurrentAction = nil

      end

    end

  end
end)

-- Drive test
Citizen.CreateThread(function()
  while true do

    Citizen.Wait(0)

    if CurrentTest == 'drive' then

      local playerPed      = GetPlayerPed(-1)
      local coords         = GetEntityCoords(playerPed)
      local nextCheckPoint = CurrentCheckPoint + 1

      if Config.CheckPoints[nextCheckPoint] == nil then
                  if DoesBlipExist(CurrentBlip) then
          RemoveBlip(CurrentBlip)
        end

        CurrentTest = nil

        ESX.ShowNotification(_U('driving_test_complete'))

        if DriveErrors < Config.MaxErrors then
          StopDriveTest(true)
        else
          StopDriveTest(false)
        end
              else

        if CurrentCheckPoint ~= LastCheckPoint then

          if DoesBlipExist(CurrentBlip) then
            RemoveBlip(CurrentBlip)
          end

          CurrentBlip = AddBlipForCoord(Config.CheckPoints[nextCheckPoint].Pos.x, Config.CheckPoints[nextCheckPoint].Pos.y, Config.CheckPoints[nextCheckPoint].Pos.z)
          SetBlipRoute(CurrentBlip, 1)

          LastCheckPoint = CurrentCheckPoint

        end

        local distance = GetDistanceBetweenCoords(coords, Config.CheckPoints[nextCheckPoint].Pos.x, Config.CheckPoints[nextCheckPoint].Pos.y, Config.CheckPoints[nextCheckPoint].Pos.z, true)

        if distance <= 100.0 then
          DrawMarker(1, Config.CheckPoints[nextCheckPoint].Pos.x, Config.CheckPoints[nextCheckPoint].Pos.y, Config.CheckPoints[nextCheckPoint].Pos.z, 0.0, 0.0, 0.0, 0, 0.0, 0.0, 2.5, 2.5, 0.5, 0, 255, 0, 100, false, true, 2, false, false, false, false)
        end

        if distance <= 3.0 then
          Config.CheckPoints[nextCheckPoint].Action(playerPed, CurrentVehicle, SetCurrentZoneType)
          CurrentCheckPoint = CurrentCheckPoint + 1
        end

      end

    end

  end
end)

-- Speed / Damage control
Citizen.CreateThread(function()
  while true do

    Citizen.Wait(0)

    if CurrentTest == 'drive' then

      local playerPed = GetPlayerPed(-1)

      if IsPedInAnyVehicle(playerPed,  false) then

        local vehicle      = GetVehiclePedIsIn(playerPed,  false)
        local speed        = GetEntitySpeed(vehicle) * Config.SpeedMultiplier
        local tooMuchSpeed = false

        for k,v in pairs(Config.SpeedLimits) do
          if CurrentZoneType == k and speed > v then

            tooMuchSpeed = true

            if not IsAboveSpeedLimit then

              DriveErrors       = DriveErrors + 1
              IsAboveSpeedLimit = true

              ESX.ShowNotification(_U('driving_too_fast') .. v .. 'km/h')
              ESX.ShowNotification(_U('errors') .. DriveErrors .. '~s~/' .. Config.MaxErrors)

            end

          end
        end

        if not tooMuchSpeed then
          IsAboveSpeedLimit = false
        end

        local health = GetEntityHealth(vehicle)

        if health < LastVehicleHealth then

          DriveErrors = DriveErrors + 1

          ESX.ShowNotification(_U('you_damaged_veh'))
          ESX.ShowNotification(_U('errors') .. DriveErrors .. '~s~/' .. Config.MaxErrors)
                    LastVehicleHealth = health

        end

      end

    end

  end

end)
