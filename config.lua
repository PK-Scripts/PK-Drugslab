Keys = {
    ['ESC'] = 322, ['F1'] = 288, ['F2'] = 289, ['F3'] = 170, ['F5'] = 166, ['F6'] = 167, ['F7'] = 168, ['F8'] = 169, ['F9'] = 56, ['F10'] = 57,
    ['~'] = 243, ['1'] = 157, ['2'] = 158, ['3'] = 160, ['4'] = 164, ['5'] = 165, ['6'] = 159, ['7'] = 161, ['8'] = 162, ['9'] = 163, ['-'] = 84, ['='] = 83, ['BACKSPACE'] = 177,
    ['TAB'] = 37, ['Q'] = 44, ['W'] = 32, ['E'] = 38, ['R'] = 45, ['T'] = 245, ['Y'] = 246, ['U'] = 303, ['P'] = 199, ['['] = 39, [']'] = 40, ['ENTER'] = 18,
    ['CAPS'] = 137, ['A'] = 34, ['S'] = 8, ['D'] = 9, ['F'] = 23, ['G'] = 47, ['H'] = 74, ['K'] = 311, ['L'] = 182,
    ['LEFTSHIFT'] = 21, ['Z'] = 20, ['X'] = 73, ['C'] = 26, ['V'] = 0, ['B'] = 29, ['N'] = 249, ['M'] = 244, [','] = 82, ['.'] = 81,
    ['LEFTCTRL'] = 36, ['LEFTALT'] = 19, ['SPACE'] = 22, ['RIGHTCTRL'] = 70,
    ['HOME'] = 213, ['PAGEUP'] = 10, ['PAGEDOWN'] = 11, ['DELETE'] = 178,
    ['LEFT'] = 174, ['RIGHT'] = 175, ['TOP'] = 27, ['DOWN'] = 173,
}

Config = {}

function _(str, ...)  -- Translate string

	if Locales[Config.Locale] ~= nil then

		if Locales[Config.Locale][str] ~= nil then
			return string.format(Locales[Config.Locale][str], ...)
		else
			return 'Translation [' .. Config.Locale .. '][' .. str .. '] does not exist'
		end

	else
		return 'Locale [' .. Config.Locale .. '] does not exist'
	end

end

function _U(str, ...) -- Translate string first char uppercase
	return tostring(_(str, ...):gsub("^%l", string.upper))
end

Config.Locale = "nl"

Config.Framework = 'esx' ---[ 'esx' / 'qbcore' / 'other' ] Choose your framework.

Config.FrameworkTriggers = { --You can change the esx/qbus events (IF NEEDED).
    main = 'esx:getSharedObject',   --ESX = 'esx:getSharedObject'   QBUSOLD = 'QBCore:GetObject'
}

Config.NotificationType = { --[ 'esx' / 'qbus' / 'mythic_old' / 'mythic_new' / 'chat' / 'other' ] Choose your notification script.
    client = 'mythic_new' 
}

-- mysqlasync is voor ESX
-- ghamttimysql is voor oud qbcore
-- oxmysql is voor nieuwe qbcore

Config.MYSQLUsage = "mysqlasync"

--Linden_inventory = linden
--br-menu = br-menu
--ESX Menu = esx(W.I.P)
--qbcore = QBCore Inventory(W.I.P)

Config.UseMenu = "br-menu"

Config.ZOffset = 1000

-- Webhook --
Config.WebHook = "https://discord.com/api/webhooks/872867340654628915/RtQc6LQz71QoVV1j2OOFkV51bwgLr7zxe7tkLZvPlP973JDV5aRyiypXn312OSfovsfo"

-- Police stuff --
Config.PoliceBreakTime = 10 -- Dit is in secondes
Config.PoliceChange = 40

-- Upgrade lab --

Config.EnableUpgrade = true

-- Witwas --

Config.UseWitwas = true

Config.WitwasLevels = {
	[1] = {
		money = 1000, -- Hoeveel kost deze upgrade
		minwash = 50000,
		tax = 0.5, -- hoeveel er overblijft van de zwart geld
	},
	[2] = {
		money = 30000,
		minwash = 100000,
		tax = 0.6,
	}
}

