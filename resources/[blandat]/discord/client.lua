ESX = nil

local appid = '537578653765074975' -- Namnet på det.
local asset = 'generationen' -- Stor bild
local liten = 'test' -- Mindre bild

Citizen.CreateThread(function()

    while ESX == nil do
        TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)
        Citizen.Wait(0)
    end

    while ESX.GetPlayerData().job == nil do
        Citizen.Wait(10)
    end

    ESX.PlayerData = ESX.GetPlayerData()
    ESX.TriggerServerCallback('getIdentity', function(identity)
        while true do
            Citizen.Wait(5000)
            SetRichPresence(CountPlayers() .. '/32 - ' .. identity.firstname .. ' ' .. identity.lastname)
            SetDiscordAppId(appid)
            SetDiscordRichPresenceAsset(asset)
            SetDiscordRichPresenceAssetSmall(liten)
            SetDiscordRichPresenceAssetSmallText(litentext)
            SetDiscordRichPresenceAssetText(stortext)
        end
    end)
end)

function CountPlayers()
    local count = 0

    for i = 0, 31 do
        if NetworkIsPlayerActive(i) then
            count = count + 1
        end
    end

    return count
end