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

Citizen.CreateThread(function()
	while ESX == nil do
		TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)
		Citizen.Wait(0)
		PlayerData = ESX.GetPlayerData()
	end
end)

RegisterNetEvent('esx:playerLoaded')
AddEventHandler('esx:playerLoaded', function(xPlayer)
    PlayerData = xPlayer
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

-- EVENTS --

RegisterNetEvent('esx_andreas_bankfack:checkItem')
AddEventHandler('esx_andreas_bankfack:checkItem', function()
    ESX.TriggerServerCallback('esx_andreas_bankfack:checkKey', function(hasItem)
        if hasItem then 
			RequestAnimDict("anim@heists@humane_labs@finale@keycards")

			while not HasAnimDictLoaded( "anim@heists@humane_labs@finale@keycards") do
				Citizen.Wait(0)
			end
		
			TaskPlayAnim(GetPlayerPed(-1), "anim@heists@humane_labs@finale@keycards" ,"ped_b_enter" ,8.0, -8.0, -1, 0, 0, false, false, false )
			Citizen.Wait(1000)
			OpenBankMenu()
        else
            ESX.ShowNotification('Du har ingen bankfacksnyckel')
        end
    end)
end)


-- DRAW MARKERS --

Citizen.CreateThread(function()
	while true do Citizen.Wait(0)
		if (GetDistanceBetweenCoords(GetEntityCoords(GetPlayerPed(-1)), 262.51, 220.32, 100.80, true) <= 2.1 ) then
			if IsControlPressed(0, Keys['E']) then
				SetEntityHeading(GetPlayerPed(-1), 162.56)
				TriggerEvent('esx_andreas_bankfack:checkItem')
			end
		end
	end
end)

Citizen.CreateThread(function()
	while true do
	Citizen.Wait(1)
  
		if (GetDistanceBetweenCoords(GetEntityCoords(GetPlayerPed(-1)), 262.51, 220.32, 100.80, true) <= 500 ) then
			DrawMarker(27, 262.51, 220.32, 100.80, 0, 0, 0, 0, 0, 0, 1.001, 1.0001, 0.5001, 128, 128, 128, 200, 0, 0, 0, 0)
		end
  
		if GetDistanceBetweenCoords(GetEntityCoords(GetPlayerPed(-1)), 262.51, 220.32, 100.80, true) <= 6.5 then
			Draw3DText(262.51, 220.32, 101.68, '[~g~E~w~] för öppna ditt ~g~bankfack')
		end
	end
end)

function OpenBankMenu()
    ESX.UI.Menu.CloseAll()

    ESX.UI.Menu.Open(
        'default', GetCurrentResourceName(), 'bank_menu',
        {
            title    = 'Bankfack',
            elements = {
				{label = 'Lägg in föremål', value = 'get'},
				{label = 'Ta ut föremål', value = 'put'},
            }
        },
        function(data, menu)
            if data.current.value == 'put' then
                OpenRoomInventoryMenu() 
            end  

            if data.current.value == 'get' then
                OpenPlayerInventoryMenu()
            end
        end,
        function(data, menu)
            menu.close()
        end
    )
end

function OpenRoomInventoryMenu()

	ESX.TriggerServerCallback('esx_property:getPropertyInventory', function(inventory)

		local elements = {}

		if inventory.blackMoney > 0 then
			table.insert(elements, {
				label = _U('dirty_money', ESX.Math.GroupDigits(inventory.blackMoney)),
				type = 'item_account',
				value = 'black_money'
			})
		end

		for i=1, #inventory.items, 1 do
			local item = inventory.items[i]

			if item.count > 0 then
				table.insert(elements, {
					label = item.label .. ' x' .. item.count,
					type = 'item_standard',
					value = item.name
				})
			end
		end

		for i=1, #inventory.weapons, 1 do
			local weapon = inventory.weapons[i]

			table.insert(elements, {
				label = ESX.GetWeaponLabel(weapon.name) .. ' [' .. weapon.ammo .. ']',
				type  = 'item_weapon',
				value = weapon.name,
				ammo  = weapon.ammo
			})
		end

		ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'room_inventory',
		{
			title    = 'Innehåll',
			align    = 'top-left',
			elements = elements
		}, function(data, menu)

			if data.current.type == 'item_weapon' then

				menu.close()

				TriggerServerEvent('esx_property:getItem', owner, data.current.type, data.current.value, data.current.ammo)
				ESX.SetTimeout(300, function()
					OpenRoomInventoryMenu(property, owner)
				end)

			else

				ESX.UI.Menu.Open('dialog', GetCurrentResourceName(), 'get_item_count', {
					title = _U('amount')
				}, function(data2, menu)

					local quantity = tonumber(data2.value)
					if quantity == nil then
						ESX.ShowNotification(_U('amount_invalid'))
					else
						menu.close()

						TriggerServerEvent('esx_property:getItem', owner, data.current.type, data.current.value, quantity)
						ESX.SetTimeout(300, function()
							OpenRoomInventoryMenu(property, owner)
						end)
					end

				end, function(data2,menu)
					menu.close()
				end)

			end

		end, function(data, menu)
			menu.close()
		end)

	end, owner)

end

function OpenPlayerInventoryMenu()

	ESX.TriggerServerCallback('esx_property:getPlayerInventory', function(inventory)

		local elements = {}

		if inventory.blackMoney > 0 then
			table.insert(elements, {
				label = _U('dirty_money', ESX.Math.GroupDigits(inventory.blackMoney)),
				type  = 'item_account',
				value = 'black_money'
			})
		end

		for i=1, #inventory.items, 1 do
			local item = inventory.items[i]

			if item.count > 0 then
				table.insert(elements, {
					label = item.label .. ' x' .. item.count,
					type  = 'item_standard',
					value = item.name
				})
			end
		end

		for i=1, #inventory.weapons, 1 do
			local weapon = inventory.weapons[i]

			table.insert(elements, {
				label = weapon.label .. ' [' .. weapon.ammo .. ']',
				type  = 'item_weapon',
				value = weapon.name,
				ammo  = weapon.ammo
			})
		end

		ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'player_inventory',
		{
			title    = 'Lägg in förenål',
			align    = 'top-left',
			elements = elements
		}, function(data, menu)

			if data.current.type == 'item_weapon' then

				menu.close()
				TriggerServerEvent('esx_property:putItem', owner, data.current.type, data.current.value, data.current.ammo)

				ESX.SetTimeout(300, function()
					OpenPlayerInventoryMenu(property, owner)
				end)

			else

				ESX.UI.Menu.Open('dialog', GetCurrentResourceName(), 'put_item_count', {
					title = _U('amount')
				}, function(data2, menu2)

					local quantity = tonumber(data2.value)

					if quantity == nil then
						ESX.ShowNotification(_U('amount_invalid'))
					else

						menu2.close()

						TriggerServerEvent('esx_property:putItem', owner, data.current.type, data.current.value, tonumber(data2.value))
						ESX.SetTimeout(300, function()
							OpenPlayerInventoryMenu(property, owner)
						end)
					end

				end, function(data2, menu2)
					menu2.close()
				end)

			end

		end, function(data, menu)
			menu.close()
		end)

	end)

end