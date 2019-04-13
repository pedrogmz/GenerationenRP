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
local PlayerData              = {}

Citizen.CreateThread(function()
	while ESX == nil do
		TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)
		Citizen.Wait(1)
		PlayerData = ESX.GetPlayerData()
	end
end)

function hintToDisplay(text)
	SetTextComponentFormat("STRING")
	AddTextComponentString(text)
	DisplayHelpTextFromStringLabel(0, 0, 1, -1)
end

local CartPlaces = {
    { x = 43.9, y = -998.4, z = 29.2 },
    { x = 132.8, y = -1462.5, z = 29.1 },
    { x = 11.9, y = -1606.5, z = 29.1 },
    { x = 169.0, y = -1633.4, z = 29.1 },
    { x = -1721.6, y = -1102.4, z = 12.8 },
    { x = -1692.2, y = -1134.3, z = 12.8 },
    { x = -242.0, y = 278.8, z = 91.8 },
    { x = 81.1, y = 274.0, z = 110.0 },
    { x = 1233.4, y = -354.6, z = 68.5 },
    { x = 1983.1, y = 3708.7, z = 31.6 },
    { x = 910.9, y = 3644.3, z = 32.1 },
    { x = 650.5, y = 2728.4, z = 41.6 },
    { x = 1591.3, y = 6450.6, z = 25.0 },
    { x = -122.6, y = 6389.56, z = 31.9 },
	{ x = -2193.4, y = 4289.9, z = 48.8 },
	{ x = 1969.750, y = 3262.082, z = 45.3 },
	{ x = -2549.411, y = 2316.600, z = 33.1 },
	{ x = 162.143, y = 6636.662, z = 31.3 },
	{ x = -406.399, y = 6062.787, z = 31.3 },
	{ x = -582.140, y = -984.957, z = 25.7 },
	{ x = -860.952, y = -1140.420, z = 7.1 },
	{ x = 1084.888, y = -775.644, z = 58.1 },
	{ x = 273.498, y = -832.961, z = 29.211 },
	{ x = -843.804, y = -352.455, z = 38.480 },
	{ x = 2741.552, y = 4413.034, z = 48.623 },
	{ x = 152.495, y = 6504.854, z = 31.4 }, -- Paleto Bay
	{ x = -271.298, y = 6073.0, z = 31.3 }, -- Paleto Bay 2
	{ x = -1091.138, y = 2715.747, z = 19.076 }, -- 
	{ x = -441.134, y = 1595.292, z = 358.468 }, -- 
	{ x = 442.815, y = -1010.215, z = 4.3 }, -- Skjutbanan
	{ x = 312.544, y = -587.664, z = 43.1 }, -- Pillbox Sjukhus 1
	{ x = 321.219, y = -599.831, z = 43.1 }, -- Pillbox Sjukhus 2
	{ x = 436.197, y = -986.690, z = 30.5 }, -- Polisstation, Inomhus, Övervåning
	{ x = 449.857, y = -987.882, z = 26.3 }, -- Polisstation, Inomhus, Undervåning
	{ x = 226.569, y = -909.727, z = 30.4 }, -- Torg 1
	{ x = 233.631, y = -897.534, z = 30.4 }, -- Torg 2
	{ x = -208.049, y = -1342.076, z = 34.6 }, -- Mekonomen
	{ x = -464.082, y = -367.370, z = -186.9 }, -- Sjukhuset 1
}

Citizen.CreateThread(function()
    while true do
        Citizen.Wait(5)

        for index, value in pairs(CartPlaces) do

            local plyCoords = GetEntityCoords(GetPlayerPed(-1), false)
            local dist = Vdist(plyCoords.x, plyCoords.y, plyCoords.z, value.x, value.y, value.z)

            if dist < 7.5 then
                DrawMarker(21, value.x, value.y, value.z, 0, 0, 0, 0, 0, 0, 1.001, 1.0001, 0.5001, 255, 106, 0, 200, 0, 0, 0, 0)
                if dist <= 1.0 then
                    hintToDisplay('Tryck ~INPUT_CONTEXT~ för att handla ~g~mat ~w~/ ~g~dryck~w~.')
                    
                    if IsControlJustPressed(0, Keys['E']) then -- "E"
                        OpenCartMenu()
                    end			
                end
            end

        end
    end
end)

