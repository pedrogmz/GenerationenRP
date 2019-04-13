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

local RequiredPolice = 0
local DelayBetween = 1800

ESX = nil
PlayerData = {}

Citizen.CreateThread(function()
	while ESX == nil do
		TriggerEvent('esx:getSharedObject', function(obj)
			ESX = obj

			if ESX.IsPlayerLoaded() == true then
				PlayerData = ESX.GetPlayerData()
			end
		end)

		for i=1, #Config.WeedFarms, 1 do
			local farm = Config.WeedFarms[i]

			Marker.AddMarker('weed_farm_' .. i, farm, 'Tryck på ~INPUT_CONTEXT~ för att hantera weed plantan.', nil, 0, function()
				OpenWeedPlantMenu('weed_' .. i)
			end, 
			function()
				ESX.UI.Menu.CloseAll()
			end)
		end

		for i=1, #Config.CocaineFarms, 1 do 
			local farm = Config.CocaineFarms[i]

			Marker.AddMarker('cocaine_farm_' .. i, farm, 'Tryck på ~INPUT_CONTEXT~ för att hantera kokain.', nil, 0, function()
				OpenCocaineFarmMenu('cocaine_' .. i)
			end, 
			function()
				ESX.UI.Menu.CloseAll()
			end)
		end

		for i=1, #Config.MethFarms, 1 do 
			local farm = Config.MethFarms[i]

			Marker.AddMarker('meth_farm_' .. i, farm, 'Tryck på ~INPUT_CONTEXT~ för att hantera meth.', nil, 0, function()
				OpenMethFarmMenu('meth_' .. i)
			end, 
			function()
				ESX.UI.Menu.CloseAll()
			end)
		end

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

function OpenWeedPlantMenu(plantId)
	ESX.UI.Menu.CloseAll()
	ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'weed_plant', 
		{
			title = 'Weed Plant',
			align = 'top-left',
			elements = {
				{
					label = 'Plantera',
					value = 'plant_seed'
				},
				{
					label = 'Vatnna',
					value = 'water_plant'
				},
				{	
					label = 'Plocka',
					value = 'harvest_plant'
				}
			}
		},
		function(data, menu)
            ESX.UI.Menu.CloseAll()
			ESX.TriggerServerCallback('revenge-drugs:getPolice', function(count)
				if count >= RequiredPolice then
					ESX.TriggerServerCallback('revenge-drugs:getProgress', function(progress, time)
						if data.current.value == 'plant_seed' then
							if progress.task == 'plant' then
								Citizen.CreateThread(function()
									ESX.TriggerServerCallback('revenge-drugs:useIngredients', function(state)
										if state == true then
											playAnimation(nil, 'world_human_gardener_plant')

											progress.task = 'water'
											progress.tasksLeft = 3

											TriggerServerEvent('revenge-drugs:setProgress', progress)

											Citizen.Wait(10000)
											ClearPedTasks(GetPlayerPed(-1))
										else
											TriggerEvent('esx:showNotification', 'Du behöver samla några weed frön!')
										end
									end, progress)
								end)
							else
								TriggerEvent('esx:showNotification', 'Det finns redan en växt här.')
							end
						elseif data.current.value == 'water_plant' then
							if progress.task == 'water' then
								Citizen.CreateThread(function()
									if progress.delay + DelayBetween < time then
										playAnimation('amb@world_human_bum_wash@male@high@idle_a', 'idle_a')

										if progress.tasksLeft > 1 then
											progress.tasksLeft = progress.tasksLeft - 1
											progress.delay = time
										else
											progress.task = 'harvest'
											progress.tasksLeft = 1
											progress.delay = time
										end

										TriggerServerEvent('revenge-drugs:setProgress', progress)

										Citizen.Wait(10000)
										ClearPedTasks(GetPlayerPed(-1))

										ESX.UI.Menu.CloseAll()
									else
										TriggerEvent('esx:showNotification', 'Vänta '.. DelayBetween ..' sekunder efter du har hanterar plantan. Innan du kan göra det igen.')
									end
								end)
							else
								if progress.task == 'plant' then
									TriggerEvent('esx:showNotification', 'Det finns ingen växt här.')
								else
									TriggerEvent('esx:showNotification', 'Du har redan lyckats med plantan tillräckligt.')
								end
							end
						elseif data.current.value == 'harvest_plant' then
							if progress.task == 'harvest' then
								Citizen.CreateThread(function()
									if progress.delay + DelayBetween < time then
										progress.task = 'plant'
										progress.tasksLeft = 1
										progress.delay = 0

										TriggerServerEvent('revenge-drugs:setProgress', progress)

										playAnimation('amb@prop_human_movie_studio_light@base', 'base')

										Citizen.Wait(10000)
										ClearPedTasks(GetPlayerPed(-1))

										ESX.TriggerServerCallback('revenge-drugs:giveRewards', function()
											TriggerEvent('esx:showNotification', 'Skördade växten.')

											ESX.UI.Menu.CloseAll()
										end, 'weed_pooch', 20)

										ESX.UI.Menu.CloseAll()
									else
										TriggerEvent('esx:showNotification', 'Du måste vänta på att plantan är klar.')		
									end
								end)
							else
								if progress.task == 'plant' then
									TriggerEvent('esx:showNotification', 'Det finns ingen växt här.')
								else
									TriggerEvent('esx:showNotification', 'Du måste hantera plantan först.')
								end
							end
						end
					end, plantId)
				else
					TriggerEvent('esx:showNotification', 'Det måste vara minst ~b~' .. RequiredPolice .. ' ~w~poliser för att farma droger.')
				end
			end)
		end,
		function(data, menu)
			menu.close()
		end
	)
