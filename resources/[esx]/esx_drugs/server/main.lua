ESX = nil

TriggerEvent('esx:getSharedObject', function(obj)
	ESX = obj 
end)

ESX.RegisterServerCallback('revenge-drugs:getProgress', function(source, callback, plantId)
	local result = MySQL.Sync.fetchAll('SELECT * FROM drug_farms') 
	local found = false

	for i=1, #result, 1 do
		local row = result[i]

		if row ~= nil and row.id ~= nil then
			if row.id == plantId then
				found = true

				callback(row, os.time())
			end
		end
	end

	if found == false then
		local data = {
			id = plantId,
			type = '',
			task = '',
			tasksLeft = 0,
			delay = 0
		}

		if string.startsWith(plantId, 'weed_') then
			data.type = 'weed'
			data.task = 'plant'
			data.tasksLeft = 1
		elseif string.startsWith(plantId, 'cocaine_') then
			data.type = 'cocaine'
			data.task = 'ingredients'
			data.tasksLeft = 1
		elseif string.startsWith(plantId, 'meth_') then
			data.type = 'meth'
			data.task = 'ingredients'
			data.tasksLeft = 1
		end

		callback(data, os.time())

		TriggerEvent('revenge-drugs:setProgress', data)
	end
end)

ESX.RegisterServerCallback('revenge-drugs:getPolice', function(source, callback)
	local players = ESX.GetPlayers()
	local copCount = 0

	for i=1, #players, 1 do
		local player = ESX.GetPlayerFromId(players[i])

		if player ~= nil and player.job ~= nil then
			if player.job.name == 'police' then
				copCount = copCount + 1
			end
		end
	end

	callback(copCount)
end)

ESX.RegisterServerCallback('revenge-drugs:giveRewards', function(source, callback, item, count)
	local xPlayer = ESX.GetPlayerFromId(source)

	if xPlayer ~= nil then
		xPlayer.addInventoryItem(item, count)
	end
end)

ESX.RegisterServerCallback('revenge-drugs:useIngredients', function(source, callback, progress)
	local xPlayer = ESX.GetPlayerFromId(source)

	if xPlayer ~= nil then
		local itemName = ''

		if progress.type == 'weed' then
			itemName = 'weed_seed'
		elseif progress.type == 'cocaine' then
			itemName = 'coke_ingredients'
		elseif progress.type == 'meth' then
			itemName = 'meth_ingredients'
		else
			return
		end

		local item = xPlayer.getInventoryItem(itemName)

		if item.count > 0 then
			callback(true)

			xPlayer.removeInventoryItem(itemName, 1)
		else
			callback(false)
		end
	end
end)

ESX.RegisterServerCallback('revenge-drugs:isPedAccepting', function(source, callback)
	local accepting = math.random(0, 2) == 0

	callback(not accepting)
end)

ESX.RegisterServerCallback('revenge-drugs:sellDrugs', function(source, callback)
	local xPlayer = ESX.GetPlayerFromId(source)

	if xPlayer ~= nil then
		local items = {}
		local copCount = 0
		local players = ESX.GetPlayers()

		if xPlayer.getInventoryItem('weed').count > 0 then
			table.insert(items, {item = 'weed', price = 250})
		end

		if xPlayer.getInventoryItem('coke').count > 0 then
			table.insert(items, {item = 'coke', price = 350})
		end
		
		if xPlayer.getInventoryItem('meth').count > 0 then
			table.insert(items, {item = 'meth', price = 300})
		end

		for i=1, #players, 1 do
			local player = ESX.GetPlayerFromId(players[i])

			if player ~= nil and player.job ~= nil then
				if player.job.name == 'police' then
					copCount = copCount + 1
				end
			end
		end

		if #items > 0 then
			if copCount > 1 then
                if copCount > 7 then
                   copCount = 7
                end

				local item = items[math.random(#items)]
				local money = item.price * (copCount)
                                 
				xPlayer.removeInventoryItem(item.item, 1)
				xPlayer.addAccountMoney('black_money', money)

				callback(money)
			else
				callback(-1)
			end
		else
			callback(0)
		end
	end
end)

ESX.RegisterServerCallback('revenge-drugs:hasDrugs', function(source, callback)
	local xPlayer = ESX.GetPlayerFromId(source)

	if xPlayer ~= nil then
		local items = {}

		if xPlayer.getInventoryItem('weed').count > 0 then
			table.insert(items, 'weed')
		elseif xPlayer.getInventoryItem('coke').count > 0 then
			table.insert(items, 'coke')
		elseif xPlayer.getInventoryItem('meth').count > 0 then
			table.insert(items, 'meth')
		end

		callback(#items > 0)
	end
end)

RegisterServerEvent('revenge-drugs:setProgress')
AddEventHandler('revenge-drugs:setProgress', function(progress)
	local result = MySQL.Sync.fetchAll('SELECT * FROM drug_farms')
	local found = false

	for i=1, #result, 1 do
		local row = result[i]
		
		if row ~= nil and row.id ~= nil then
			if row.id == progress.id then
				found = true
			end
		end
	end

	if found == false then
		MySQL.Sync.execute('INSERT INTO drug_farms (id, type, task, tasksLeft, delay) VALUES (@id, @type, @task, @tasksLeft, @delay)', 
			{
				["@id"] = progress.id,
				["@type"] = progress.type,
				["@task"] = progress.task,
				["@tasksLeft"] = progress.tasksLeft,
				["@delay"] = progress.delay
			}
		)
	else
		MySQL.Sync.execute('UPDATE drug_farms SET type = @type, task = @task, tasksLeft = @tasksLeft, delay = @delay WHERE id = @id', 
			{
				["@id"] = progress.id,
				["@type"] = progress.type,
				["@task"] = progress.task,
				["@tasksLeft"] = progress.tasksLeft,
				["@delay"] = progress.delay
			}
		)
	end
end)

function string.startsWith(string, value)
   return string.sub(string, 1, string.len(value)) == value
end

function table.contains(table, object)
	for index, value in ipairs(table) do
        if value == object then
            return true
        end
    end

    return false
end