-- inkoop --

Config.inkoopwage = "rumpo" -- voertuig waar mee je gaat rijden

Config.Inkoopgeef = 10 -- hoeveel x je de drugs krijgt

Config.InkoopSell = { -- waar je je voertuig in levert en drugs krijgt
	[1] = {
        x = 1596.2170,  
        y = -1708.0591,
        z = 88.1266,
        h = 113.3583,
    },
}

Config.drugsrunwagen = { -- waar je je voertuig pakt
	[1] = {
        x = -70.3239,
        y = 349.0723,
        z = 112.4459,
        h = 335.4078,
    },
}

Config.Dealer = { -- waar je naar toe moet gaan voor te hacken
    [1] = {
        x = -1669.47,
        y = 3144.45,
        z = 31.77,
        h = 6.66,
    },
    [2] = {
        x = 1537.02,
        y = 3797.41,
        z = 34.45,
        h = 199.73,
    },
    [3] = {
        x = 121.24,
        y = -2468.92,
        z = 6.1,
        h = 232.73,
    },
    [4] = {
        x = -581.44,
        y = -1768.48,
        z = 23.18,
        h = 322.88,
    }
}

-- Einde Inkoop --
-- Items --

Config.Items = {
	Weed = "cannabis", --Item die verpakt word
	Coke = "coca_leaf", --Item die verpakt word 		
	Meth = "meth", --Item die verpakt word
	WeedVerpakt = "drugsbagweed", --Item die verpakt zijn
	CokeVerpakt = "drugsbagcoke", --Item die verpakt zijn
	MethVerpakt = "drugsbagmeth", --Item die verpakt zijn
}

-- Offsets --

Config.Offsets = { -- PAS HIER NIET ZOMAAR WAT AAN ALLEEN ALS JE WEET WAT JE DOET!
    ['shell_coke2'] = {
		upgrade = 10000,
        exit1 = {x = -6.269073, y = 8.591202, z = -0.958517, 		text = "[~g~E~w~] · Verlaten"},
        verwerken = {x = -2.011368, y = 1.175751, z = -0.958519,	text = "[~g~E~w~] · Coke Verpakken"},
        verwerken2 = {x = -1.901901, y = -0.4820251, z = -0.958521, text = "[~g~E~w~] · Coke Verpakken"},
        opslag = {x = 4.413528, y = 3.076523, z = -0.958546, 		text = "[~g~E~w~] · Opslag"},
        computer = {x = -8.035126, y = -0.9961548, z = -0.958521, 	text = "[~g~E~w~] · Laptop Gebruiken"},
    },
    ['shell_meth'] = {
		upgrade = 10000,
        exit1 = {x = -6.230286, y = 8.604797, z = -0.958517, 		text = "[~g~E~w~] · Verlaten"},
        verwerken = {x = 4.459427, y = -2.731369, z = -0.958517,	text = "[~g~E~w~] · Meth Verpakken"},
        verwerken2 = {x = 5.651321, y = 2.912308, z = -0.958498,	text = "[~g~E~w~] · Meth Verpakken"},
        opslag = {x = 1.955933, y = 2.926514, z = -0.958513, 		text = "[~g~E~w~] · Opslag"},
		computer = {x = -7.940216, y = 1.492752, z = -0.958517, 	text = "[~g~E~w~] · Laptop Gebruiken"},
    },
    ['shell_weed2'] = {
		upgrade = 10000,
        exit1 = {x = 17.85669, y = 11.68689, z = -2.097003, 		text = "[~g~E~w~] · Verlaten"},
        verwerken = {x = -14.94531, y = -9.843872, z = -1.110729, 	text = "[~g~E~w~] · Wiet Verpakken"},
        verwerken2 = {x = -16.8739, y = -8.490845, z = -1.119811, 	text = "[~g~E~w~] · Wiet Verpakken"},
        opslag = {x = -16.00391, y = -12.40662, z = -1.112052, 		text = "[~g~E~w~] · Opslag"},
        computer = {x = -4.036255, y = -3.797485, z = -1.088299, 	text = "[~g~E~w~] · Laptop Gebruiken"},
    }
}