function OpenCartMenu()
    ESX.UI.Menu.CloseAll()

    ESX.UI.Menu.Open(
        'default', GetCurrentResourceName(), 'mat_meny',
        {
            title    = 'Matvagn ',
            elements = {
				{label = 'Hamburgare (SEK 25)', value = 'sausage_1', item = 'hamburgare', price = 25},
                {label = 'Ugnsstekt Potatis (SEK 20)', value = 'water_1', item = 'potatis', price = 20},
                {label = 'Oxfilé (SEK 45)', value = 'water_1', item = 'steak', price = 45},
                {label = 'Kycklingklubba (SEK 40)', value = 'water_1', item = 'klubba', price = 40},
                {label = 'Varmkorv (SEK 30)', value = 'water_1', item = 'korv', price = 30},
                {label = 'Sockermunk (SEK 10)', value = 'water_1', item = 'munk', price = 10},
                {label = 'Ramlösa (SEK 12)', value = 'water_1', item = 'water', price = 12}, 
                {label = 'Kaffe (SEK 15)', value = 'water_1', item = 'kaffe', price = 15}, 
                {label = 'Coca Cola (SEK 10)', value = 'water_1', item = 'cola', price = 10}, 
                {label = 'Päronläsk (SEK 10)', value = 'water_1', item = 'sprite', price = 10}, 
            }
        },
        function(data, menu)
            local item = data.current.item
            local price = data.current.price
            TriggerServerEvent('esx_didrik_matvagn:buy', item, price)
            TriggerServerEvent('esx:useItem', item)
        end,
    function(data, menu)
        menu.close()
    end)
end

------------------------------------ MAT / PROPS ----------------------------------------

RegisterNetEvent('esx_didrik_hamburgare:onEat')
AddEventHandler('esx_didrik_hamburgare:onEat', function(prop_name)
    if not IsAnimated then
		local prop_name = prop_name or 'prop_cs_burger_01'
    	IsAnimated = true
	    local playerPed = GetPlayerPed(-1)
	    Citizen.CreateThread(function()
	        local x,y,z = table.unpack(GetEntityCoords(playerPed))
	        prop = CreateObject(GetHashKey(prop_name), x, y, z+0.2,  true,  true, true)
	        AttachEntityToEntity(prop, playerPed, GetPedBoneIndex(playerPed, 18905), 0.12, 0.028, 0.001, 10.0, 175.0, 0.0, true, true, false, true, 1, true)
	        RequestAnimDict('mp_player_inteat@burger')
	        while not HasAnimDictLoaded('mp_player_inteat@burger') do
	            Wait(0)
	        end
	        TaskPlayAnim(playerPed, 'mp_player_inteat@burger', 'mp_player_int_eat_burger_fp', 8.0, -8, -1, 49, 0, 0, 0, 0)
	        Wait(9000)
	        IsAnimated = false
	        ClearPedSecondaryTask(playerPed)
	        DeleteObject(prop)
	    end)
	end
end)

---------------------------------------------------------------------------------------------------

RegisterNetEvent('esx_didrik_potatis:onEat')
AddEventHandler('esx_didrik_potatis:onEat', function(prop_name)
    if not IsAnimated then
		local prop_name = prop_name or 'ng_proc_food_ornge1a'
    	IsAnimated = true
	    local playerPed = GetPlayerPed(-1)
	    Citizen.CreateThread(function()
	        local x,y,z = table.unpack(GetEntityCoords(playerPed))
	        prop = CreateObject(GetHashKey(prop_name), x, y, z+0.2,  true,  true, true)
	        AttachEntityToEntity(prop, playerPed, GetPedBoneIndex(playerPed, 18905), 0.12, 0.028, 0.001, 10.0, 175.0, 0.0, true, true, false, true, 1, true)
	        RequestAnimDict('mp_player_inteat@burger')
	        while not HasAnimDictLoaded('mp_player_inteat@burger') do
	            Wait(0)
	        end
	        TaskPlayAnim(playerPed, 'mp_player_inteat@burger', 'mp_player_int_eat_burger_fp', 8.0, -8, -1, 49, 0, 0, 0, 0)
	        Wait(3000)
	        IsAnimated = false
	        ClearPedSecondaryTask(playerPed)
	        DeleteObject(prop)
	    end)
	end
end)

---------------------------------------------------------------------------------------------------

