-- 2018 Henric 'zeb' Johansson

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

ESX               				= nil
local PlayerData                = {}
local PoliceJob 				= 'police'

local isTackling				= false
local isGettingTackled			= false

local tackleLib					= "anim@heists@box_carry@"
local tackleAnim 				= 'idle'
local tackleVictimLib			= 'amb@world_human_bum_slumped@male@laying_on_right_side@base'
local tackleVictimAnim			= 'base'


local lastTackleTime			= 0
local isRagdoll					= false

Citizen.CreateThread(function()
	while ESX == nil do
		TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)
		Citizen.Wait(0)
	end

	PlayerData = ESX.GetPlayerData()
end)

RegisterNetEvent('esx:playerLoaded')
AddEventHandler('esx:playerLoaded', function(xPlayer)
	PlayerData = xPlayer
end)

RegisterNetEvent('esx:setJob')
AddEventHandler('esx:setJob', function(job)
	PlayerData.job = job
end)

RegisterNetEvent('esx_zeb_tackle:getTackled')
AddEventHandler('esx_zeb_tackle:getTackled', function(target)


	local playerPed = GetPlayerPed(-1)
	local targetPed = GetPlayerPed(GetPlayerFromServerId(target))

	RequestAnimDict(tackleVictimLib)

	while not HasAnimDictLoaded(tackleVictimLib) do
		Citizen.Wait(10)
	end

    if isGettingTackled then
     isGettingTackled = false

	DetachEntity(GetPlayerPed(-1), true, false)
	Citizen.Wait(80)
    ClearPedTasks(GetPlayerPed(-1))
    else

    	isGettingTackled = true	
    	Citizen.Wait(25)
    	AttachEntityToEntity(GetPlayerPed(-1), targetPed, GetPedBoneIndex(playerPed, 57005), -0.32, -0.6, -0.35, 240.0, 35.0, 149.0, true, true, false, true, 1, true)
	     Citizen.Wait(50)
	TaskPlayAnim(playerPed, tackleVictimLib, tackleVictimAnim, 8.0, 8.0, -1, 9, 0, false, false, false )
	

   end

end)

RegisterNetEvent('esx_zeb_tackle:playTackle')
AddEventHandler('esx_zeb_tackle:playTackle', function()


	local playerPed = GetPlayerPed(-1)

	RequestAnimDict(tackleLib)

	while not HasAnimDictLoaded(tackleLib) do
		Citizen.Wait(10)
	end

	if isTackling then
	isTackling = false
	Citizen.Wait(50)
	ClearPedTasks(GetPlayerPed(-1))


else
    
	TaskPlayAnim(playerPed, tackleLib, tackleAnim, 8.0, 8.0, -1, 50, 0, false, false, false )
	isTackling = true

   end

end)

