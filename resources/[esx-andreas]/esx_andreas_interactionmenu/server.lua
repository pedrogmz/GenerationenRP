local ESX = nil
TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)




ESX.RegisterServerCallback('esx_didrik:getLicenses', function(source, cb, target)
  local identifier = ESX.GetPlayerFromId(target).identifier
  local xPlayer = ESX.GetPlayerFromId(target)
  local name = getIdentity(target)
  MySQL.Async.fetchAll("SELECT identifier, firstname, lastname, drive, drive_bike, drive_truck FROM `users` WHERE `identifier` = @identifier",
  {
    ['@identifier'] = identifier
  },
  function(result)
    if identifier ~= nil then
        local crime = {}
        
        table.insert(crime, {
          drive = result[1].drive,
          bike = result[1].drive_bike,
          truck = result[1].drive_truck,
        })
      cb(crime)
    end
  end)
end)

RegisterServerEvent('modifyLicense')
AddEventHandler('modifyLicense', function(value, test)
    local _source = source
    local identifier = ESX.GetPlayerFromId(_source).identifier

    MySQL.Sync.execute("UPDATE users SET " .. value .. " =@wanted WHERE identifier=@id",{['@wanted'] = test , ['@id'] = identifier})
end)

--- identitet
ESX.RegisterServerCallback('esx_qalle:getIdentity', function(source, cb)
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
			lastname = identity['lastname'],
			dateofbirth = identity['dateofbirth'],
			sex = identity['sex'],
			height = identity['height']
		}
	else
		return nil
	end
end