end

function OpenCocaineFarmMenu(plantId)
	ESX.UI.Menu.CloseAll()
	ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'cocaine_farm', 
		{
			title = 'Cocaine Farm',
			align = 'top-left',
			elements = {
				{
					label = 'Samla',
					value = 'ingredients'
				},
				{
					label = 'Blanda',
					value = 'sample'
				},
				{	
					label = 'Paketera',
					value = 'package'
				}
			}
		},
		function(data, menu)
                        ESX.UI.Menu.CloseAll()
			ESX.TriggerServerCallback('revenge-drugs:getPolice', function(count)
				if count >= RequiredPolice then
					ESX.TriggerServerCallback('revenge-drugs:getProgress', function(progress, time)
						if data.current.value == 'ingredients' then
							if progress.task == 'ingredients' then
								Citizen.CreateThread(function()
									ESX.TriggerServerCallback('revenge-drugs:useIngredients', function(state)
										if state == true then
											progress.task = 'sample'
											progress.tasksLeft = 3

											TriggerServerEvent('revenge-drugs:setProgress', progress)

											playAnimation('mini@repair', 'fixing_a_ped')

											Citizen.Wait(10000)
											ClearPedTasks(GetPlayerPed(-1))

											ESX.UI.Menu.CloseAll()
										else
											TriggerEvent('esx:showNotification', 'Du måste samla koksingredienserna först!')
										end
									end, progress)
								end)
							else
								TriggerEvent('esx:showNotification', 'Du har redan blandat ingredienserna.')
							end
						elseif data.current.value == 'sample' then
							if progress.task == 'sample' then
								Citizen.CreateThread(function()
									if progress.delay + DelayBetween < time then
										if progress.tasksLeft > 1 then
											progress.tasksLeft = progress.tasksLeft - 1
											progress.delay = time
										else
											progress.task = 'package'
											progress.tasksLeft = 1
											progress.delay = time
										end

										TriggerServerEvent('revenge-drugs:setProgress', progress)

										playAnimation('mini@repair', 'fixing_a_ped')

										Citizen.Wait(10000)
										ClearPedTasks(GetPlayerPed(-1))

										ESX.UI.Menu.CloseAll()
									else
										TriggerEvent('esx:showNotification', 'Du har redan provat kokainen.')
									end
								end)
							else
								if progress.task == 'ingredients' then
									TriggerEvent('esx:showNotification', 'Du måste blanda ingredienserna först.')
								else
									TriggerEvent('esx:showNotification', 'Kokainet är klart för förpackning.')
								end
							end
						elseif data.current.value == 'package' then
							if progress.task == 'package' then
								Citizen.CreateThread(function()
									if progress.delay + DelayBetween < time then
										progress.task = 'ingredients'
										progress.tasksLeft = 1
										progress.delay = 0

										TriggerServerEvent('revenge-drugs:setProgress', progress)

										playAnimation('amb@prop_human_movie_studio_light@base', 'base')

										Citizen.Wait(10000)
										ClearPedTasks(GetPlayerPed(-1))
										
										ESX.TriggerServerCallback('revenge-drugs:giveRewards', function()
											TriggerEvent('esx:showNotification', 'Förpackade kokainen.')

											ESX.UI.Menu.CloseAll()
										end, 'coke_pooch', 20)

										ESX.UI.Menu.CloseAll()
									else
										TriggerEvent('esx:showNotification', 'Du måste vänta på att cola slutar.')		
									end
								end)
							else
								if progress.task == 'ingredients' then
									TriggerEvent('esx:showNotification', 'Du måste blanda ingredienserna först.')
								else
									TriggerEvent('esx:showNotification', 'Du måste först prova kokainen.')
								end
							end
						end
					end, plantId)
				else
					TriggerEvent('esx:showNotification', 'Det måste vara minst ~b~' .. RequiredPolice .. ' ~w~poliser för att farma droger .')
				end
			end)
		end,
		function(data, menu)
			menu.close()
		end
	)
