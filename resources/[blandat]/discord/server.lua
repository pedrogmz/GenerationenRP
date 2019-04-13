ESX = nil

TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)

ESX.RegisterServerCallback('getIdentity', function(source, cb)
  local identity = getIdentity(source)

  cb(identity)
end)

function getIdentity(source)
  local identifier = GetPlayerIdentifiers(source)[1]
  local result = MySQL.Sync.fetchAll("SELECT * FROM users WHERE identifier = @identifier", {['@identifier'] = identifier})
  if result[1] ~= nil then
      local identity = result[1]

      return {
          job = identity['job'],
          firstname = identity['firstname'],
          lastname = identity['lastname']
      }
  else
      return nil
  end
end 