RegisterNetEvent('esx_didrik_korv:onEat')
AddEventHandler('esx_didrik_korv:onEat', function(prop_name)
    if not IsAnimated then
		local prop_name = prop_name or 'prop_cs_hotdog_01'
    	IsAnimated = true
	    local playerPed = GetPlayerPed(-1)
	    Citizen.CreateThread(function()
	        local x,y,z = table.unpack(GetEntityCoords(playerPed))
	        prop = CreateObject(GetHashKey(prop_name), x, y, z+0.2,  true,  true, true)
	        AttachEntityToEntity(prop, playerPed, GetPedBoneIndex(playerPed, 18905), 0.12, 0.028, 0.001, 10.0, 175.0, 0.0, true, true, false, true, 1, true)
	        RequestAnimDict('mp_player_inteat@burger')
	        while not HasAnimDictLoaded('mp_player_inteat@burger') do
	            Wait(0)
	        end
	        TaskPlayAnim(playerPed, 'mp_player_inteat@burger', 'mp_player_int_eat_burger_fp', 8.0, -8, -1, 49, 0, 0, 0, 0)
	        Wait(9000)
	        IsAnimated = false
	        ClearPedSecondaryTask(playerPed)
	        DeleteObject(prop)
	    end)
	end
end)

---------------------------------------------------------------------------------------------------

RegisterNetEvent('esx_didrik_steak:onEat')
AddEventHandler('esx_didrik_steak:onEat', function(prop_name)
    if not IsAnimated then
		local prop_name = prop_name or 'prop_cs_steak'
    	IsAnimated = true
	    local playerPed = GetPlayerPed(-1)
	    Citizen.CreateThread(function()
	        local x,y,z = table.unpack(GetEntityCoords(playerPed))
	        prop = CreateObject(GetHashKey(prop_name), x, y, z+0.2,  true,  true, true)
	        AttachEntityToEntity(prop, playerPed, GetPedBoneIndex(playerPed, 18905), 0.12, 0.028, 0.001, 10.0, 175.0, 0.0, true, true, false, true, 1, true)
	        RequestAnimDict('mp_player_inteat@burger')
	        while not HasAnimDictLoaded('mp_player_inteat@burger') do
	            Wait(0)
	        end
	        TaskPlayAnim(playerPed, 'mp_player_inteat@burger', 'mp_player_int_eat_burger_fp', 8.0, -8, -1, 49, 0, 0, 0, 0)
	        Wait(9000)
	        IsAnimated = false
	        ClearPedSecondaryTask(playerPed)
	        DeleteObject(prop)
	    end)
	end
end)

---------------------------------------------------------------------------------------------------

RegisterNetEvent('esx_didrik_munk:onEat')
AddEventHandler('esx_didrik_munk:onEat', function(prop_name)
    if not IsAnimated then
		local prop_name = prop_name or 'prop_amb_donut'
    	IsAnimated = true
	    local playerPed = GetPlayerPed(-1)
	    Citizen.CreateThread(function()
	        local x,y,z = table.unpack(GetEntityCoords(playerPed))
	        prop = CreateObject(GetHashKey(prop_name), x, y, z+0.2,  true,  true, true)
	        AttachEntityToEntity(prop, playerPed, GetPedBoneIndex(playerPed, 18905), 0.12, 0.028, 0.001, 10.0, 175.0, 0.0, true, true, false, true, 1, true)
	        RequestAnimDict('mp_player_inteat@burger')
	        while not HasAnimDictLoaded('mp_player_inteat@burger') do
	            Wait(0)
	        end
	        TaskPlayAnim(playerPed, 'mp_player_inteat@burger', 'mp_player_int_eat_burger_fp', 8.0, -8, -1, 49, 0, 0, 0, 0)
	        Wait(9000)
	        IsAnimated = false
	        ClearPedSecondaryTask(playerPed)
	        DeleteObject(prop)
	    end)
	end
end)

---------------------------------------------------------------------------------------------------

