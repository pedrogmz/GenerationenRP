DATASAVE = {}
DATASAVE.dir = "pd_database/"
function DATASAVE:DoesPathExist( path )
    if ( type( path ) ~= "string" ) then return false end 
    local response = os.execute( "cd " .. path )
    if ( response == true ) then
        return true
    end
    return false
end
function DATASAVE:RunLaunchChecks()
    local exists = self:DoesPathExist( "pd_database" )

    if ( not exists ) then 
        print( "pd_database folder not found, attempting to create." )
        os.execute("mkdir pd_database")
    else
        print( "pd_database folder found!" )
    end 
end 
function DATASAVE:DoesFileExist( name )
    local dir = self.dir .. name
    local file = io.open( dir, "r" )
    if ( file ~= nil ) then 
        io.close( file )
        return true 
    else 
        return false 
    end 
end

function DATASAVE:CreateFile( name )
    local dir = self.dir .. name
    local file, err = io.open( dir, 'w' )
    file:write("") 
    file:close()
end 

function DATASAVE:WriteToFile( name, data)
    local dir = self.dir .. name

    local file, err = io.open( dir, 'a+' )

    file:write( data..'\n')
    file:flush()
    file:close()
end

function DATASAVE:LoadFile( name )
    local dir = self.dir .. name 
    local file, err = io.open( dir, 'rb' )
    local lines = {}

    while true do
        contents = file:read("*l")
        if contents == nil then break end
        lines[#lines + 1] = contents
    end

    file:close()

    return lines
end 

function DATASAVE:RemoveFile( name)
    local dir = self.dir .. name
    local file, err = io.open( dir, 'w' )
    file:write("") 
    file:close()
end 

function DATASAVE:GetIdentifier( source, identifier )
    local ids = GetPlayerIdentifiers(source)

    for k, v in pairs( ids ) do 
        local id = stringsplit( v, ":" )
        local start = id[1]

        if ( start == identifier ) then 
            return id[2]
        end 
    end 

    return nil

end 

function DATASAVE:GenerateFileName(source)
    if DATASAVE:GetIdentifier(source, "steam") ~= nil then
        return DATASAVE:GetIdentifier(source, "steam") .. '.db'
    else
        print('[PD DATABASE]: Player '..GetPlayerName(source).." don't use steam.")
    end
end

function startsWith( string, start )
    return string.sub( string, 1, string.len( start ) ) == start
end

function stringsplit( inputstr, sep )
    if sep == nil then
        sep = "%s"
    end

    local t = {} ; i = 1
    
    for str in string.gmatch( inputstr, "([^" .. sep .. "]+)" ) do
        t[i] = str
        i = i + 1
    end

    return t
end



-------------------
-- Create Folder --
-------------------
if not DATASAVE:DoesPathExist(DATASAVE.dir) then
    DATASAVE:RunLaunchChecks()
end



--------
-- DB --
--------
RegisterServerEvent('pd:SV:spawn')
AddEventHandler('pd:SV:spawn', function() 
    if DATASAVE:DoesPathExist(DATASAVE.dir) then
        if not DATASAVE:DoesFileExist(DATASAVE:GenerateFileName(source)) then
            DATASAVE:CreateFile(DATASAVE:GenerateFileName(source))
            print('[PD DATABASE]: DB file created for *'..GetPlayerName(source))
        end
    else
        print('[PD DATABASE]: Folder don\'t exist! Contact Deli#1080 [error 701]')
    end
end)

RegisterServerEvent('pd:SV:write')
AddEventHandler('pd:SV:write', function(player, data)
    if GetPlayerName(player) ~= nil then
        if not DATASAVE:DoesFileExist(DATASAVE:GenerateFileName(source)) then 
            TriggerClientEvent("pd:notify", source, '~c~[PD Database] ~r~Error!~n~~w~Player isn\'t in DB!')
            return 
        end
        DATASAVE:WriteToFile(DATASAVE:GenerateFileName(player), data)
        TriggerClientEvent("pd:notify", source, '~c~[PD Database] ~g~Success!~n~~w~Message added to database')
    else
        TriggerClientEvent("pd:notify", source, '~c~[PD Database] ~r~Error!~n~~w~Invalid player id!')
    end
end)

RegisterServerEvent('pd:SV:remove')
AddEventHandler('pd:SV:remove', function(id)
    if GetPlayerName(id) ~= nil then
        if not DATASAVE:DoesFileExist(DATASAVE:GenerateFileName(source)) then 
            TriggerClientEvent("pd:notify", source, '~c~[PD Database] ~r~Error!~n~~w~Player isn\'t in DB!')
            return 
        end
        DATASAVE:RemoveFile(DATASAVE:GenerateFileName(id))
        TriggerClientEvent("pd:notify", source, '~c~[PD Database] ~g~Success!~n~~w~Player deleted from database!')
    else
        TriggerClientEvent("pd:notify", source, '~c~[PD Database] ~r~Error!~n~~w~Invalid player id!')
    end
end)

RegisterServerEvent('pd:SV:get')
AddEventHandler('pd:SV:get', function(id)
    if GetPlayerName(id) ~= nil then
        if DATASAVE:DoesFileExist(DATASAVE:GenerateFileName(id)) then
            local data = {}
            local data = DATASAVE:LoadFile(DATASAVE:GenerateFileName(id))
            TriggerClientEvent('pd:recive', source, data, GetPlayerName(id), id)
        else
            TriggerClientEvent("pd:notify", source, '~c~[PD Database] ~r~Error!~n~~w~Player isn\'t in DB!')
        end
    else
        TriggerClientEvent("pd:notify", source, '~c~[PD Database] ~r~Error!~n~~w~Invalid player id!')
    end
end)