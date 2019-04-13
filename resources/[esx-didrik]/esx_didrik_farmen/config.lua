Config                            = {}
Config.DrawDistance               = 100.0
Config.MarkerType                 = 27
Config.MarkerSize                 = { x = 1.5, y = 1.5, z = 1.0 }
Config.MarkerColor                = { r = 214, g = 217, b = 219 }
Config.EnablePlayerManagement     = true
Config.EnableArmoryManagement     = true
Config.EnableESXIdentity          = true -- only turn this on if you are using esx_identity
Config.Locale                     = 'en'
Config.TimeToPlocka               = 30 -- Sekunder
Config.TimeToOmvandla              = 10 -- Sekunder
Config.WaterNeeded = 1

Config.FarmenStations = {

  Farmen = {
    Blip = {
      Pos   = {x = 425.130, y = -979.558, z = 30.711},
      Sprite  = 60,
      Display = 4,
      Scale   = 0.8,
      Colour  = 4,
    },

    Cloakrooms = {
      {x = 2431.814, y = 4962.951, z = 45.910},
    },

    Applerooms = {
      {x = 2389.981, y = 4992.351, z = 44.288},
      {x = 2389.754, y = 5004.567, z = 44.849},
      {x = 2377.537, y = 5004.009, z = 43.706},
      {x = 2376.508, y = 5016.833, z = 44.537},
      {x = 2369.402, y = 5010.977, z = 43.436},
    },

    Omvandlarooms = {
      {x = 2433.476, y = 4968.941, z = 41.447},
    },


    BossActions = {
      {x = 4534548.417, y = -973.208, z = 29.7}
    }
  }
}