RegisterNetEvent('esx_didrik_klubba:onEat')
AddEventHandler('esx_didrik_klubba:onEat', function(prop_name)
    if not IsAnimated then
		local prop_name = prop_name or 'prop_turkey_leg_01'
    	IsAnimated = true
	    local playerPed = GetPlayerPed(-1)
	    Citizen.CreateThread(function()
	        local x,y,z = table.unpack(GetEntityCoords(playerPed))
	        prop = CreateObject(GetHashKey(prop_name), x, y, z+0.2,  true,  true, true)
	        AttachEntityToEntity(prop, playerPed, GetPedBoneIndex(playerPed, 18905), 0.12, 0.028, 0.001, 10.0, 175.0, 0.0, true, true, false, true, 1, true)
	        RequestAnimDict('mp_player_inteat@burger')
	        while not HasAnimDictLoaded('mp_player_inteat@burger') do
	            Wait(0)
	        end
	        TaskPlayAnim(playerPed, 'mp_player_inteat@burger', 'mp_player_int_eat_burger_fp', 8.0, -8, -1, 49, 0, 0, 0, 0)
	        Wait(9000)
	        IsAnimated = false
	        ClearPedSecondaryTask(playerPed)
	        DeleteObject(prop)
	    end)
	end
end)

---------------------------------------------------------------------------------------------------

------------------------------------ MAT / PROPS ----------------------------------------

RegisterNetEvent('esx_didrik_kaffe:onDrink')
AddEventHandler('esx_didrik_kaffe:onDrink', function(prop_name)
	if not IsAnimated then
		local prop_name = prop_name or 'p_ing_coffeecup_01'
		IsAnimated = true
		local playerPed = GetPlayerPed(-1)
		Citizen.CreateThread(function()
			local x,y,z = table.unpack(GetEntityCoords(playerPed))
			prop = CreateObject(GetHashKey(prop_name), x, y, z+0.2,  true,  true, true)			
	        AttachEntityToEntity(prop, playerPed, GetPedBoneIndex(playerPed, 18905), 0.12, 0.028, 0.001, 10.0, 175.0, 0.0, true, true, false, true, 1, true)
			RequestAnimDict('mp_player_intdrink')  
			while not HasAnimDictLoaded('mp_player_intdrink') do
				Wait(0)
			end
			TaskPlayAnim(playerPed, 'mp_player_intdrink', 'loop_bottle', 1.0, -1.0, 2000, 0, 1, true, true, true)
			Wait(9000)
	        IsAnimated = false
	        ClearPedSecondaryTask(playerPed)
			DeleteObject(prop)
		end)
	end
end)

RegisterNetEvent('esx_didrik_cola:onDrink')
AddEventHandler('esx_didrik_cola:onDrink', function(prop_name)
	if not IsAnimated then
		local prop_name = prop_name or 'prop_ecola_can'
		IsAnimated = true
		local playerPed = GetPlayerPed(-1)
		Citizen.CreateThread(function()
			local x,y,z = table.unpack(GetEntityCoords(playerPed))
			prop = CreateObject(GetHashKey(prop_name), x, y, z+0.2,  true,  true, true)			
	        AttachEntityToEntity(prop, playerPed, GetPedBoneIndex(playerPed, 18905), 0.12, 0.028, 0.001, 10.0, 175.0, 0.0, true, true, false, true, 1, true)
			RequestAnimDict('mp_player_intdrink')  
			while not HasAnimDictLoaded('mp_player_intdrink') do
				Wait(0)
			end
			TaskPlayAnim(playerPed, 'mp_player_intdrink', 'loop_bottle', 1.0, -1.0, 2000, 0, 1, true, true, true)
			Wait(9000)
	        IsAnimated = false
	        ClearPedSecondaryTask(playerPed)
			DeleteObject(prop)
		end)
	end
end)

RegisterNetEvent('esx_didrik_sprite:onDrink')
AddEventHandler('esx_didrik_sprite:onDrink', function(prop_name)
	if not IsAnimated then
		local prop_name = prop_name or 'ng_proc_sodacan_01b'
		IsAnimated = true
		local playerPed = GetPlayerPed(-1)
		Citizen.CreateThread(function()
			local x,y,z = table.unpack(GetEntityCoords(playerPed))
			prop = CreateObject(GetHashKey(prop_name), x, y, z+0.2,  true,  true, true)			
	        AttachEntityToEntity(prop, playerPed, GetPedBoneIndex(playerPed, 18905), 0.12, 0.028, 0.001, 10.0, 175.0, 0.0, true, true, false, true, 1, true)
			RequestAnimDict('mp_player_intdrink')  
			while not HasAnimDictLoaded('mp_player_intdrink') do
				Wait(0)
			end
			TaskPlayAnim(playerPed, 'mp_player_intdrink', 'loop_bottle', 1.0, -1.0, 2000, 0, 1, true, true, true)
			Wait(9000)
	        IsAnimated = false
	        ClearPedSecondaryTask(playerPed)
			DeleteObject(prop)
		end)
	end
end)

