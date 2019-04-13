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
local GUI                     = {}
GUI.Time                      = 0
local HasAlreadyEnteredMarker = false
local LastZone                = nil
local CurrentAction           = nil
local CurrentActionMsg        = ''
local CurrentActionData       = {}
local IsDead                  = false

Citizen.CreateThread(function()
    while ESX == nil do
        TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)
        Citizen.Wait(0)
    end
end)

-- Shop Menu
function OpenShopMenu()

    TriggerEvent('esx_skin:openRestrictedMenu', function(data, menu)

        menu.close()

        ESX.UI.Menu.Open(
            'default', GetCurrentResourceName(), 'shop_confirm',
            {
                title = _U('valid_purchase'),
                align = 'top-left',
                elements = {
                    {label = _U('yes'), value = 'yes'},
                    {label = _U('no'), value = 'no'},
                }
            },
            function(data, menu)
                menu.close()

                if data.current.value == 'yes' then

                    ESX.TriggerServerCallback('esx_jewelery:checkMoney', function(hasEnoughMoney)

                        if hasEnoughMoney then

                            TriggerServerEvent('esx_jewelery:pay')

                            TriggerEvent('skinchanger:getSkin', function(skin)
                                TriggerServerEvent('esx_jewelery:save', skin)
                            end)
                        else

                            TriggerEvent('esx_skin:getLastSkin', function(skin)
                                TriggerEvent('skinchanger:loadSkin', skin)
                            end)

                            ESX.ShowNotification(_U('not_enough_money'))
                        end
                    end)
                end

                if data.current.value == 'no' then

                    local player = GetPlayerPed(-1)

                    TriggerEvent('esx_skin:getLastSkin', function(skin)
                        TriggerEvent('skinchanger:loadSkin', skin)
                    end)

                    ClearPedProp(Player, 2)
                end

                CurrentAction     = 'shop_menu'
                CurrentActionMsg  = _U('press_access')
                CurrentActionData = {}
            end,
            function(data, menu)

                menu.close()

                CurrentAction     = 'shop_menu'
                CurrentActionMsg  = _U('press_access')
                CurrentActionData = {}
            end
        )
    end, function(data, menu)

            menu.close()

            CurrentAction     = 'shop_menu'
            CurrentActionMsg  = _U('press_access')
            CurrentActionData = {}
    end, {
        'watches_1',
        'watches_2',
        'bracelets_1',
        'bracelets_2',
    })
end

-- Player
AddEventHandler('playerSpawned', function()
    IsDead = false
end)

AddEventHandler('baseevents:onPlayerDied', function(killerType, coords)
    TriggerEvent('esx_ambulancejob:onPlayerDeath')
end)

AddEventHandler('baseevents:onPlayerKilled', function(killerId, data)
    TriggerEvent('esx_ambulancejob:onPlayerDeath')
end)

AddEventHandler('esx_ambulancejob:onPlayerDeath', function()
    IsDead = true
end)

-- Marker event
AddEventHandler('esx_jewelery:hasEnteredMarker', function(zone)

    CurrentAction     = 'shop_menu'
    CurrentActionMsg  = _U('press_access')
    CurrentActionData = { accessory = zone }
end)

AddEventHandler('esx_jewelery:hasExitedMarker', function(zone)
    ESX.UI.Menu.CloseAll()
    CurrentAction = nil
end)

-- Create Blips
Citizen.CreateThread(function()
    for k,v in pairs(Config.ShopsBlips) do
        if v.Pos ~= nil then
            for i=1, #v.Pos, 1 do
                local blip = AddBlipForCoord(v.Pos[i].x, v.Pos[i].y, v.Pos[i].z)

                SetBlipSprite (blip, v.Blip.sprite)
                SetBlipDisplay(blip, 4)
                SetBlipScale  (blip, 1.0)
                SetBlipColour (blip, v.Blip.color)
                SetBlipAsShortRange(blip, true)

                BeginTextCommandSetBlipName("STRING")
                AddTextComponentString(_U('jewelery_blip'))
                EndTextCommandSetBlipName(blip)
            end
        end
    end
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
                end
            end
        end

        if (isInMarker and not HasAlreadyEnteredMarker) or (isInMarker and LastZone ~= currentZone) then
            HasAlreadyEnteredMarker = true
            LastZone                = currentZone
            TriggerEvent('esx_jewelery:hasEnteredMarker', currentZone)
        end

        if not isInMarker and HasAlreadyEnteredMarker then
            HasAlreadyEnteredMarker = false
            TriggerEvent('esx_jewelery:hasExitedMarker', LastZone)
        end
    end
end)

-- Key controls
Citizen.CreateThread(function()
    while true do
        Citizen.Wait(0)

        if CurrentAction ~= nil then

            SetTextComponentFormat('STRING')
            AddTextComponentString(CurrentActionMsg)
            DisplayHelpTextFromStringLabel(0, 0, 1, -1)

            if IsControlPressed(0,  Keys['E']) and (GetGameTimer() - GUI.Time) > 300 then

                if CurrentAction == 'shop_menu' then
                    OpenShopMenu()
                end

                CurrentAction = nil
                GUI.Time      = GetGameTimer()
            end
        end
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

-------------------------------------------------------------------------------------------------

  Citizen.CreateThread(function() 
	while true do
		Citizen.Wait(1)
         if GetDistanceBetweenCoords(GetEntityCoords(GetPlayerPed(-1)), -622.4, -230.8, 38.0, true) <= 2.5 then
            Draw3DText(-622.4, -230.8, 38.0, '[~g~E~w~] för att bläddra bland ~r~klockorna~w~/ ~r~armbanden~w~')
        end
    end
end) 

-------------------------------------------------------------------------------

