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


function OpenSoldMenu()
	ESX.UI.Menu.CloseAll()
	local elements = {}
	for k, v in pairs(ESX.GetPlayerData().inventory) do
		local price = Config.Itemsold[v.name]

		if price and v.count > 0 then
			table.insert(elements, {
				label = ('%s - <span style="color:green;">%s</span>'):format(v.label, _U('police_item', ESX.Math.GroupDigits(price))),
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
		title    = 'Utylizacjaa',
		align    = 'center',
		elements = elements
	}, function(data, menu)
		TriggerServerEvent('matt:sellItem', data.current.name, data.current.value)
	end, function(data, menu)
		menu.close()
	end)
end	
