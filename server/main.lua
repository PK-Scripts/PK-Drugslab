Labs = {}
Stash = {}
inventory = {}
ClosestDrugslab = nil
key = "&a2F0WuoZHmk#8hYK7!*CJ*&LwoK"

function sendtoDiscord(id, player, item, amount, reason, cheater, TrueorNO)
	local spelernaam = GetPlayerName(id)
    local WebHook = Config.WebHook

    local discordInfo = {
        ["color"] = "16711680",
        ["type"] = "rich",
        ["title"] = "[PK SCRIPTS]",
        ["description"] = "**Steamnaam:** " .. spelernaam .. "\n **identifier: **" .. player .. "\n **ID: **".. id.. "\n **Item:** "..item.. "\n **Hoeveelheid:** "..amount.."\n **Reden:** "..reason .. "\n **HackerDetectie:** " .. cheater,
        ["footer"] = {
        ["text"] = "PK Logs" 
		}
    }
	PerformHttpRequest(WebHook, function(err, text, headers) end, 'POST', json.encode({ username = 'CT SCRIPTS', embeds = { discordInfo } }), { ['Content-Type'] = 'application/json' })
	if TrueorNO then 
		PerformHttpRequest(WebHook, function(err, text, headers) end, 'POST', json.encode({ username = 'CT SCRIPTS', content = "@here" }), { ['Content-Type'] = 'application/json'})
	end
end

function sendtoDiscordwitwas(witwasser, amount, totaal, zwartgeld)
    local WebHook = Config.WebHook

    local discordInfo = {
        ["color"] = "16711680",
        ["type"] = "rich",
        ["title"] = "[PK SCRIPTS]",
        ["description"] = "\n **WITWAS** \n **Steamnaam:** " .. witwasser .. " \n **Geld Gewassen: ** €" .. amount .. " \n **Totaal overgehouden:** €" .. totaal .. " \n **Huidig zwartgeld:** €" .. zwartgeld,
        ["footer"] = {
        ["text"] = "PK Logs" 
		}
    }
	PerformHttpRequest(WebHook, function(err, text, headers) end, 'POST', json.encode({ username = 'CT SCRIPTS', embeds = { discordInfo } }), { ['Content-Type'] = 'application/json' })
	if TrueorNO then 
		PerformHttpRequest(WebHook, function(err, text, headers) end, 'POST', json.encode({ username = 'CT SCRIPTS', content = "@here" }), { ['Content-Type'] = 'application/json'})
	end
end

function sendtoDiscordWitWasUp(id, player, witwaslevel, witwaslevelupgraded, reason, cheater, TrueorNO)
	local spelernaam = GetPlayerName(id)
    local WebHook = Config.WebHook

    local discordInfo = {
        ["color"] = "16711680",
        ["type"] = "rich",
        ["title"] = "[PK SCRIPTS]",
        ["description"] = "\n **WITWAS** \n **Steamnaam:** " .. spelernaam .. "\n **identifier: **" .. player .. "\n **ID: **".. id.. "\n **Voor upgrade:** ".. witwaslevel .. "\n **Na upgrade:** "..witwaslevelupgraded,
        ["footer"] = {
        ["text"] = "PK Logs" 
		}
    }
	PerformHttpRequest(WebHook, function(err, text, headers) end, 'POST', json.encode({ username = 'CT SCRIPTS', embeds = { discordInfo } }), { ['Content-Type'] = 'application/json' })
	if TrueorNO then 
		PerformHttpRequest(WebHook, function(err, text, headers) end, 'POST', json.encode({ username = 'CT SCRIPTS', content = "@here" }), { ['Content-Type'] = 'application/json'})
	end
end

function sendtoDiscordLabUp(id, player, labshell, labshellupgraded, labid, cost)
	local spelernaam = GetPlayerName(id)
    local WebHook = Config.WebHook

    local discordInfo = {
        ["color"] = "16711680",
        ["type"] = "rich",
        ["title"] = "[PK SCRIPTS]",
        ["description"] = "\n **Lab Upgrade** \n **Steamnaam:** " .. spelernaam .. "\n **identifier: **" .. player .. "\n **ID: **".. id.. "\n **Prijs:**"..cost.. " \n **Voor upgrade:** ".. labshell .. "\n **Na upgrade:** "..labshellupgraded .. "\n **LabID: **" .. labid,
        ["footer"] = {
        ["text"] = "PK Logs" 
		}
    }
	PerformHttpRequest(WebHook, function(err, text, headers) end, 'POST', json.encode({ username = 'CT SCRIPTS', embeds = { discordInfo } }), { ['Content-Type'] = 'application/json' })
	if TrueorNO then 
		PerformHttpRequest(WebHook, function(err, text, headers) end, 'POST', json.encode({ username = 'CT SCRIPTS', content = "@here" }), { ['Content-Type'] = 'application/json'})
	end