end

function OpenMethFarmMenu(plantId)
	ESX.UI.Menu.CloseAll()
	ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'meth_farm', 
		{
			title = 'Meth Farm',
			align = 'top-left',
			elements = {
				{
					label = 'Blanda',
					value = 'ingredients'
				},
				{
					label = 'Koka',
					value = 'cook'
				},
				{	
					label = 'Paketera',
					value = 'package'
				}
			}
		},
		function(data, menu)
            ESX.UI.Menu.CloseAll()
			ESX.TriggerServerCallback('revenge-drugs:getPolice', function(count)
				if count >= RequiredPolice then
					ESX.TriggerServerCallback('revenge-drugs:getProgress', function(progress, time)
						if data.current.value == 'ingredients' then
							if progress.task == 'ingredients' then
								Citizen.CreateThread(function()
									ESX.TriggerServerCallback('revenge-drugs:useIngredients', function(state)
										if state == true then
											playAnimation('mini@repair', 'fixing_a_ped')
											
											progress.task = 'cook'
											progress.tasksLeft = 3

											TriggerServerEvent('revenge-drugs:setProgress', progress)

											Citizen.Wait(10000)
											ClearPedTasks(GetPlayerPed(-1))

											ESX.UI.Menu.CloseAll()
										else
											TriggerEvent('esx:showNotification', 'Du måste samla metingredienserna först!')
										end
									end, progress)
								end)
							else
								TriggerEvent('esx:showNotification', 'Du har redan blandat ingredienserna.')
							end
						elseif data.current.value == 'cook' then
							if progress.task == 'cook' then
								Citizen.CreateThread(function()
									if progress.delay + DelayBetween < time then
										playAnimation('mini@repair', 'fixing_a_ped')
										
										if progress.tasksLeft > 1 then
											progress.tasksLeft = progress.tasksLeft - 1
											progress.delay = time
										else
											progress.task = 'package'
											progress.tasksLeft = 1
											progress.delay = time
										end

										TriggerServerEvent('revenge-drugs:setProgress', progress)

										Citizen.Wait(10000)
										ClearPedTasks(GetPlayerPed(-1))

										ESX.UI.Menu.CloseAll()
									else
										TriggerEvent('esx:showNotification', 'Du har redan kokat meten.')
									end
								end)
							else
								if progress.task == 'ingredients' then
									TriggerEvent('esx:showNotification', 'Du måste blanda ingredienserna först.')
								else
									TriggerEvent('esx:showNotification', 'Meth är klar för förpackning.')
								end
							end
						elseif data.current.value == 'package' then
							if progress.task == 'package' then
								Citizen.CreateThread(function()
									if progress.delay + DelayBetween < time then
										progress.task = 'ingredients'
										progress.tasksLeft = 1
										progress.delay = 0

										TriggerServerEvent('revenge-drugs:setProgress', progress)

										playAnimation('amb@prop_human_movie_studio_light@base', 'base')

										Citizen.Wait(10000)
										ClearPedTasks(GetPlayerPed(-1))
										
										ESX.TriggerServerCallback('revenge-drugs:giveRewards', function()
											TriggerEvent('esx:showNotification', 'Förpackade meth.')

											ESX.UI.Menu.CloseAll()
										end, 'meth_pooch', 20)

										ESX.UI.Menu.CloseAll()
									else
										TriggerEvent('esx:showNotification', 'Du måste vänta på meth för att avsluta matlagningen.')		
									end
								end)
							else
								if progress.task == 'ingredients' then
									TriggerEvent('esx:showNotification', 'Du måste blanda ingredienserna först.')
								else
									TriggerEvent('esx:showNotification', 'Du måste laga meten först.')
								end
							end
						end
					end, plantId)
				else
					TriggerEvent('esx:showNotification', 'Det måste vara minst ~b~' .. RequiredPolice .. ' ~w~poliser för att farma droger.')
				end
			end)
		end,
		function(data, menu)
			menu.close()
		end
	)
