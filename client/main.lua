isLoggedIn = false
PlayerData = {}

local InsieDrugslab = false
local DrugslabObj = {}
local POIOffsets = nil
local ClosestDrugslab = nil

Labs = nil

key = nil

stash = nil

disableEControl = false

-- Code

PlayerItems = nil

getStash = nil

Citizen.CreateThread(function()
    Wait(1000)
    if Config.Framework == "esx" and ESX ~= nil then
        isLoggedIn = true
        PlayerData = ESX.GetPlayerData()
	elseif Config.Framework == "qbcore" and QBCore ~= nil then
		isLoggedIn = true
		PlayerData = QBCore.Functions.GetPlayerData()
    end
	if key == nil then
		if Config.Framework == "esx" then
			ESX.TriggerServerCallback('pk-drugslab:krijgkey', function(keyLoad)
				key = keyLoad
			end)
		elseif Config.Framework == "qbcore" and QBCore ~= nil then
			QBCore.Functions.TriggerCallback('pk-drugslab:krijgkey', function(keyLoad)
				key = keyLoad
			end)
		end
	end

	while true do
		if isLoggedIn ~= nil then
			if Labs == nil then
				if Config.Framework == "esx" then
					ESX.TriggerServerCallback('pk-drugslab:krijgLab', function(LabsLoad)
						if LabsLoad == nil then
							Labs = "{}"
						else
							Labs = LabsLoad
						end
					end)
				elseif Config.Framework == "qbcore" and QBCore ~= nil then
					QBCore.Functions.TriggerCallback('pk-drugslab:krijgLab', function(LabsLoad)
						if LabsLoad == nil then
							Labs = "{}"
						else
							Labs = LabsLoad
						end
					end)
				end
			end
		end
		if isLoggedIn and ClosestDrugslab ~= nil and Labs ~= nil then
			if Config.Framework == "esx" then
				if PlayerItems == nil then
					PlayerItems = ESX.GetPlayerData().inventory
				end
			elseif Config.Framework == "qbcore" and QBCore ~= nil then
				if PlayerItems == nil then
					PlayerItems = QBCore.Functions.GetPlayerData().items
				end
			end
		end
		Citizen.Wait(10)
	end
		
end)

RegisterNetEvent('esx:playerLoaded')
AddEventHandler('esx:playerLoaded', function(xPlayer)
    ESX.PlayerData = xPlayer
end)

RegisterNetEvent('esx:setJob')
AddEventHandler('esx:setJob', function(job)
	ESX.PlayerData.job = job
end)

function DrawText3Ds(x, y, z, text)
	SetTextScale(0.35, 0.35)
    SetTextFont(4)
    SetTextProportional(1)
    SetTextColour(255, 255, 255, 215)
    SetTextEntry("STRING")
    SetTextCentre(true)
    AddTextComponentString(text)
    SetDrawOrigin(x,y,z, 0)
    DrawText(0.0, 0.0)
    local factor = (string.len(text)) / 370
    DrawRect(0.0, 0.0+0.0125, 0.017+ factor, 0.03, 0, 0, 0, 75)
    ClearDrawOrigin()
end

RegisterNUICallback('PinpadClose', function()
    SetNuiFocus(false, false)
end)

RegisterNUICallback('ErrorMessage', function(data)
	Notification(3, data.message)
end)

RegisterNUICallback('EnterPincode', function(d)
    if tonumber(d.pin) == tonumber(Labs[ClosestDrugslab].pincode) then
        EnterDrugslab(Labs[ClosestDrugslab])
    else
		Notification(3, _U('wrong_code'))
    end
end)