end

function KrijgDrugsLab()
	Labs = nil
	if Config.MYSQLUsage == "mysqlasync" then
		MySQL.Async.fetchAll("SELECT * , JSON_EXTRACT(pos, '$.x') x, JSON_EXTRACT(pos, '$.y') y, JSON_EXTRACT(pos, '$.z') z FROM `pk_drugslab`", {}, function(result)
			if result and #result > 0 then
				Labs = result
			end
		end)
	elseif Config.MYSQLUsage == "ghamttimysql" then
		exports.ghamttimysql:execute("SELECT * , JSON_EXTRACT(pos, '$.x') x, JSON_EXTRACT(pos, '$.y') y, JSON_EXTRACT(pos, '$.z') z FROM `pk_drugslab`", {}, function(result)
			if result and #result > 0 then
				Labs = result
			end
		end)
	elseif Config.MYSQLUsage == "oxmysql" then
		query = "SELECT * , JSON_EXTRACT(pos, '$.x') x, JSON_EXTRACT(pos, '$.y') y, JSON_EXTRACT(pos, '$.z') z FROM `pk_drugslab`"
		exports.oxmysql:execute(query, {}, function(result)
			if result and #result > 0 then
				Labs = result
			end
		end)
	end
end

table.indexOf = function ( tab, value )
  for index, val in ipairs(tab) do
    if value == val then
      return index
    end
  end
      return -1
end

RegisterServerEvent('pk-drugslab:finisheddrugsrun')
AddEventHandler('pk-drugslab:finisheddrugsrun', function(drugstype)
	if drugstype ~= nil then
		local xPlayer = ESX.GetPlayerFromId(source)
		local xItem = xPlayer.getInventoryItem(drugstype)
		xPlayer.addInventoryItem(xItem.name,tonumber(Config.Inkoopgeef))
		sendtoDiscord(source, xPlayer.identifier, xItem.name, tonumber(Config.Inkoopgeef), "Drugs Run gedaan", "Nee", false)
	end
end)

RegisterServerEvent('pk-drugslab:witwasupgraded')
AddEventHandler('pk-drugslab:witwasupgraded', function(witwaslevel, witwaslevelupgraded, id)
	local xPlayer = ESX.GetPlayerFromId(source)
	if xPlayer.getMoney() >= Config.WitwasLevels[witwaslevelupgraded].money then
		xPlayer.removeMoney(Config.WitwasLevels[witwaslevelupgraded].money)
		if Config.MYSQLUsage == "mysqlasync" then
				MySQL.Async.execute("UPDATE `pk_drugslab` SET `witwaslevel` = @witwaslevel WHERE id = @id", {
					["witwaslevel"] = tonumber(witwaslevelupgraded),
					["@id"] = id,
				})
		elseif Config.MYSQLUsage == "ghamttimysql" then
			exports.ghamttimysql.execute("UPDATE `pk_drugslab` SET `witwaslevel` = @witwaslevel WHERE id = @id", {
				["witwaslevel"] = tonumber(witwaslevelupgraded),
				["@id"] = id,
			})
		elseif Config.MYSQLUsage == "oxmysql" then
			exports.oxmysql:execute("UPDATE `pk_drugslab` SET `witwaslevel` = @witwaslevel WHERE id = @id", {
				["witwaslevel"] = tonumber(witwaslevelupgraded),
				["@id"] = id,
			})
		end
		sendtoDiscordWitWasUp(source, xPlayer.identifier, witwaslevel, witwaslevelupgraded, "Heeft Witwas geupgrade", "Nee", false)
		Wait(100)
		KrijgDrugsLab()
		refreshlabsclient(src)
	end
end)

