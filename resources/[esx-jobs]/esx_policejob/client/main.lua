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

local PlayerData                = {}
local GUI                       = {}
local HasAlreadyEnteredMarker   = false
local LastStation               = nil
local LastPart                  = nil
local LastPartNum               = nil
local LastEntity                = nil
local CurrentAction             = nil
local CurrentActionMsg          = ''
local CurrentActionData         = {}
local IsHandcuffed              = false
local IsDragged               = false
local CopPed                    = 0
local playerId = PlayerId()
local serverId = GetPlayerServerId(localPlayerId)
local tiempo = 12000
local vehWeapons = {
  0x1D073A89, -- ShotGun
  0x83BF0278, -- Carbine
  0x5FC3C11, -- Sniper
  0x1B06D571, -- Pistol
}

local hasBeenInPoliceVehicle = false

local alreadyHaveWeapon = {}

ESX                             = nil
GUI.Time                        = 0

Citizen.CreateThread(function()
  while ESX == nil do
    TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)
    Citizen.Wait(0)
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

Citizen.CreateThread(function()
  while true do
    Citizen.Wait(0)
    if IsPedBeingStunned(GetPlayerPed(-1)) then
    SetPedMinGroundTimeForStungun(GetPlayerPed(-1), tiempo)
    end
  end
end)

function getJob()
  
  if PlayerData.job ~= nil then
  return PlayerData.job.name  
  
  end  
end

function OpenCloakroomMenu()

  local elements = {
    { label = ('Personliga Kläder'), value = 'citizen_wear' },
    { label = ('Ta på reflexväst'), value = 'veston_wear' },
    { label = ('Ta av reflexväst'), value = 'vestoff_wear' },
    { label = ('Ta på mössa'), value = 'hjalmon_wear' },
    { label = ('Ta av mössa'), value = 'hjalmoff_wear' },
  }

  if PlayerData.job.grade_name == 'recruit' then
    table.insert(elements, {label = ('Polisuniform'), value = 'police_wear'})
  end

  if PlayerData.job.grade_name == 'officer' then
    table.insert(elements, {label = ('Polisuniform'), value = 'police_wear'})
  end

  if PlayerData.job.grade_name == 'sergeant' then
    table.insert(elements, {label = ('Polisuniform'), value = 'police_wear'})
  end

  if PlayerData.job.grade_name == 'lieutenant' then
    table.insert(elements, {label = ('Polisuniform'), value = 'police_wear'})
  end

  if PlayerData.job.grade_name == 'boss' then
    table.insert(elements, {label = ('Polisuniform'), value = 'police_wear'})
  end

  ESX.UI.Menu.CloseAll()

  ESX.UI.Menu.Open(
    'default', GetCurrentResourceName(), 'cloakroom',
    {
      title    = _U('cloakroom'),
      align    = 'top-left',
      elements = elements,
    },
    function(data, menu)
      menu.close()

      if data.current.value == 'citizen_wear' then
        ESX.TriggerServerCallback('esx_skin:getPlayerSkin', function(skin, jobSkin)
          TriggerEvent('skinchanger:loadSkin', skin)
		  local model = nil



          TriggerEvent('skinchanger:loadSkin', skin)
          TriggerEvent('esx:restoreLoadout')
          local playerPed = GetPlayerPed(-1)
          SetPedArmour(playerPed, 0)
          ClearPedBloodDamage(playerPed)
          ResetPedVisibleDamage(playerPed)
          ClearPedLastWeaponDamage(playerPed)
        end)
      end

      if data.current.value == 'veston_wear' then
        TriggerEvent('skinchanger:getSkin', function(skin)
        
            if skin.sex == 0 then

                local clothesSkin = {
                  ['bags_1'] = 1, ['bags_2'] = 0,
                }
                TriggerEvent('skinchanger:loadClothes', skin, clothesSkin)

            else

                local clothesSkin = {
                  ['bags_1'] = 1, ['bags_2'] = 0,
                }
                TriggerEvent('skinchanger:loadClothes', skin, clothesSkin)

            end

            local playerPed = GetPlayerPed(-1)
            SetPedArmour(playerPed, 0)
            ClearPedBloodDamage(playerPed)
            ResetPedVisibleDamage(playerPed)
            ClearPedLastWeaponDamage(playerPed)
            
        end)
      end

      if data.current.value == 'vestoff_wear' then
        TriggerEvent('skinchanger:getSkin', function(skin)
        
            if skin.sex == 0 then

                local clothesSkin = {
                  ['bags_1'] = 0, ['bags_2'] = 0,
                }
                TriggerEvent('skinchanger:loadClothes', skin, clothesSkin)

            else

                local clothesSkin = {
                  ['bags_1'] = 0, ['bags_2'] = 0,
                }
                TriggerEvent('skinchanger:loadClothes', skin, clothesSkin)

            end

            local playerPed = GetPlayerPed(-1)
            SetPedArmour(playerPed, 0)
            ClearPedBloodDamage(playerPed)
            ResetPedVisibleDamage(playerPed)
            ClearPedLastWeaponDamage(playerPed)
            
        end)
      end

      if data.current.value == 'hjalmon_wear' then
        TriggerEvent('skinchanger:getSkin', function(skin)
        
            if skin.sex == 0 then

                local clothesSkin = {
                  ['helmet_1'] = 1, ['helmet_2'] = 0,
                }
                TriggerEvent('skinchanger:loadClothes', skin, clothesSkin)

            else

                local clothesSkin = {
                  ['helmet_1'] = 1, ['helmet_2'] = 0,
                }
                TriggerEvent('skinchanger:loadClothes', skin, clothesSkin)

            end

            local playerPed = GetPlayerPed(-1)
            SetPedArmour(playerPed, 0)
            ClearPedBloodDamage(playerPed)
            ResetPedVisibleDamage(playerPed)
            ClearPedLastWeaponDamage(playerPed)
            
        end)
      end

      if data.current.value == 'hjalmoff_wear' then
        TriggerEvent('skinchanger:getSkin', function(skin)
        
            if skin.sex == 0 then

                local clothesSkin = {
                  ['helmet_1'] = -1, ['helmet_2'] = 0,
                }
                TriggerEvent('skinchanger:loadClothes', skin, clothesSkin)

            else

                local clothesSkin = {
                  ['helmet_1'] = -1, ['helmet_2'] = 0,
                }
                TriggerEvent('skinchanger:loadClothes', skin, clothesSkin)

            end

            local playerPed = GetPlayerPed(-1)
            SetPedArmour(playerPed, 0)
            ClearPedBloodDamage(playerPed)
            ResetPedVisibleDamage(playerPed)
            ClearPedLastWeaponDamage(playerPed)
            
        end)
      end


      if data.current.value == 'police_wear' then
        TriggerEvent('skinchanger:getSkin', function(skin)
        
            if skin.sex == 0 then

                local clothesSkin = {
                  ['tshirt_1'] = 37, ['tshirt_2'] = 0,
                  ['torso_1'] = 1, ['torso_2'] = 0,
                  ['arms'] = 26,
                  ['pants_1'] = 1, ['pants_2'] = 0,
                  ['shoes_1'] = 1, ['shoes_2'] = 0,
                  ['chain_1'] = 1, ['chain_2'] = 0,
                  ['mask_1'] = 121, ['mask_2'] = 0,
                  ['decals_1'] = 0, ['decals_2'] = 0,
                  ['helmet_1'] = -1, ['helmet_2'] = 0,
                  ['bags_1'] = 0, ['bags_2'] = 0,
                }
                TriggerEvent('skinchanger:loadClothes', skin, clothesSkin)

            else

                local clothesSkin = {
                  ['tshirt_1'] = 2, ['tshirt_2'] = 0,
                  ['torso_1'] = 2, ['torso_2'] = 0,
                  ['arms'] = 14,
                  ['pants_1'] = 1, ['pants_2'] = 0,
                  ['shoes_1'] = 9, ['shoes_2'] = 0,
                  ['chain_1'] = 1, ['chain_2'] = 0,
                  ['mask_1'] = 121, ['mask_2'] = 0,
                  ['decals_1'] = 1, ['decals_2'] = 0,
                  ['helmet_1'] = -1, ['helmet_2'] = 0,
                  ['bags_1'] = 0, ['bags_2'] = 0,
                }
                TriggerEvent('skinchanger:loadClothes', skin, clothesSkin)

            end

            local playerPed = GetPlayerPed(-1)
            SetPedArmour(playerPed, 0)
            ClearPedBloodDamage(playerPed)
            ResetPedVisibleDamage(playerPed)
            ClearPedLastWeaponDamage(playerPed)
            
        end)
      end

      if data.current.value == 'insats_wear' then
        TriggerEvent('skinchanger:getSkin', function(skin)
        
            if skin.sex == 0 then

                local clothesSkin = {
					['bproof_1'] = 16, ['bproof_2'] = 2
                }
                TriggerEvent('skinchanger:loadClothes', skin, clothesSkin)

            else

                local clothesSkin = {
                    ['bproof_1'] = 18, ['bproof_2'] = 2
                }
                TriggerEvent('skinchanger:loadClothes', skin, clothesSkin)

            end

            local playerPed = GetPlayerPed(-1)
            SetPedArmour(playerPed, 100)
            ClearPedBloodDamage(playerPed)
            ResetPedVisibleDamage(playerPed)
            ClearPedLastWeaponDamage(playerPed)
            
        end)
      end

      CurrentAction     = 'menu_cloakroom'
      CurrentActionMsg  = _U('open_cloackroom')
      CurrentActionData = {}

    end,
    function(data, menu)

      menu.close()

      CurrentAction     = 'menu_cloakroom'
      CurrentActionMsg  = _U('open_cloackroom')
      CurrentActionData = {}
    end
  )

end

