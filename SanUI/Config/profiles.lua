local _, addon = ...
local S = addon[1]

-- This is the list of profiles you can choose from the menu
-- If there's only 1, it's loaded automatically and you dont get anything in the menu
-- If there's more than 1, the first is loaded by default, and you can choose all of them from the menu
-- Modes are defined below, see "MODES HERE"
S["profiles"] = {
 ["Tavore"] = {
	modes = {"SanHeal","SanChicken","SanBear", "SanCat", "SanLarodar" },
	AddonMenu = {BigWigs=1,  Hack=2, MDT=3},
 },
 ["Tovi"] ={
	modes = {"ToviDam", "ToviAug" },
	AddonMenu = {BigWigs=1,  Hack=2, MDT=3,},
 },
  ["Dovi"] = {
	modes = {"DoviBM" },
	AddonMenu = {BigWigs=1,  Hack=2, MDT=3},
 },
 ["Jhess"] = {
	modes = {"JhessDisc","JhessHoly","JhessShadow"},
	AddonMenu = {BigWigs=1, WorldFrame=2},
 },
 ["Lolgas"] = {
	modes = { "LolgasTank" },
	AddonMenu = {BigWigs=1,  Hack=2, MDT=3},
 },
 ["Tiamar"] = {
	modes = {"AmberTank" },
	AddonMenu = {BigWigs=1, Hack=2, MDT=3},
 },
 ["DEFAULT"] = {
 	modes = {"Heal","Tank", "Damage" },
	AddonMenu = {BigWigs=1, Hack=2, MDT=3},
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
							--ToviDam is like SanChicken, but the cast time text is above the GCD bar
		["powerbar"] = "Hidden",		--Hidden hides it, SanCat shows it in cat form right in the middle of the screen below the char (only works for druids),
							--SanBear/SahneUnholy put it where the first 7/8 action buttons are usually, see ["ActionButtons"] below
		["gcd"] = "SanHeal",			--Hidden hides it, everything else puts is below the castbar
		["bossbars"] = "SanHeal",		--SanHeal has greyish colors and tukui borders, Suran has red color and black borders
							--SanChicken has SanHeals colors, but puts them stacked above target frame (useful for multidot)
		["ActionButtons"] = "SanHeal",		--Positioning of ActionButtons, SanHeal is just the standard, SanBear arranges the first 7
							--visibly below the char... and positions the buff timer bar for savage defense appropriately
							--i.e. => you should just use SanBear for bears
							--and use ActionButton7 for SavageDefense

		["DBM"] = "SanHeal", --DBM profile to use, if you choose one that deosn't exist, one with that name will be created
	},
	["SanLarodar"] = {
		["raidframes"] = "SanHeal",
		["SimpleAuraFilter"] = "SanHeal",
		["castbar"] = "SanHeal",
		["powerbar"] = "Hidden",
		["gcd"] = "SanHeal",
		["bossbars"] = "SanChicken",
		["ActionButtons"] = "SanHeal",
		["DBM"] = "SanHeal",
	},
	["ToviAug"] = {
		["raidframes"] = "SanChicken",
		["SimpleAuraFilter"] = "ToviAug",
		["castbar"] = "ToviAug",
		["powerbar"] = "Hidden",
		["gcd"] = "ToviAug",
		["bossbars"] = "SanHeal",
		["ActionButtons"] = "SanBear",
		["DBM"] = "SanHeal",
		["namedframes"] = "ToviAug",
	},
	["SanChicken"] = {
		["raidframes"] = "SanChicken",
		["SimpleAuraFilter"] = "SanChicken",
		["castbar"] = "SanChicken",
		["powerbar"] = "SanChicken",
		["gcd"] = "SanChicken",
		["bossbars"] = "SanChicken",
		["ActionButtons"] = "SanHeal",
		["DBM"] = "SanHeal",
	},
	["SanBear"] = {
		["raidframes"] = "SanChicken",
		["SimpleAuraFilter"] = "SanBear",
		["castbar"] = "SanBear",
		["powerbar"] = "SanBear",
		["gcd"] = "SanBear",
		["bossbars"] = "SanChicken",
		["ActionButtons"] = "SanBear",
		["DBM"] = "SanBear",
	},
	["AmberTank"] = {
		["raidframes"] = "AmberTank",
		["SimpleAuraFilter"] = "AmberTank",
		["castbar"] = "SanBear",
		["powerbar"] = "SanBear",
		["gcd"] = "SanBear",
		["bossbars"] = "SanChicken",
		["ActionButtons"] = "SanBear",
		["DBM"] = "SanBear",
	},
	["ToviDam"] = {
		["raidframes"] = "SanChicken",
		["SimpleAuraFilter"] = "SanChicken",
		["castbar"] = "ToviDam",
		["powerbar"] = "Hidden",
		["gcd"] = "SanChicken",
		["bossbars"] = "SanChicken",
		["ActionButtons"] = "SanHeal",
		["DBM"] = "SanHeal",
	},
	["SanCat"] = {
		["raidframes"] = "SanChicken",
		["SimpleAuraFilter"] = "SanCat",
		["castbar"] = "SanCat",
		["powerbar"] = "Hidden",
		["gcd"] = "SanCat",
		["bossbars"] = "SanHeal",
		["ActionButtons"] = "SanHeal",
		["DBM"] = "SanHeal",
	},
	["DoviBM"] = {
		["raidframes"] = "SanChicken",
		["SimpleAuraFilter"] = "SanChicken",
		["castbar"] = "SanHeal",
		["powerbar"] = "SanBear",
		["gcd"] = "Hidden",
		["bossbars"] = "SanChicken",
		["ActionButtons"] = "SanBear",
		["DBM"] = "HedgeBM",
	},
	["JhessDisc"] = {
		["raidframes"] = "SanHeal",
		["SimpleAuraFilter"] = "SanChicken",
		["castbar"] = "SanHeal",
		["powerbar"] = "Hidden",
		["gcd"] = "SanHeal",
		["bossbars"] = "SanHeal",
		["ActionButtons"] = "SanHeal",
		["DBM"] = "JhessDisc",
	},
	["JhessHoly"] = {
		["raidframes"] = "SanHeal",
		["SimpleAuraFilter"] = "SanChicken",
		["castbar"] = "SanChicken",
		["powerbar"] = "Hidden",
		["gcd"] = "SanChicken",
		["bossbars"] = "SanHeal",
		["ActionButtons"] = "SanHeal",
		["DBM"] = "JhessDisc",
	},
	["JhessShadow"] = {
		["raidframes"] = "SanChicken",
		["SimpleAuraFilter"] = "SanChicken",
		["castbar"] = "SanChicken",
		["powerbar"] = "Hidden",
		["gcd"] = "SanChicken",
		["bossbars"] = "SanChicken",
		["ActionButtons"] = "SanHeal",
		["DBM"] = "JhessShadow",
	},
	["LolgasTank"] = {
		["raidframes"] = "SanChicken",
		["SimpleAuraFilter"] = "Lolgas",
		["castbar"] = "SanBear",
		["powerbar"] = "SanBear",
		["gcd"] = "SanBear",
		["bossbars"] = "SanChicken",
		["ActionButtons"] = "SanBear",
		["DBM"] = "SanBear",
	},
}

if not S["profiles"][S.MyName] then

	if S.MyClass == "Druid" then
		S["profiles"][S.MyName] = S["profiles"]["Tavore"]
	else
		S["profiles"][S.MyName] = S["profiles"]["DEFAULT"]
		S["Modes"]["Heal"] = S["Modes"]["SanHeal"]
		S["Modes"]["Tank"] = S["Modes"]["SanBear"]
		S["Modes"]["Damage"] = S["Modes"]["SanChicken"]
	end

	if S.MyClass == "Priest" then
		S["profiles"][S.MyName]["modes"][4]="Discipline"
		S["Modes"]["Discipline"] = S["Modes"]["JhessDisc"]
	end
end