RegisterServerEvent('pk-drugslab:labupgraded')
AddEventHandler('pk-drugslab:labupgraded', function(cost, vorigelab, lab, id)
	local xPlayer = ESX.GetPlayerFromId(source)
	if xPlayer.getMoney() >= cost then
		xPlayer.removeMoney(cost)
		if Config.MYSQLUsage == "mysqlasync" then
			MySQL.Async.execute("UPDATE `pk_drugslab` SET `shell` = @shell WHERE id = @id", {
				["shell"] = lab,
				["@id"] = id,
			})
		elseif Config.MYSQLUsage == "ghamttimysql" then
			exports.ghamttimysql.execute("UPDATE `pk_drugslab` SET `shell` = @shell WHERE id = @id", {
				["shell"] = lab,
				["@id"] = id,
			})
		elseif Config.MYSQLUsage == "oxmysql" then
			exports.oxmysql:execute("UPDATE `pk_drugslab` SET `shell` = @shell WHERE id = @id", {
				["shell"] = lab,
				["@id"] = id,
			})
		end
		sendtoDiscordLabUp(source, xPlayer.identifier, vorigelab, lab, id, cost)
		Wait(100)
		KrijgDrugsLab()
		refreshlabsclient(src)
	elseif xPlayer.getAccount("bank").money >= cost then
		xPlayer.removeAccountMoney("bank", cost)
		if Config.MYSQLUsage == "mysqlasync" then
			MySQL.Async.execute("UPDATE `pk_drugslab` SET `shell` = @shell WHERE id = @id", {
				["shell"] = lab,
				["@id"] = id,
			})
		elseif Config.MYSQLUsage == "ghamttimysql" then
			exports.ghamttimysql.execute("UPDATE `pk_drugslab` SET `shell` = @shell WHERE id = @id", {
				["shell"] = lab,
				["@id"] = id,
			})
		elseif Config.MYSQLUsage == "oxmysql" then
			exports.oxmysql:execute("UPDATE `pk_drugslab` SET `shell` = @shell WHERE id = @id", {
				["shell"] = lab,
				["@id"] = id,
			})
		end
		sendtoDiscordLabUp(source, xPlayer.identifier, vorigelab, lab, id, cost)
		Wait(100)
		KrijgDrugsLab()
		refreshlabsclient(src)
	end
end)

RegisterServerEvent('pk-drugslab:refreshLabs')
AddEventHandler('pk-drugslab:refreshLabs', function(xPlayer1)
	refreshlabsclient(1)
end)

RegisterServerEvent('pk-drugslab:starteddrugsrun')
AddEventHandler('pk-drugslab:starteddrugsrun', function(xPlayer1)
	refreshlabsclient(1)
end)

ESX.RegisterCommand('lab-create', "admin", function(xPlayer, args, showError)
	xPlayer.triggerEvent('pk-drugslab:createlab', xPlayer)
end, true)

ESX.RegisterCommand('lab-remove', "admin", function(xPlayer, args, showError)
	xPlayer.triggerEvent('pk-drugslab:removelab', xPlayer)
end, true)

function refreshlabsclient(something)
	Wait(20)
	TriggerClientEvent('pk-drugslab:SyncLabs1', -1)
end

