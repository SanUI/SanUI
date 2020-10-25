local S = unpack(SanUI)


-- This is the list of profiles you can choose from the menu
-- If there's only 1, it's loaded automatically and you dont get anything in the menu
-- If there's more than 1, the first is loaded by default, and you can choose all of them from the menu
-- Modes are defined below, see "MODES HERE"
S["profiles"] = {
 ["Tavore"] = { 
	modes = {"SanHeal","SanChicken","SanBear", "SanCat" },
	AddonMenu = {DBM=1, Altoholic=2, Hack=3, MDT=4},
 },
 ["Jhess"] = {
	modes = {"JhessDisc","JhessHoly","JhessShadow"},
	AddonMenu = {DBM=1,Altoholic=2, WorldFrame=3},
 },
 ["Picker"] = { 
	modes = {"PickerEnh" },
	AddonMenu = {DBM=1, Altoholic=2, WorldFrame=3},
 },
 ["Sahnetorture"] = { 
	modes = {"SahneUnholy"},
	AddonMenu = {DBM=1, Altoholic=2, WorldFrame=3},
 },
 ["Alakabaster"] = {
	modes = {"Alakabaster"},
	AddonMenu = {Grid=1, DBM=2, Altoholic=3},
 },
 ["Nortrum"] = {
	modes = {"NortrumTank"},
	AddonMenu = {DBM=1,Altoholic=2,WorldFrame=3},
 },
 ["Suran"] = {
	modes = {"Suran"},
	AddonMenu = {Grid=1, DBM=2, Altoholic=3},
 },
 ["Borrack"] = {
	modes = {"Borrack"},
	AddonMenu = {Grid=1, DBM=2, Altoholic=3},
 },
 ["Manyak"] = {
	modes = {"Manyak"},
	AddonMenu = {Grid=1, DBM=2, Altoholic=3},
 },
 ["Sindaria"] = {
	modes = {"SinHeal","SinShadow"},
	AddonMenu = {DBM=1,Altoholic=2, WorldFrame=3},
 },
 ["Simplex"] = {
	modes = {"Simplex"},
	AddonMenu = {Grid=1,Altoholic=2,DXE=3}
 },
 ["Amber"] = {
 	modes = {"PHoly","PProt","PRet"},
	AddonMenu = {DBM=1, Altoholic=2, Hack=3},
 },
 ["Hedge"] = { 
	modes = {"HedgeBM" },
	AddonMenu = {DBM=1, Altoholic=2, Hack=3, MDT=4},
 },
 ["DEFAULT"] = {
 	modes = {"Heal","Tank", "Damage" },
	AddonMenu = {DBM=1, Altoholic=2, WorldFrame=3},
 },
}

-- MODES HERE
-- Just c&p any of the entries and edit to your likings
-- the individual entries are commented below in the SanHeal mode
-- most things should be obvious from the screenshots, see http://www.wowinterface.com/downloads/fileinfo.php?id=18562#info
-- I've described them below nevertheless