---------------------------- BLIPS ------------------------

local blips = {
    {title="Mat / Drycker", colour=64, id=515, x = 260.130, y = 204.308, z = 109.287},
    {title="Mat / Drycker", colour=64, id=515, x = 43.9, y = -998.4, z = 29.2 },
    {title="Mat / Drycker", colour=64, id=515, x = 132.8, y = -1462.5, z = 29.1 },
    {title="Mat / Drycker", colour=64, id=515, x = 11.9, y = -1606.5, z = 29.1 },
    {title="Mat / Drycker", colour=64, id=515, x = 169.0, y = -1633.4, z = 29.1 },
    {title="Mat / Drycker", colour=64, id=515, x = -1721.6, y = -1102.4, z = 12.8 },
    {title="Mat / Drycker", colour=64, id=515, x = -1692.2, y = -1134.3, z = 12.8 },
    {title="Mat / Drycker", colour=64, id=515, x = -242.0, y = 278.8, z = 91.8 },
    {title="Mat / Drycker", colour=64, id=515, x = 81.1, y = 274.0, z = 110.0 },
    {title="Mat / Drycker", colour=64, id=515, x = 1233.4, y = -354.6, z = 68.5 },
    {title="Mat / Drycker", colour=64, id=515, x = 1983.1, y = 3708.7, z = 31.6 },
    {title="Mat / Drycker", colour=64, id=515, x = 910.9, y = 3644.3, z = 32.1 },
    {title="Mat / Drycker", colour=64, id=515, x = 650.5, y = 2728.4, z = 41.6 },
    {title="Mat / Drycker", colour=64, id=515, x = 1591.3, y = 6450.6, z = 25.0 },
	{title="Mat / Drycker", colour=64, id=515, x = -122.6, y = 6389.56, z = 31.9 },
	{title="Mat / Drycker", colour=64, id=515, x = 1969.750, y = 3262.082, z = 31.9 },
	{title="Mat / Drycker", colour=64, id=515, x = -2193.4, y = 4289.9, z = 48.8 },
	{title="Mat / Drycker", colour=64, id=515, x = -2549.411, y = 2316.600, z = 48.8 },
	{title="Mat / Drycker", colour=64, id=515, x = 162.143, y = 6636.662, z = 48.8 },
	{title="Mat / Drycker", colour=64, id=515, x = -406.399, y = 6062.787, z = 48.8 },
	{title="Mat / Drycker", colour=64, id=515, x = -582.140, y = -984.957, z = 48.8 },
	{title="Mat / Drycker", colour=64, id=515, x = -860.952, y = -1140.420, z = 48.8 },
	{title="Mat / Drycker", colour=64, id=515, x = 152.495, y = 6504.854, z = 48.8 },
	{title="Mat / Drycker", colour=64, id=515, x = -271.298, y = 6073.0, z = 48.8 },
	{title="Mat / Drycker", colour=64, id=515, x = -1091.138, y = 2715.747, z = 48.8 },
	{title="Mat / Drycker", colour=64, id=515, x = -441.134, y = 1595.292, z = 48.8 },
	{title="Mat / Drycker", colour=64, id=515, x = 273.555, y = -832.943, z = 48.8 },
	{title="Mat / Drycker", colour=64, id=515, x = -834.804, y = -352.455, z = 48.8 },
	{title="Mat / Drycker", colour=64, id=515, x = 2741.552, y = 4413.034, z = 48.8 }
  }

Citizen.CreateThread(function()

    for _, info in pairs(blips) do
      info.blip = AddBlipForCoord(info.x, info.y, info.z)
      SetBlipSprite(info.blip, info.id)
      SetBlipDisplay(info.blip, 4)
      SetBlipScale(info.blip, 0.5)
      SetBlipColour(info.blip, info.colour)
      SetBlipAsShortRange(info.blip, true)
	  BeginTextCommandSetBlipName("STRING")
      AddTextComponentString(info.title)
      EndTextCommandSetBlipName(info.blip)
    end
end)

-----------------------------------------------------------------------------------------------------------