RegisterServerEvent('pk-drugslab:leg1')
AddEventHandler('pk-drugslab:leg1', function(src, item, amount, id, ClosestDrugslab1)
	if Config.Framework == 'esx' then
		local xPlayer = ESX.GetPlayerFromId(source)
		local xItem = xPlayer.getInventoryItem(item)
		local inventory, count = {}, 0
		local DrugslabItems = json.decode(Labs[ClosestDrugslab1].stash)
		local DrugslabItem = getDrugslabItem(xItem, DrugslabItems)
		if DrugslabItem == nil then
			local t = PlayerInventoryItemToDrugslabItem(xPlayer, xItem, tonumber(amount), xPlayer.inventory)
			xPlayer.removeInventoryItem(item,tonumber(amount))
			table.insert(DrugslabItems, t)
		else
			local index = table.indexOf(DrugslabItems, DrugslabItem)
			if index > 0 then
				table.remove(DrugslabItems, index)
				DrugslabItem.count = DrugslabItem.count + amount
				xPlayer.removeInventoryItem(item,tonumber(amount))
				table.insert(DrugslabItems, DrugslabItem)
			elseif index < 0 then
				print("DEZE INDEX IS NULL: ".. index)
			end
		end
		sendtoDiscord(source, xPlayer.identifier, item, tonumber(amount), "Item in drugslab gedaan", "Nee", false)
		if Config.MYSQLUsage == "mysqlasync" then
			MySQL.Async.execute("UPDATE `pk_drugslab` SET `stash` = @inventory WHERE id = @id", {
				["@inventory"] = json.encode(DrugslabItems),
				["@id"] = id,
			})
		elseif Config.MYSQLUsage == "ghamttimysql" then
			exports.ghamttimysql.execute("UPDATE `pk_drugslab` SET `stash` = @inventory WHERE id = @id", {
				["@inventory"] = json.encode(DrugslabItems),
				["@id"] = id,
			})
		elseif Config.MYSQLUsage == "oxmysql" then
			exports.oxmysql:execute("UPDATE `pk_drugslab` SET `stash` = @inventory WHERE id = @id", {
				["@inventory"] = json.encode(DrugslabItems),
				["@id"] = id,
			})
		end
	elseif Config.Framework == 'qbcore'  then
		local xPlayer = QBCore.Functions.GetPlayer(source)
		local identifier = xPlayer.PlayerData.license
		local xItem = xPlayer.Functions.GetItemByName(item)
		local count = 0
		local DrugslabItems = json.decode(Labs[ClosestDrugslab1].stash)
		local DrugslabItem = getDrugslabItem(xItem, DrugslabItems)
		if DrugslabItem == nil then
			local t = PlayerInventoryItemToDrugslabItem(xPlayer, xItem, tonumber(amount), xPlayer.PlayerData.items)
			xPlayer.Functions.RemoveItem(item ,tonumber(amount))
			table.insert(DrugslabItems, t)
		else
			local index = table.indexOf(DrugslabItems, DrugslabItem)
			if index > 0 then
				table.remove(DrugslabItems, index)
				DrugslabItem.count = DrugslabItem.count + amount
				xPlayer.Functions.RemoveItem(item,tonumber(amount))
				table.insert(DrugslabItems, DrugslabItem)
			elseif index < 0 then
				print("DEZE INDEX IS NULL: ".. index)
			end
		end
		sendtoDiscord(source, xPlayer.identifier, item, tonumber(amount), "Item in drugslab gedaan", "Nee", false)
		if Config.MYSQLUsage == "mysqlasync" then
			MySQL.Async.execute("UPDATE `pk_drugslab` SET `stash` = @inventory WHERE id = @id", {
				["@inventory"] = json.encode(DrugslabItems),
				["@id"] = id,
			})
		elseif Config.MYSQLUsage == "ghamttimysql" then
			exports.ghamttimysql.execute("UPDATE `pk_drugslab` SET `stash` = @inventory WHERE id = @id", {
				["@inventory"] = json.encode(DrugslabItems),
				["@id"] = id,
			})
		elseif Config.MYSQLUsage == "oxmysql" then
			exports.oxmysql:execute("UPDATE `pk_drugslab` SET `stash` = @inventory WHERE id = @id", {
				["@inventory"] = json.encode(DrugslabItems),
				["@id"] = id,
			})
		end
	end
	Wait(100)
	KrijgDrugsLab()
	refreshlabsclient(src)
end)

function PlayerInventoryItemToDrugslabItem(xPlayer, xItem, amount, playerinventory)
	if Config.Framework == "esx" then
		for k, v in pairs(playerinventory) do
			if v.name == xItem.name and xItem.count > amount then
				return {
					name = v.name,
					count = amount,
					label = v.label,
				}
			end
		end
	elseif Config.Framework == "qbcore" then
		for k, v in pairs(playerinventory) do
			if v.name == xItem.name and xItem.amount > amount then
				return {
					name = v.name,
					count = amount,
					label = v.label,
				}
			end
		end
	end
end

function getDrugslabItem(item, DrugslabItems)
	for kl, itemDrugslab in pairs(DrugslabItems) do
		if itemDrugslab.name == item.name then
			return itemDrugslab
		end
	end
	return nil
end

