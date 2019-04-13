CurrentWeather = 'EXTRASUNNY'
local lastWeather = CurrentWeather
Time = {}
Time.h = 12
Time.m = 0
local freezeTime = false
local blackout = false

RegisterNetEvent('vSync:updateWeather')
AddEventHandler('vSync:updateWeather', function(NewWeather, newblackout)
    CurrentWeather = NewWeather
    blackout = newblackout
end)

Citizen.CreateThread(function()
    while true do
        if lastWeather ~= CurrentWeather then
            lastWeather = CurrentWeather
            SetWeatherTypeOverTime(CurrentWeather, 15.0)
            Citizen.Wait(15000)
        end
        Citizen.Wait(100) -- Wait 0 seconds to prevent crashing.
        SetBlackout(blackout)
        ClearOverrideWeather()
        ClearWeatherTypePersist()
        SetWeatherTypePersist(lastWeather)
        SetWeatherTypeNow(lastWeather)
        SetWeatherTypeNowPersist(lastWeather)
        if lastWeather == 'XMAS' then
            SetForceVehicleTrails(true)
            SetForcePedFootstepsTracks(true)
        else
            SetForceVehicleTrails(false)
            SetForcePedFootstepsTracks(false)
        end
    end
end)

RegisterNetEvent('vSync:updateTime')
AddEventHandler('vSync:updateTime', function(hours, minutes, freeze)
    freezeTime = freeze
    Time.h = hours
    Time.m = minutes
end)

Citizen.CreateThread(function()
    while true do
        if not freezeTime then
            Citizen.Wait(2000)
            NetworkOverrideClockTime(Time.h, Time.m, 0)
            Time.m = Time.m + 1
            if Time.m > 59 then
                Time.m = 0
                Time.h = Time.h + 1
                if Time.h > 23 then
                    Time.h = 0
                end
            end
        else
            Citizen.Wait(0)
            NetworkOverrideClockTime(Time.h, Time.m, 0)
        end
    end
end)

AddEventHandler('playerSpawned', function()
    TriggerServerEvent('vSync:requestSync')
end)

-- Display a notification above the minimap.
function ShowNotification(text, blink)
    if blink == nil then blink = false end
    SetNotificationTextEntry("STRING")
    AddTextComponentSubstringPlayerName(text)
    DrawNotification(blink, false)
end

RegisterNetEvent('vSync:notify')
AddEventHandler('vSync:notify', function(message, blink)
    ShowNotification(message, blink)
end)
