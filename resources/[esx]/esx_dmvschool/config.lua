Config                 = {}
Config.DrawDistance    = 100.0
Config.MaxErrors       = 5
Config.SpeedMultiplier = 3.6
Config.Locale          = 'en'

Config.Prices = {
  dmv         = 250,
  drive       = 500,
  drive_bike  = 500,
  drive_truck = 500
}

Config.VehicleModels = {
  drive       = 'ninef',
  drive_bike  = 'bati',
  drive_truck = 'mule3'
}

Config.SpeedLimits = {
  residence = 55,
  town      = 85,
  freeway   = 125
}

Config.Zones = {

  DMVSchool = {
    Pos   = {x = 239.471, y = -1380.960, z = 32.741},
    Size  = {x = 3.5, y = 3.5, z = 0.5},
    Color = {r = 0, g = 255, b = 0},
    Type  = 1
  },

  VehicleSpawnPoint = {
    Pos   = {x = 249.409, y = -1407.230, z = 30.4094},
    Size  = {x = 1.5, y = 1.5, z = 1.0},
    Color = {r = 204, g = 204, b = 0},
    Type  = -1
  },

}

Config.CheckPoints = {

  {
    Pos = {x = 255.139, y = -1400.731, z = 29.537},
    Action = function(playerPed, vehicle, setCurrentZoneType)
      DrawMissionText(_U('next_point_speed') .. Config.SpeedLimits['residence'] .. 'km/h', 5000)
    end
  },

  {
    Pos = {x = 271.874, y = -1370.574, z = 30.932},
    Action = function(playerPed, vehicle, setCurrentZoneType)
      DrawMissionText(_U('go_next_point'), 5000)
    end
  },

  {
    Pos = {x = 234.907, y = -1345.385, z = 29.542},
    Action = function(playerPed, vehicle, setCurrentZoneType)
      Citizen.CreateThread(function()
        DrawMissionText(_U('stop_for_ped'), 5000)
        PlaySound(-1, 'RACE_PLACED', 'HUD_AWARDS', 0, 0, 1)
        FreezeEntityPosition(vehicle, true)
        Citizen.Wait(1000)
        FreezeEntityPosition(vehicle, false)
        DrawMissionText(_U('good_lets_cont'), 5000)

      end)
    end
  },

  {
    Pos = {x = 217.821, y = -1410.520, z = 28.292},
    Action = function(playerPed, vehicle, setCurrentZoneType)

      setCurrentZoneType('town')

      Citizen.CreateThread(function()
        DrawMissionText(_U('stop_look_left') .. Config.SpeedLimits['town'] .. 'km/h', 5000)
        PlaySound(-1, 'RACE_PLACED', 'HUD_AWARDS', 0, 0, 1)
        FreezeEntityPosition(vehicle, true)
        Citizen.Wait(3000)
        FreezeEntityPosition(vehicle, false)
        DrawMissionText(_U('good_turn_right'), 5000)
      end)
    end
  },

  {
    Pos = {x = 178.550, y = -1401.755, z = 28.11},
    Action = function(playerPed, vehicle, setCurrentZoneType)
      DrawMissionText(_U('watch_traffic_lightson'), 5000)
    end
  },

  {
    Pos = {x = 116.13, y = -1354.27, z = 28.11},
    Action = function(playerPed, vehicle, setCurrentZoneType)
      DrawMissionText(_U('go_next_point'), 5000)
    end
  },

  {
    Pos = {x = 69.13, y = -1280.13, z = 28.11},
    Action = function(playerPed, vehicle, setCurrentZoneType)
      DrawMissionText(_U('stop_for_passing'), 5000)
      PlaySound(-1, 'RACE_PLACED', 'HUD_AWARDS', 0, 0, 1)
      FreezeEntityPosition(vehicle, true)
      Citizen.Wait(6000)
      FreezeEntityPosition(vehicle, false)
    end
  },

  {
    Pos = {x = 66.13, y = -1151.13, z = 28.25},
    Action = function(playerPed, vehicle, setCurrentZoneType)
      DrawMissionText(_U('go_left_to_cardealer'), 5000)
    end
  },

  {
    Pos = {x = -69.13, y = -1137.13, z = 24.84},
    Action = function(playerPed, vehicle, setCurrentZoneType)
      DrawMissionText(_U('go_left_to_get_to_the_next_point'), 5000)
    end
  },

  {
    Pos = {x = -99.13, y = -1340.13, z = 28.300},
    Action = function(playerPed, vehicle, setCurrentZoneType)
      DrawMissionText(_U('go_left_to_get_to_the_next_point'), 5000)
    end
  },

  {
    Pos = {x = 68.99, y = -1374.72, z = 28.29},
    Action = function(playerPed, vehicle, setCurrentZoneType)
      DrawMissionText(_U('go_right_and_park_at_the_clotheshop'), 5000)
    end
  },

  {
    Pos = {x = 106.0, y = -1399.0, z = 28.29},
    Action = function(playerPed, vehicle, setCurrentZoneType)
      DrawMissionText(_U('backa_ut_and_go'), 5000)
      FreezeEntityPosition(vehicle, true)
      Citizen.Wait(6000)
      FreezeEntityPosition(vehicle, false)
    end
  },

  {
    Pos = {x = 107.13, y = -1416.13, z = 28.27},
    Action = function(playerPed, vehicle, setCurrentZoneType)
      DrawMissionText(_U('go_next_point'), 5000)
    end
  },

  {
    Pos = {x = 145.65, y = -1420.58, z = 28.24},
    Action = function(playerPed, vehicle, setCurrentZoneType)
      DrawMissionText(_U('go_left_to_get_to_the_next_point'), 5000)
    end
  },

  {
    Pos = {x = 222.41, y = -1440.48, z = 28.34},
    Action = function(playerPed, vehicle, setCurrentZoneType)
      DrawMissionText(_U('gratz_now_go_into_skola'), 5000)
      PlaySound(-1, 'RACE_PLACED', 'HUD_AWARDS', 0, 0, 1)
    end
  },

  {
    Pos = {x = 235.283, y = -1398.329, z = 28.921},
    Action = function(playerPed, vehicle, setCurrentZoneType)
      ESX.Game.DeleteVehicle(vehicle)
    end
  },

}
