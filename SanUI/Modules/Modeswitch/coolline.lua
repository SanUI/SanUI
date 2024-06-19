local addonName, addon = ...
local S = unpack(addon)

S.switchCoolLine = function(profile)

	local db, block = {}

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
		
	elseif profile == "Simplex" then
		block = {
			[GetItemInfo(6948) or "Hearthstone"] = true,  -- Hearthstone
			[GetSpellInfo(17364) or "Sturmschlag"] = true,
			[GetSpellInfo(60103) or "Lavapeitsche"] = true,
			[GetSpellInfo(73680) or "Elemente entfesseln"] = true,
			[GetSpellInfo(188389) or "Flammenschock"] = true,
			[GetSpellInfo(8056) or "Frostschock"] = true,
			[GetSpellInfo(73899) or "Urtümlicher Schlag"] = true,
			[GetSpellInfo(58861) or "Hieb"] = true,
			[GetSpellInfo(187874) or "Crash Lightning"] = true,
			[GetSpellInfo(115356) or "Windstrike"] = true,
			[GetSpellInfo(197214) or "Sundering"] = true,
		}
		
	elseif profile == "SahneUnholy" then
		block = {
			[GetItemInfo(6948) or "Hearthstone"] = true,  -- Hearthstone
			[GetSpellInfo(91809) or "Sprung"] = true, --Jump (Ghoul ability)
			[GetSpellInfo(91837) or "Eitriges Bollwerk"] = true, -- Putrid Bulwark (Ghoul ability)
			[GetSpellInfo(47468) or "Klaue"] = true, -- Claw(Ghoul ability)
			[GetSpellInfo(91778) or "Klauenfeger"] = true, -- Sweeping Claws(Ghoul ability)
			[GetSpellInfo(91797 ) or "Monströser Hieb"] = true,  -- Monstrous Blow(Ghoul ability)
			[GetSpellInfo(47481) or "Nagen"] = true,  -- Gnaw(Ghoul ability)
			[GetSpellInfo(91802) or "Torkelnder Ansturm"] = true, -- Shambling Rush (Ghoul ability)
			[GetSpellInfo(47484) or "Zusammenkauern"] = true, -- Huddle(Ghoul ability)	     
		}
	elseif profile == "SandWW" then
		block = {
			[GetItemInfo(6948) or "Hearthstone"] = true,  -- Hearthstone
			[GetSpellInfo(107428) or "Rising Sun Kick"] = true,
			[GetSpellInfo(113656) or "Fists of Fury"] = true,
			[GetSpellInfo(101545) or "Flying Serpent Kick"] = true,
			[GetSpellInfo(115098) or "Chi Wave"] = true,
		}
	elseif profile == "PickerEnh" then
		block = {
			[GetItemInfo(6948) or "Hearthstone"] = true,  -- Hearthstone
			[GetSpellInfo(17364) or "Stormstrike"] = true,
			[GetSpellInfo(60103) or "Lava Lash"] = true,
			[GetSpellInfo(73680) or "Unleash Elements"] = true,
			[GetSpellInfo(8050) or "Flame Shock"] = true,
			[GetSpellInfo(8056) or "Frost Shock"] = true,
			[GetSpellInfo(1535) or "Fire Nova"] = true,
		}
	elseif profile == "NortrumTank" then
		block = {
			[GetItemInfo(6948) or "Hearthstone"] = true,  -- Hearthstone
			[GetSpellInfo(6572) or "Revenge"] = true,
			[GetSpellInfo(23922) or "Shield Slam"] = true,
			[GetSpellInfo(78) or "Heroic Strike"] = true,
			--[GetSpellInfo(46968) or "Shockwave"] = true,
			[GetSpellInfo(6343) or "Thunder Clap"] = true,
			[GetSpellInfo(2565) or "Shield Block"] = true,
		}
	elseif profile == "HedgeBM" then
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
		
	local key, value

	for key, value in pairs(db.block) do
		db.block[key] = nil
	end

	for key, value in pairs(block) do
		db.block[key] = value
	end
	
	CoolLine:updatelook()
end