function OpenArmoryMenu(station)

  if Config.EnableArmoryManagement then

    local elements = {
      {label = _U('get_weapon'), value = 'get_weapon'},
      {label = _U('put_weapon'), value = 'put_weapon'},
      {label = 'Ta ut beslagtagna föremål',  value = 'get_stock'},
      {label = 'Lagra beslagtagna föremål',  value = 'put_stock'}
    }

    if PlayerData.job.grade_name == 'boss' then
      table.insert(elements, {label = _U('buy_weapons'), value = 'buy_weapons'})
    end

    ESX.UI.Menu.CloseAll()

    ESX.UI.Menu.Open(
      'default', GetCurrentResourceName(), 'armory',
      {
        title    = _U('armory'),
        align    = 'top-left',
        elements = elements,
      },
      function(data, menu)

        if data.current.value == 'get_weapon' then
          OpenGetWeaponMenu()
        end

        if data.current.value == 'put_weapon' then
          OpenPutWeaponMenu()
        end

        if data.current.value == 'buy_weapons' then
          OpenBuyWeaponsMenu(station)
        end

        if data.current.value == 'put_stock' then
              OpenPutStocksMenu()
            end

            if data.current.value == 'get_stock' then
              OpenGetStocksMenu()
            end

      end,
      function(data, menu)

        menu.close()

        CurrentAction     = 'menu_armory'
        CurrentActionMsg  = _U('open_armory')
        CurrentActionData = {station = station}
      end
    )

  else

    local elements = {}

    for i=1, #Config.PoliceStations[station].AuthorizedWeapons, 1 do
      local weapon = Config.PoliceStations[station].AuthorizedWeapons[i]
      table.insert(elements, {label = ESX.GetWeaponLabel(weapon.name), value = weapon.name})
    end

    ESX.UI.Menu.CloseAll()

    ESX.UI.Menu.Open(
      'default', GetCurrentResourceName(), 'armory',
      {
        title    = _U('armory'),
        align    = 'top-left',
        elements = elements,
      },
      function(data, menu)
        local weapon = data.current.value
        TriggerServerEvent('esx_policejob:giveWeapon', weapon,  1000)
      end,
      function(data, menu)

        menu.close()

        CurrentAction     = 'menu_armory'
        CurrentActionMsg  = _U('open_armory')
        CurrentActionData = {station = station}

      end
    )

  end

end

function OpenVehicleSpawnerMenu(station, partNum)

  local vehicles = Config.PoliceStations[station].Vehicles

  ESX.UI.Menu.CloseAll()

  if Config.EnableSocietyOwnedVehicles then

    local elements = {}

    ESX.TriggerServerCallback('esx_society:getVehiclesInGarage', function(garageVehicles)

      for i=1, #garageVehicles, 1 do
        table.insert(elements, {label = GetDisplayNameFromVehicleModel(garageVehicles[i].model) .. ' [' .. garageVehicles[i].plate .. ']', value = garageVehicles[i]})
      end

      ESX.UI.Menu.Open(
        'default', GetCurrentResourceName(), 'vehicle_spawner',
        {
          title    = _U('vehicle_menu'),
          align    = 'top-left',
          elements = elements,
        },
        function(data, menu)

          menu.close()

          local vehicleProps = data.current.value

          ESX.Game.SpawnVehicle(vehicleProps.model, vehicles[partNum].SpawnPoint, 270.0, function(vehicle)
          local props = ESX.Game.GetVehicleProperties(vehicle)

          props.plate = 'POLIS'

          ESX.Game.SetVehicleProperties(vehicle, props)

          TriggerEvent("advancedFuel:setEssence", 100, GetVehicleNumberPlateText(vehicle), GetDisplayNameFromVehicleModel(GetEntityModel(vehicle)))
          local playerPed = GetPlayerPed(-1)
          TaskWarpPedIntoVehicle(playerPed,  vehicle,  -1)
          end)

          TriggerServerEvent('esx_society:removeVehicleFromGarage', 'police', vehicleProps)

        end,
        function(data, menu)

          menu.close()

          CurrentAction     = 'menu_vehicle_spawner'
          CurrentActionMsg  = _U('vehicle_spawner')
          CurrentActionData = {station = station, partNum = partNum}

        end
      )

    end, 'police')

  else

    local elements = {}
   
    
      table.insert(elements, { label = 'Radiobil: Volvo XC70', value = 'police'})
      table.insert(elements, { label = 'Radiobil: Volvo V90', value = 'police2'})  
      table.insert(elements, { label = 'Radiobil: Volvo V70', value = 'fbi'})
      table.insert(elements, { label = 'Radiobil: Volvo V90 Cross Country', value = 'police3'})
      table.insert(elements, { label = 'Civilbil: Volvo XC70', value = 'sheriff'})

	 if PlayerData.job.grade_name == 'Recruit' then
    table.insert(elements, { label = 'Radiobil: Volvo XC70 2010', value = 'police'})
    table.insert(elements, { label = 'Radiobil: Volvo XC70 2018', value = 'police3'})
    table.insert(elements, { label = 'Radiobil: Volvo V70', value = 'fbi'})
    table.insert(elements, { label = 'Radiobil: Volvo V90', value = 'police2'})
    table.insert(elements, { label = 'Civilbil: Volvo XC70', value = 'sheriff'})  

   end

    if PlayerData.job.grade_name == 'Officer' then
	    table.insert(elements, { label = 'Radiobil: Volvo XC70 2010', value = 'police'})
      table.insert(elements, { label = 'Radiobil: Volvo XC70 2018', value = 'police3'})
	    table.insert(elements, { label = 'Radiobil: Volvo V70', value = 'fbi'})
      table.insert(elements, { label = 'Radiobil: Volvo V90', value = 'police2'})
      table.insert(elements, { label = 'Civilbil: Volvo XC70', value = 'sheriff'})  
    end

    if PlayerData.job.grade_name == 'Sergeant' then
	    table.insert(elements, { label = 'Radiobil: Volvo XC70 2010', value = 'police'})
      table.insert(elements, { label = 'Radiobil: Volvo XC70 2018', value = 'police3'})
	    table.insert(elements, { label = 'Radiobil: Volvo V70', value = 'fbi'})
      table.insert(elements, { label = 'Radiobil: Volvo V90', value = 'police2'})
      table.insert(elements, { label = 'Civilbil: Volvo XC70', value = 'sheriff'})  
    end

    if PlayerData.job.grade_name == 'Lieutenant' then
	    table.insert(elements, { label = 'Radiobil: Volvo XC70 2010', value = 'police'})
      table.insert(elements, { label = 'Radiobil: Volvo XC70 2018', value = 'police3'})
	    table.insert(elements, { label = 'Radiobil: Volvo V70', value = 'fbi'})
      table.insert(elements, { label = 'Radiobil: Volvo V90', value = 'police2'})
      table.insert(elements, { label = 'Civilbil: Volvo XC70', value = 'sheriff'})  
    end

    if PlayerData.job.grade_name == 'Boss' then
	    table.insert(elements, { label = 'Radiobil: Volvo XC70 2010', value = 'police'})
      table.insert(elements, { label = 'Radiobil: Volvo XC70 2018', value = 'police3'})
	    table.insert(elements, { label = 'Radiobil: Volvo V70', value = 'fbi'})
      table.insert(elements, { label = 'Radiobil: Volvo V90', value = 'police2'})
      table.insert(elements, { label = 'Civilbil: Volvo XC70', value = 'sheriff'})  
    end

    ESX.UI.Menu.Open(
      'default', GetCurrentResourceName(), 'vehicle_spawner',
      {
        title    = _U('vehicle_menu'),
        align    = 'top-left',
        elements = elements,
      },
      function(data, menu)

        menu.close()

        local model = data.current.value

        local vehicle = GetClosestVehicle(vehicles[partNum].SpawnPoint.x,  vehicles[partNum].SpawnPoint.y,  vehicles[partNum].SpawnPoint.z,  3.0,  0,  71)

        if not DoesEntityExist(vehicle) then

          local playerPed = GetPlayerPed(-1)

          if Config.MaxInService == -1 then

            ESX.Game.SpawnVehicle(model, {
              x = vehicles[partNum].SpawnPoint.x,
              y = vehicles[partNum].SpawnPoint.y,
              z = vehicles[partNum].SpawnPoint.z
            }, vehicles[partNum].Heading, function(vehicle)
              local props = ESX.Game.GetVehicleProperties(vehicle)

              props.plate = 'POLIS'

              ESX.Game.SetVehicleProperties(vehicle, props)

              TriggerEvent("advancedFuel:setEssence", 100, GetVehicleNumberPlateText(vehicle), GetDisplayNameFromVehicleModel(GetEntityModel(vehicle)))
              local playerPed = GetPlayerPed(-1)
              TaskWarpPedIntoVehicle(playerPed,  vehicle,  -1)
            end)

          else

            ESX.TriggerServerCallback('esx_service:enableService', function(canTakeService, maxInService, inServiceCount)

              if canTakeService then

                ESX.Game.SpawnVehicle(model, {
                  x = vehicles[partNum].SpawnPoint.x,
                  y = vehicles[partNum].SpawnPoint.y,
                  z = vehicles[partNum].SpawnPoint.z
                }, vehicles[partNum].Heading, function(vehicle)
                  TaskWarpPedIntoVehicle(playerPed,  vehicle,  -1)
                end)

              else
                ESX.ShowNotification(_U('service_max') .. inServiceCount .. '/' .. maxInService)
              end

            end, 'police')

          end

        else
          ESX.ShowNotification(_U('vehicle_out'))
        end

      end,
      function(data, menu)

        menu.close()

        CurrentAction     = 'menu_vehicle_spawner'
        CurrentActionMsg  = _U('vehicle_spawner')
        CurrentActionData = {station = station, partNum = partNum}

      end
    )

  end

end