S["Modes"] = {

	["SanHeal"] = {
	
		["raidframes"] = "SanHeal",		--SanHeal always shows the Healing Raid Frames
							--SanChicken always shows the DD Raid Frames
		["SimpleAuraFilter"] = "SanHeal",	--Those profiles aren't delivered with SanUI, choose any you want and configure ingame
							--Just Shift+Rightclick on any buff to hide, it will be cancelled now, but never show up again, even if you have it
		["castbar"] = "SanHeal",		--SanHeal/SanFeral puts it under the player frame, SanChicken in the middle between player and target with symbol above
							--Pally puts it under the player frame, left of the holy power (paladins should use this)
							--DK puts it under the player frame, under the rune display (deathknights should use this)
		["powerbar"] = "Hidden",		--Hidden hides it, SanCat shows it in cat form right in the middle of the screen below the char (only works for druids),
							--Rogue is the same as SanFeral just without shapeshift magic
							--SanBear/SahneUnholy put it where the first 7/8 action buttons are usually, see ["ActionButtons"] below
		["Filger"] = "SanHeal",			--SanHeal for druid healers, SanFeral for Ferals, SanChicken for moonkins... others need to be defined in Tukui_Filger/Tukui_Filger_San.lua
							--you can always use default_CLASS (i.e. default_MAGE)
							--look at the Modes below to see what else has been preconfigured other then default_CLASS (e.g. default_PRIEST etc.)
		["gcd"] = "SanHeal",			--Hidden hides it, everything else puts is below the castbar
		["bossbars"] = "SanHeal",		--SanHeal has greyish colors and tukui borders, Suran has red color and black borders
							--SanChicken has SanHeals colors, but puts them stacked above target frame (useful for multidot)
		["coolline"] = "SanHeal",		--SanHeal for Druid Healers, disable to disable it (does not unload the addon, just disable it)
							--SanFeral for Feral Druids, hides all the short time stuff like mangle(bear)
							--Simplex for Enhancement Shaman, hides all the rotational stuff
		["ActionButtons"] = "SanHeal",		--Positioning of ActionButtons, SanHeal is just the standard, SanBear arranges the first 7
							--visibly below the char... and positions the buff timer bar for savage defense appropriately
							--i.e. => you should just use SanBear for bears, in combination with the SanBear Filger profile
							--and use ActionButton7 for SavageDefense
							--SahneUnholy is the same as SanBear, just for the 8 first buttons instead of 7
		["DBM"] = "SanHeal", --DBM profile to use, if you choose one that deosn't exist, one with that name will be created
	},
	["SanChicken"] = {
		["raidframes"] = "SanChicken",
		["SimpleAuraFilter"] = "SanChicken",
		["castbar"] = "SanChicken",
		["powerbar"] = "SanChicken",
		["Filger"] = "SanChicken",
		["gcd"] = "SanChicken",
		["bossbars"] = "SanChicken",
		["coolline"] = "SanHeal",
		["ActionButtons"] = "SanHeal",
		["DBM"] = "SanHeal", 
	},
	["SanBear"] = {
		["raidframes"] = "SanChicken",
		["SimpleAuraFilter"] = "SanBear",
		["castbar"] = "SanBear",
		["powerbar"] = "SahneUnholy",
		["gcd"] = "SanBear",
		["bossbars"] = "SanChicken",
		["coolline"] = "SanBear",
		["ActionButtons"] = "SanBear",
		["DBM"] = "SanBear", 
	},
	["SanCat"] = {
		["raidframes"] = "SanChicken",
		["SimpleAuraFilter"] = "SanCat",
		["castbar"] = "SanCat",
		["powerbar"] = "SanCat",
		["Filger"] = "SanCat",
		["gcd"] = "SanCat",
		["bossbars"] = "SanHeal",
		["coolline"] = "SanCat",
		["ActionButtons"] = "SanHeal",
		["DBM"] = "SanHeal", 
	},
	["JhessDisc"] = {
		["raidframes"] = "SanHeal",
		["SimpleAuraFilter"] = "SanChicken",
		["castbar"] = "SanHeal",
		["powerbar"] = "Hidden",
		["Filger"] = "SanChicken",
		["gcd"] = "SanChicken",
		["bossbars"] = "SanChicken",
		["coolline"] = "SanHeal",
		["ActionButtons"] = "SanHeal",
		["DBM"] = "JhessDisc", 
	},
	["JhessHoly"] = {
		["raidframes"] = "SanHeal",
		["SimpleAuraFilter"] = "SanChicken",
		["castbar"] = "SanChicken",
		["powerbar"] = "Hidden",
		["Filger"] = "SanChicken",
		["gcd"] = "SanChicken",
		["bossbars"] = "SanHeal",
		["coolline"] = "SanHeal",
		["ActionButtons"] = "SanHeal",
		["DBM"] = "JhessDisc", 
	},
	["JhessShadow"] = {
		["raidframes"] = "SanChicken",
		["SimpleAuraFilter"] = "SanChicken",
		["castbar"] = "SanChicken",
		["powerbar"] = "Hidden",
		["Filger"] = "SanChicken",
		["gcd"] = "SanChicken",
		["bossbars"] = "SanChicken",
		["coolline"] = "SanHeal",
		["ActionButtons"] = "SanHeal",
		["DBM"] = "JhessShadow", 
	},
	["PHoly"] = {
		["raidframes"] = "SanHeal",
		["SimpleAuraFilter"] = "SanHeal",
		["castbar"] = "SanHeal",
		["powerbar"] = "Hidden",
		["Filger"] = "SanHeal",
		["gcd"] = "SanHeal",
		["bossbars"] = "SanHeal",
		["coolline"] = "SanHeal",
		["ActionButtons"] = "SanHeal",
		["DBM"] = "SanHeal",
	},
	["PProt"] = {
		["raidframes"] = "SanChicken",
		["SimpleAuraFilter"] = "SanBear",
		["castbar"] = "SanBear",
		["powerbar"] = "SahneUnholy",
		["gcd"] = "SanBear",
		["bossbars"] = "SanChicken",
		["coolline"] = "SanBear",
		["ActionButtons"] = "SanBear",
		["DBM"] = "SanBear", 
	},
	["PRet"] = {
		["raidframes"] = "SanChicken",
		["SimpleAuraFilter"] = "SanBear",
		["castbar"] = "PRet",
		["powerbar"] = "SahneUnholy",
		["gcd"] = "SanBear",
		["classpower"] = "PRet",
		["bossbars"] = "SanChicken",
		["coolline"] = "SanBear",
		["ActionButtons"] = "PRet",
		["DBM"] = "SanBear", 
	},
	["HedgeBM"] = {
		["raidframes"] = "SanChicken",
		["SimpleAuraFilter"] = "SanChicken",
		["castbar"] = "SanHeal",
		["powerbar"] = "SanChicken",
		["Filger"] = "SanChicken",
		["gcd"] = "Hidden",
		["bossbars"] = "SanChicken",
		["coolline"] = "HedgeBM",
		["ActionButtons"] = "SanHeal",
		["DBM"] = "HedgeBM", 
	},
	["SahneUnholy"] = {
		["raidframes"] = "SanChicken",
		["SimpleAuraFilter"] = "SanBear",
		["castbar"] = "DK",
		["powerbar"] = "SahneUnholy",
		["gcd"] = "SanBear",
		["bossbars"] = "SanChicken",
		["coolline"] = "SanBear",
		["ActionButtons"] = "SanBear",
		["DBM"] = "SanBear", 
	},
}

if not S["profiles"][S.MyName] then

	if S.MyClass == "DRUID" then
		S["profiles"][S.MyName] = S["profiles"]["Tavore"]
	else
		S["profiles"][S.MyName] = S["profiles"]["DEFAULT"]
		S["Modes"]["Heal"] = S["Modes"]["SanHeal"]
		S["Modes"]["Tank"] = S["Modes"]["SanBear"]
		S["Modes"]["Damage"] = S["Modes"]["SanChicken"]
	end
	
	if S.MyClass == "PRIEST" then
		S["profiles"][S.MyName]["modes"][4]="Discipline"
		S["Modes"]["Discipline"] = S["Modes"]["JhessDisc"]
	end
end