RegisterServerEvent('pk-drugslab:krijg1')
AddEventHandler('pk-drugslab:krijg1', function(item, amount, id, ClosestDrugslab1)
	if Config.Framework == 'esx' then
		local xPlayer = ESX.GetPlayerFromId(source)
		local xItem = xPlayer.getInventoryItem(item)
		local inventory, count = {}, 0
		local DrugslabItems = json.decode(Labs[ClosestDrugslab1].stash)
		local DrugslabItem = getDrugslabItem(xItem, DrugslabItems)
		local index = table.indexOf(DrugslabItems, DrugslabItem)
		for k,v in pairs(DrugslabItems) do
			if v.name == xItem.name and tonumber(v.count) >= tonumber(amount) then 
				if index > 0 then
					table.remove(DrugslabItems, index)
					DrugslabItem.count = DrugslabItem.count - amount
					if DrugslabItem.count >= 1 then
						xPlayer.addInventoryItem(item,tonumber(amount))
						table.insert(DrugslabItems, DrugslabItem)
					elseif DrugslabItem.count <= 0 then
						xPlayer.addInventoryItem(item,tonumber(amount))
						table.remove(DrugslabItems, index)
					end
					sendtoDiscord(source, xPlayer.identifier, item, tonumber(amount), "Item uit drugslab gehaalt", "Nee", false)
				elseif index < 0 then
					print("DEZE INDEX IS NULL: ".. index)
				end
				
				if Config.MYSQLUsage == "mysqlasync" then
					MySQL.Async.execute("UPDATE `pk_drugslab` SET `stash` = @inventory WHERE id = @id", {
						["@inventory"] = json.encode(DrugslabItems),
						["@id"] = id,
					})
				elseif Config.MYSQLUsage == "ghamttimysql" then
					exports.ghamttimysql.execute("UPDATE `pk_drugslab` SET `stash` = @inventory WHERE id = @id", {
						["@inventory"] = json.encode(DrugslabItems),
						["@id"] = id,
					})
				elseif Config.MYSQLUsage == "oxmysql" then
					exports.oxmysql:execute("UPDATE `pk_drugslab` SET `stash` = @inventory WHERE id = @id", {
						["@inventory"] = json.encode(DrugslabItems),
						["@id"] = id,
					})
				end
			end
		end
	elseif Config.Framework == 'qbcore'  then
		local xPlayer = QBCore.Functions.GetPlayer(source)
		local xItem = xPlayer.Functions.GetItemByName(item)
		local inventory, count = {}, 0
		local DrugslabItems = json.decode(Labs[ClosestDrugslab1].stash)
		local DrugslabItem = getDrugslabItem(xItem, DrugslabItems)
		local index = table.indexOf(DrugslabItems, DrugslabItem)
		for k,v in pairs(DrugslabItems) do
			if v.name == xItem.name and tonumber(v.count) >= tonumber(amount) then 
				if index > 0 then
					table.remove(DrugslabItems, index)
					DrugslabItem.count = DrugslabItem.count - amount
					if DrugslabItem.count >= 1 then
						xPlayer.Functions.AddItem(item,tonumber(amount))
						table.insert(DrugslabItems, DrugslabItem)
					elseif DrugslabItem.count <= 0 then
						xPlayer.Functions.AddItem(item,tonumber(amount))
						table.remove(DrugslabItems, index)
					end
					sendtoDiscord(source, xPlayer.identifier, item, tonumber(amount), "Item uit drugslab gehaalt", "Nee", false)
				elseif index < 0 then
					print("DEZE INDEX IS NULL: ".. index)
				end
				
				if Config.MYSQLUsage == "mysqlasync" then
					MySQL.Async.execute("UPDATE `pk_drugslab` SET `stash` = @inventory WHERE id = @id", {
						["@inventory"] = json.encode(DrugslabItems),
						["@id"] = id,
					})
				elseif Config.MYSQLUsage == "ghamttimysql" then
					exports.ghamttimysql.execute("UPDATE `pk_drugslab` SET `stash` = @inventory WHERE id = @id", {
						["@inventory"] = json.encode(DrugslabItems),
						["@id"] = id,
					})
				elseif Config.MYSQLUsage == "oxmysql" then
					exports.oxmysql:execute("UPDATE `pk_drugslab` SET `stash` = @inventory WHERE id = @id", {
						["@inventory"] = json.encode(DrugslabItems),
						["@id"] = id,
					})
				end
			end
		end
	end
	Wait(100)
	KrijgDrugsLab()
	refreshlabsclient(src)
end)
KrijgDrugsLab()
RegisterServerEvent('pk-drugslab:ClosestDrugslab')
AddEventHandler('pk-drugslab:ClosestDrugslab', function(ClosestDrugslabLoad)
	ClosestDrugslab = ClosestDrugslabLoad
end)

