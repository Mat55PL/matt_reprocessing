ESX              = nil
local PlayerData = {}

Citizen.CreateThread(function()
	while ESX == nil do
		TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)
		Citizen.Wait(0)
	end
end)

RegisterNetEvent('esx:playerLoaded')
AddEventHandler('esx:playerLoaded', function(xPlayer)
  PlayerData = xPlayer   
end)

RegisterNetEvent('esx:setJob')
AddEventHandler('esx:setJob', function(job)
  PlayerData.job = job
end)

OpenSoldMenu = function()
	ESX.UI.Menu.CloseAll()
	local elements = {}
	for k, v in pairs(ESX.GetPlayerData().inventory) do
		local price = Config.Itemsold[v.name]
		if price and v.count > 0 then
			table.insert(elements, {
				label = ('%s - <span style="color:green;">%s</span>'):format(v.label, _U('sold_item', ESX.Math.GroupDigits(price))),
				name = v.name,
				price = price,

				type = 'slider',
				value = 1,
				min = 1,
				max = v.count
			})
		end
	end

	ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'item_sold', {
		title    = 'Utylizacja',
		align    = 'center',
		elements = elements
	}, function(data, menu)
		TriggerServerEvent('matt:sellItem', data.current.name, data.current.value)
	end, function(data, menu)
		menu.close()
	end)
end	
Citizen.CreateThread(function()
	Citizen.Wait(100)

	while true do
		local sleep = 500
		local ped = PlayerPedId()
		local pedcoords = GetEntityCoords(ped)
		local dstcheck = GetDistanceBetweenCoords(pedcoords, Config.Menu["x"], Config.Menu["y"], Config.Menu["z"], true)
			if dstcheck <= 5.0 and PlayerData.job ~= nil and PlayerData.job.name == 'police' then
				sleep = 5
				text = "Utylizacja"
				if dstcheck <= 1.0 then
					text = "Naciśnij [~o~E~w~] aby otworzyć menu"
					if IsControlJustPressed(0, 38) then
						OpenSoldMenu()
					end
				end	
				DrawText3Ds(Config.Menu, text, 0.4)	
			end
		Citizen.Wait(sleep)
	end
end)

DrawText3Ds = function(coords, text, scale)
	local x,y,z = coords.x, coords.y, coords.z
	local onScreen, _x, _y = World3dToScreen2d(x, y, z)
	local pX, pY, pZ = table.unpack(GetGameplayCamCoords())

	SetTextScale(scale, scale)
	SetTextFont(4)
	SetTextProportional(1)
	SetTextEntry("STRING")
	SetTextCentre(1)
	SetTextColour(255, 255, 255, 215)
	AddTextComponentString(text)
	DrawText(_x, _y)
	local factor = (string.len(text)) / 370
	DrawRect(_x, _y + 0.0150, 0.030 + factor, 0.025, 41, 11, 41, 100)
end








--[[(  ____ \(  ____ )(  ____ \(  ___  )\__   __/(  ____ \(  __  \   (  ___ \ |\     /|  (       )(  ___  )\__   __/\__   __/
| (    \/| (    )|| (    \/| (   ) |   ) (   | (    \/| (  \  )  | (   ) )( \   / )  | () () || (   ) |   ) (      ) (   
| |      | (____)|| (__    | (___) |   | |   | (__    | |   ) |  | (__/ /  \ (_) /   | || || || (___) |   | |      | |   
| |      |     __)|  __)   |  ___  |   | |   |  __)   | |   | |  |  __ (    \   /    | |(_)| ||  ___  |   | |      | |   
| |      | (\ (   | (      | (   ) |   | |   | (      | |   ) |  | (  \ \    ) (     | |   | || (   ) |   | |      | |   
| (____/\| ) \ \__| (____/\| )   ( |   | |   | (____/\| (__/  )  | )___) )   | |     | )   ( || )   ( |   | |      | |   
(_______/|/   \__/(_______/|/     \|   )_(   (_______/(______/   |/ \___/    \_/     |/     \||/     \|   )_(      )_(  --]] 

