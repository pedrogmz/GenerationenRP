local Keys = {
    ["ESC"] = 322, ["F1"] = 288, ["F2"] = 289, ["F3"] = 170, ["F5"] = 166, ["F6"] = 167, ["F7"] = 168, ["F8"] = 169, ["F9"] = 56, ["F10"] = 57,
    ["~"] = 243, ["1"] = 157, ["2"] = 158, ["3"] = 160, ["4"] = 164, ["5"] = 165, ["6"] = 159, ["7"] = 161, ["8"] = 162, ["9"] = 163, ["-"] = 84, ["="] = 83, ["BACKSPACE"] = 177,
    ["TAB"] = 37, ["Q"] = 44, ["W"] = 32, ["E"] = 38, ["R"] = 45, ["T"] = 245, ["Y"] = 246, ["U"] = 303, ["P"] = 199, ["["] = 39, ["]"] = 40, ["ENTER"] = 18,
    ["CAPS"] = 137, ["A"] = 34, ["S"] = 8, ["D"] = 9, ["F"] = 23, ["G"] = 47, ["H"] = 74, ["K"] = 311, ["L"] = 182,
    ["LEFTSHIFT"] = 21, ["Z"] = 20, ["X"] = 73, ["C"] = 26, ["V"] = 0, ["B"] = 29, ["N"] = 249, ["M"] = 244, [","] = 82, ["."] = 81,
    ["LEFTCTRL"] = 36, ["LEFTALT"] = 19, ["SPACE"] = 22, ["RIGHTCTRL"] = 70,
    ["HOME"] = 213, ["PAGEUP"] = 10, ["PAGEDOWN"] = 11, ["DELETE"] = 178,
    ["LEFT"] = 174, ["RIGHT"] = 175, ["TOP"] = 27, ["DOWN"] = 173,
    ["NENTER"] = 201, ["N4"] = 108, ["N5"] = 60, ["N6"] = 107, ["N+"] = 96, ["N-"] = 97, ["N7"] = 117, ["N8"] = 61, ["N9"] = 118      }

------------
-- CONFIG --
------------
local TOGGLE_PDDATABASE_KEY = Keys["PAGEDOWN"]

local LANG = {

	POLICE_DEPT 	= 'Svenska Polismyndigheten',
	DEPT_DESC 		= 'Skydda & Rädda',

	APP_NAME 		= 'Brottsregister',

	BUTTON_ADD 		= 'Lägg till',
	BUTTON_GET 		= 'Sök',
	BUTTON_DEL 		= 'Ta bort',
	BUTTON_DEL_WARN = 'Ta bort',

	ERROR_ONLY_NUMBER = "~r~Fel!~n~~w~Skriv bara nummer!",
	ERROR_INVALID_MSG = "r~Fel!~n~~w~Du kan inte skriva såhär!",
}


--[[-----------]]
--[[---CODE----]]
--[[-----------]]