function OpenPoliceActionsMenu()

  ESX.UI.Menu.CloseAll()

  ESX.UI.Menu.Open(
    'default', GetCurrentResourceName(), 'police_actions',
    {
      title    = 'Polismeny',
      align    = 'top-left',
      elements = {
        {label = _U('citizen_interaction'), value = 'citizen_interaction'},
        {label = _U('vehicle_interaction'), value = 'vehicle_interaction'},
        {label = "Fängelseåtgärder",               value = 'jail_menu'},
        {label = _U('object_spawner'),      value = 'object_spawner'},
      },
    },
    function(data, menu)

      if data.current.value == 'jail_menu' then
        TriggerEvent("esx-qalle-jail:openJailMenu")
      end

      if data.current.value == 'citizen_interaction' then

        ESX.UI.Menu.Open(
          'default', GetCurrentResourceName(), 'citizen_interaction',
          {
            title    = _U('citizen_interaction'),
            align    = 'top-left',
            elements = {
              {label = _U('id_card'),         value = 'identity_card'},
              {label = 'Kontrollera Körkort', value = 'fines_check'},
              {label = _U('search'),          value = 'body_search'},
              {label = 'Handfängsel på / av',   value = 'handcuff'},
              {label = _U('drag'),      	  value = 'drag'},
              {label = _U('put_in_vehicle'),  value = 'put_in_vehicle'},
              {label = _U('out_the_vehicle'), value = 'out_the_vehicle'},
              {label = _U('fine'),            value = 'fine'},
              --{label = 'Ta DNA-Prov', value = 'dna'},
              --{label = _U('fine_history'),    value = 'fine_history'},
			  -- {label = _U('codedmv'),      value = 'codedmv'},
			  --label = _U('codedrive'),       value = 'codedrive'},
			  --{label = _U('codedrivebike'),   value = 'codedrivebike'},
			  --{label = _U('codedrivetruck'),  value = 'codedrivetruck'},
			  --{label = _U('weaponlicense'),   value = 'weaponlicense'},
			  {label = ('Hjärt & Lungräddning'),   value = 'revive'},
			  
            },
          },
           function(data2, menu2)

            local player, distance = ESX.Game.GetClosestPlayer()

            if distance ~= -1 and distance <= 3.0 then


              if data2.current.value == 'dna' then
                TriggerEvent('jsfour-dna:get', player)
              end

              if data2.current.value == 'identity_card' then
                OpenIdentityCardMenu(player)
              end

              if data2.current.value == 'body_search' then
                OpenBodySearchMenu(player)
              end

              if data2.current.value == 'fines_check' then
                  ESX.TriggerServerCallback('esx_qalle:getLicenses', function (licenses)

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
                              title    = 'Körkortsbehållare',
                              align = 'top-left',
                              elements = elements

                          },
                          function(data3, menu3)
                          

                          end,

                          function(data3, menu3)
                          menu3.close()
                      end
                        )
                      end, GetPlayerServerId(player))   
              end

              if data2.current.value == 'pistol_krut' then
                TriggerEvent('esx_guntest:checkGun', source)
              end

              if data2.current.value == 'handcuff' then
                TriggerServerEvent('esx_policejob:handcuff', GetPlayerServerId(player))
              end

              if data2.current.value == 'unhandcuff' then
                TriggerServerEvent('esx_policejob:unhandcuff', GetPlayerServerId(player))
              end

              if data2.current.value == 'drag' then
                TriggerServerEvent('esx_policejob:drag', GetPlayerServerId(closestPlayer))
              end

              if data2.current.value == 'put_in_vehicle' then
                TriggerServerEvent('esx_policejob:putInVehicle', GetPlayerServerId(player))
              end

              if data2.current.value == 'out_the_vehicle' then
                  TriggerServerEvent('esx_policejob:OutVehicle', GetPlayerServerId(player))
              end

              if data2.current.value == 'fine' then
                OpenFineMenu(player)
              end

              if data2.current.value == 'fine_history' then
                OpenFineHistoryMenu(player)
              end
			  
			  if data2.current.value == 'code' then
                TriggerServerEvent('esx_policejob:codedmv', GetPlayerServerId(player))
              end
			  
			  if data2.current.value == 'codedrive' then
                TriggerServerEvent('esx_policejob:codedrive', GetPlayerServerId(player))
              end
			  
			  if data2.current.value == 'codedrivebike' then
                TriggerServerEvent('esx_policejob:codedrivebike', GetPlayerServerId(player))
              end
			  
			  if data2.current.value == 'codedrivetruck' then
                TriggerServerEvent('esx_policejob:codedrivetruck', GetPlayerServerId(player))
              end 
			  
			  if data2.current.value == 'weaponlicense' then
                TriggerServerEvent('esx_policejob:weaponlicense', GetPlayerServerId(player))
              end
			  
			  if data2.current.value == 'revive' then

				menu.close()

				local closestPlayer, closestDistance = ESX.Game.GetClosestPlayer()

				if closestPlayer == -1 or closestDistance > 3.0 then
					sendNotification('Ingen person i närheten.', 'error', 2500)
				else

					local ped    = GetPlayerPed(closestPlayer)
					local health = GetEntityHealth(ped)
					local ped    = GetPlayerPed(closestPlayer)
					local health = GetEntityHealth(ped)

					if health < 100 then

						local playerPed        = GetPlayerPed(-1)
						local closestPlayerPed = GetPlayerPed(closestPlayer)

						Citizen.CreateThread(function()

							ESX.ShowNotification(_U('revive_inprogress'))
							RequestAnimDict("missheistfbi3b_ig8_2")
							RequestAnimDict("mini@cpr@char_a@cpr_def")
							while not HasAnimDictLoaded("missheistfbi3b_ig8_2") do
								Citizen.Wait(0)
							end
							while not HasAnimDictLoaded("mini@cpr@char_a@cpr_def") do
								Citizen.Wait(0)
							end
							TaskPlayAnim(GetPlayerPed(-1), "mini@cpr@char_a@cpr_def" ,"cpr_intro" ,8.0, -8.0, -1, 1, 0, false, false, false )
							Citizen.Wait(12000)
							TaskPlayAnim(GetPlayerPed(-1), "missheistfbi3b_ig8_2" ,"cpr_loop_paramedic" ,8.0, -8.0, -1, 1, 0, false, false, false )
							Citizen.Wait(10000)
							ClearPedTasks(playerPed)

							if GetEntityHealth(closestPlayerPed) == 0 then
								TriggerServerEvent('esx_ambulancejob:revive', GetPlayerServerId(closestPlayer))
								ESX.ShowNotification(_U('revive_complete') .. GetPlayerName(closestPlayer))
							else
								ESX.ShowNotification(GetPlayerName(closestPlayer) .. _U('isdead'))
							end

						end)

					else
						ESX.ShowNotification(GetPlayerName(closestPlayer) .. _U('unconscious'))
					end
				end
			end

            else
              sendNotification('Ingen person i närheten.', 'error', 2500)
            end

          end,
          function(data2, menu2)
            menu2.close()
          end
        )

      end

      if data.current.value == 'vehicle_interaction' then

        ESX.UI.Menu.Open(
          'default', GetCurrentResourceName(), 'vehicle_interaction',
          {
            title    = _U('vehicle_interaction'),
            align    = 'top-left',
            elements = {
              {label = 'Kolla Fordonsplåtnummer', value = 'plate'},
              --{label = _U('vehicle_info'), value = 'vehicle_infos'},
              {label = _U('pick_lock'),    value = 'hijack_vehicle'},
            },
          },
          function(data2, menu2)

            local playerPed = GetPlayerPed(-1)
            local coords    = GetEntityCoords(playerPed)
            local vehicle   = GetClosestVehicle(coords.x,  coords.y,  coords.z,  3.0,  0,  71)

            if data2.current.value == 'plate' then
              LookupVehicle()
            end

            if DoesEntityExist(vehicle) then

              local vehicleData = ESX.Game.GetVehicleProperties(vehicle)

              if data2.current.value == 'vehicle_infos' then
                OpenVehicleInfosMenu(vehicleData)
              end

              if data2.current.value == 'hijack_vehicle' then

                local playerPed = GetPlayerPed(-1)
                local coords    = GetEntityCoords(playerPed)

                if IsAnyVehicleNearPoint(coords.x, coords.y, coords.z, 3.0) then

                  local vehicle = GetClosestVehicle(coords.x,  coords.y,  coords.z,  3.0,  0,  71)

                  if DoesEntityExist(vehicle) then

                    Citizen.CreateThread(function()

                      TaskStartScenarioInPlace(playerPed, "WORLD_HUMAN_WELDING", 0, true)

                      Wait(20000)

                      ClearPedTasksImmediately(playerPed)

                      SetVehicleDoorsLocked(vehicle, 1)
                      SetVehicleDoorsLockedForAllPlayers(vehicle, false)

                      sendNotification('Bilen är upplåst.', 'error', 2500)

                    end)

                  end

                end

              end

            else
              sendNotification('Inga fordon i närhetem.', 'error', 2500)
            end

          end,
          function(data2, menu2)
            menu2.close()
          end
        )

      end

      if data.current.value == 'object_spawner' then

        ESX.UI.Menu.Open(
          'default', GetCurrentResourceName(), 'citizen_interaction',
          {
            title    = _U('traffic_interaction'),
            align    = 'top-left',
            elements = {
              {label = _U('cone'),     value = 'prop_roadcone02a'},
              {label = _U('barrier'), value = 'prop_barrier_work06a'},
              {label = _U('spikestrips'),    value = 'p_ld_stinger_s'},
              --{label = _U('box'),   value = 'prop_boxpile_07d'},
              --{label = _U('cash'),   value = 'hei_prop_cash_crate_half_full'}
            },
          },
          function(data2, menu2)


            local model     = data2.current.value
            local playerPed = GetPlayerPed(-1)
            local coords    = GetEntityCoords(playerPed)
            local forward   = GetEntityForwardVector(playerPed)
            local x, y, z   = table.unpack(coords + forward * 1.0)

            if model == 'prop_roadcone02a' then
              z = z - 2.0
            end

            ESX.Game.SpawnObject(model, {
              x = x,
              y = y,
              z = z
            }, function(obj)
              SetEntityHeading(obj, GetEntityHeading(playerPed))
              PlaceObjectOnGroundProperly(obj)
            end)

          end,
          function(data2, menu2)
            menu2.close()
          end
        )

      end      
	  
    if data.current.value == 'radar_spawner' then
    TriggerEvent('esx_policejob:POLICE_radar')
      end       

    end,
    function(data, menu)

      menu.close()

    end
  )

end