RegisterServerEvent('pk-drugslab:Verpak')
AddEventHandler('pk-drugslab:Verpak', function(itemdrugs, itemdrugsverpakt, keyGet)
	if Config.Framework == 'esx' then
		local _source = source 
		local xPlayer = ESX.GetPlayerFromId(_source)
		local drugs = xPlayer.getInventoryItem(itemdrugs)
	
		if key == keyGet then
			if drugs.count >= 5 then
				xPlayer.removeInventoryItem(itemdrugs, 5)
				xPlayer.addInventoryItem(itemdrugsverpakt, 2)
				sendtoDiscord(source, xPlayer.identifier, itemdrugs, 2, "Verpakt", "Nee", false)
			elseif drugs.count < 5 then 
				Notification(3, 'Je hebt niet genoeg '.. drugs.label ..'', source)
			end
		elseif not keyGet == key then
			sendtoDiscord(source, xPlayer.identifier, itemdrugs, 2, "Verpakt", "JA", true)
		end
	elseif Config.Framework == 'qbcore'  then
		local _source = source 
		local xPlayer = QBCore.Functions.GetPlayer(_source)
		local drugs = xPlayer.Functions.GetItemByName(itemdrugs)
	
		if key == keyGet then
			if drugs.amount >= 5 and zakje >= 2 then
				xPlayer.Functions.RemoveItem(itemdrugs, 5)
				xPlayer.Functions.AddItem(itemdrugsverpakt, 2)
				sendtoDiscord(source, xPlayer.identifier, itemdrugs, 2, "Verpakt", "Nee", false)
			elseif drugs.amount < 5 then 
				Notification(3, 'Je hebt niet genoeg '.. drugs.label ..'', source)
			end
		elseif not keyGet == key then
			sendtoDiscord(source, xPlayer.identifier, itemdrugs, 2, "Verpakt", "JA", true)
		end
	end
end)

labid = nil

function maakLab(src,prijs,shell,pincode)
    if Config.Framework == "esx" then
		local xPlayer = ESX.GetPlayerFromId(src)
	elseif Config.Framework == "qbcore" then
		local xPlayer = QBCore.Functions.GetPlayer(src)
	end
	local huisID = "PK-" .. math.random(1000, 9999)
	labid = huisID
	print(huisID, json.encode(GetEntityCoords(GetPlayerPed(src))), prijs, shell, pincode)
	if Config.MYSQLUsage == "mysqlasync" then
		MySQL.Async.execute("INSERT INTO `pk_drugslab` ( `id`, `pos`, `price`, `shell`, `pincode`, `stash`) VALUES (@id, @pos, @price, @shell, @pincode, @stash)", {
			["@id"] = huisID,
			["@pos"] = json.encode(GetEntityCoords(GetPlayerPed(src))),
			["@price"] = prijs,
			["@shell"] = shell,
			["@pincode"] = pincode,
			["@stash"] = "{}",
		})
	elseif Config.MYSQLUsage == "ghamttimysql" then
		exports.ghamttimysql.execute("INSERT INTO `pk_drugslab` ( `id`, `pos`, `price`, `shell`, `pincode`, `stash`) VALUES (@id, @pos, @price, @shell, @pincode, @stash)", {
			["@id"] = huisID,
			["@pos"] = json.encode(GetEntityCoords(GetPlayerPed(src))),
			["@price"] = prijs,
			["@shell"] = shell,
			["@pincode"] = pincode,
			["@stash"] = "{}",
		})
	elseif Config.MYSQLUsage == "oxmysql" then
		exports.oxmysql:execute("INSERT INTO `pk_drugslab` ( `id`, `pos`, `price`, `shell`, `pincode`, `stash`) VALUES (@id, @pos, @price, @shell, @pincode, @stash)", {
			["@id"] = huisID,
			["@pos"] = json.encode(GetEntityCoords(GetPlayerPed(src))),
			["@price"] = prijs,
			["@shell"] = shell,
			["@pincode"] = pincode,
			["@stash"] = "{}",
		})
	end
	KrijgDrugsLab()