PlayerData = xPlayer
RegisterNetEvent('esx:playerLoaded')
AddEventHandler('esx:playerLoaded', function(xPlayer)
  PlayerData = xPlayer
end)
RegisterNetEvent('esx:setJob')
AddEventHandler('esx:setJob', function(job)
  PlayerData.job = job
end)
local first = true
AddEventHandler('playerSpawned', function(spawn)
	if first then 
		TriggerServerEvent("pd:SV:spawn") 
		first = false
	end
end)
RegisterNetEvent("pd:add")
AddEventHandler("pd:add", function()
	local _id = Input(data,'ID')
	local data = Input(data,'msg')
	if tonumber(_id) == nil then
		Notify(LANG.ERROR_ONLY_NUMBER)
		return
	end
	if data == nil or data == "" then 
		Notify(LANG.ERROR_INVALID_MSG)
	else
		TriggerServerEvent("pd:SV:write", _id, data)
	end
end)
RegisterNetEvent("pd:notify")
AddEventHandler("pd:notify", function(msg)
	Notify(msg)
end)
local deli = false
local data = {msg = nil, player_name = nil, player_id = nil}
RegisterNetEvent("pd:recive")
AddEventHandler("pd:recive", function(_data, _player_name, _player_id)
	data.msg = _data
	data.player_name = _player_name
	data.player_id = _player_id
	deli = true
end)
Citizen.CreateThread(function ()
	LoadTexture("3dtextures")
	while true do Citizen.Wait(1)
		if IsControlJustPressed(0, TOGGLE_PDDATABASE_KEY) then
			if PlayerData.job.name ~= nil then
				if PlayerData.job.name == 'police' then
					deli = true
				else
					print('[PD DATABASE] Player not in "police"')
				end
			else
				print("[PD DATABASE] Contact Deli#1080 on discord -> ERROR_ID: 501")
			end
		end
		if deli then
			ShowCursorThisFrame()
			DatabaseUI()
			DisableControlAction(0, 1, true)
     		DisableControlAction(0, 2, true)
     		DisableControlAction(0, 142, true)
     		DisableControlAction(0, 106, true)
			key = MouseInteraction()
			if key ~= nil then
				if IsControlJustPressed(0, 24) then
					if key == "quit" then
						deli = false
						data.msg = nil
						data.player_id = nil
						data.player_name = nil
					elseif key == "add" then
						data.msg = nil
						data.player_id = nil
						data.player_name = nil
						TriggerEvent('pd:add')
					elseif key == "get" then
						data.msg = nil
						data.player_id = nil
						data.player_name = nil
						local _id = Input(data,'ID')
						if tonumber(_id) ~= nil then
							TriggerServerEvent('pd:SV:get', _id)
						else
							Notify(''..LANG.ERROR_ONLY_NUMBER)
						end
					elseif key == "del" then
						data.msg = nil
						data.player_id = nil
						data.player_name = nil
						local _id = Input(data,'ID')
						if tonumber(_id) ~= nil then
							TriggerServerEvent('pd:SV:remove', _id)
						else
							Notify(''..LANG.ERROR_ONLY_NUMBER)
						end
					end
				end
			end
		else
			EnableControlAction(0, 1, true)
     		EnableControlAction(0, 2, true)
     		EnableControlAction(0, 142, true)
     		EnableControlAction(0, 106, true)
		end
	end
end)
local HUD = {
	x = 0.5, y = 0.5, 
	x_btn = {text = "~h~~w~X", x = 0.18, y = -0.185, w = 0.02, h = 0.03}, 
	MENU = {min_y = 0.26+0.085, max_y = 0.29+0.085, add = 0, get = 0, del = 0, del_msg = LANG.BUTTON_DEL} } 
function DatabaseUI()
	DrawRect(HUD.x, HUD.y + 0.00,	0.600 - 0.2, 0.600 - 0.2, 	25,25,25, 255)
	DrawRect(HUD.x, HUD.y + 0.0185,	0.600 - 0.2, 0.560 - 0.2, 	70,130,180, 150)
	drawTxt(0.35, 0.30, 0.6, 1, LANG.APP_NAME, 200,200,200, 'center', false)
	DrawRect(HUD.x + HUD.x_btn.x, HUD.y + HUD.x_btn.y,	HUD.x_btn.w, HUD.x_btn.h, 	100,100,100, 255)
	drawTxt(0.68, 0.29, 0.6, 0, HUD.x_btn.text, 255,255,255, 'center', false)
	drawTxt(0.58 - 0.02, 0.24 + 0.095, 0.45, 2, LANG.POLICE_DEPT, 255,255,255, 'left', false)
	drawTxt(0.62 - 0.02, 0.26 + 0.095, 0.4, 1, LANG.DEPT_DESC, 160,160,160, 'left', false)
	DrawRect(HUD.x, HUD.y - 0.115,	0.6 - 0.2, 0.01, 	255,215,0, 200)
	DrawSprite("3dtextures", "mpgroundlogo_cops", 0.5,0.55, 0.19, 0.23, 0, 100,100,150, 20)
	drawTxt(0.305, 0.25+0.085, 0.6, 4, LANG.BUTTON_ADD	 , 190 + HUD.MENU.add, 155 + HUD.MENU.add + 40, 0, 'left', false)
	drawTxt(0.37, 0.25+0.085, 0.6, 4, LANG.BUTTON_GET	 , 190 + HUD.MENU.get, 155 + HUD.MENU.get + 40, 0, 'left', false)
	drawTxt(0.41, 0.25+0.085, 0.6, 4, del_msg , 190 + HUD.MENU.del, 155 + HUD.MENU.del + 40, 0, 'left', false)
	if data.msg ~= nil then
		for i = 1,#data.msg do
			drawTxt(0.305, 0.37 + i / 40, 0.45, 6, ''..data.msg[i], 255, 255, 255, 'left', false)
		end
	end
	if data.player_id ~= nil then
		drawTxt(0.50, 0.30, 0.5, 0, '~w~ [~s~'..data.player_id..'~w~] '..'~s~'..data.player_name, 255, 215, 0, 'center', false)
	end
