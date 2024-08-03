local _, addon = ...
local S = unpack(addon)

local GetItemInfo = C_Item.GetItemInfo
S.switchCoolLine = function(profile)

	local db, block = {}, nil

	CoolLineDB = CoolLineDB or { }
	if CoolLineDB.perchar then
		db = CoolLineCharDB
	else
		db = CoolLineDB
	end

	if profile == "SanHeal" or profile == "SanChicken" then
		block = {
			[GetItemInfo(6948) or "Hearthstone"] = true,
			[GetItemInfo(140192) or "Dalaran Hearthstone"] = true,
			[GetItemInfo(141605) or "Flight Master's Whistle"] = true,
			[GetItemInfo(139599) or "Empowered Ring of the Kirin Tor"] = true,
			[GetItemInfo(147707) or "Repurposed Fel Focuser"] = true,
			[GetItemInfo(153023) or "Lightforged Augment Rune"] = true,
			[GetItemInfo(140789) or "Animated Exoskeleton"] = true,
			[GetItemInfo(142157) or "Aran's Relaxing Ruby"] = true,
			[GetItemInfo(137486) or "Windscar Whetstone"] = true,
			[GetItemInfo(140807) or "Infernal Contract"] = true,
			[GetItemInfo(144249) or "Archimonde's Hatred Reborn"] = true,
			["Rebirth"] = true
		}
	elseif profile == "SanBear" then
		block = {
			[GetItemInfo(6948) or "Hearthstone"] = true,  -- Hearthstone
			[GetItemInfo(140192) or "Dalaran Hearthstone"] = true,
			[GetItemInfo(141605) or "Flight Master's Whistle"] = true,
			[GetItemInfo(139599) or "Empowered Ring of the Kirin Tor"] = true,
			[GetItemInfo(147707) or "Repurposed Fel Focuser"] = true,
			[GetItemInfo(153023) or "Lightforged Augment Rune"] = true,
			[GetItemInfo(140793) or "Perfectly Preserved Cake"] = true,
			[GetSpellInfo(33917) or "Zerfleischen"] = true, -- Mangle(Bear)
			[GetSpellInfo(779) or "Prankenhieb"] = true, -- Swipe(Bear
			[GetSpellInfo(77758) or "Hauen"] = true, -- Thrash
			[GetSpellInfo(6807) or "Zermalmen"] = true, -- Maul
			["Carafe of Searing Light"] = true,
			--[GetSpellInfo(33745) or "Aufschlitzen"] = true, --Lacerate
			[GetSpellInfo(144258) or "Velen's Future Sight"] = true,
		}
	elseif profile == "SanCat" then
		block = {
			[GetItemInfo(6948) or "Hearthstone"] = true,  -- Hearthstone
			[GetItemInfo(140793) or "Perfectly Preserved Cake"] = true,
			[GetItemInfo(140192) or "Dalaran Hearthstone"] = true,
			[GetItemInfo(141605) or "Flight Master's Whistle"] = true,
			[GetItemInfo(147707) or "Repurposed Fel Focuser"] = true,
			[GetItemInfo(153023) or "Lightforged Augment Rune"] = true,
			[GetItemInfo(139599) or "Empowered Ring of the Kirin Tor"] = true,
			[GetItemInfo(137486) or "Windscar Whetstone"] = true,
			[GetItemInfo(140789) or "Animated Exoskeleton"] = true,
			[GetSpellInfo(33917) or "Zerfleischen"] = true, -- Mangle(Bear)
			[GetSpellInfo(779) or "Prankenhieb"] = true, -- Swipe(Bear
			[GetSpellInfo(77758) or "Hauen"] = true, -- Thrash
			[GetSpellInfo(6807) or "Zermalmen"] = true, -- Maul
			[GetItemInfo(140807) or "Infernal Contract"] = true,
			["Carafe of Searing Light"] = true,
			[GetItemInfo(144249) or "Archimonde's Hatred Reborn"] = true,
			[GetSpellInfo(144258) or "Velen's Future Sight"] = true,
			--[GetSpellInfo(33745) or "Aufschlitzen"] = true, --Lacerate
		}
	elseif profile == "DoviBM" then
		block = {
			[GetItemInfo(6948) or "Hearthstone"] = true,  -- Hearthstone
			[GetItemInfo(140192) or "Dalaran Hearthstone"] = true,
			[GetItemInfo(141605) or "Flight Master's Whistle"] = true,
			[GetItemInfo(139599) or "Empowered Ring of the Kirin Tor"] = true,
			[GetItemInfo(147707) or "Repurposed Fel Focuser"] = true,
			[GetItemInfo(153023) or "Lightforged Augment Rune"] = true,
			[GetSpellInfo(19574) or "Bestial Wrath"] = true,
			[GetSpellInfo(217200) or "Barbed Shot"] = true,
			[GetSpellInfo(34026) or "Kill Command"] = true,
			[GetSpellInfo(61684) or "Dash"] = true,
			[GetSpellInfo(49966) or "Smack"] = true,
			[GetSpellInfo(17253) or "Bite"] = true,
			[GetSpellInfo(2649) or "Growl"] = true,
		}
	else
		block = {
			[GetItemInfo(6948) or "Hearthstone"] = true,  -- Hearthstone
			[GetItemInfo(140192) or "Dalaran Hearthstone"] = true,
			[GetItemInfo(141605) or "Flight Master's Whistle"] = true,
			[GetItemInfo(139599) or "Empowered Ring of the Kirin Tor"] = true,
			[GetItemInfo(147707) or "Repurposed Fel Focuser"] = true,
			[GetItemInfo(153023) or "Lightforged Augment Rune"] = true,
		}
	end

	for key, value in pairs(db.block) do
		db.block[key] = nil
	end

	for key, value in pairs(block) do
		db.block[key] = value
	end

	CoolLine:updatelook()
end
