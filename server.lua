ESX = nil

TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)


RegisterServerEvent('matt:sellItem')
AddEventHandler('matt:sellItem', function(itemName, amount)
	local xPlayer = ESX.GetPlayerFromId(source)
	local money = Config.Itemsold[itemName]
	local xItem = xPlayer.getInventoryItem(itemName)
	if not money then
		return
	end
	if xItem.count < amount then
		TriggerClientEvent('esx:showNotification', source, 'Podana wartość jest zbyt duża!')
		return
	end
	money = ESX.Math.Round(money * amount)
	xPlayer.addMoney(money)
	xPlayer.removeInventoryItem(xItem.name, amount)
	TriggerClientEvent('esx:showNotification', source, 'Zutylizowałeś '.. xItem.label.. ' ' .. amount .. 'x za ' .. money .. '$' )
end)