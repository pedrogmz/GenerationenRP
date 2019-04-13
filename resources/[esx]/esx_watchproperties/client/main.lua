local Keys = {
  ["ESC"] = 322, ["F1"] = 288, ["F2"] = 289, ["F3"] = 170, ["F5"] = 166, ["F6"] = 167, ["F7"] = 168, ["F8"] = 169, ["F9"] = 56, ["F10"] = 57,
  ["~"] = 243, ["1"] = 157, ["2"] = 158, ["3"] = 160, ["4"] = 164, ["5"] = 165, ["6"] = 159, ["7"] = 161, ["8"] = 162, ["9"] = 163, ["-"] = 84, ["="] = 83, ["BACKSPACE"] = 177,
  ["TAB"] = 37, ["Q"] = 44, ["W"] = 32, ["E"] = 38, ["R"] = 45, ["T"] = 245, ["Y"] = 246, ["U"] = 303, ["P"] = 199, ["["] = 39, ["]"] = 40, ["ENTER"] = 18,
  ["CAPS"] = 137, ["A"] = 34, ["S"] = 8, ["D"] = 9, ["F"] = 23, ["G"] = 47, ["H"] = 74, ["K"] = 311, ["L"] = 182,
  ["LEFTSHIFT"] = 21, ["Z"] = 20, ["X"] = 73, ["C"] = 26, ["V"] = 0, ["B"] = 29, ["N"] = 249, ["M"] = 244, [","] = 82, ["."] = 81,
  ["LEFTCTRL"] = 36, ["LEFTALT"] = 19, ["SPACE"] = 22, ["RIGHTCTRL"] = 70,
  ["HOME"] = 213, ["PAGEUP"] = 10, ["PAGEDOWN"] = 11, ["DELETE"] = 178,
  ["LEFT"] = 174, ["RIGHT"] = 175, ["TOP"] = 27, ["DOWN"] = 173,
}

--- action functions
local CurrentAction           = nil
local CurrentActionMsg        = ''
local CurrentActionData       = {}
local HasAlreadyEnteredMarker = false
local LastZone                = nil

--- esx
local PlayerData              = {}
ESX                           = nil

Citizen.CreateThread(function ()
  while ESX == nil do
    TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)
    Citizen.Wait(0)
  end
end)

----markers
AddEventHandler('esx_propertywatch:hasEnteredMarker', function (zone)

  if zone == 'PropertyShow' then
    CurrentAction     = 'property_menu'
    CurrentActionMsg  = _U('press_e')
    CurrentActionData = {}
  end

end)

AddEventHandler('esx_propertywatch:hasExitedMarker', function (zone)
  CurrentAction = nil
end)

