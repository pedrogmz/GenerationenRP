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

ESX              = nil
local PlayerData = {}


Citizen.CreateThread(function()
	while ESX == nil do
		TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)
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

function openMenu()
    ESX.UI.Menu.CloseAll()

    ESX.UI.Menu.Open(
        'default', GetCurrentResourceName(), 'person_menu',
        {
            title = ('Interaktionmeny'),
            elements = {

				{label = ('Individåtgärder'), value = 'person'},
				{label = ('Fordonsmeny'), value = 'vehicle'},
				{label = ('Animationer'), value = 'animations'},
            }
        },

    function(data, menu)
	
        if data.current.value == 'person' then
			openCivMenu()
        end
        
		if data.current.value == 'vehicle' then
			TriggerEvent('esx_didrik_fordonmenu:openMenu')
        end
        
		if data.current.value == 'animations' then
            TriggerEvent('esx_animations:openMenu')
		end
    end,
    function(data, menu)
		menu.close()
    end
    )
end

function openCivMenu()
    ESX.UI.Menu.CloseAll()

    ESX.UI.Menu.Open(
        'default', GetCurrentResourceName(), 'civ_menu',
        {
            title    = 'Individåtgärder',
            elements = {
                {label = 'Kolla på ditt ID-Kort', value = 'id'},
                {label = 'Visa ditt ID-Kort', value = 'showid'},
                {label = 'Mina körkort', value = 'korkort'},
                {label = 'Ögonbindel På/Av', value = 'blindfold'},	
                {label = 'Lyft', value = 'lift'},
                {label = 'Stäng av / på telefon', value = 'phoneonoff'},
				{label = 'Accessoarer', value = 'acc'}	
            }
        },
        function(data, menu)
            
            if data.current.value == 'id' then
              TriggerServerEvent('jsfour-legitimation:open', GetPlayerServerId(PlayerId()), GetPlayerServerId(PlayerId()))
            end

            if data.current.value == 'korkort' then
                ESX.TriggerServerCallback('esx_didrik:getLicenses', function (licenses)

                    local elements = {}

                    for i=1, #licenses, 1 do

                        if licenses[i].drive == 'yes' then
                            table.insert(elements, {label = 'B-Körkort'})
                        end

                        if licenses[i].drive == 'no' then
                            table.insert(elements, {label = '------'})
                        end

                        if licenses[i].bike == 'yes' then
                            table.insert(elements, {label = 'MC-Körkort'})
                        end

                        if licenses[i].bike == 'no' then
                            table.insert(elements, {label = '------'})
                        end

                        if licenses[i].truck == 'yes' then
                            table.insert(elements, {label = 'CE-Körkort'})
                        end

                        if licenses[i].truck == 'no' then
                            table.insert(elements, {label = '------'})
                        end
                    end


                      ESX.UI.Menu.Open(
                          'default', GetCurrentResourceName(), 'licenses',
                          {
                          title    = '🔖 Körkortsbehållare',
                          align = 'top-left',
                          elements = elements

                      },
                      function(data3, menu3)
            

                      end,

                      function(data3, menu3)
                            menu3.close()
                    end
                      )
                  end, GetPlayerServerId(PlayerId()))    
            end

            if data.current.value == 'showid' then
                local player, distance = ESX.Game.GetClosestPlayer()

				if distance ~= -1 and distance <= 3.0 then
                    TriggerServerEvent('jsfour-legitimation:open', GetPlayerServerId(PlayerId()), GetPlayerServerId(player))
				else
					sendNotification('Ingen person i närheten.', 'error', 2500)
				end		
            end
 
            if data.current.value == 'phoneonoff' then
               TriggerServerEvent("esx_didrik:togglePhone")   
            end

			if data.current.value == 'blindfold' then
				local player, distance = ESX.Game.GetClosestPlayer()

				if distance ~= -1 and distance <= 3.0 then
					ESX.TriggerServerCallback('jsfour-blindfold:itemCheck', function( hasItem )
						TriggerServerEvent('jsfour-blindfold', GetPlayerServerId(player), hasItem)
					end)
				else
					sendNotification('Ingen person i närheten.', 'error', 2500)
				end
			end
			
			if data.current.value == 'lift' then	
                local closestPlayer, distance = ESX.Game.GetClosestPlayer()

                if distance ~= -1 and distance <= 3.0 and not IsPedInAnyVehicle(GetPlayerPed(-1)) and not IsPedInAnyVehicle(GetPlayerPed(closestPlayer)) then
                  TriggerServerEvent('esx_zeb_tackle:tryTackle', GetPlayerServerId(closestPlayer))
                else
                    sendNotification('Ingen person i närheten.', 'error', 2500)
                end
            end
            
			if data.current.value == 'acc' then
				TriggerEvent('esx_accessories:openMenu')
			end
        end,
        function(data, menu)
            openMenu()
        end
    )
end

Citizen.CreateThread(function()
	while true do
		Citizen.Wait(1)
		if IsControlJustReleased(0, Keys['F3']) then
			openMenu()
		end
	end
end)

function sendNotification(message, messageType, messageTimeout)
	TriggerEvent("pNotify:SendNotification", {
		text = message,
		type = messageType,
		queue = "didrik",
		timeout = messageTimeout,
		layout = "bottomCenter"
	})
end