end

local oldPed = nil
local currentPed = nil
local hasDrugs = false

Citizen.CreateThread(function()
	while true do
  		Citizen.Wait(0)
  		
  		local player = GetPlayerPed(-1)
  		local playerloc = GetEntityCoords(player, 0)
  		local handle, ped = FindFirstPed()

  		repeat
   			local success, ped = FindNextPed(handle)
   			local pos = GetEntityCoords(ped)
  		 	local distance = GetDistanceBetweenCoords(pos.x, pos.y, pos.z, playerloc['x'], playerloc['y'], playerloc['z'], true)

   			if IsPedInAnyVehicle(GetPlayerPed(-1)) == false then
     			if DoesEntityExist(ped) then
        			if IsPedDeadOrDying(ped) == false then
          				if IsPedInAnyVehicle(ped) == false then
            				local pedType = GetPedType(ped)
            				
            				if pedType ~= 28 and IsPedAPlayer(ped) == false then
              					currentPed = pos
              					
              					if distance <= 2 and ped  ~= GetPlayerPed(-1) and ped ~= oldPed then
              						if hasDrugs == true then 			
	              						drawTxt(0.90, 1.40, 1.0,1.0,0.4, "Tryck på ~g~E ~w~för att sälja droger", 255, 255, 255, 255)
	              						
	              						if IsControlJustPressed(1, 86) then
	              							FreezeEntityPosition(player, true)

	                 						oldPed = ped
	                  						
	                  						SetEntityAsMissionEntity(ped)
	                 						TaskStandStill(ped, 9.0)
	            
	                 						Citizen.Wait(7000)

	                 						SetPedAsNoLongerNeeded(oldPed)

	                 						ESX.TriggerServerCallback('revenge-drugs:isPedAccepting', function(state)
	                 							if state == true then
	                 								if GetPedType(ped) == 4 then
		                 								PlayAmbientSpeechWithVoice(ped, 'GENERIC_THANKS', 'S_M_Y_HWAYCOP_01_BLACK_FULL_02', 'SPEECH_PARAMS_FORCE_SHOUTED', 0)
		                 							else
		                 								PlayAmbientSpeechWithVoice(ped, 'GENERIC_THANKS', 'A_F_M_DOWNTOWN_01_BLACK_FULL_01', 'SPEECH_PARAMS_FORCE_SHOUTED', 0)
		                 							end

		                 							ESX.TriggerServerCallback('revenge-drugs:sellDrugs', function(money)
		                 								if money == -1 then
		                 									TriggerEvent('esx:showNotification', "~r~Det måste finnas minst 2 poliser i plikt att sälja droger.")
		                 								elseif money > 0 then
	                 										TriggerEvent('esx:showNotification', 'Du sålde några droger för ~g~SEK' .. money)
		                 								end
		                 							end)
	                 							else
	                 								if GetPedType(ped) == 4 then
		                 								PlayAmbientSpeechWithVoice(ped, 'GENERIC_THANKS', 'S_M_Y_HWAYCOP_01_BLACK_FULL_02', 'SPEECH_PARAMS_FORCE_SHOUTED', 0)
		                 							else
		                 								PlayAmbientSpeechWithVoice(ped, 'GENERIC_THANKS', 'A_F_M_DOWNTOWN_01_BLACK_FULL_01', 'SPEECH_PARAMS_FORCE_SHOUTED', 0)
		                 							end

		                 							ESX.TriggerServerCallback('revenge-drugs:sellDrugs', function(money)
		                 								if money == -1 then
		                 									TriggerEvent('esx:showNotification', "~r~Det måste finnas minst 2 poliser i plikt att sälja droger.")
		                 								elseif money > 0 then
		                 									local coords = GetEntityCoords(GetPlayerPed(-1))
	                 										
	                 										TriggerEvent('esx:showNotification', 'Du sålde några droger för ~g~SEK' .. money)
	                 										TriggerServerEvent('esx_phone:send', 'police', 'Det finns ett potensiell drog handel i området!.', true, {x = coords.x, y = coords.y, z = coords.z})
		                 								end
		                 							end)	
	                 							end
	                 						end)
	              							
	              							FreezeEntityPosition(player, false)
	             						end
	             					end
              					end
            				end
         				end
        			end
     			end
    		end
  		until not success
  			EndFindPed(handle)
	end
end)