function OpenIdentityCardMenu(player)

  if Config.EnableESXIdentity then

    ESX.TriggerServerCallback('esx_policejob:getOtherPlayerData', function(data)

--      local jobLabel    = nil
      local sexLabel    = nil
      local sex         = nil
      local dobLabel    = nil
      local heightLabel = nil
      local idLabel     = nil

--      if data.job.grade_label ~= nil and  data.job.grade_label ~= '' then
--        jobLabel = 'Job : ' .. data.job.label .. ' - ' .. data.job.grade_label
--      else
--        jobLabel = 'Job : ' .. data.job.label
--      end

      if data.sex ~= nil then
        if (data.sex == 'm') or (data.sex == 'M') then
          sex = 'Man'
        else
          sex = 'Kvinna'
        end
        sexLabel = 'Kön : ' .. sex
      else
        sexLabel = 'Kön : Okänt'
      end

      if data.dob ~= nil then
        dobLabel = 'Personnummer : ' .. data.dob
      else
        dobLabel = 'Personnummer : Okänt'
      end

      if data.height ~= nil then
        heightLabel = 'Längd : ' .. data.height .. ' cm'
      else
        heightLabel = 'Längd : Okänt'
      end

      if data.name ~= nil then
        idLabel = 'Medborgarens nummer : ' .. GetPlayerServerId(player)
      else
        idLabel = 'Medborgarens nummer är okänt'
      end

      local elements = {
        {label = _U('name') .. data.firstname .. " " .. data.lastname, value = nil},
        {label = sexLabel,    value = nil},
        {label = dobLabel,    value = nil},
        {label = heightLabel, value = nil},
--        {label = jobLabel,    value = nil},
        {label = idLabel,     value = nil},
      }

      if data.drunk ~= nil then
        table.insert(elements, {label = _U('bac') .. data.drunk .. '%', value = nil})
      end

      if data.licenses ~= nil then

        table.insert(elements, {label = '--- Licenses ---', value = nil})

        for i=1, #data.licenses, 1 do
          table.insert(elements, {label = data.licenses[i].label, value = nil})
        end

      end

      ESX.UI.Menu.Open(
        'default', GetCurrentResourceName(), 'citizen_interaction',
        {
          title    = _U('citizen_interaction'),
          align    = 'top-left',
          elements = elements,
        },
        function(data, menu)

        end,
        function(data, menu)
          menu.close()
        end
      )

    end, GetPlayerServerId(player))

  else

    ESX.TriggerServerCallback('esx_policejob:getOtherPlayerData', function(data)

--      local jobLabel = nil

--      if data.job.grade_label ~= nil and  data.job.grade_label ~= '' then
--        jobLabel = 'Job : ' .. data.job.label .. ' - ' .. data.job.grade_label
--      else
--        jobLabel = 'Job : ' .. data.job.label
--      end

--        local elements = {
--          {label = _U('name') .. data.name, value = nil},
--          {label = jobLabel,              value = nil},
--        }

      if data.drunk ~= nil then
        table.insert(elements, {label = _U('bac') .. data.drunk .. '%', value = nil})
      end

      if data.licenses ~= nil then

        table.insert(elements, {label = '--- Licenses ---', value = nil})

        for i=1, #data.licenses, 1 do
          table.insert(elements, {label = data.licenses[i].label, value = nil})
        end

      end

      ESX.UI.Menu.Open(
        'default', GetCurrentResourceName(), 'citizen_interaction',
        {
          title    = _U('citizen_interaction'),
          align    = 'top-left',
          elements = elements,
        },
        function(data, menu)

        end,
        function(data, menu)
          menu.close()
        end
      )

    end, GetPlayerServerId(player))

  end

end

function OpenBodySearchMenu(player)

  ESX.TriggerServerCallback('esx_policejob:getOtherPlayerData', function(data)

    local elements = {}

    local blackMoney = 0

    for i=1, #data.accounts, 1 do
      if data.accounts[i].name == 'black_money' then
        blackMoney = data.accounts[i].money
      end
    end

    table.insert(elements, {
      label          = _U('confiscate_dirty') .. blackMoney,
      value          = 'black_money',
      itemType       = 'item_account',
      amount         = blackMoney
    })

    table.insert(elements, {label = '--- Vapen ---', value = nil})

    for i=1, #data.weapons, 1 do
      table.insert(elements, {
        label          = _U('confiscate') .. ESX.GetWeaponLabel(data.weapons[i].name),
        value          = data.weapons[i].name,
        itemType       = 'item_weapon',
        amount         = data.ammo,
      })
    end

    table.insert(elements, {label = _U('inventory_label'), value = nil})

    for i=1, #data.inventory, 1 do
      if data.inventory[i].count > 0 then
        table.insert(elements, {
          label          = _U('confiscate_inv') .. data.inventory[i].count .. ' ' .. data.inventory[i].label,
          value          = data.inventory[i].name,
          itemType       = 'item_standard',
          amount         = data.inventory[i].count,
        })
      end
    end


    ESX.UI.Menu.Open(
      'default', GetCurrentResourceName(), 'body_search',
      {
        title    = _U('search'),
        align    = 'top-left',
        elements = elements,
      },
      function(data, menu)

        local itemType = data.current.itemType
        local itemName = data.current.value
        local amount   = data.current.amount

        if data.current.value ~= nil then

          TriggerServerEvent('esx_policejob:confiscatePlayerItem', GetPlayerServerId(player), itemType, itemName, amount)

          OpenBodySearchMenu(player)

        end

      end,
      function(data, menu)
        menu.close()
      end
    )

  end, GetPlayerServerId(player))

end

function OpenFineMenu(player)

  ESX.UI.Menu.Open(
    'default', GetCurrentResourceName(), 'fine',
    {
      title    = _U('fine'),
      align    = 'top-left',
      elements = {
        {label = _U('traffic_offense'),   value = 0},
        {label = _U('minor_offense'),     value = 1},
        {label = _U('average_offense'),   value = 2},
        {label = _U('major_offense'),     value = 3}
      },
    },
    function(data, menu)

      OpenFineCategoryMenu(player, data.current.value)

    end,
    function(data, menu)
      menu.close()
    end
  )

end

function OpenFineHistoryMenu(player, category)

  ESX.TriggerServerCallback('esx_kekke_fine_history:getFineHistory', function(fines)

    local elements = {}

    for i=1, #fines, 1 do
      table.insert(elements, {
        label     = fines[i].label .. ' SEK ' .. fines[i].amount,
        value = i
      })
    end

    ESX.UI.Menu.Open(
      'default', GetCurrentResourceName(), 'fine_history',
      {
        title    = _U('fine_history'),
        align    = 'top-left',
        elements = elements,
      },
      function(data, menu)

      end,
      function(data, menu)
        menu.close()
      end
    )

  end, GetPlayerServerId(player))

end

function OpenFineCategoryMenu(player, category)

  ESX.TriggerServerCallback('esx_policejob:getFineList', function(fines)

    local elements = {}

    for i=1, #fines, 1 do
      table.insert(elements, {
        label     = fines[i].label .. ' SEK ' .. fines[i].amount,
        value     = fines[i].id,
        amount    = fines[i].amount,
        fineLabel = fines[i].label
      })
    end

    ESX.UI.Menu.Open(
      'default', GetCurrentResourceName(), 'fine_category',
      {
        title    = _U('fine'),
        align    = 'top-left',
        elements = elements,
      },
      function(data, menu)

        local label  = data.current.fineLabel
        local amount = data.current.amount

        menu.close()

        if Config.EnablePlayerManagement then
          --local xPlayer = ESX.GetPlayerFromId(GetPlayerServerId(player))
          TriggerServerEvent('esx_kekke_fine_history:addFineHistory', GetPlayerServerId(player), label, amount)
          TriggerServerEvent('esx_billing:sendBill', GetPlayerServerId(player), 'society_police', _U('fine_total') .. label, amount)
        else
          TriggerServerEvent('esx_billing:sendBill', GetPlayerServerId(player), '', _U('fine_total') .. label, amount)
        end

        ESX.SetTimeout(300, function()
          OpenFineCategoryMenu(player, category)
        end)

      end,
      function(data, menu)
        menu.close()
      end
    )

  end, category)

end

function OpenVehicleInfosMenu(vehicleData)

  ESX.TriggerServerCallback('esx_policejob:getVehicleInfos', function(infos)

    local elements = {}

    table.insert(elements, {label = _U('plate') .. infos.plate, value = nil})

    if infos.owner == nil then
      table.insert(elements, {label = _U('owner_unknown'), value = nil})
    else
      table.insert(elements, {label = _U('owner') .. infos.owner, value = nil})
    end

    ESX.UI.Menu.Open(
      'default', GetCurrentResourceName(), 'vehicle_infos',
      {
        title    = _U('vehicle_info'),
        align    = 'top-left',
        elements = elements,
      },
      nil,
      function(data, menu)
        menu.close()
      end
    )

  end, vehicleData.plate)

end

function OpenGetWeaponMenu()

  ESX.TriggerServerCallback('esx_policejob:getArmoryWeapons', function(weapons)

    local elements = {}

    for i=1, #weapons, 1 do
      if weapons[i].count > 0 then
        table.insert(elements, {label = 'x' .. weapons[i].count .. ' ' .. ESX.GetWeaponLabel(weapons[i].name), value = weapons[i].name})
      end
    end

    ESX.UI.Menu.Open(
      'default', GetCurrentResourceName(), 'armory_get_weapon',
      {
        title    = _U('get_weapon_menu'),
        align    = 'top-left',
        elements = elements,
      },
      function(data, menu)

        menu.close()

        ESX.TriggerServerCallback('esx_policejob:removeArmoryWeapon', function()
          OpenGetWeaponMenu()
        end, data.current.value)

      end,
      function(data, menu)
        menu.close()
      end
    )

  end)

end

function OpenPutWeaponMenu()

  local elements   = {}
  local playerPed  = GetPlayerPed(-1)
  local weaponList = ESX.GetWeaponList()

  for i=1, #weaponList, 1 do

    local weaponHash = GetHashKey(weaponList[i].name)

    if HasPedGotWeapon(playerPed,  weaponHash,  false) and weaponList[i].name ~= 'WEAPON_UNARMED' then
      local ammo = GetAmmoInPedWeapon(playerPed, weaponHash)
      table.insert(elements, {label = weaponList[i].label, value = weaponList[i].name})
    end

  end

  ESX.UI.Menu.Open(
    'default', GetCurrentResourceName(), 'armory_put_weapon',
    {
      title    = _U('put_weapon_menu'),
      align    = 'top-left',
      elements = elements,
    },
    function(data, menu)

      menu.close()

      ESX.TriggerServerCallback('esx_policejob:addArmoryWeapon', function()
        OpenPutWeaponMenu()
      end, data.current.value)

    end,
    function(data, menu)
      menu.close()
    end
  )

end

