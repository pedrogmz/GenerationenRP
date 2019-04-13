Citizen.CreateThread(function()
    while true do
    	Citizen.Wait(0) 
    	pos = GetEntityCoords(GetPlayerPed(-1))
        heading = GetEntityHeading(GetPlayerPed(-1))
    	WriteCoords("~y~X~s~: " .. tostring(pos.x), 0.015, 0.67)
    	WriteCoords("~y~Y~s~: " .. tostring(pos.y), 0.015, 0.695)
    	WriteCoords("~y~Z~s~: " .. tostring(pos.z), 0.015, 0.72) 
    	WriteCoords("~y~Z~s~: " .. tostring(pos.z) - 0.9 .. " / ~y~Ground height", 0.015, 0.745)
    	WriteCoords("~y~H~s~: " .. tostring(heading), 0.015, 0.77)
    end
end)

function WriteCoords(txt, x, y)
	SetTextFont(4)
	SetTextProportional(0)
	SetTextScale(0.5, 0.5)
	SetTextColour(255, 255, 255, 255)
	SetTextEdge(1, 0, 0, 0, 255)
	SetTextDropShadow()
	SetTextOutline()
	SetTextEntry("STRING")
	AddTextComponentString(txt)
	DrawText(x, y)
end


AddEventHandler("playerSpawned", function()
	Citizen.CreateThread(function()
  
	  local player = PlayerId()
	  local playerPed = GetPlayerPed(-1)
  
	  -- Enable pvp
	  NetworkSetFriendlyFireOption(true)
	  SetCanAttackFriendly(playerPed, true, true)
  
	end)
  end)