end
function MouseInteraction()
	local MouseX = GetControlNormal(0,239)
	local MouseY = GetControlNormal(0,240)
	if 	(MouseX >= HUD.x + HUD.x_btn.x - HUD.x_btn.w/2 and MouseX <= HUD.x + HUD.x_btn.x + HUD.x_btn.w/2)
	and (MouseY >= HUD.y + HUD.x_btn.y - HUD.x_btn.h/2 and MouseY <= HUD.y + HUD.x_btn.y + HUD.x_btn.h/2) then
		HUD.x_btn.text = "~h~~r~X"
		return ('quit')
	else
		HUD.x_btn.text = "~h~~w~X"
	end
	if (MouseX >= 0.305 and MouseX <= 0.35) and (MouseY >= HUD.MENU.min_y and MouseY <= HUD.MENU.max_y) then
		HUD.MENU.add = 55
		return('add')
	else
		HUD.MENU.add = 0
	end

	if (MouseX >= 0.37 and MouseX <= 0.39) and (MouseY >= HUD.MENU.min_y and MouseY <= HUD.MENU.max_y) then
		HUD.MENU.get = 55
		return('get')
	else
		HUD.MENU.get = 0
	end
	if (MouseX >= 0.41 and MouseX <= 0.45) and (MouseY >= HUD.MENU.min_y and MouseY <= HUD.MENU.max_y) then
		HUD.MENU.del = 55
		del_msg = LANG.BUTTON_DEL_WARN
		return('del')
	else
		del_msg = LANG.BUTTON_DEL
		HUD.MENU.del = 0
	end
	return("nothing")
end
function LoadTexture(name)
	if not HasStreamedTextureDictLoaded(name) then
		RequestStreamedTextureDict(name, true)
		while not HasStreamedTextureDictLoaded(name) do
			Wait(1)
		end
	end
end
function Input(var,help)
	DisplayOnscreenKeyboard(6, "FMMC_KEY_TIP8", "", help, "", "", "", 60)
	while UpdateOnscreenKeyboard() == 0 do
		DisableAllControlActions(0)
		Citizen.Wait(0)
	end
	if GetOnscreenKeyboardResult() then
		var = GetOnscreenKeyboardResult()
	end
	return var
end
function Notify(text)
	SetNotificationTextEntry('STRING')
	AddTextComponentString(text)
	DrawNotification(true, false)
end
function drawTxt(x,y,scale,font,text, r,g,b, mode, outline)
    if r == nil then r,g,b = 255,255,255 end
    if mode == 'center' then
        Citizen.InvokeNative(0x4E096588B13FFECA, 0)
    elseif mode == 'right' then
        Citizen.InvokeNative(0x4E096588B13FFECA, 2)
    else
        mode = 0
    end
    SetTextFont(font)
    SetTextProportional(0)
    SetTextScale(scale, scale)
    SetTextColour(r,g,b, 255)
    if outline == true or outline == nil then
        SetTextDropShadow(0,0,0,0,255)
        SetTextEdge(2, 0, 0, 0, 255)
        SetTextDropShadow()
        SetTextOutline()
    end
    SetTextEntry("STRING")
    AddTextComponentString(text)
    DrawText(x , y)
end