function OpenBuyWeaponsMenu(station)

  ESX.TriggerServerCallback('esx_policejob:getArmoryWeapons', function(weapons)

    local elements = {}

    for i=1, #Config.PoliceStations[station].AuthorizedWeapons, 1 do

      local weapon = Config.PoliceStations[station].AuthorizedWeapons[i]
      local count  = 0

      for i=1, #weapons, 1 do
        if weapons[i].name == weapon.name then
          count = weapons[i].count
          break
        end
      end

      table.insert(elements, {label = 'x' .. count .. ' ' .. ESX.GetWeaponLabel(weapon.name) .. ' $' .. weapon.price, value = weapon.name, price = weapon.price})

    end

    ESX.UI.Menu.Open(
      'default', GetCurrentResourceName(), 'armory_buy_weapons',
      {
        title    = _U('buy_weapon_menu'),
        align    = 'top-left',
        elements = elements,
      },
      function(data, menu)

        ESX.TriggerServerCallback('esx_policejob:buy', function(hasEnoughMoney)

          if hasEnoughMoney then
            ESX.TriggerServerCallback('esx_policejob:addArmoryWeapon', function()
              OpenBuyWeaponsMenu(station)
            end, data.current.value)
          else
            sendNotification('Du har inte tillräckligt med pengar.', 'error', 2500)
          end

        end, data.current.price)

      end,
      function(data, menu)
        menu.close()
      end
    )

  end)

end

function OpenGetStocksMenu()

  ESX.TriggerServerCallback('esx_policejob:getStockItems', function(items)

    print(json.encode(items))

    local elements = {}

    for i=1, #items, 1 do
      table.insert(elements, {label = 'x' .. items[i].count .. ' ' .. items[i].label, value = items[i].name})
    end

    ESX.UI.Menu.Open(
      'default', GetCurrentResourceName(), 'stocks_menu',
      {
        title    = _U('police_stock'),
        elements = elements
      },
      function(data, menu)

        local itemName = data.current.value

        ESX.UI.Menu.Open(
          'dialog', GetCurrentResourceName(), 'stocks_menu_get_item_count',
          {
            title = _U('quantity')
          },
          function(data2, menu2)

            local count = tonumber(data2.value)

            if count == nil then
              sendNotification('Ogiltigt antal.', 'error', 2500)
            else
              menu2.close()
              menu.close()
              OpenGetStocksMenu()

              TriggerServerEvent('esx_policejob:getStockItem', itemName, count)
            end

          end,
          function(data2, menu2)
            menu2.close()
          end
        )

      end,
      function(data, menu)
        menu.close()
      end
    )

  end)

end

function OpenPutStocksMenu()

  ESX.TriggerServerCallback('esx_policejob:getPlayerInventory', function(inventory)

    local elements = {}

    for i=1, #inventory.items, 1 do

      local item = inventory.items[i]

      if item.count > 0 then
        table.insert(elements, {label = item.label .. ' x' .. item.count, type = 'item_standard', value = item.name})
      end

    end

    ESX.UI.Menu.Open(
      'default', GetCurrentResourceName(), 'stocks_menu',
      {
        title    = _U('inventory'),
        elements = elements
      },
      function(data, menu)

        local itemName = data.current.value

        ESX.UI.Menu.Open(
          'dialog', GetCurrentResourceName(), 'stocks_menu_put_item_count',
          {
            title = _U('quantity')
          },
          function(data2, menu2)

            local count = tonumber(data2.value)

            if count == nil then
              sendNotification('Ogiltigt antal.', 'error', 2500)
            else
              menu2.close()
              menu.close()
              OpenPutStocksMenu()

              TriggerServerEvent('esx_policejob:putStockItems', itemName, count)
            end

          end,
          function(data2, menu2)
            menu2.close()
          end
        )

      end,
      function(data, menu)
        menu.close()
      end
    )

  end)

end

RegisterNetEvent('esx:playerLoaded')
AddEventHandler('esx:playerLoaded', function(xPlayer)
  PlayerData = xPlayer
end)

RegisterNetEvent('esx:setJob')
AddEventHandler('esx:setJob', function(job)
  PlayerData.job = job
end)

RegisterNetEvent('esx_phone:loaded')
AddEventHandler('esx_phone:loaded', function(phoneNumber, contacts)

  local specialContact = {
    name       = 'Polisen',
    number     = 'police',
    base64Icon = 'data:image/png;base64,iVBORw0KGgoAAAANSUhEUgAAACAAAAAgCAYAAABzenr0AAAAGXRFWHRTb2Z0d2FyZQBBZG9iZSBJbWFnZVJlYWR5ccllPAAAAyZpVFh0WE1MOmNvbS5hZG9iZS54bXAAAAAAADw/eHBhY2tldCBiZWdpbj0i77u/IiBpZD0iVzVNME1wQ2VoaUh6cmVTek5UY3prYzlkIj8+IDx4OnhtcG1ldGEgeG1sbnM6eD0iYWRvYmU6bnM6bWV0YS8iIHg6eG1wdGs9IkFkb2JlIFhNUCBDb3JlIDUuNi1jMTM4IDc5LjE1OTgyNCwgMjAxNi8wOS8xNC0wMTowOTowMSAgICAgICAgIj4gPHJkZjpSREYgeG1sbnM6cmRmPSJodHRwOi8vd3d3LnczLm9yZy8xOTk5LzAyLzIyLXJkZi1zeW50YXgtbnMjIj4gPHJkZjpEZXNjcmlwdGlvbiByZGY6YWJvdXQ9IiIgeG1sbnM6eG1wPSJodHRwOi8vbnMuYWRvYmUuY29tL3hhcC8xLjAvIiB4bWxuczp4bXBNTT0iaHR0cDovL25zLmFkb2JlLmNvbS94YXAvMS4wL21tLyIgeG1sbnM6c3RSZWY9Imh0dHA6Ly9ucy5hZG9iZS5jb20veGFwLzEuMC9zVHlwZS9SZXNvdXJjZVJlZiMiIHhtcDpDcmVhdG9yVG9vbD0iQWRvYmUgUGhvdG9zaG9wIENDIDIwMTcgKFdpbmRvd3MpIiB4bXBNTTpJbnN0YW5jZUlEPSJ4bXAuaWlkOjQwRDQzQzU2QzI0NzExRTc4RTFBQjBFMjg3NTExRjFCIiB4bXBNTTpEb2N1bWVudElEPSJ4bXAuZGlkOjQwRDQzQzU3QzI0NzExRTc4RTFBQjBFMjg3NTExRjFCIj4gPHhtcE1NOkRlcml2ZWRGcm9tIHN0UmVmOmluc3RhbmNlSUQ9InhtcC5paWQ6NDBENDNDNTRDMjQ3MTFFNzhFMUFCMEUyODc1MTFGMUIiIHN0UmVmOmRvY3VtZW50SUQ9InhtcC5kaWQ6NDBENDNDNTVDMjQ3MTFFNzhFMUFCMEUyODc1MTFGMUIiLz4gPC9yZGY6RGVzY3JpcHRpb24+IDwvcmRmOlJERj4gPC94OnhtcG1ldGE+IDw/eHBhY2tldCBlbmQ9InIiPz7hPt6DAAAIYklEQVR42qxXCWxU1xU9f52ZP57NM8YeG4OxMXghbDZ2gBSbxUCgWSiijaKoG4VUSaBJowSaNm2KKBSBQQkpoSxNkaAqSUlCCjVgGpYEjEmAAiaYDNjgbWw8Xmb5M/P3vjFEQhEKxuRLT3rz/tzz7j333XPfh2EYuHPczzOvjH/jqRn82vux+eZ+LB7gkVlbDlgqCQgMGGPADpgFe1Zqdu5MhqXMglXNi4q99QPBob5JO0VR3+4xx7unlpc9P7cseVkoKgoJCIdgkg/VxDYcPHioUlWVwL1SMCAHhufmTZ5WPmlZkpUdP/uRlIxd2yvfL5o4q9BsFsxHq/ec/NniF5+pPhVp6w1GLxw/8cXa+st1n/THAbo/NJWUTn76T398ucrDX5wyp6Ik49L5/dd2VMVf8njctpQUl+sf1fJvTtfurZs7syTdw9dNXPH6kn9PKZu+MBHPvbDv6UBx8YT5b25YvWPPP1cdaGjTP0xJtUH3NXMrhyR/kJ6WnulJSXOtzk7ey13tEBwuFv5eoWrn31fsWbPq9S1Tysp//EAOsJzFufSl3/7hsyPbW/zHGxu/Xzp4RjR8DvkyP6TC7ilRA/sgd36AaQ7P+IcUS3YkeAZzHvZO66lt8x+uervhuRdeec0iOAYN2IFxI5knbdzZHO14jXW9M+/VYTdODdYaNgIRE6IeDRbJD0vMD9GlgJbMUK5uweCGTwZtcI181XTyjJPXazNKCukfDbgMOzqj5129f5ZKih2uXk6Ao4CFwnlhGSEi3MAiy82DZigEkhQkeXXwQhqYERJ6RsdQWhB3MZE10bZ25eyAGWjqwGVJc/Z6cxlWTFIhRhSku4Kg3Abc31MgmOMQTDF4JqmgUnV4XSHERBlRq4rkYRQDxin6mnHhAQ6hHt/8XnBzmNbgmR1HUraGQFBD6jgJaaMkaLoKRVWRWkh+F8noCmkQhmhwz4ojLmh4Z3doG8EIP6gQsfvWWnzFY9is3hCDsGxCb5RHXGOhG0xfodHQYGYUOAUFdl6Cw6bhsk9rn/pCNJfYR75NB+56Bmga1lkPmxYdPi3tHpTMZq08Vux39EzIagymoktxQKKskA0emnHLWYYywFMyTIYIDxfEMHsHYlfO+DNST47tCCi+GaWmpw7XSu+qGkL9YuC5BULl7xYm/bqlQ/WHRMM6o3oli5RiARSx1ziyo/R1PHdkksw1E3mnENZtQNclqWracsVj18LpKZy3cmdk0/pd4vP9UUK6otRUrqhA7hDOm+PVk4Yn+7kCphogIUx3fgwH3QEPGpFG+TCIakAqfLDSXahwfkSc0JDP/ReZ9hZ6uFcTcjM5r6IamF5iKrsb43dzwGhq1xoTk4ZWDTYLSF7j9FzvCRQwJ1A58X08nnIUjydXI10IwmOOYF5KNeYkH8OGybtRQJ/EE95PiU2McVp1XGvR+kCbb2Hq/dEBY++x+JExI7j5Xb06wr1yV8uNSLuamfRQoeVLMIyOTK6Z5EpGt+iEpHMYxHfDqsVBkXAKhS+hMRb4W6P1dT7J3R1DajjGgGAevZsDd2OAmjbB9ESiGDxOGu0BzZwqRJO7Ylb8Ynwt6EQahvpQPKgFHTE7ApIdhS4/Hs2pB6UYWDiuFkFJQKpFdPo7NXOygwFNsMqL+ccS57VfKai/rrYk22lEJQOZaYwtxxvNCKlWzMjvRE6qgrK8bgwmUhzTBaIDZqS7gan5Xcgm72bm30SYrGenRdOz0hlHjGAksL66obYRbK1fUnzkC/ktMy9aK0r5BXYXTeW5OrGxdT4Kdw3t67CSzhIRIr6TciQ1iKdPLAFXo4Gn1T6WWyKZWJz+N6ITFMSYYby1W/zw0Cm5sl9KmOami4JhPRCNGxcLczhDVilCZwii7kB9vAj1YgFSjDY0xUejzHUc5a6jaCZzD1mrF/PJf4oRMZLhtQQhaxQKc1jIilHXG9Zvej30uHsysPZF+7bZ080FniSal6MJgWERIppP+WLo0x0yfpB5Cj0NDiwpOEwI0NFaY8N8snb6Kqk0imiEEUe2J4YMF4esDIZ6d5Xr9+si+vIjx6QrBGH0tzKw8z+xTW4rxSeEhUmwTGQx0BEmnt4WH0K/aNgwwnQFLi4MJxdBLn+FrJHLMamIW8ooE5sQqRiaYFAJ/YWbBLRjf3TLPVNwsEbaumZr5Eic7BchB8ggIeemybAx4VuHmDS5logDC0aeBWvIoHUZC/LOoFV0oK8OCaSNjmCkN9GsKIQJRiwOrN8eqdn3qfSXfnXDd/4Vfa3qWLw+caRO1WmIh8MYw31OIjT1mSSi/ckjlzAlr5OMAH5K5tEEAwk43YxC7gwUMYSTF1XSMwxUn5Cuvv2euOwO7b53N7SYqPTlP0/aXJLPPRaOqJBI83nlq5fRzpdhKP85nskhumJwt40U7Goow3WpBG7pJNblroWNjcEisDh3VTmwelvkWVINTfd9LR83klu0abl9S1wmbUCW0dxjwuamH+K0Ph2Ikaue5bauxEh5mwMoYo5gccZuZLujYE18Igj8al1waW2dsvG+2vHXz4RCbrxGxJMl+9yMsMjLUHFg4k6caz2kV10fbnx8wXOZ5FmbNzYwqmLIVao4s4P2NdNobGeRaU30JYNg8OOJAwO7kNgEKi0vi330l/OFFWVF/OAIKcsh6QxCIQWKIiPYo4V0AuBysQ6W5+Cw82hq05AkUPjsf0rb5j3iG5ca1P1h0Wh7oC8j0hPGHtvqPp7ioW2d3TqshFqJnO7u0K3e4iJSayZrIllLcdHo7tGjU5/tnuoPaKe/s08zq4XKWTRPWDppHD+LlLb18jW1ZttH0Y26Dn3hk5Ylo4Zzk4hQxU+dlw/9dU/0TcKWrz+fZv8XYADKodqb+HwseQAAAABJRU5ErkJggg=='
  }

  TriggerEvent('esx_phone:addSpecialContact', specialContact.name, specialContact.number, specialContact.base64Icon)

end)

