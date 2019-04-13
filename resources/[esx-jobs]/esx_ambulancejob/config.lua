Config                            = {}
Config.DrawDistance               = 100.0
Config.MarkerColor                = { r = 214, g = 217, b = 219 }

local second = 1000
local minute = 60 * second

-- How much time before auto respawn at hospital
Config.RespawnDelayAfterRPDeath   = 900 * second

-- How much time before a menu opens to ask the player if he wants to respawn at hospital now
-- The player is not obliged to select YES, but he will be auto respawn
-- at the end of RespawnDelayAfterRPDeath just above.
Config.RespawnToHospitalMenuTimer   = true
Config.MenuRespawnToHospitalDelay   = 900 * second

Config.EnablePlayerManagement       = true
Config.EnableSocietyOwnedVehicles   = false

Config.RemoveWeaponsAfterRPDeath    = true
Config.RemoveCashAfterRPDeath       = true
Config.RemoveItemsAfterRPDeath      = true

-- Will display a timer that shows RespawnDelayAfterRPDeath time remaining
Config.ShowDeathTimer               = true

-- Will allow to respawn at any time, don't use RespawnToHospitalMenuTimer at the same time !
Config.EarlyRespawn                 = false
-- The player can have a fine (on bank account)
Config.RespawnFine                  = false
Config.RespawnFineAmount            = 900

Config.Locale                       = 'fr'

Config.Blip = {
  Pos     = { x = -498.931, y = -335.696, z = 33.601 },
  Sprite  = 61,
  Display = 4,
  Scale   = 0.8,
  Colour  = 2,
}

Config.HelicopterSpawner = {
  SpawnPoint  = { x = 313.33, y = -1465.2, z = 45.5 },
  Heading     = 0.0
}

Config.Zones = {

  HospitalInteriorInside1 = { -- ok
    Pos  = { x = -457.080, y = -358.435, z = -187.372 },
    Size = { x = 1.5, y = 1.5, z = 1.0 },
    Type = -1
  },

  AmbulanceActions = { -- CLOACKROOM
    Pos  = { x = -473.932, y = -335.887, z = -187.360 },
    Size = { x = 1.5, y = 1.5, z = 0.4 },
    Type = 27
  },

  VehicleSpawner = {
    Pos  = { x = -496.884, y = -347.263, z = 33.601 },
    Size = { x = 1.5, y = 1.5, z = 0.4 },
    Type = 27
  },

  VehicleSpawnPoint = {
    Pos  = { x = -487.424, y = -342.956, z = 33.463 },
    Size = { x = 1.5, y = 1.5, z = 1.0 },
    Type = -1
  },

  VehicleDeleter = {
    Pos  = { x = -492.286, y = -336.936, z = 33.473 },
    Size = { x = 3.5, y = 3.5, z = 0.5 },
    Type = 1
  },

  Pharmacy = {
    Pos  = { x = -465.064, y = -357.122, z = -187.368 },
    Size = { x = 1.5, y = 1.5, z = 0.4 },
    Type = 27
  }

}