end

function verwijderLab(id)
	if Config.MYSQLUsage == "mysqlasync" then
		MySQL.Async.execute("DELETE FROM pk_drugslab WHERE id = @id", {
			["@id"] = id,
		})
	elseif Config.MYSQLUsage == "ghamttimysql" then
		exports.ghamttimysql.execute("DELETE FROM pk_drugslab WHERE id = @id", {
			["@id"] = id,
		})
	elseif Config.MYSQLUsage == "oxmysql" then
		exports.oxmysql:execute("DELETE FROM pk_drugslab WHERE id = @id", {
			["@id"] = id,
		})
	end
	KrijgDrugsLab()
end

function veranderpin(id, pincode)
	if Config.MYSQLUsage == "mysqlasync" then
		MySQL.Async.execute("UPDATE pk_drugslab SET pincode=@pincode WHERE id = @id", {
			["@id"] = id,
			["@pincode"] = pincode,
		})
	elseif Config.MYSQLUsage == "ghamttimysql" then
		exports.ghamttimysql.execute("UPDATE pk_drugslab SET pincode=@pincode WHERE id = @id", {
			["@id"] = id,
			["@pincode"] = pincode,
		})
	elseif Config.MYSQLUsage == "oxmysql" then
		exports.oxmysql:execute("UPDATE pk_drugslab SET pincode=@pincode WHERE id = @id", {
			["@id"] = id,
			["@pincode"] = pincode,
		})
	end
	KrijgDrugsLab()
end

RegisterNetEvent('pk-drugslab:witwassen')
AddEventHandler('pk-drugslab:witwassen', function(amount, witwaslevel)
    local _source = source
    local xPlayer = ESX.GetPlayerFromId(_source)
    amount        = ESX.Math.Round(tonumber(amount))
	tax = Config.WitwasLevels[witwaslevel].tax
	
    local witwasser = GetPlayerName(source)
		
    totaalTax = ESX.Math.Round(tonumber(amount * tax))
    totaal    = tonumber(totaalTax)
		
    if xPlayer.getAccount('black_money').money >= amount then
         xPlayer.removeAccountMoney('black_money', amount)
         xPlayer.addMoney(totaal)
		 Notification(1, 'Je hebt ~g~€' .. totaal .. ' ~w~overgehouden na het witwassen van ~r~€' .. amount, source)
         local zwartgeld = xPlayer.getAccount('black_money').money
		sendtoDiscordwitwas(witwasser,amount,totaal,zwartgeld)
    else
		 Notification(1, '~r~Je hebt niet zoveel zwart geld op zak', src)
    end
end)