AddEventHandler('esx_policejob:hasEnteredMarker', function(station, part, partNum)

  if part == 'Cloakroom' then
    CurrentAction     = 'menu_cloakroom'
    CurrentActionMsg  = _U('open_cloackroom')
    CurrentActionData = {}
  end

  if part == 'Armory' then
    CurrentAction     = 'menu_armory'
    CurrentActionMsg  = _U('open_armory')
    CurrentActionData = {station = station}
  end

  if part == 'VehicleSpawner' then
    CurrentAction     = 'menu_vehicle_spawner'
    CurrentActionMsg  = _U('vehicle_spawner')
    CurrentActionData = {station = station, partNum = partNum}
  end

  if part == 'HelicopterSpawner' then

    local helicopters = Config.PoliceStations[station].Helicopters
    CurrentActionMsg = 'Tryck ~INPUT_CONTEXT~ för att ta ut en helikopter'

    if IsControlPressed(0,  Keys['E']) then

      ESX.Game.SpawnVehicle('polmav', {
        x = helicopters[partNum].SpawnPoint.x,
        y = helicopters[partNum].SpawnPoint.y,
        z = helicopters[partNum].SpawnPoint.z
      }, helicopters[partNum].Heading, function(vehicle)
        SetVehicleModKit(vehicle, 0)
        SetVehicleLivery(vehicle, 0)
      end)

    end

  end

  if part == 'VehicleDeleter' then

    local playerPed = GetPlayerPed(-1)
    local coords    = GetEntityCoords(playerPed)

    if IsPedInAnyVehicle(playerPed,  false) then

      local vehicle = GetVehiclePedIsIn(playerPed, false)

      if DoesEntityExist(vehicle) then
        CurrentAction     = 'delete_vehicle'
        CurrentActionMsg  = _U('store_vehicle')
        CurrentActionData = {vehicle = vehicle}
      end

    end

  end

  if part == 'BossActions' then
    CurrentAction     = 'menu_boss_actions'
    CurrentActionMsg  = _U('open_bossmenu')
    CurrentActionData = {}
  end

end)

AddEventHandler('esx_policejob:hasExitedMarker', function(station, part, partNum)
  ESX.UI.Menu.CloseAll()
  CurrentAction = nil
end)

AddEventHandler('esx_policejob:hasEnteredEntityZone', function(entity)

  local playerPed = GetPlayerPed(-1)

  if PlayerData.job ~= nil and PlayerData.job.name == 'police' and not IsPedInAnyVehicle(playerPed, false) then
    CurrentAction     = 'remove_entity'
    CurrentActionMsg  = _U('remove_object')
    CurrentActionData = {entity = entity}
  end

  if GetEntityModel(entity) == GetHashKey('p_ld_stinger_s') then

    local playerPed = GetPlayerPed(-1)
    local coords    = GetEntityCoords(playerPed)

    if IsPedInAnyVehicle(playerPed,  false) then

      local vehicle = GetVehiclePedIsIn(playerPed)

      for i=0, 7, 1 do
        SetVehicleTyreBurst(vehicle,  i,  true,  1000)
      end

    end

  end

end)

AddEventHandler('esx_policejob:hasExitedEntityZone', function(entity)

  if CurrentAction == 'remove_entity' then
    CurrentAction = nil
  end

end)

function LookupVehicle()
	ESX.UI.Menu.Open(
	'dialog', GetCurrentResourceName(), 'lookup_vehicle',
	{
		title = _U('search_database_title'),
	}, function (data, menu)
		local length = string.len(data.value)
		if data.value == nil or length < 8 or length > 13 then
			ESX.ShowNotification(_U('search_database_error_invalid'))
      menu.close()
		else
			ESX.TriggerServerCallback('esx_policejob:getVehicleFromPlate', function(owner, found)
				if found then
					ESX.ShowNotification(_U('search_database_found', owner))
				else
					ESX.ShowNotification(_U('search_database_error_not_found'))
				end
			end, data.value)
			menu.close()
		end
	end, function (data, menu)
		menu.close()
	end
	)
end

RegisterNetEvent('esx_policejob:handcuff')
AddEventHandler('esx_policejob:handcuff', function()
	IsHandcuffed    = not IsHandcuffed;
	
	local dict = "mp_arresting"
	local anim = "idle"
	local flags = 49
	local ped = PlayerPedId()
	local changed = false
	local prevMaleVariation = 0
	local prevFemaleVariation = 0
	local femaleHash = GetHashKey("mp_f_freemode_01")
	local maleHash = GetHashKey("mp_m_freemode_01")

    ped = GetPlayerPed(-1)
    RequestAnimDict(dict)

    while not HasAnimDictLoaded(dict) do
        Citizen.Wait(0)
    end

        ClearPedTasks(ped)
        SetEnableHandcuffs(ped, false)
        UncuffPed(ped)

        if GetEntityModel(ped) == femaleHash or GetEntityModel(ped) == maleHash then
			if IsHandcuffed then
			SetEnableHandcuffs(ped, true)
			TaskPlayAnim(ped, dict, anim, 8.0, -8, -1, flags, 0, 0, 0, 0)
        else
			SetEnableHandcuffs(ped, false)
			ClearPedSecondaryTask(playerPed)
        end
	end
end)

RegisterNetEvent('esx_policejob:drag')
AddEventHandler('esx_policejob:drag', function(cop)
	IsDragged = not IsDragged
	CopPed = tonumber(cop)
end)

Citizen.CreateThread(function()
	while true do
		Citizen.Wait(1)
		if IsHandcuffed then
			if IsDragged then
				local ped = GetPlayerPed(GetPlayerFromServerId(CopPed))
				local myped = PlayerPedId()
				AttachEntityToEntity(myped, ped, 11816, 0.54, 0.54, 0.0, 0.0, 0.0, 0.0, false, false, false, false, 2, true)
			else
				DetachEntity(PlayerPedId(), true, false)
			end
		else
			Citizen.Wait(500)
		end
	end
end)

RegisterNetEvent('esx_policejob:putInVehicle')
AddEventHandler('esx_policejob:putInVehicle', function()

  local playerPed = GetPlayerPed(-1)
  local coords    = GetEntityCoords(playerPed)

  if IsAnyVehicleNearPoint(coords.x, coords.y, coords.z, 5.0) then

    local vehicle = GetClosestVehicle(coords.x,  coords.y,  coords.z,  5.0,  0,  71)

    if DoesEntityExist(vehicle) then

      local maxSeats = GetVehicleMaxNumberOfPassengers(vehicle)
      local freeSeat = nil

      for i=maxSeats - 1, 0, -1 do
        if IsVehicleSeatFree(vehicle,  i) then
          freeSeat = i
          break
        end
      end

      if freeSeat ~= nil then
        TaskWarpPedIntoVehicle(playerPed,  vehicle,  freeSeat)
      end

    end

  end

end)

RegisterNetEvent('esx_policejob:OutVehicle')
AddEventHandler('esx_policejob:OutVehicle', function(t)
  local ped = GetPlayerPed(t)
  ClearPedTasksImmediately(ped)
  plyPos = GetEntityCoords(GetPlayerPed(-1),  true)
  local xnew = plyPos.x+2
  local ynew = plyPos.y+2

  SetEntityCoords(GetPlayerPed(-1), xnew, ynew, plyPos.z)
end)