function OpenPropertyMenu()

  local pP = GetPlayerPed(-1)

  ESX.UI.Menu.Open(
    'default', GetCurrentResourceName(), 'property_menu',
    {
      title    = 'Lägenhet',
      align    = 'top-right',
      elements = {
        {label = 'Whispymound Drive 120.000 SEK', value = 'WhispymoundDrive'},
        {label = 'Richard Majestic Apartment 350.000 SEK', value = 'RichardMajesticApt2'},
        {label = 'North Conker Avenue 160.000 SEK', value = 'NorthConkerAvenue2044'},
        {label = 'Apartment De Base 47.000 SEK', value = 'ApartmentDeBase'},
        {label = 'Hillcrest Avenue 160.000 SEK', value = 'HillcrestAvenue2868'},
        {label = 'Tinsel Towers Apartment 350.000 SEK', value = 'TinselTowersApt12'},
      }
    },
    function(data, menu)
      if data.current.value == 'WhispymoundDrive' then
        SetEntityCoords(pP, Config.WhispymoundDrive.x, Config.WhispymoundDrive.y, Config.WhispymoundDrive.z - 5)
        camera = CreateCam("DEFAULT_SCRIPTED_CAMERA", true)
        SetCamCoord(camera, Config.WhispymoundDrive.x, Config.WhispymoundDrive.y, Config.WhispymoundDrive.z + 1.5);
        SetCamRot(camera, -10.0, 0.0, -30.0)
        SetCamAffectsAiming(camera, true)
        SetCamActive(camera, true)
        RenderScriptCams(true, false, 0, 1, 0)
      elseif data.current.value == 'RichardMajesticApt2' then
        SetEntityCoords(pP, Config.RichardMajesticApt2.x, Config.RichardMajesticApt2.y, Config.RichardMajesticApt2.z -1)
        camera = CreateCam("DEFAULT_SCRIPTED_CAMERA", true)
        SetCamCoord(camera, Config.RichardMajesticApt2.x, Config.RichardMajesticApt2.y, Config.RichardMajesticApt2.z + 1);
        SetCamRot(camera, -10.0, 0.0, 76.0)
        SetCamAffectsAiming(camera, true)
        SetCamActive(camera, true)
        RenderScriptCams(true, false, 0, 1, 0)
      elseif data.current.value == 'NorthConkerAvenue2044' then
        SetEntityCoords(pP, Config.NorthConkerAvenue2044.x, Config.NorthConkerAvenue2044.y, Config.NorthConkerAvenue2044.z -1)
        camera = CreateCam("DEFAULT_SCRIPTED_CAMERA", true)
        SetCamCoord(camera, Config.NorthConkerAvenue2044.x, Config.NorthConkerAvenue2044.y, Config.NorthConkerAvenue2044.z + 1);
        SetCamRot(camera, -10.0, 0.0, 171.0)
        SetCamAffectsAiming(camera, true)
        SetCamActive(camera, true)
        RenderScriptCams(true, false, 0, 1, 0)
      elseif data.current.value == 'ApartmentDeBase' then
        SetEntityCoords(pP, Config.ApartmentDeBase.x, Config.ApartmentDeBase.y, Config.ApartmentDeBase.z -1)
        camera = CreateCam("DEFAULT_SCRIPTED_CAMERA", true)
        SetCamCoord(camera, Config.ApartmentDeBase.x, Config.ApartmentDeBase.y, Config.ApartmentDeBase.z + 1);
        SetCamRot(camera, -10.0, 0.0, 231.0)
        SetCamAffectsAiming(camera, true)
        SetCamActive(camera, true)
        RenderScriptCams(true, false, 0, 1, 0)
      elseif data.current.value == 'ApartmentDeBase' then
        SetEntityCoords(pP, Config.ApartmentDeBase.x, Config.ApartmentDeBase.y, Config.ApartmentDeBase.z -1)
        camera = CreateCam("DEFAULT_SCRIPTED_CAMERA", true)
        SetCamCoord(camera, Config.ApartmentDeBase.x, Config.ApartmentDeBase.y, Config.ApartmentDeBase.z + 1);
        SetCamRot(camera, -10.0, 0.0, 231.0)
        SetCamAffectsAiming(camera, true)
        SetCamActive(camera, true)
        RenderScriptCams(true, false, 0, 1, 0)
      elseif data.current.value == 'HillcrestAvenue2868' then
        SetEntityCoords(pP, Config.HillcrestAvenue2868.x, Config.HillcrestAvenue2868.y, Config.HillcrestAvenue2868.z -1)
        camera = CreateCam("DEFAULT_SCRIPTED_CAMERA", true)
        SetCamCoord(camera, Config.HillcrestAvenue2868.x, Config.HillcrestAvenue2868.y, Config.HillcrestAvenue2868.z + 1);
        SetCamRot(camera, -10.0, 0.0, 320.0)
        SetCamAffectsAiming(camera, true)
        SetCamActive(camera, true)
        RenderScriptCams(true, false, 0, 1, 0)
      elseif data.current.value == 'TinselTowersApt12' then
        SetEntityCoords(pP, Config.TinselTowersApt12.x, Config.TinselTowersApt12.y, Config.TinselTowersApt12.z -1)
        camera = CreateCam("DEFAULT_SCRIPTED_CAMERA", true)
        SetCamCoord(camera, Config.TinselTowersApt12.x, Config.TinselTowersApt12.y, Config.TinselTowersApt12.z + 1);
        SetCamRot(camera, -10.0, 0.0, -40.0)
        SetCamAffectsAiming(camera, true)
        SetCamActive(camera, true)
        RenderScriptCams(true, false, 0, 1, 0)
      end

    end,
    function(data, menu)
        menu.close()
        SetEntityCoords(pP, Config.Zones.PropertyShow.Pos.x, Config.Zones.PropertyShow.Pos.y, Config.Zones.PropertyShow.Pos.z)
        RenderScriptCams(false, false, 0, 1, 0)
        DestroyCam(cam, false)
    end
  )
end

--keycontrols
Citizen.CreateThread(function ()
  while true do
    Citizen.Wait(0)

    if CurrentAction ~= nil then
      SetTextComponentFormat('STRING')
      AddTextComponentString(CurrentActionMsg)
      DisplayHelpTextFromStringLabel(0, 0, 1, -1)
      
      if IsControlPressed(0, Keys['E']) then
        if CurrentAction == 'property_menu' then
          OpenPropertyMenu()
        end
      end
    end
  end
end)

-- Display markers
Citizen.CreateThread(function ()
  while true do
    Wait(0)

    local coords = GetEntityCoords(GetPlayerPed(-1))

    for k,v in pairs(Config.Zones) do
      if(v.Type ~= -1 and GetDistanceBetweenCoords(coords, v.Pos.x, v.Pos.y, v.Pos.z, true) < Config.DrawDistance) then
        DrawMarker(v.Type, v.Pos.x, v.Pos.y, v.Pos.z, 0.0, 0.0, 0.0, 0, 0.0, 0.0, v.Size.x, v.Size.y, v.Size.z, Config.MarkerColor.r, Config.MarkerColor.g, Config.MarkerColor.b, 100, false, true, 2, false, false, false, false)
      end
    end
  end
end)

-- Enter / Exit marker events
Citizen.CreateThread(function ()
  while true do
    Wait(0)

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
      TriggerEvent('esx_propertywatch:hasEnteredMarker', currentZone)
    end

    if not isInMarker and HasAlreadyEnteredMarker then
      HasAlreadyEnteredMarker = false
      TriggerEvent('esx_propertywatch:hasExitedMarker', LastZone)
    end
  end
end)