if Config.Framework == 'esx' then
	ESX.RegisterServerCallback('pk-drugslab:maakLab', function(src, cb, prijs, shell, pincode)
		maakLab(src, prijs, shell,pincode)
		Notification(1, 'De lab is gemaakt. Met de LabID: ' .. labid, src)
		TriggerClientEvent('pk-drugslab:SyncLabs1', -1)
		cb(true)
	end)
	
	ESX.RegisterServerCallback('pk-drugslab:verwijderLab', function(src, cb, id)
		verwijderLab(id)
		Notification(1, 'De lab is verwijdert. Met de LabID: ' .. id, src)
		TriggerClientEvent('pk-drugslab:SyncLabs1', -1)
		cb(true)
	end)
	
	ESX.RegisterServerCallback("pk-drugslab:koopLab", function(src, cb, id, prijs)
		local xPlayer = ESX.GetPlayerFromId(src)
		
		if xPlayer.getMoney() >= tonumber(prijs) then
			Notification(1, 'Je hebt de lab('..id..") gekocht Prijs: "..prijs.." via contant geld", src)
			xPlayer.removeMoney(tonumber(prijs))
			if Config.MYSQLUsage == "mysqlasync" then
					MySQL.Async.execute("UPDATE `pk_drugslab` SET `owner` = @owner WHERE id = @id", {
						["owner"] = xPlayer.identifier,
						["@id"] = id,
					})
			elseif Config.MYSQLUsage == "ghamttimysql" then
				exports.ghamttimysql.execute("UPDATE `pk_drugslab` SET `owner` = @owner WHERE id = @id", {
					["owner"] = xPlayer.identifier,
					["@id"] = id,
				})
			elseif Config.MYSQLUsage == "oxmysql" then
				exports.oxmysql:execute("UPDATE `pk_drugslab` SET `owner` = @owner WHERE id = @id", {
					["owner"] = xPlayer.identifier,
					["@id"] = id,
				})
			end
		elseif xPlayer.getAccount("bank").money >= tonumber(prijs) then
			Notification(1, 'Je hebt de lab('..id..") gekocht Prijs: "..prijs.." via de bank", src)
			xPlayer.removeAccountMoney("bank", tonumber(prijs))
			if Config.MYSQLUsage == "mysqlasync" then
					MySQL.Async.execute("UPDATE `pk_drugslab` SET `owner` = @owner WHERE id = @id", {
						["owner"] = xPlayer.identifier,
						["@id"] = id,
					})
			elseif Config.MYSQLUsage == "ghamttimysql" then
				exports.ghamttimysql.execute("UPDATE `pk_drugslab` SET `owner` = @owner WHERE id = @id", {
					["owner"] = xPlayer.identifier,
					["@id"] = id,
				})
			elseif Config.MYSQLUsage == "oxmysql" then
				exports.oxmysql:execute("UPDATE `pk_drugslab` SET `owner` = @owner WHERE id = @id", {
					["owner"] = xPlayer.identifier,
					["@id"] = id,
				})
			end
		end
		KrijgDrugsLab()
		TriggerClientEvent('pk-drugslab:SyncLabs1', -1)
		cb(true)
	end)
	
	ESX.RegisterServerCallback('pk-drugslab:veranderpin', function(src, cb, id, pincode)
		veranderpin(id, pincode)
		Notification(1, 'Je hebt de pincode verandert', src)
		TriggerClientEvent('pk-drugslab:SyncLabs1', -1)
		cb(true)
	end)
	
	ESX.RegisterServerCallback('pk-drugslab:krijgLab', function(src, cb)
		cb(Labs)
	end)
	
	ESX.RegisterServerCallback('pk-drugslab:krijgkey', function(src, cb)
		cb(key)
	end)
elseif Config.Framework == 'qbcore' then
	QBCore.Functions.CreateCallback('pk-drugslab:maakLab', function(src, cb, prijs, shell, pincode)
		maakLab(src, prijs, shell,pincode)
		Notification(1, 'De lab is gemaakt. Met de LabID: ' .. labid, src)
		TriggerClientEvent('pk-drugslab:SyncLabs1', -1)
		cb({trueorfalse = true})
	end)
	
	QBCore.Functions.CreateCallback("pk-drugslab:koopLab", function(src, cb, id, prijs)
		Notification(1, 'Je hebt de lab('..id..") gekocht Prijs: "..prijs, src)
	
		if Config.MYSQLUsage == "mysqlasync" then
			if Config.Framework == "qbcore" then
				MySQL.Async.execute("UPDATE `pk_drugslab` SET `owner` = @owner WHERE id = @id", {
					["owner"] = GetPlayerIdentifiers(source)[1],
					["@id"] = id,
				})
			else
				print("Je moet de Config.MYSQLUsage op een andere Config.MYSQLUsage zetten")
			end
		elseif Config.MYSQLUsage == "ghamttimysql" then
			exports.ghamttimysql.execute("UPDATE `pk_drugslab` SET `owner` = @owner WHERE id = @id", {
				["owner"] = GetPlayerIdentifiers(source)[1],
				["@id"] = id,
			})
		elseif Config.MYSQLUsage == "oxmysql" then
			exports.oxmysql:execute("UPDATE `pk_drugslab` SET `owner` = @owner WHERE id = @id", {
				["owner"] = GetPlayerIdentifiers(source)[1],
				["@id"] = id,
			})
		end
		KrijgDrugsLab()
		TriggerClientEvent('pk-drugslab:SyncLabs1', -1)
		cb(true)
	end)
	
	QBCore.Functions.CreateCallback('pk-drugslab:krijgLab', function(src, cb)
		cb(Labs)
	end)
	
	QBCore.Functions.CreateCallback('pk-drugslab:getthastash', function(src, cb, ClosestDrugslab1)
		cb(Labs[ClosestDrugslab1].stash)
	end)
	
	QBCore.Functions.CreateCallback('pk-drugslab:krijgkey', function(src, cb)
		cb(key)
	end)
end