-- Handcuff
Citizen.CreateThread(function()
  while true do
    Wait(0)
    if IsHandcuffed then
		DisableControlAction(0, 69, true) -- INPUT_VEH_ATTACK
		DisableControlAction(0, 92, true) -- INPUT_VEH_PASSENGER_ATTACK
		DisableControlAction(0, 114, true) -- INPUT_VEH_FLY_ATTACK
		DisableControlAction(0, 140, true) -- INPUT_MELEE_ATTACK_LIGHT
		DisableControlAction(0, 141, true) -- INPUT_MELEE_ATTACK_HEAVY
		DisableControlAction(0, 142, true) -- INPUT_MELEE_ATTACK_ALTERNATE
		DisableControlAction(0, 257, true) -- INPUT_ATTACK2
		DisableControlAction(0, 263, true) -- INPUT_MELEE_ATTACK1
		DisableControlAction(0, 264, true) -- INPUT_MELEE_ATTACK2
		DisableControlAction(0, 24, true) -- INPUT_ATTACK
		DisableControlAction(0, 25, true) -- INPUT_AIM
		DisableControlAction(0, 21, true) -- SHIFT
		DisableControlAction(0, 22, true) -- SPACE
		DisableControlAction(0, 288, true) -- F1
		DisableControlAction(0, 289, true) -- F2
		DisableControlAction(0, 170, true) -- F3
		DisableControlAction(0, 167, true) -- F6
		DisableControlAction(0, 168, true) -- F7
		DisableControlAction(0, 57, true) -- F10
		DisableControlAction(0, 73, true) -- X
    end
  end
end)

-- Create blips
Citizen.CreateThread(function()

  for k,v in pairs(Config.PoliceStations) do

    local blip = AddBlipForCoord(v.Blip.Pos.x, v.Blip.Pos.y, v.Blip.Pos.z)

    SetBlipSprite (blip, v.Blip.Sprite)
    SetBlipDisplay(blip, v.Blip.Display)
    SetBlipScale  (blip, v.Blip.Scale)
    SetBlipColour (blip, v.Blip.Colour)
    SetBlipAsShortRange(blip, true)

    BeginTextCommandSetBlipName("STRING")
    AddTextComponentString(_U('map_blip'))
    EndTextCommandSetBlipName(blip)

  end

end)

-- Display markers
Citizen.CreateThread(function()
  while true do

    Wait(0)

    if PlayerData.job ~= nil and PlayerData.job.name == 'police' then

      local playerPed = GetPlayerPed(-1)
      local coords    = GetEntityCoords(playerPed)

      for k,v in pairs(Config.PoliceStations) do

        for i=1, #v.Cloakrooms, 1 do
          if GetDistanceBetweenCoords(coords,  v.Cloakrooms[i].x,  v.Cloakrooms[i].y,  v.Cloakrooms[i].z,  true) < Config.DrawDistance then
            DrawMarker(Config.MarkerType, v.Cloakrooms[i].x, v.Cloakrooms[i].y, v.Cloakrooms[i].z, 0.0, 0.0, 0.0, 0, 0.0, 0.0, Config.MarkerSize.x, Config.MarkerSize.y, Config.MarkerSize.z, Config.MarkerColor.r, Config.MarkerColor.g, Config.MarkerColor.b, 100, false, true, 2, false, false, false, false)
          end
        end

        for i=1, #v.Armories, 1 do
          if GetDistanceBetweenCoords(coords,  v.Armories[i].x,  v.Armories[i].y,  v.Armories[i].z,  true) < Config.DrawDistance then
            DrawMarker(Config.MarkerType, v.Armories[i].x, v.Armories[i].y, v.Armories[i].z, 0.0, 0.0, 0.0, 0, 0.0, 0.0, Config.MarkerSize.x, Config.MarkerSize.y, Config.MarkerSize.z, Config.MarkerColor.r, Config.MarkerColor.g, Config.MarkerColor.b, 100, false, true, 2, false, false, false, false)
          end
        end

        for i=1, #v.Vehicles, 1 do
          if GetDistanceBetweenCoords(coords,  v.Vehicles[i].Spawner.x,  v.Vehicles[i].Spawner.y,  v.Vehicles[i].Spawner.z,  true) < Config.DrawDistance then
            DrawMarker(Config.MarkerType, v.Vehicles[i].Spawner.x, v.Vehicles[i].Spawner.y, v.Vehicles[i].Spawner.z, 0.0, 0.0, 0.0, 0, 0.0, 0.0, Config.MarkerSize.x, Config.MarkerSize.y, Config.MarkerSize.z, Config.MarkerColor.r, Config.MarkerColor.g, Config.MarkerColor.b, 100, false, true, 2, false, false, false, false)
          end
        end

        for i=1, #v.VehicleDeleters, 1 do
          if GetDistanceBetweenCoords(coords,  v.VehicleDeleters[i].x,  v.VehicleDeleters[i].y,  v.VehicleDeleters[i].z,  true) < Config.DrawDistance then
            DrawMarker(Config.MarkerType, v.VehicleDeleters[i].x, v.VehicleDeleters[i].y, v.VehicleDeleters[i].z, 0.0, 0.0, 0.0, 0, 0.0, 0.0, Config.MarkerSize.x, Config.MarkerSize.y, Config.MarkerSize.z, Config.MarkerColor.r, Config.MarkerColor.g, Config.MarkerColor.b, 100, false, true, 2, false, false, false, false)
          end
        end

        if Config.EnablePlayerManagement and PlayerData.job ~= nil and PlayerData.job.name == 'police' and PlayerData.job.grade_name == 'boss' then

          for i=1, #v.BossActions, 1 do
            if not v.BossActions[i].disabled and GetDistanceBetweenCoords(coords,  v.BossActions[i].x,  v.BossActions[i].y,  v.BossActions[i].z,  true) < Config.DrawDistance then
              DrawMarker(Config.MarkerType, v.BossActions[i].x, v.BossActions[i].y, v.BossActions[i].z, 0.0, 0.0, 0.0, 0, 0.0, 0.0, Config.MarkerSize.x, Config.MarkerSize.y, Config.MarkerSize.z, Config.MarkerColor.r, Config.MarkerColor.g, Config.MarkerColor.b, 100, false, true, 2, false, false, false, false)
            end
          end

        end

      end

    end

  end
end)

-- Enter / Exit marker events
Citizen.CreateThread(function()

  while true do

    Wait(0)

    if PlayerData.job ~= nil and PlayerData.job.name == 'police' then

      local playerPed      = GetPlayerPed(-1)
      local coords         = GetEntityCoords(playerPed)
      local isInMarker     = false
      local currentStation = nil
      local currentPart    = nil
      local currentPartNum = nil

      for k,v in pairs(Config.PoliceStations) do

        for i=1, #v.Cloakrooms, 1 do
          if GetDistanceBetweenCoords(coords,  v.Cloakrooms[i].x,  v.Cloakrooms[i].y,  v.Cloakrooms[i].z,  true) < Config.MarkerSize.x then
            isInMarker     = true
            currentStation = k
            currentPart    = 'Cloakroom'
            currentPartNum = i
          end
        end

        for i=1, #v.Armories, 1 do
          if GetDistanceBetweenCoords(coords,  v.Armories[i].x,  v.Armories[i].y,  v.Armories[i].z,  true) < Config.MarkerSize.x then
            isInMarker     = true
            currentStation = k
            currentPart    = 'Armory'
            currentPartNum = i
          end
        end

        for i=1, #v.Vehicles, 1 do

          if GetDistanceBetweenCoords(coords,  v.Vehicles[i].Spawner.x,  v.Vehicles[i].Spawner.y,  v.Vehicles[i].Spawner.z,  true) < Config.MarkerSize.x then
            isInMarker     = true
            currentStation = k
            currentPart    = 'VehicleSpawner'
            currentPartNum = i
          end

          if GetDistanceBetweenCoords(coords,  v.Vehicles[i].SpawnPoint.x,  v.Vehicles[i].SpawnPoint.y,  v.Vehicles[i].SpawnPoint.z,  true) < Config.MarkerSize.x then
            isInMarker     = true
            currentStation = k
            currentPart    = 'VehicleSpawnPoint'
            currentPartNum = i
          end

        end

        for i=1, #v.Helicopters, 1 do

          if GetDistanceBetweenCoords(coords,  v.Helicopters[i].Spawner.x,  v.Helicopters[i].Spawner.y,  v.Helicopters[i].Spawner.z,  true) < Config.MarkerSize.x then
            isInMarker     = true
            currentStation = k
            currentPart    = 'HelicopterSpawner'
            currentPartNum = i
          end

          if GetDistanceBetweenCoords(coords,  v.Helicopters[i].SpawnPoint.x,  v.Helicopters[i].SpawnPoint.y,  v.Helicopters[i].SpawnPoint.z,  true) < Config.MarkerSize.x then
            isInMarker     = true
            currentStation = k
            currentPart    = 'HelicopterSpawnPoint'
            currentPartNum = i
          end

        end

        for i=1, #v.VehicleDeleters, 1 do
          if GetDistanceBetweenCoords(coords,  v.VehicleDeleters[i].x,  v.VehicleDeleters[i].y,  v.VehicleDeleters[i].z,  true) < Config.MarkerSize.x then
            isInMarker     = true
            currentStation = k
            currentPart    = 'VehicleDeleter'
            currentPartNum = i
          end
        end

        if Config.EnablePlayerManagement and PlayerData.job ~= nil and PlayerData.job.name == 'police' and PlayerData.job.grade_name == 'boss' then

          for i=1, #v.BossActions, 1 do
            if GetDistanceBetweenCoords(coords,  v.BossActions[i].x,  v.BossActions[i].y,  v.BossActions[i].z,  true) < Config.MarkerSize.x then
              isInMarker     = true
              currentStation = k
              currentPart    = 'BossActions'
              currentPartNum = i
            end
          end

        end

      end

      local hasExited = false

      if isInMarker and not HasAlreadyEnteredMarker or (isInMarker and (LastStation ~= currentStation or LastPart ~= currentPart or LastPartNum ~= currentPartNum) ) then

        if
          (LastStation ~= nil and LastPart ~= nil and LastPartNum ~= nil) and
          (LastStation ~= currentStation or LastPart ~= currentPart or LastPartNum ~= currentPartNum)
        then
          TriggerEvent('esx_policejob:hasExitedMarker', LastStation, LastPart, LastPartNum)
          hasExited = true
        end

        HasAlreadyEnteredMarker = true
        LastStation             = currentStation
        LastPart                = currentPart
        LastPartNum             = currentPartNum

        TriggerEvent('esx_policejob:hasEnteredMarker', currentStation, currentPart, currentPartNum)
      end

      if not hasExited and not isInMarker and HasAlreadyEnteredMarker then

        HasAlreadyEnteredMarker = false

        TriggerEvent('esx_policejob:hasExitedMarker', LastStation, LastPart, LastPartNum)
      end

    end

  end
end)