Citizen.CreateThread(function()
	while true do
		Citizen.Wait(2000)

		ESX.TriggerServerCallback('revenge-drugs:hasDrugs', function(state)
        	hasDrugs = state
        end)
	end
end)

function drawTxt(x, y, width, height, scale, text, r, g, b, a, outline)
    SetTextFont(0)
    SetTextProportional(0)
    SetTextScale(scale, scale)
    SetTextColour(r, g, b, a)
    SetTextDropShadow(0, 0, 0, 0,255)
    SetTextEdge(1, 0, 0, 0, 255)
    SetTextDropShadow()
    
    if outline == true then
      SetTextOutline()
    end

    SetTextEntry("STRING")
    AddTextComponentString(text)
    DrawText(x - width / 2, y - height / 2 + 0.005)
end

function playAnimation(group, animation)
	if group ~= nil then
		Citizen.CreateThread(function()
			RequestAnimDict(group)

			while not HasAnimDictLoaded(group) do
	        	Citizen.Wait(100)
	      	end

	      	TaskPlayAnim(GetPlayerPed(-1), group, animation, 8.0, -8, -1, 49, 0, 0, 0, 0)
		end)
	else
		TaskStartScenarioInPlace(GetPlayerPed(-1), animation, 0, true)
	end
end

function playPedAnimation(ped, group, animation)
	if group ~= nil then
		Citizen.CreateThread(function()
			RequestAnimDict(group)

			while not HasAnimDictLoaded(group) do
	        	Citizen.Wait(100)
	      	end

	      	TaskPlayAnim(ped, group, animation, 8.0, -8, -1, 49, 0, 0, 0, 0)
		end)
	else
		TaskStartScenarioInPlace(ped, animation, 0, true)
	end
end