FormatNumber = function(number)
    local toreturn = ""
    if number >= 1000 then
        local string_number = string.reverse(tostring(number))
        for i = 0, #string_number - 1 do
            if i % 3 == 0 then
                toreturn = toreturn .. " "
            end
            toreturn = toreturn .. string.sub(string_number, i + 1, i + 1)
        end
    else
        return tostring(number)
    end
    toreturn = string.reverse(toreturn)
    if string.sub(toreturn, #toreturn, #toreturn) == " " then
        toreturn = string.sub(toreturn, 0, #toreturn - 1)
    end
    return toreturn
end

function openInventory()
	if Config.UseMenu == "br-menu" then
		exports['br-menu']:SetTitle("Drugslab Inventory")
		if Config.Framework == 'esx' then
			for k,v in pairs(PlayerItems) do
				exports['br-menu']:AddButton(v.label , _U('broekzakje', v.count) ,'pk-drugslab:leg' ,v.name ,"legmenu")
			end
		elseif Config.Framework == 'qbcore' then
			for k,v in pairs(PlayerItems) do
				exports['br-menu']:AddButton(QBShared.Items[v.name]["label"] , "count: " .. FormatNumber(v.amount) ,'pk-drugslab:leg' ,QBShared.Items[v.name]["name"] ,"legmenu")
			end
		end
		for k,v in pairs(json.decode(Labs[ClosestDrugslab].stash)) do
			exports['br-menu']:AddButton(v.label , "count: " .. FormatNumber(v.count) ,'pk-drugslab:krijg' ,v.name ,"krijgmenu")
		end
		exports['br-menu']:SubMenu("Leg" , "Leg je spullen in de lab" , "legmenu" )
		exports['br-menu']:SubMenu("Pak" , "Krijg spullen die in je drugslab zitten" , "krijgmenu" )
	elseif Config.UseMenu == "linden" then
		exports['linden_inventory']:OpenStash({owner = "DrugsLab"..ClosestDrugslab, id = "DrugsLab"..ClosestDrugslab, label = "DrugsLab"..ClosestDrugslab, slots = 200})
	end
end

function openDrugRun()
	exports['br-menu']:SetTitle("Drugslab Management")
	exports['br-menu']:AddButton("Start inkoop run" , "Start de prive inkoop run: Coke" ,'pk-drugslab:startrun' , "coke", "inkoop")
	exports['br-menu']:AddButton("Start inkoop run" , "Start de prive inkoop run: Wiet" ,'pk-drugslab:startrun' , "weed", "inkoop")
	exports['br-menu']:AddButton("Start inkoop run" , "Start de prive inkoop run: Meth" ,'pk-drugslab:startrun' , "meth", "inkoop")
	
	exports['br-menu']:SubMenu("Inkoop run menu" , "Open de inkoop run menu" , "inkoop" )
	if Config.UseWitwas then
		if tonumber(Labs[ClosestDrugslab].witwaslevel) >= 1 then
			exports['br-menu']:AddButton("WitWas" , "Start de Witwas MIN:"..Config.WitwasLevels[Labs[ClosestDrugslab].witwaslevel].minwash ,'pk-drugslab:witwas' , "", "witwas")
			exports['br-menu']:SubMenu("WitWas" , "Open de Witwas menu" , "witwas" )
		end
	end
	if Labs[ClosestDrugslab].owner == ESX.GetPlayerData().identifier then
		exports['br-menu']:AddButton("Verander pincode" , "Verander de drugslab pincode" ,'pk-drugslab:veranderpin', "" , "drugslabmanagement")
		if Config.UseWitwas then
			exports['br-menu']:AddButton("Level je Witwas omhoog" , "WitWas level: "..Labs[ClosestDrugslab].witwaslevel ,'pk-drugslab:upgradewitwas', Labs[ClosestDrugslab].witwaslevel , "drugslabmanagement")
		end
		if Config.EnableUpgrade then
			if Labs[ClosestDrugslab].shell ~= "shell_coke2" then
				exports['br-menu']:AddButton("Lab naar Coke upgrade" , "Upgrade je Lab naar een Coke Lab: "..Config.Offsets[Labs[ClosestDrugslab].shell].upgrade ,'pk-drugslab:upgradelab', "shell_coke2" , "drugslabupgrade")
			end
			if Labs[ClosestDrugslab].shell ~= "shell_meth" then
				exports['br-menu']:AddButton("Lab naar Meth upgrade" , "Upgrade je Lab naar een Meth Lab: "..Config.Offsets[Labs[ClosestDrugslab].shell].upgrade ,'pk-drugslab:upgradelab', "shell_meth" , "drugslabupgrade")
			end
			if Labs[ClosestDrugslab].shell ~= "shell_weed2" then
				exports['br-menu']:AddButton("Lab naar Weed upgrade" , "Upgrade je Lab naar een Weed Lab: "..Config.Offsets[Labs[ClosestDrugslab].shell].upgrade ,'pk-drugslab:upgradelab', "shell_weed2" , "drugslabupgrade")
			end
			exports['br-menu']:SubMenu("Upgrade Lab" , "Hier kan je de lab veranderen" , "drugslabupgrade" )
		end
		exports['br-menu']:SubMenu("Drugslab" , "Hier kan je alles veranderen van drugslab" , "drugslabmanagement" )
	end
end

DistanceBetweenEnter = nil

function SetClosestDrugslab()	
    local pos = GetEntityCoords(PlayerPedId(), true)
    local current = nil
    for id, Drugslab in pairs(Labs) do
		local x,y,z = tonumber(Drugslab.x), tonumber(Drugslab.y), tonumber(Drugslab.z)
        local currentDist = #(pos - vector3(x,y,z))
        if current ~= nil then
            if(currentDist < DistanceBetweenEnter)then
                current = id
                DistanceBetweenEnter = currentDist
            end
        else
            current = id
            DistanceBetweenEnter = currentDist
        end
    end
    ClosestDrugslab = current
end

function breaking(success, timeremaining)
	if success then
		Notification(1, "Je bent deze lab aan het openbreken")
		TriggerEvent('mhacking:hide')
		exports.rprogress:Custom({
			Duration = 10000,
			Label = "OPEN BREKEN...",
			Animation = {
				animationName = "knockdoor_idle",
				animationDictionary = "timetable@jimmy@doorknock@",
			},
			DisableControls = {
				Mouse = false,
				Player = true,
				Vehicle = true
			}
		})
		Wait(10000)
		EnterDrugslab(Labs[ClosestDrugslab])
		ClearPedTasksImmediately(playerPed)
	end
end

Citizen.CreateThread(function()	
    while true do
        local ped = PlayerPedId()
        local pos = GetEntityCoords(ped)
        local inRange = false 
		local veh = GetVehiclePedIsIn(ped, false)
        if Labs ~= nil and Labs ~= "{}" and isLoggedIn and not IsPedInVehicle(ped, veh) then			
			if not InsieDrugslab then
				SetClosestDrugslab()
				local x,y,z = tonumber(Labs[ClosestDrugslab].x), tonumber(Labs[ClosestDrugslab].y), tonumber(Labs[ClosestDrugslab].z)
				if DistanceBetweenEnter <= 10 then
					if ESX.PlayerData.job ~= nil and ESX.PlayerData.job.name ~= 'police' then
						if DistanceBetweenEnter <= 2.5 then
							if Labs[ClosestDrugslab].owner ~= nil then
								DrawText3Ds(x, y, z, '[~g~E~w~] - Naar binnen | ID: '..Labs[ClosestDrugslab].id)
								if DistanceBetweenEnter <= 1 then
									if IsControlJustPressed(0, Keys["E"]) then
										enterIt()
									end
								end
							else
								DrawText3Ds(x, y, z, '[~g~E~w~] - Koop lap | Prijs: '..Labs[ClosestDrugslab].price.." | ID: ".. Labs[ClosestDrugslab].id)
								if DistanceBetweenEnter <= 1 then
									if IsControlJustPressed(0, Keys["E"]) then
										ClosestDrugslab = ClosestDrugslab
										if Config.Framework == "esx" then
											ESX.TriggerServerCallback('pk-drugslab:koopLab', function(success)
												if success then
													TriggerServerEvent('pk-drugslab:refreshLabs', xPlayer)
												end
											end, Labs[ClosestDrugslab].id, Labs[ClosestDrugslab].price)
										elseif Config.Framework == "qbcore" and QBCore ~= nil then
											QBCore.Functions.TriggerCallback('pk-drugslab:koopLab', function(success)
												if success then
												end
											end, Labs[ClosestDrugslab].id, Labs[ClosestDrugslab].price)
										end
									end
								end
							end
						else
							Wait(500)
						end
					elseif not breakingin then
						DrawText3Ds(x, y, z, '~b~E~w~ - Breek open | ID: '..Labs[ClosestDrugslab].id)
						if DistanceBetweenEnter <= 1 then
							if IsControlJustPressed(0, Keys["E"]) then
								breaking(true, 1)
								--TriggerEvent("mhacking:show")
								--TriggerEvent("mhacking:start",5,35,breaking)
							end
						end
					end
				else
					Wait(4000)
				end
			else
				local x,y,z = tonumber(Labs[ClosestDrugslab].x), tonumber(Labs[ClosestDrugslab].y), tonumber(Labs[ClosestDrugslab].z)
				local data = Labs[ClosestDrugslab]
				local textexit = Config.Offsets[Labs[ClosestDrugslab].shell].exit1.text
                local ExitDistance = #(pos - vector3(x + POIOffsets.x, y + POIOffsets.y, z + Config.ZOffset + 1.0))
                if ExitDistance < 2 then
                    inRange = true
                    if ExitDistance < 1 then
                        DrawText3Ds(x + POIOffsets.x, y + POIOffsets.y, z + Config.ZOffset + 1.0, textexit)
                        if IsControlJustPressed(0, Keys["E"]) then
                            LeaveDrugslab(data)
                        end
                    end
				elseif Labs[ClosestDrugslab].shell == "shell_coke2" or Labs[ClosestDrugslab].shell == "shell_meth" then
					local xopslag,yopslag,zopslag,textopslag = Config.Offsets[Labs[ClosestDrugslab].shell].opslag.x, Config.Offsets[Labs[ClosestDrugslab].shell].opslag.y, Config.Offsets[Labs[ClosestDrugslab].shell].opslag.z, Config.Offsets[Labs[ClosestDrugslab].shell].opslag.text
					local InteractDistance = #(pos - vector3(x + xopslag, y + yopslag, z + Config.ZOffset + 1.0))
					if InteractDistance < 2 then
						if InteractDistance < 1 then
							DrawText3Ds(x + xopslag, y + yopslag, z + Config.ZOffset + 1.0, textopslag)
							if IsControlJustPressed(0, Keys["E"]) and not disableEControl then
								openInventory()
								Wait(1000)
							end
						end
					end 
					
					local xcomputer,ycomputer,zcomputer,textcomputer = Config.Offsets[Labs[ClosestDrugslab].shell].computer.x, Config.Offsets[Labs[ClosestDrugslab].shell].computer.y, Config.Offsets[Labs[ClosestDrugslab].shell].computer.z, Config.Offsets[Labs[ClosestDrugslab].shell].computer.text
					local InteractDistance = #(pos - vector3(x + xcomputer, y + ycomputer, z + Config.ZOffset + 1.0))
					if InteractDistance < 2 then
						if InteractDistance < 1 then
							DrawText3Ds(x + xcomputer, y + ycomputer, z + Config.ZOffset + 1.0, textcomputer)
							if IsControlJustPressed(0, Keys["E"]) and not disableEControl then
								openDrugRun()
								Wait(1000)
							end
						end
					end 
					
					local xverwerken,yverwerken,zverwerken,textverwerk = Config.Offsets[Labs[ClosestDrugslab].shell].verwerken.x, Config.Offsets[Labs[ClosestDrugslab].shell].verwerken.y, Config.Offsets[Labs[ClosestDrugslab].shell].verwerken.z, Config.Offsets[Labs[ClosestDrugslab].shell].verwerken.text
					local InteractDistance = #(pos - vector3(x + xverwerken, y + yverwerken, z + Config.ZOffset + 1.0))
					if InteractDistance < 2 then
						if InteractDistance < 1 then
							DrawText3Ds(x + xverwerken, y + yverwerken, z + Config.ZOffset + 1.0, textverwerk)
							if IsControlJustPressed(0, Keys["E"]) then
								RequestAnimDict('PROP_HUMAN_BUM_BIN')
								TaskStartScenarioInPlace(PlayerPedId(), "PROP_HUMAN_BUM_BIN", 0, true)
								exports.rprogress:Custom({
									Duration = 10000,
									Label = "VERPAKKEN...",
									Animation = {
										scenario = "PROP_HUMAN_BUM_BIN",
										animationDictionary = "idle_a",
									},
									DisableControls = {
										Mouse = false,
										Player = true,
										Vehicle = true
									}
								})
								Wait(10000)
								ClearPedTasks(ped)
								if Labs[ClosestDrugslab].shell == "shell_coke2" then
									TriggerServerEvent('pk-drugslab:Verpak', Config.Items.Coke, "drugsbagcoke", key)
								elseif Labs[ClosestDrugslab].shell == "shell_meth" then
									TriggerServerEvent('pk-drugslab:Verpak', "meth", Config.Items.Meth, key)
								end
							end
						end
					end 
					
					local xverwerken2,yverwerken2,zverwerken2,textverwerk2 = Config.Offsets[Labs[ClosestDrugslab].shell].verwerken2.x, Config.Offsets[Labs[ClosestDrugslab].shell].verwerken2.y, Config.Offsets[Labs[ClosestDrugslab].shell].verwerken2.z, Config.Offsets[Labs[ClosestDrugslab].shell].verwerken2.text
					local InteractDistance = #(pos - vector3(x + xverwerken2, y + yverwerken2, z + Config.ZOffset + 1.0))
					if InteractDistance < 2 then
						if InteractDistance < 1 then
							DrawText3Ds(x + xverwerken2, y + yverwerken2, z + Config.ZOffset + 1.0, textverwerk2)
							if IsControlJustPressed(0, Keys["E"]) then
								RequestAnimDict('PROP_HUMAN_BUM_BIN')
								TaskStartScenarioInPlace(PlayerPedId(), "PROP_HUMAN_BUM_BIN", 0, true)
								exports.rprogress:Custom({
									Duration = 10000,
									Label = "VERPAKKEN...",
									Animation = {
										scenario = "PROP_HUMAN_BUM_BIN",
										animationDictionary = "idle_a",
									},
									DisableControls = {
										Mouse = false,
										Player = true,
										Vehicle = true
									}
								})
								Wait(10000)
								ClearPedTasks(ped)
								if Labs[ClosestDrugslab].shell == "shell_coke2" then
									TriggerServerEvent('pk-drugslab:Verpak', Config.Items.Coke, Config.Items.CokeVerpakt, key)
								elseif Labs[ClosestDrugslab].shell == "shell_meth" then
									TriggerServerEvent('pk-drugslab:Verpak', Config.Items.Meth, Config.Items.MethVerpakt, key)
								end	
							end
						end
					end
				elseif Labs[ClosestDrugslab].shell == "shell_weed2" then
					local xopslag,yopslag,zopslag,textopslagweed = Config.Offsets[Labs[ClosestDrugslab].shell].opslag.x, Config.Offsets[Labs[ClosestDrugslab].shell].opslag.y, Config.Offsets[Labs[ClosestDrugslab].shell].opslag.z, Config.Offsets[Labs[ClosestDrugslab].shell].opslag.text
					local InteractDistance = #(pos - vector3(x + xopslag, y + yopslag, z + Config.ZOffset + 2.0))
					if InteractDistance < 2 then
						if InteractDistance < 1 then
							DrawText3Ds(x + xopslag, y + yopslag, z + Config.ZOffset + 2.0, textopslagweed)
							if IsControlJustPressed(0, Keys["E"]) then
								openInventory()
								Wait(1000)
							end
						end
					end 
					
					local xcomputer,ycomputer,zcomputer,textcomputerweed = Config.Offsets[Labs[ClosestDrugslab].shell].computer.x, Config.Offsets[Labs[ClosestDrugslab].shell].computer.y, Config.Offsets[Labs[ClosestDrugslab].shell].computer.z, Config.Offsets[Labs[ClosestDrugslab].shell].computer.text
					local InteractDistance = #(pos - vector3(x + xcomputer, y + ycomputer, z + Config.ZOffset + 2.0))
					if InteractDistance < 2 then
						if InteractDistance < 1 then
							DrawText3Ds(x + xcomputer, y + ycomputer, z + Config.ZOffset + 2.0, textcomputerweed)
							if IsControlJustPressed(0, Keys["E"]) and not disableEControl then
								openDrugRun()
								Wait(1000)
							end
						end
					end 
					
					local xverwerken,yverwerken,zverwerken,textverwerk = Config.Offsets[Labs[ClosestDrugslab].shell].verwerken.x, Config.Offsets[Labs[ClosestDrugslab].shell].verwerken.y, Config.Offsets[Labs[ClosestDrugslab].shell].verwerken.z, Config.Offsets[Labs[ClosestDrugslab].shell].verwerken.text
					local InteractDistance = #(pos - vector3(x + xverwerken, y + yverwerken, z + Config.ZOffset + 2.0))
					if InteractDistance < 2 then
						if InteractDistance < 1 then
							DrawText3Ds(x + xverwerken, y + yverwerken, z + Config.ZOffset + 2.0, textverwerk)
							if IsControlJustPressed(0, Keys["E"]) then
								RequestAnimDict('PROP_HUMAN_BUM_BIN')
								TaskStartScenarioInPlace(PlayerPedId(), "PROP_HUMAN_BUM_BIN", 0, true)
								exports.rprogress:Custom({
									Duration = 10000,
									Label = "VERPAKKEN...",
									Animation = {
										scenario = "PROP_HUMAN_BUM_BIN",
										animationDictionary = "idle_a",
									},
									DisableControls = {
										Mouse = false,
										Player = true,
										Vehicle = true
									}
								})
								Wait(10000)
								ClearPedTasks(ped)
								TriggerServerEvent('pk-drugslab:Verpak', Config.Items.Weed, Config.Items.WeedVerpakt, key)
							end
						end
					end 
					
					local xverwerken2,yverwerken2,zverwerken2,textverwerk2 = Config.Offsets[Labs[ClosestDrugslab].shell].verwerken2.x, Config.Offsets[Labs[ClosestDrugslab].shell].verwerken2.y, Config.Offsets[Labs[ClosestDrugslab].shell].verwerken2.z, Config.Offsets[Labs[ClosestDrugslab].shell].verwerken2.text
					local InteractDistance = #(pos - vector3(x + xverwerken2, y + yverwerken2, z + Config.ZOffset + 2.0))
					if InteractDistance < 2 then
						if InteractDistance < 1 then
							DrawText3Ds(x + xverwerken2, y + yverwerken2, z + Config.ZOffset + 2.0, textverwerk2)
							if IsControlJustPressed(0, Keys["E"]) then
								RequestAnimDict('PROP_HUMAN_BUM_BIN')
								TaskStartScenarioInPlace(PlayerPedId(), "PROP_HUMAN_BUM_BIN", 0, true)
								exports.rprogress:Custom({
									Duration = 10000,
									Label = "VERPAKKEN...",
									Animation = {
										scenario = "PROP_HUMAN_BUM_BIN",
										animationDictionary = "idle_a",
									},
									DisableControls = {
										Mouse = false,
										Player = true,
										Vehicle = true
									}
								})
								Wait(10000)
								ClearPedTasks(ped)
								TriggerServerEvent('pk-drugslab:Verpak', Config.Items.Weed, Config.Items.WeedVerpakt, key)
							end
						end
					end
				end
            end
        else
            Citizen.Wait(2000)
        end
        Citizen.Wait(0)
    end
end)

function enterIt()
	TriggerServerEvent('pk-drugslab:ClosestDrugslab', ClosestDrugslab)
	SendNUIMessage({
		action = "open"
	})
	SetNuiFocus(true, true)
end

xPlayers = nil

RegisterNetEvent('pk-drugslab:SyncLabs1')
AddEventHandler('pk-drugslab:SyncLabs1', function(blahblahblah)
	PlayerItems = nil
	getStash = nil
	Labs = nil
end)

RegisterNetEvent('pk-drugslab:witwas')
AddEventHandler('pk-drugslab:witwas', function(blahblahblah)
	witwasamounttext = KeyboardInput("Voer hoeveel zwart geld je wit wilt wassen MIN:"..Config.WitwasLevels[Labs[ClosestDrugslab].witwaslevel].minwash, "", 10)
    witwas = witwasamounttext
	if (witwas) then
		TriggerServerEvent('pk-drugslab:witwassen', witwas, Labs[ClosestDrugslab].witwaslevel)
	end
end)


RegisterNetEvent('pk-drugslab:upgradewitwas')
AddEventHandler('pk-drugslab:upgradewitwas', function(witwaslevel)
	local witwaslevels = math.random(1, #Config.WitwasLevels)
	if tonumber(witwaslevel) >= #Config.WitwasLevels then
		Notification(1, "Je hebt al de max levels bij witwas")
	else
		local witwaslevelupgraded = tonumber(witwaslevel) + 1
		print(witwaslevelupgraded)
		TriggerServerEvent('pk-drugslab:witwasupgraded', witwaslevel, witwaslevelupgraded, Labs[ClosestDrugslab].id)
	end
end)

RegisterNetEvent('pk-drugslab:upgradelab')
AddEventHandler('pk-drugslab:upgradelab', function(lab)
	LeaveDrugslab(Labs[ClosestDrugslab])
	TriggerServerEvent('pk-drugslab:labupgraded',Config.Offsets[Labs[ClosestDrugslab].shell].upgrade, Labs[ClosestDrugslab].shell, lab, Labs[ClosestDrugslab].id)	
end)

RegisterNetEvent('pk-drugslab:leg')
AddEventHandler('pk-drugslab:leg', function(item)
	local amount = KeyboardInput("Voer De Amount in", "", 10)
	if amount ~= nil then
		TriggerServerEvent('pk-drugslab:leg1',source,  item, amount, Labs[ClosestDrugslab].id, ClosestDrugslab)
		disableEControl = true,
		exports.rprogress:Custom({
			Duration = 2500,
			Label = "Spullen opslaan...",
			Animation = {
				scenario = "PROP_HUMAN_BUM_BIN",
				animationDictionary = "idle_a",
			},
			DisableControls = {
				Mouse = false,
				Player = true,
				Vehicle = true
			}
		})
		Citizen.Wait(2500)
		disableEControl = false
	end
end)

RegisterNetEvent('pk-drugslab:krijg')
AddEventHandler('pk-drugslab:krijg', function(item)
	local amount = KeyboardInput("Voer De Amount in", "", 10)
	if amount ~= nil then
		TriggerServerEvent('pk-drugslab:krijg1', item, amount, Labs[ClosestDrugslab].id, ClosestDrugslab)
			disableEControl = true,
		exports.rprogress:Custom({
			Duration = 2500,
			Label = "Spullen Pakken...",
			Animation = {
				scenario = "PROP_HUMAN_BUM_BIN",
				animationDictionary = "idle_a",
			},
			DisableControls = {
				Mouse = false,
				Player = true,
				Vehicle = true
			}
		})
		Citizen.Wait(2500)
		disableEControl = false
	end
end)

function CreateDealerBlip(x,y,z)
	blip = AddBlipForCoord(x,y,z)
    SetBlipSprite(blip, 205)
    SetBlipColour(blip, 2)
    SetBlipScale(blip, 0.5)
    SetBlipAsShortRange(blip, true)
    BeginTextCommandSetBlipName("STRING")
    AddTextComponentString('[Dealer] Place of meeting')
    EndTextCommandSetBlipName(blip)
end

function SpawnVehicle(model,coords,heading)
	Wait(1500)
	ESX.Game.SpawnVehicle(model, coords, heading, function(vehicle)
	end)
end

BringToSell = false
testthis = nil

function mycb(success, timeremaining)
	if success then
		local pakwagen = math.random(1, #Config.drugsrunwagen)
		SpawnVehicle(Config.inkoopwage, vector3(Config.drugsrunwagen[pakwagen].x,Config.drugsrunwagen[pakwagen].y,Config.drugsrunwagen[pakwagen].z), Config.drugsrunwagen[pakwagen].h)
		SetNewWaypoint(Config.drugsrunwagen[pakwagen].x,Config.drugsrunwagen[pakwagen].y,Config.drugsrunwagen[pakwagen].z)
		Notification(1, "Ga naar de locatie toe en pak de wagen")
		TriggerEvent('mhacking:hide')
		done123 = false
		BringToSell = true
		Citizen.CreateThread(function()	
			while BringToSell do
				local ped = PlayerPedId()
				local pos = GetEntityCoords(ped)
				local veh = GetVehiclePedIsIn(ped, false)
				local sellpos = math.random(1, #Config.InkoopSell)
					if IsPedInAnyVehicle(ped, false) and IsVehicleModel(GetVehiclePedIsIn(ped, false), GetHashKey(Config.inkoopwage)) then
						SetNewWaypoint(Config.InkoopSell[sellpos].x,Config.InkoopSell[sellpos].y,Config.InkoopSell[sellpos].z)
						if not done123 then
							Notification(1, "Ga naar de locatie toe en pak de wagen")
							done123 = true
						end
						local InteractDistance = #(pos - vector3(Config.InkoopSell[sellpos].x,Config.InkoopSell[sellpos].y,Config.InkoopSell[sellpos].z))
						if InteractDistance < 3 then
							DrawText3Ds(Config.InkoopSell[sellpos].x,Config.InkoopSell[sellpos].y,Config.InkoopSell[sellpos].z, "Druk op [~g~E~w~] om de voertuig te leveren")
							if IsControlJustPressed(0, Keys["E"]) then
								ESX.Game.DeleteVehicle(veh)
								TriggerServerEvent('pk-drugslab:finisheddrugsrun', testthis)
								done123 = false
								BringToSell = false
							end
						end
					end
				Citizen.Wait(10)
			end
		end)
	else
		print('Failure')
		TriggerEvent('mhacking:hide')
	end
end

StartedRun = false

RegisterNetEvent('pk-drugslab:startrun')
AddEventHandler('pk-drugslab:startrun', function(drugstype)
	if drugstype == "coke" then
		testthis = Config.Items.CokeVerpakt
		local dealerpos = math.random(1, #Config.Dealer)
		CreateDealerBlip(Config.Dealer[dealerpos].x,Config.Dealer[dealerpos].y,Config.Dealer[dealerpos].z)
		Notification(1, "Ga naar de locatie toe en hack")
		StartedRun = true
		Citizen.CreateThread(function()	
			while StartedRun do
				local ped = PlayerPedId()
				local pos = GetEntityCoords(ped)
				local InteractDistance = #(pos - vector3(Config.Dealer[dealerpos].x,Config.Dealer[dealerpos].y,Config.Dealer[dealerpos].z))
				if InteractDistance < 2 then
					DrawText3Ds(Config.Dealer[dealerpos].x,Config.Dealer[dealerpos].y,Config.Dealer[dealerpos].z, "Druk op [~g~E~w~] om te hacken")
					if IsControlJustPressed(0, Keys["E"]) then
						TriggerEvent("mhacking:show")
						TriggerEvent("mhacking:start",5,35,mycb)
						RemoveBlip(blip)
						StartedRun = false
					end
				end
				Citizen.Wait(10)
			end
		end)		
	elseif drugstype == "weed" then
		testthis = Config.Items.WeedVerpakt
		local dealerpos = math.random(1, #Config.Dealer)
		CreateDealerBlip(Config.Dealer[dealerpos].x,Config.Dealer[dealerpos].y,Config.Dealer[dealerpos].z)
		Notification(1, "Ga naar de locatie toe en hack")
		StartedRun = true
		Citizen.CreateThread(function()	
			while StartedRun do
				local ped = PlayerPedId()
				local pos = GetEntityCoords(ped)
				local InteractDistance = #(pos - vector3(Config.Dealer[dealerpos].x,Config.Dealer[dealerpos].y,Config.Dealer[dealerpos].z))
				if InteractDistance < 2 then
					DrawText3Ds(Config.Dealer[dealerpos].x,Config.Dealer[dealerpos].y,Config.Dealer[dealerpos].z, "Test")
					if IsControlJustPressed(0, Keys["E"]) then
						TriggerEvent("mhacking:show")
						TriggerEvent("mhacking:start",5,35,mycb)
						RemoveBlip(blip)
						StartedRun = false
					end
				end
				Citizen.Wait(10)
			end
		end)
	elseif drugstype == "meth" then
		testthis = Config.Items.MethVerpakt
		local dealerpos = math.random(1, #Config.Dealer)
		CreateDealerBlip(Config.Dealer[dealerpos].x,Config.Dealer[dealerpos].y,Config.Dealer[dealerpos].z)
		Notification(1, "Ga naar de locatie toe en hack")
		StartedRun = true
		Citizen.CreateThread(function()	
			while StartedRun do
				local ped = PlayerPedId()
				local pos = GetEntityCoords(ped)
				local InteractDistance = #(pos - vector3(Config.Dealer[dealerpos].x,Config.Dealer[dealerpos].y,Config.Dealer[dealerpos].z))
				if InteractDistance < 2 then
					DrawText3Ds(Config.Dealer[dealerpos].x,Config.Dealer[dealerpos].y,Config.Dealer[dealerpos].z, "Test")
					if IsControlJustPressed(0, Keys["E"]) then
						TriggerEvent("mhacking:show")
						TriggerEvent("mhacking:start",5,35,mycb)
						RemoveBlip(blip)
						StartedRun = false
					end
				end
				Citizen.Wait(10)
			end
		end)
	end
end)

function DespawnInterior(objects)
    Citizen.CreateThread(function()
        for k, v in pairs(objects) do
            if DoesEntityExist(v) then
                DeleteEntity(v)
            end
        end
    end)
end

function TeleportToInterior(x, y, z, h)
    Citizen.CreateThread(function()
        SetEntityCoords(PlayerPedId(), x, y, z, 0, 0, 0, false)
        SetEntityHeading(PlayerPedId(), h)

        Citizen.Wait(100)

        DoScreenFadeIn(1000)
    end)
end

function CreateShell(spawn,shell)
	local objects = {}

    local POIOffsets = {}
	POIOffsets.x = Config.Offsets[Labs[ClosestDrugslab].shell].exit1.x
	POIOffsets.y = Config.Offsets[Labs[ClosestDrugslab].shell].exit1.y
	POIOffsets.z = Config.Offsets[Labs[ClosestDrugslab].shell].exit1.z
	POIOffsets.h = 358.633972168
	DoScreenFadeOut(500)
    while not IsScreenFadedOut() do
        Citizen.Wait(10)
    end
	RequestModel(shell)
	while not HasModelLoaded(shell) do
	    Citizen.Wait(1000)
	end
	local house = CreateObject(shell, spawn.x, spawn.y, spawn.z, false, false, false)
    FreezeEntityPosition(house, true)
	table.insert(objects, house)

	TeleportToInterior(spawn.x + POIOffsets.x, spawn.y + POIOffsets.y, spawn.z, POIOffsets.h)

    return { objects, POIOffsets }
end

function EnterDrugslab(data)
    local coords = { x = tonumber(Labs[ClosestDrugslab].x), y = tonumber(Labs[ClosestDrugslab].y), z= tonumber(Labs[ClosestDrugslab].z) + Config.ZOffset}
	local shell = Labs[ClosestDrugslab].shell
    data = CreateShell(coords, shell)
    DrugslabObj = data[1]
    POIOffsets = data[2]
    CurrentDrugslab = ClosestDrugslab
    InsieDrugslab = true
    SetRainFxIntensity(0.0)
    TriggerEvent("ToggleWeatherSync", false)
    SetWeatherTypePersist('EXTRASUNNY')
    SetWeatherTypeNow('EXTRASUNNY')
    SetWeatherTypeNowPersist('EXTRASUNNY')
    NetworkOverrideClockTime(23, 0, 0)
end

function LeaveDrugslab(data)
    local ped = GetPlayerPed(-1)
    TriggerServerEvent("InteractSound_SV:PlayOnSource", "houses_door_open", 0.25)
    DoScreenFadeOut(250)
    Citizen.Wait(250)
    DespawnInterior(DrugslabObj)
    TriggerEvent("ToggleWeatherSync", true)
    DoScreenFadeIn(250)
    SetEntityCoords(ped, tonumber(Labs[ClosestDrugslab].x), tonumber(Labs[ClosestDrugslab].y), tonumber(Labs[ClosestDrugslab].z) + 0.5)
    DrugslabObj = nil
    POIOffsets = nil
    CurrentDrugslab = nil
    InsieDrugslab = false
end

RegisterNetEvent('pk-drugslab:veranderpin')
AddEventHandler('pk-drugslab:veranderpin', function(xPlayer)
	pincodetext = KeyboardInput("Voer De pincode in", "", 10)
    pincode = pincodetext
	if (pincode) then
		if Config.Framework == "esx" then
			ESX.TriggerServerCallback('pk-drugslab:veranderpin', function(success)
				if success then
					TriggerServerEvent('pk-drugslab:refreshLabs', xPlayer)
				end
			end,Labs[ClosestDrugslab].id, pincode)
		elseif Config.Framework == "qbcore" and QBCore ~= nil then
			QBCore.Functions.TriggerCallback('pk-drugslab:veranderpin', function(success)
				if success.trueorfalse then
					TriggerServerEvent('pk-drugslab:refreshLabs', xPlayer)
				end
			end,Labs[ClosestDrugslab].id, pincode)
		end
	end
end)

RegisterNetEvent('pk-drugslab:createlab')
AddEventHandler('pk-drugslab:createlab', function(xPlayer)
    local done = 0
    local prijs,shell,pincode
    prijstext = KeyboardInput("Voer De prijs in", "", 10)
    prijs = prijstext
    shelltext = KeyboardInput("Voer De shell in | shell_coke2 | shell_meth | shell_weed2", "", 15)
    shell = shelltext
    pincodetext = KeyboardInput("Voer De pincode in", "", 10)
    pincode = pincodetext
    if(pincode) and (shell) and (prijs) then 
		if Config.Framework == "esx" then
			print(prijs, shell, pincode)
			ESX.TriggerServerCallback('pk-drugslab:maakLab', function(success)
				if success then
					TriggerServerEvent('pk-drugslab:refreshLabs', xPlayer)
				end
			end, prijs, shell, pincode)
		elseif Config.Framework == "qbcore" and QBCore ~= nil then
			QBCore.Functions.TriggerCallback('pk-drugslab:maakLab', function(success)
				if success.trueorfalse then
					TriggerServerEvent('pk-drugslab:refreshLabs', xPlayer)
				end
			end)
		end
    end
end)

RegisterNetEvent('pk-drugslab:removelab')
AddEventHandler('pk-drugslab:removelab', function(xPlayer)
	if Config.Framework == "esx" then
		ESX.TriggerServerCallback('pk-drugslab:verwijderLab', function(success)
			if success then
				TriggerServerEvent('pk-drugslab:refreshLabs', xPlayer)
			end
		end, Labs[ClosestDrugslab].id)
	elseif Config.Framework == "qbcore" and QBCore ~= nil then
		QBCore.Functions.TriggerCallback('pk-drugslab:verwijderLab', function(success)
			if success.trueorfalse then
				TriggerServerEvent('pk-drugslab:refreshLabs', xPlayer)
			end
		end, Labs[ClosestDrugslab].id)
	end
end)

Progressbar = function(name, label, duration, useWhileDead, canCancel, disableControls, animation, prop, propTwo, onFinish, onCancel)
    exports['progressbar']:Progress({
        name = name:lower(),
        duration = duration,
        label = label,
        useWhileDead = useWhileDead,
        canCancel = canCancel,
        controlDisables = disableControls,
        animation = animation,
        prop = prop,
        propTwo = propTwo,
    }, function(cancelled)
        if not cancelled then
            if onFinish ~= nil then
                onFinish()
            end
        else
            if onCancel ~= nil then
                onCancel()
            end
        end
    end)

end

function KeyboardInput(TextEntry, ExampleText, MaxStringLenght)

	-- TextEntry		-->	The Text above the typing field in the black square
	-- ExampleText		-->	An Example Text, what it should say in the typing field
	-- MaxStringLenght	-->	Maximum String Lenght

	AddTextEntry('FMMC_KEY_TIP1', TextEntry) --Sets the Text above the typing field in the black square
	DisplayOnscreenKeyboard(1, "FMMC_KEY_TIP1", "", ExampleText, "", "", "", MaxStringLenght) --Actually calls the Keyboard Input
	blockinput = true --Blocks new input while typing if **blockinput** is used

	while UpdateOnscreenKeyboard() ~= 1 and UpdateOnscreenKeyboard() ~= 2 do --While typing is not aborted and not finished, this loop waits
		Citizen.Wait(0)
	end
		
	if UpdateOnscreenKeyboard() ~= 2 then
		local result = GetOnscreenKeyboardResult() --Gets the result of the typing
		Citizen.Wait(500) --Little Time Delay, so the Keyboard won't open again if you press enter to finish the typing
		blockinput = false --This unblocks new Input when typing is done
		return result --Returns the result
	else
		Citizen.Wait(500) --Little Time Delay, so the Keyboard won't open again if you press enter to finish the typing
		blockinput = false --This unblocks new Input when typing is done
		return nil --Returns nil if the typing got aborted
	end
end