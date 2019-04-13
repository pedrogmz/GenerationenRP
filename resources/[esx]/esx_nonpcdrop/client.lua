--NODROPNPC
Citizen.CreateThread(function()
  while true do
    Citizen.Wait(1)
    --Hashes key för alla vapen.. (https://pastebin.com/8EuSv2r1)
    RemoveAllPickupsOfType(0xDF711959) -- Carbine rifle
    RemoveAllPickupsOfType(0xF9AFB48F) -- Pistol
    RemoveAllPickupsOfType(0xA9355DCD) -- Pumpshotgun 
  end
end)