-- Enter / Exit entity zone events
Citizen.CreateThread(function()

  local trackedEntities = {
    'prop_roadcone02a',
    'prop_barrier_work06a',
    'p_ld_stinger_s',
    'prop_boxpile_07d',
  }

  while true do

    Citizen.Wait(0)

    local playerPed = GetPlayerPed(-1)
    local coords    = GetEntityCoords(playerPed)

    local closestDistance = -1
    local closestEntity   = nil

    for i=1, #trackedEntities, 1 do

      local object = GetClosestObjectOfType(coords.x,  coords.y,  coords.z,  3.0,  GetHashKey(trackedEntities[i]), false, false, false)

      if DoesEntityExist(object) then

        local objCoords = GetEntityCoords(object)
        local distance  = GetDistanceBetweenCoords(coords.x,  coords.y,  coords.z,  objCoords.x,  objCoords.y,  objCoords.z,  true)

        if closestDistance == -1 or closestDistance > distance then
          closestDistance = distance
          closestEntity   = object
        end

      end

    end

    if closestDistance ~= -1 and closestDistance <= 3.0 then

      if LastEntity ~= closestEntity then
        TriggerEvent('esx_policejob:hasEnteredEntityZone', closestEntity)
        LastEntity = closestEntity
      end

    else

      if LastEntity ~= nil then
        TriggerEvent('esx_policejob:hasExitedEntityZone', LastEntity)
        LastEntity = nil
      end

    end

  end
end)

-- Key Controls
Citizen.CreateThread(function()
  while true do

    Citizen.Wait(0)

    if CurrentAction ~= nil then

      if IsControlPressed(0,  Keys['E']) and PlayerData.job ~= nil and PlayerData.job.name == 'police' and (GetGameTimer() - GUI.Time) > 150 then

        if CurrentAction == 'menu_cloakroom' then
          OpenCloakroomMenu()
        end

        if CurrentAction == 'menu_armory' then
          OpenArmoryMenu(CurrentActionData.station)
        end

        if CurrentAction == 'menu_vehicle_spawner' then
          OpenVehicleSpawnerMenu(CurrentActionData.station, CurrentActionData.partNum)
        end

        if CurrentAction == 'delete_vehicle' then

          if Config.EnableSocietyOwnedVehicles then

            local vehicleProps = ESX.Game.GetVehicleProperties(CurrentActionData.vehicle)
            TriggerServerEvent('esx_society:putVehicleInGarage', 'police', vehicleProps)

          else

            if
              GetEntityModel(vehicle) == GetHashKey('police')  or
              GetEntityModel(vehicle) == GetHashKey('police2') or
              GetEntityModel(vehicle) == GetHashKey('police3') or
              GetEntityModel(vehicle) == GetHashKey('police4') or
              GetEntityModel(vehicle) == GetHashKey('policeb') or
              GetEntityModel(vehicle) == GetHashKey('policet')
            then
              TriggerServerEvent('esx_service:disableService', 'police')
            end

          end

          ESX.Game.DeleteVehicle(CurrentActionData.vehicle)
        end

        if CurrentAction == 'menu_boss_actions' then

          ESX.UI.Menu.CloseAll()

          TriggerEvent('esx_society:openBossMenu', 'police', function(data, menu)

            menu.close()

            CurrentAction     = 'menu_boss_actions'
            CurrentActionMsg  = _U('open_bossmenu')
            CurrentActionData = {}

          end)

        end

        if CurrentAction == 'remove_entity' then
          DeleteEntity(CurrentActionData.entity)
        end

        CurrentAction = nil
        GUI.Time      = GetGameTimer()

      end

    end

     if IsControlPressed(0,  Keys['F6']) and PlayerData.job ~= nil and PlayerData.job.name == 'police' and not ESX.UI.Menu.IsOpen('default', GetCurrentResourceName(), 'police_actions') and (GetGameTimer() - GUI.Time) > 150 then
      OpenPoliceActionsMenu()
      GUI.Time = GetGameTimer()
    end

  end
end)

-- NO NPC STEAL
Citizen.CreateThread(function()
        while true do
            Wait(0)

            local player = GetPlayerPed(-1)

            if DoesEntityExist(GetVehiclePedIsTryingToEnter(PlayerPedId(player))) then

                local veh = GetVehiclePedIsTryingToEnter(PlayerPedId(player))
                local lock = GetVehicleDoorLockStatus(veh)

                if lock == 7 then
                    SetVehicleDoorsLocked(veh, 2)
                end

                local pedd = GetPedInVehicleSeat(veh, -1)

                if pedd then
                    SetPedCanBeDraggedOut(pedd, false)
                end
            end
    end
end)

Citizen.CreateThread(function()
    while true do
        Citizen.Wait(10)
        DisablePlayerVehicleRewards(PlayerId())
    end
end)


Citizen.CreateThread(function()

  while true do
    Citizen.Wait(0)
    if(not IsPedInAnyVehicle(GetPlayerPed(-1))) then
      for i=1,#vehWeapons do
        if(HasPedGotWeapon(GetPlayerPed(-1), vehWeapons[i], false)==1) then
          alreadyHaveWeapon[i] = true
        else
          alreadyHaveWeapon[i] = false
        end
      end
    end
    Citizen.Wait(5000)
  end

end)


RegisterNetEvent("PoliceVehicleWeaponDeleter:drop")
AddEventHandler("PoliceVehicleWeaponDeleter:drop", function(wea)
  RemoveWeaponFromPed(GetPlayerPed(-1), wea)
end)

--- Vehicle Spawner

Citizen.CreateThread(function()
	while true do
    Citizen.Wait(1)
            if PlayerData.job ~= nil and PlayerData.job.name == 'police' then
         if GetDistanceBetweenCoords(GetEntityCoords(GetPlayerPed(-1)), 454.7, -1017.4, 28.4, true) <= 2.5 then
            Draw3DText(454.7, -1017.4, 28.4, '[~g~E~w~] för att ta ut ett ~r~tjänstefordon~w~')
            end
        end
    end
end)

--- Vehicle Deleter

Citizen.CreateThread(function()
	while true do
    Citizen.Wait(1)
            if PlayerData.job ~= nil and PlayerData.job.name == 'police' then
         if GetDistanceBetweenCoords(GetEntityCoords(GetPlayerPed(-1)), 462.3, -1019.6, 28.1, true) <= 2.5 then
            Draw3DText(462.3, -1019.6, 28.1, '[~g~E~w~] för att lagra ditt ~r~tjänstefordon~w~')
            end
        end
    end
end)

--- Vehicle Deleter

Citizen.CreateThread(function()
	while true do
    Citizen.Wait(1)
            if PlayerData.job ~= nil and PlayerData.job.name == 'police' then
         if GetDistanceBetweenCoords(GetEntityCoords(GetPlayerPed(-1)), 462.6, -1014.4, 28.1, true) <= 2.5 then
            Draw3DText(462.6, -1014.4, 28.1, '[~g~E~w~] för att lagra ditt ~r~tjänstefordon~w~')
            end
        end
    end
end)

--- Armories

Citizen.CreateThread(function()
	while true do
    Citizen.Wait(1)
            if PlayerData.job ~= nil and PlayerData.job.name == 'police' then
         if GetDistanceBetweenCoords(GetEntityCoords(GetPlayerPed(-1)), 460.9, -982.4, 30.6, true) <= 2.5 then
            Draw3DText(460.9, -982.4, 30.6, '[~g~E~w~] för att ta ut ditt ~r~tjänstevapen~w~')
            end
        end
    end
end)

--- Cloakrooms 1

Citizen.CreateThread(function()
	while true do
    Citizen.Wait(1)
            if PlayerData.job ~= nil and PlayerData.job.name == 'police' then
         if GetDistanceBetweenCoords(GetEntityCoords(GetPlayerPed(-1)), 450.0, -992.8, 30.6, true) <= 2.5 then
            Draw3DText(450.0, -992.8, 30.6, '[~g~E~w~] för att byta ~r~outfit~w~')
            end
        end
    end
end)

--- Cloakrooms 2

Citizen.CreateThread(function()
	while true do
    Citizen.Wait(1)
            if PlayerData.job ~= nil and PlayerData.job.name == 'police' then
         if GetDistanceBetweenCoords(GetEntityCoords(GetPlayerPed(-1)), 475.311, -991.729, 24.9, true) <= 2.5 then
            Draw3DText(475.311, -991.729, 24.9, '[~g~E~w~] för att byta ~r~outfit~w~')
            end
        end
    end
end)

--- Boss Actions

Citizen.CreateThread(function()
	while true do
    Citizen.Wait(1)
            if PlayerData.job ~= nil and PlayerData.job.name == 'police' then
         if GetDistanceBetweenCoords(GetEntityCoords(GetPlayerPed(-1)), 448.4, -973.0, 30.6, true) <= 2.5 then
            Draw3DText(448.4, -973.0, 30.6, '[~g~E~w~] för hantera ~r~chefs-menyn~w~')
            end
        end
    end
end)

TriggerServerEvent("player:serviceOn", "police")

-- notification
function sendNotification(message, messageType, messageTimeout)
	TriggerEvent("pNotify:SendNotification", {
		text = message,
		type = messageType,
		queue = "qalle",
		timeout = messageTimeout,
		layout = "bottomCenter"
	})
end

Citizen.CreateThread(function()
  while true do
    Citizen.Wait(1)
    -- List of pickup hashes (https://pastebin.com/8EuSv2r1)
    RemoveAllPickupsOfType(0xDF711959) -- carbine rifle
    RemoveAllPickupsOfType(0xF9AFB48F) -- pistol
    RemoveAllPickupsOfType(0xA9355DCD) -- pumpshotgun
  end
end)