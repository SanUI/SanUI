local oUF_Hank = {}
local cfg = oUF_Hank_config

local S, C = unpack(SanUI)
local oUF = SanUI.oUF --Tukui.oUF

local libDispel = S.libDispel
local canDispel = function(dispellType)
	libDispel:IsDispellableByMe(dispellType)
end

local Scale = S.Scale

-- GLOBALS: oUF_player, oUF_pet, oUF_target, oUF_focus
-- GLOBALS: _G, MIRRORTIMER_NUMTIMERS, SPELL_POWER_HOLY_POWER, MAX_TOTEMS, MAX_COMBO_POINTS, DebuffTypeColor, SPEC_WARLOCK_DEMONOLOGY

local ToggleDropDownMenu = ToggleDropDownMenu
local UnitIsUnit = UnitIsUnit
local GetTime = GetTime
local AnimateTexCoords = AnimateTexCoords
local GetSpecialization = GetSpecialization
local UnitHasVehicleUI = UnitHasVehicleUI
local UnitHealth = UnitHealth
local UnitHealthMax = UnitHealthMax
local UnitPower = UnitPower
local UnitIsDead = UnitIsDead
local UnitIsGhost = UnitIsGhost
local UnitIsConnected = UnitIsConnected
local UnitAffectingCombat = UnitAffectingCombat
local GetLootMethod = GetLootMethod
local UnitIsGroupLeader = UnitIsGroupLeader
local UnitIsPVPFreeForAll = UnitIsPVPFreeForAll
local UnitIsPVP = UnitIsPVP
local UnitInRaid = UnitInRaid
local IsResting = IsResting
local UnitCanAttack = UnitCanAttack
local UnitIsGroupAssistant = UnitIsGroupAssistant
local GetRuneCooldown = GetRuneCooldown
local UnitClass = UnitClass
local CancelUnitBuff = CancelUnitBuff
local CreateFrame = CreateFrame
local IsAddOnLoaded = C_AddOns.IsAddOnLoaded
local UnitFrame = UnitFrame_OnEnter
local UnitFrame = UnitFrame_OnLeave
local unpack = unpack
local pairs = pairs
local ipairs = ipairs
local select = select
local tinsert = table.insert
local ceil = math.ceil
local floor = math.floor
local upper = string.upper
local strlen = string.len
local strsub = string.sub
local gmatch = string.gmatch
local match = string.match

oUF_Hank.digitTexCoords = {
	["1"] = {1, 20},
	["2"] = {21, 31},
	["3"] = {53, 30},
	["4"] = {84, 33},
	["5"] = {118, 30},
	["6"] = {149, 31},
	["7"] = {181, 30},
	["8"] = {212, 31},
	["9"] = {244, 31},
	["0"] = {276, 31},
	["%"] = {308, 17},
	["X"] = {326, 31}, -- Dead
	["G"] = {358, 36}, -- Ghost
	["Off"] = {395, 23}, -- Offline
	["B"] = {419, 42}, -- Boss
	["height"] = 42,
	["texWidth"] = 512,
	["texHeight"] = 128
}

oUF_Hank.classResources = {
	['PALADIN'] = {
		inactive = {'Interface\\AddOns\\oUF_Hank\\textures\\HolyPower.blp', { 0, 18/64, 0, 18/32 }},
		active = {'Interface\\AddOns\\oUF_Hank\\textures\\HolyPower.blp', { 18/64, 36/64, 0, 18/32 }},
		size = {18, 18},
		max = 5,
	},
	['MONK'] = {
		inactive = {'Interface\\PlayerFrame\\MonkNoPower'},
		active = {'Interface\\PlayerFrame\\MonkLightPower'},
		size = {20, 20},
		max = 6,
		offset = - 100,
	},
	['SHAMAN'] = {
		inactive = {'Interface\\AddOns\\oUF_Hank\\textures\\blank.blp', { 0, 23/128, 0, 20/32 }},
		active = {'Interface\\AddOns\\oUF_Hank\\textures\\totems.blp', { (1+23)/128, ((23*2)+1)/128, 0, 20/32 }},
		size = {23, 20},
		spacing = -3,
		inverse = true,
		max = 3,
	},
	['WARLOCK'] = {
		inactive = {'Interface\\AddOns\\oUF_Hank\\textures\\shard_bg.blp'},
		active = {'Interface\\AddOns\\oUF_Hank\\textures\\shard.blp'},
		size = {16, 16},
		spacing = 5,
		max = 6,
	},
	['EVOKER'] = {
		inactive = {'Interface\\PlayerFrame\\MonkNoPower'},
		active = {'Interface\\PlayerFrame\\MonkLightPower'},
		size = {20, 20},
		max = 6,
		offset = - 102,
	},
}

local fntBig = CreateFont("UFFontBig")
fntBig:SetFont(unpack(cfg.FontStyleBig))
fntBig:SetShadowColor(unpack(cfg.colors.text))
fntBig:SetShadowOffset(Scale(1), -Scale(1))
local fntMedium = CreateFont("UFFontMedium")
fntMedium:SetFont(unpack(cfg.FontStyleMedium))
fntMedium:SetTextColor(unpack(cfg.colors.text))
fntMedium:SetShadowColor(unpack(cfg.colors.textShadow))
fntMedium:SetShadowOffset(Scale(1), -Scale(1))
local fntSmall = CreateFont("UFFontSmall")
fntSmall:SetFont(unpack(cfg.FontStyleSmall))
fntSmall:SetTextColor(unpack(cfg.colors.text))
fntSmall:SetShadowColor(unpack(cfg.colors.textShadow))
fntSmall:SetShadowOffset(Scale(1), -Scale(1))

--local canDispel = oUF_NotRaidDebuffs.DispelFilter

-- Functions -------------------------------------

-- Unit menu
oUF_Hank.menu = function(self)
	local unit = self.unit:sub(1, -2)
	local cunit = self.unit:gsub("(.)", upper, 1)

	-- Swap menus in vehicle
	if unit == "player"  and cunit=="Vehicle" then cunit = "Player" end
	if unit == "pet" and cunit=="Player" then cunit = "Pet" end

	if(unit == "party" or unit == "partypet") then
		ToggleDropDownMenu(nil, nil, _G["PartyMemberFrame"..self.id.."DropDown"], "cursor", 0, 0)
	elseif(cunit == "Player") then
		local which = nil;
		local contextData = {
			fromPlayerFrame = true;
		};

		if unit == "vehicle" then
			which = "VEHICLE";
			contextData.unit = "vehicle";
		else
			which = "SELF";
			contextData.unit = "player";
		end
		UnitPopup_OpenMenu(which, contextData);
	elseif(_G[cunit.."Frame_OpenMenu"]) then
		_G[cunit.."Frame_OpenMenu"]()
	--elseif(_G[cunit.."FrameDropDown"]) then
	--	ToggleDropDownMenu(nil, nil, _G[cunit.."FrameDropDown"], "cursor", 0, 0)
	end
end

-- This is where the magic happens. Handle health update, display digit textures
oUF_Hank.UpdateHealth = function(self)
	-- self.unit == "vehicle" works fine
	local h, hMax = UnitHealth(self.unit), UnitHealthMax(self.unit)

	local status = (not UnitIsConnected(self.unit) or nil) and "Off" or UnitIsGhost(self.unit) and "G" or UnitIsDead(self.unit) and "X"

	if not status then
		local hPerc = ("%d"):format(h / hMax * 100 + 0.5)
		local len = strlen(hPerc)

		if self.unit:find("boss") then
			self.health[1]:SetSize(oUF_Hank.digitTexCoords["B"][2], oUF_Hank.digitTexCoords["height"])
			self.health[1]:SetTexCoord(oUF_Hank.digitTexCoords["B"][1] / oUF_Hank.digitTexCoords["texWidth"], (oUF_Hank.digitTexCoords["B"][1] + oUF_Hank.digitTexCoords["B"][2]) / oUF_Hank.digitTexCoords["texWidth"], 1 / oUF_Hank.digitTexCoords["texHeight"], (1 + oUF_Hank.digitTexCoords["height"]) / oUF_Hank.digitTexCoords["texHeight"])
			self.health[1]:Show()
			self.healthFill[1]:SetSize(oUF_Hank.digitTexCoords["B"][2], oUF_Hank.digitTexCoords["height"] * h / hMax)
			self.healthFill[1]:SetTexCoord(
				oUF_Hank.digitTexCoords["B"][1] / oUF_Hank.digitTexCoords["texWidth"],
				(oUF_Hank.digitTexCoords["B"][1] + oUF_Hank.digitTexCoords["B"][2]) / oUF_Hank.digitTexCoords["texWidth"],
				(2 + 2 * oUF_Hank.digitTexCoords["height"] - oUF_Hank.digitTexCoords["height"] * h / hMax) / oUF_Hank.digitTexCoords["texHeight"],
				(2 + 2 * oUF_Hank.digitTexCoords["height"]) / oUF_Hank.digitTexCoords["texHeight"]
			)
			self.healthFill[1]:Show()
		else
			for i = 1, 3 do
				if i > len then
					self.health[4 - i]:Hide()
					self.healthFill[4 - i]:Hide()
				else
					local digit
					if self == oUF_player then
						digit = strsub(hPerc , -i, -i)
					elseif self == oUF_target or self == oUF_focus then
						digit = strsub(hPerc , i, i)
					end
					self.health[4 - i]:SetSize(oUF_Hank.digitTexCoords[digit][2], oUF_Hank.digitTexCoords["height"])
					self.health[4 - i]:SetTexCoord(oUF_Hank.digitTexCoords[digit][1] / oUF_Hank.digitTexCoords["texWidth"], (oUF_Hank.digitTexCoords[digit][1] + oUF_Hank.digitTexCoords[digit][2]) / oUF_Hank.digitTexCoords["texWidth"], 1 / oUF_Hank.digitTexCoords["texHeight"], (1 + oUF_Hank.digitTexCoords["height"]) / oUF_Hank.digitTexCoords["texHeight"])
					self.health[4 - i]:Show()
					self.healthFill[4 - i]:SetSize(oUF_Hank.digitTexCoords[digit][2], oUF_Hank.digitTexCoords["height"] * h / hMax)
					self.healthFill[4 - i]:SetTexCoord(oUF_Hank.digitTexCoords[digit][1] / oUF_Hank.digitTexCoords["texWidth"], (oUF_Hank.digitTexCoords[digit][1] + oUF_Hank.digitTexCoords[digit][2]) / oUF_Hank.digitTexCoords["texWidth"], (2 + 2 * oUF_Hank.digitTexCoords["height"] - oUF_Hank.digitTexCoords["height"] * h / hMax) / oUF_Hank.digitTexCoords["texHeight"], (2 + 2 * oUF_Hank.digitTexCoords["height"]) / oUF_Hank.digitTexCoords["texHeight"])
					self.healthFill[4 - i]:Show()
				end
			end

			if self == oUF_player then
				self.power:SetPoint("BOTTOMRIGHT", self.health[4 - len], "BOTTOMLEFT", -Scale(5), 0)
			elseif self == oUF_target or self == oUF_focus then
				self.power:SetPoint("BOTTOMLEFT", self.health[4 - len], "BOTTOMRIGHT", Scale(5), 0)
			end
		end
	else
		if self.unit:find("boss") then
			self.healthFill[1]:Hide()
			self.health[1]:SetSize(oUF_Hank.digitTexCoords[status][2], oUF_Hank.digitTexCoords["height"])
			self.health[1]:SetTexCoord(oUF_Hank.digitTexCoords[status][1] / oUF_Hank.digitTexCoords["texWidth"], (oUF_Hank.digitTexCoords[status][1] + oUF_Hank.digitTexCoords[status][2]) / oUF_Hank.digitTexCoords["texWidth"], 1 / oUF_Hank.digitTexCoords["texHeight"], (1 + oUF_Hank.digitTexCoords["height"]) / oUF_Hank.digitTexCoords["texHeight"])
			self.health[1]:Show()
		else
			for i = 1, 3 do
				self.healthFill[i]:Hide()
				self.health[i]:Hide()
			end

			self.health[3]:SetSize(oUF_Hank.digitTexCoords[status][2], oUF_Hank.digitTexCoords["height"])
			self.health[3]:SetTexCoord(oUF_Hank.digitTexCoords[status][1] / oUF_Hank.digitTexCoords["texWidth"], (oUF_Hank.digitTexCoords[status][1] + oUF_Hank.digitTexCoords[status][2]) / oUF_Hank.digitTexCoords["texWidth"], 1 / oUF_Hank.digitTexCoords["texHeight"], (1 + oUF_Hank.digitTexCoords["height"]) / oUF_Hank.digitTexCoords["texHeight"])
			self.health[3]:Show()

			if self == oUF_player then
				self.power:SetPoint("BOTTOMRIGHT", self.health[3], "BOTTOMLEFT", -Scale(5), 0)
			elseif self == oUF_target or self == oUF_focus then
				self.power:SetPoint("BOTTOMLEFT", self.health[3], "BOTTOMRIGHT", Scale(5), 0)
			end
		end
	end
end

-- Manual status icons update
oUF_Hank.UpdateStatus = function(self)
	local referenceElement
	-- TODO find a better way to do this
	local hasAdditionalPower = {
		["DEMONHUNTER"] = false,
		["DEATHKNIGHT"] = false,
		["DRUID"] = (GetSpecialization() ~= 4),
		["HUNTER"] = false,
		["MAGE"] = false,
		["MONK"] = false,
		["PALADIN"] = false,
		["PRIEST"] = (GetSpecialization() == 3),
		["ROGUE"] = false,
		["SHAMAN"] = (GetSpecialization() == 1 or GetSpecialization() == 2),
		["WARLOCK"] = false,
		["WARRIOR"] = false,
	}
	if cfg.AdditionalPower and self.additionalPower and hasAdditionalPower[select(2, UnitClass("player"))] then
		referenceElement = self.additionalPower
	else
		referenceElement = self.power
	end
	-- Attach the first icon to the right border of self.power
	local lastElement = {"BOTTOMRIGHT", referenceElement, "TOPRIGHT"}

	-- Status icon texture names and conditions
	local icons = {
		["C"] = {"CombatIndicator", UnitAffectingCombat("player")},
		["R"] = {"RestingIndicator", IsResting()},
		["L"] = {"LeaderIndicator", UnitIsGroupLeader("player")},
		["M"] = {"MasterLooterIndicator", ({GetLootMethod()})[1] == "master" and (
				(({GetLootMethod()})[2]) == 0 or
				((({GetLootMethod()})[2]) and UnitIsUnit("player", "party" .. ({GetLootMethod()})[2])) or
				((({GetLootMethod()})[3]) and UnitIsUnit("player", "raid" .. ({GetLootMethod()})[3]))
			)},
		["P"] = {"PvPIndicator", UnitIsPVPFreeForAll("player") or UnitIsPVP("player")},
		["A"] = {"AssistantIndicator", UnitInRaid("player") and UnitIsGroupAssistant("player") and not UnitIsGroupLeader("player")},
	}

	for i = -1, -strlen(cfg.StatusIcons), -1 do
		if icons[strsub(cfg.StatusIcons, i, i)][2] then
			self[icons[strsub(cfg.StatusIcons, i, i)][1]]:ClearAllPoints()
			self[icons[strsub(cfg.StatusIcons, i, i)][1]]:SetPoint(unpack(lastElement))
			self[icons[strsub(cfg.StatusIcons, i, i)][1]]:Show()
			-- Arrange any successive icon to the last one
			lastElement = {"RIGHT", self[icons[strsub(cfg.StatusIcons, i, i)][1]], "LEFT"}
		else
			-- Condition for displaying the icon not met
			self[icons[strsub(cfg.StatusIcons, i, i)][1]]:Hide()
		end
	end
end

-- Reanchoring / -sizing on name update
oUF_Hank.PostUpdateName = function(self)
	if (self.name) then
		-- Reanchor raid icon to the largest string (either name or power)
		if self.name:GetWidth() >= self.power:GetWidth() then
			self.RaidTargetIndicator:SetPoint("LEFT", self.name, "RIGHT", Scale(10), 0)
		else
			self.RaidTargetIndicator:SetPoint("LEFT", self.power, "RIGHT", Scale(10), 0)
		end
	end
end
	--[[ 
	Called after the aura button has been updated.

	* self     - the widget holding the aura buttons
	* button   - the updated aura button (Button)
	* unit     - the unit on which the aura is cast (string)
	* data     - the aura data (table)
	* position - the actual position of the aura button (number)
		element:PostUpdateIcon(button, unit, data, position)
		--]]
-- Sticky aura colors
oUF_Hank.PostUpdateButton = function(icons, icon, unit, data, index)
	local filter = icons.filter
	local config = cfg["Auras" .. upper(unit)]
	local stickyauras = (config and config.StickyAuras) or {}
	local can_attack = UnitCanAttack("player", unit)

	local dtype = data.dispelName
	local caster = data.sourceUnit

	-- We want the border, not the color for the type indication
	icon.Overlay:SetVertexColor(1, 1, 1)

	if caster == "vehicle" then caster = "player" end

	if filter == "HELPFUL" and (not can_attack) and caster == "player" and stickyauras.myBuffs then
		-- Sticky aura: myBuffs
		icon.Icon:SetVertexColor(unpack(cfg.AuraStickyColor))
		icon.Icon:SetDesaturated(false)
	elseif filter == "HARMFUL" and can_attack and caster == "player" and stickyauras.myDebuffs then
		-- Sticky aura: myDebuffs
		icon.Icon:SetVertexColor(unpack(cfg.AuraStickyColor))
		icon.Icon:SetDesaturated(false)
	elseif filter == "HARMFUL" and can_attack and caster == "pet" and stickyauras.petDebuffs then
		-- Sticky aura: petDebuffs
		icon.Icon:SetVertexColor(unpack(cfg.AuraStickyColor))
		icon.Icon:SetDesaturated(false)
	elseif filter == "HARMFUL" and (not can_attack) and canDispel(dtype) and stickyauras.curableDebuffs then
		-- Sticky aura: curableDebuffs
		icon.Icon:SetVertexColor(DebuffTypeColor[dtype].r, DebuffTypeColor[dtype].g, DebuffTypeColor[dtype].b)
		icon.Icon:SetDesaturated(false)
	elseif filter == "HELPFUL" and can_attack and UnitIsUnit(unit, caster or "") and stickyauras.enemySelfBuffs then
		-- Sticky aura: enemySelfBuffs
		icon.Icon:SetVertexColor(unpack(cfg.AuraStickyColor))
		icon.Icon:SetDesaturated(false)
	elseif filter == "HARMFUL" and (not can_attack) and stickyauras.debuffsOnFriendly then
		icon.Icon:SetVertexColor(unpack(cfg.AuraStickyColor))
		icon.Icon:SetDesaturated(false)
	else
		icon.Icon:SetVertexColor(1, 1, 1)
		icon.Icon:SetDesaturated(true)
	end
end

-- Custom filters
oUF_Hank.FilterAura = function(icons, unit, data)
--function(icons, unit, icon, name, texture, count, dtype, duration, timeLeft, caster)
	local filter = icons.filter
	local config = cfg["Auras" .. upper(unit)]
	local stickyauras = (config and config.StickyAuras) or {}
	local can_attack = UnitCanAttack("player", unit)

	local name = data.name
	local dtype = data.dispelName
	local caster = data.sourceUnit

	if caster == "vehicle" then caster = "player" end

	if filter == "HELPFUL" and (not can_attack) and caster == "player" and stickyauras.myBuffs then
		-- Sticky aura: myBuffs
		return true
	elseif filter == "HARMFUL" and can_attack and caster == "player" and stickyauras.myDebuffs then
		-- Sticky aura: myDebuffs
		return true
	elseif filter == "HARMFUL" and can_attack and caster == "pet" and stickyauras.petDebuffs then
		-- Sticky aura: petDebuffs
		return true
	elseif filter == "HARMFUL" and (not can_attack) and canDispel(dtype) and stickyauras.curableDebuffs then
		-- Sticky aura: curableDebuffs
		return true
	-- Usage of UnitIsUnit: Call from within focus frame will return "target" as caster if focus is targeted (player > target > focus)
	elseif filter == "HELPFUL" and can_attack and UnitIsUnit(unit, caster or "") and stickyauras.enemySelfBuffs then
		-- Sticky aura: enemySelfBuffs
		return true
	elseif filter == "HARMFUL" and (not can_attack) and stickyauras.debuffsOnFriendly then
		return true
	else
		local auratype = filter == "HELPFUL" and "Buffs" or "Debuffs"
		local filtermethod = config and config.FilterMethod[auratype]
		local blacklist = (config and config.BlackList) or {}
		local whitelist = (config and config.WhiteList) or {}

		-- Aura is not sticky, filter is set to blacklist
		if filtermethod == "BLACKLIST" then
			for _, v in ipairs(blacklist) do
				if v == name then
					return false
				end
			end
			return true
		-- Aura is not sticky, filter is set to whitelist
		elseif filtermethod == "WHITELIST" then
			for _, v in ipairs(whitelist) do
				if v == name then
					return true
				end
			end
			return false
		-- Aura is not sticky, filter is set to none
		else
			return true
		end
	end
end

-- Aura mouseover
oUF_Hank.OnEnterAura = function(self, icon)
	-- Aura magnification
	if icon.isDebuff then
		self.HighlightAura:SetSize(cfg.DebuffSize * cfg.AuraMagnification, cfg.DebuffSize * cfg.AuraMagnification)
		self.HighlightAura.icon:SetSize(cfg.DebuffSize * cfg.AuraMagnification, cfg.DebuffSize * cfg.AuraMagnification)
		self.HighlightAura.border:SetSize(cfg.DebuffSize * cfg.AuraMagnification * 1.1, cfg.DebuffSize * cfg.AuraMagnification * 1.1)
		self.HighlightAura:SetPoint("TOPLEFT", icon, "TOPLEFT", -(cfg.DebuffSize * cfg.AuraMagnification - cfg.DebuffSize) / 2, (cfg.DebuffSize * cfg.AuraMagnification - cfg.DebuffSize) / 2)
	else
		self.HighlightAura:SetSize(cfg.BuffSize * cfg.AuraMagnification, cfg.BuffSize * cfg.AuraMagnification)
		self.HighlightAura.icon:SetSize(cfg.BuffSize * cfg.AuraMagnification, cfg.BuffSize * cfg.AuraMagnification)
		self.HighlightAura.border:SetSize(cfg.BuffSize * cfg.AuraMagnification * 1.1, cfg.BuffSize * cfg.AuraMagnification * 1.1)
		self.HighlightAura:SetPoint("TOPLEFT", icon, "TOPLEFT", -(cfg.BuffSize * cfg.AuraMagnification - cfg.BuffSize) / 2, (cfg.BuffSize * cfg.AuraMagnification - cfg.BuffSize) / 2)
	end
	self.HighlightAura.icon:SetTexture(icon.Icon:GetTexture())
	self.HighlightAura:Show()
end

-- Aura mouseout
oUF_Hank.OnLeaveAura = function(self)
	self.HighlightAura:Hide()
end

-- Hook aura scripts, set aura border
oUF_Hank.PostCreateButton = function(icons, icon)
	if cfg.AuraBorder then
		-- Custom aura border
		icon.Overlay:SetTexture(cfg.AuraBorder)
		icon.Overlay:SetPoint("TOPLEFT", icon, "TOPLEFT", -2, 2)
		icon.Overlay:SetPoint("BOTTOMRIGHT", icon, "BOTTOMRIGHT", 2, -2)
		icon.Overlay:SetTexCoord(0, 1, 0, 1)
		icons.showType = true
	end
	icon.Icon:SetTexCoord(0.08, 0.92, 0.08, 0.92)
	icon.Cooldown:SetReverse(true)
	icon.Cooldown.noCooldownCount = true
	icon:HookScript("OnEnter", function() oUF_Hank.OnEnterAura(icons:GetParent(), icon) end)
	icon:HookScript("OnLeave", function() oUF_Hank.OnLeaveAura(icons:GetParent()) end)
	-- Cancel player buffs on right click
	icon:HookScript("OnClick", function(_, button, down)
		if button == "RightButton" and down == false then
			if icon.filter == "HELPFUL" and UnitIsUnit("player", icons:GetParent().unit) then
				CancelUnitBuff("player", icon:GetID())
				oUF_Hank.OnLeaveAura(icons:GetParent())
			end
		end
	end)
end

-- Debuff anchoring
oUF_Hank.BuffsPostUpdate = function(buffs, unit)
	local width = cfg.BuffSize
	local height = cfg.BuffSize
	local sizex = width + cfg.AuraSpacing
	local sizey = height + cfg.AuraSpacing
	local cols = floor(buffs:GetWidth() / sizex + 0.5)
	local buffs_shown = #buffs.sorted
	local rows = floor((buffs_shown - 1) / cols)
	--print("rows: "..tostring(rows).."width: "..tostring(buffs:GetWidth()))

	local debuffs = buffs:GetParent().Debuffs
	debuffs:ClearAllPoints()

	if buffs_shown > 0 then
		-- Anchor debuff frame to bottomost buff icon, i.e the last buff row
		debuffs:SetPoint("TOPLEFT", buffs, "BOTTOMLEFT", 0, -rows*sizey -cfg.AuraSpacing -2)
	else
		-- No buffs
		if buffs:GetParent().CPoints then
			debuffs:SetPoint("TOP", buffs:GetParent().CPoints[1], "BOTTOM", 0, -10)
		else
			debuffs:SetPoint("TOPLEFT", buffs)
		end
	end
end

-- Castbar
oUF_Hank.PostCastStart = function(castbar, unit, name, rank, castid)
	castbar.castIsChanneled = false
	if unit == "vehicle" then unit = "player" end

	-- Latency display
	if unit == "player" then
		-- Time between cast transmission and cast start event
		local latency = GetTime() - (castbar.castSent or 0)
		latency = latency > castbar.max and castbar.max or latency
		castbar.Latency:SetText(("%dms"):format(latency * 1e3))
		castbar.PreciseSafeZone:SetWidth(castbar:GetWidth() * latency / castbar.max)
		castbar.PreciseSafeZone:ClearAllPoints()
		castbar.PreciseSafeZone:SetPoint("TOPRIGHT")
		castbar.PreciseSafeZone:SetPoint("BOTTOMRIGHT")
		castbar.PreciseSafeZone:SetDrawLayer("BACKGROUND")
	end

	if unit ~= "focus" then
		-- Cast layout
		castbar.Text:SetJustifyH("LEFT")
		castbar.Time:SetJustifyH("LEFT")
		if cfg.CastbarIcon then castbar.Dummy.Icon:SetTexture(castbar.Icon:GetTexture()) end
	end

	-- Uninterruptible spells
	if castbar.Shield:IsShown() and UnitCanAttack("player", unit) then
		castbar.Background:SetBackdropBorderColor(unpack(cfg.colors.castbar.noInterrupt))
	else
		castbar.Background:SetBackdropBorderColor(0, 0, 0)
	end
end

oUF_Hank.PostChannelStart = function(castbar, unit, name, rank)
	castbar.castIsChanneled = true
	if unit == "vehicle" then unit = "player" end

	if unit == "player" then
		local latency = GetTime() - (castbar.castSent or 0) -- Something happened with UNIT_SPELLCAST_SENT for vehicles
		latency = latency > castbar.max and castbar.max or latency
		castbar.Latency:SetText(("%dms"):format(latency * 1e3))
		castbar.PreciseSafeZone:SetWidth(castbar:GetWidth() * latency / castbar.max)
		castbar.PreciseSafeZone:ClearAllPoints()
		castbar.PreciseSafeZone:SetPoint("TOPLEFT")
		castbar.PreciseSafeZone:SetPoint("BOTTOMLEFT")
		castbar.PreciseSafeZone:SetDrawLayer("OVERLAY")
	end

	if unit ~= "focus" then
		-- Channel layout
		castbar.Text:SetJustifyH("RIGHT")
		castbar.Time:SetJustifyH("RIGHT")
		if cfg.CastbarIcon then castbar.Dummy.Icon:SetTexture(castbar.Icon:GetTexture()) end
	end

	if castbar.Shield:IsShown() and UnitCanAttack("player", unit) then
		castbar.Background:SetBackdropBorderColor(unpack(cfg.colors.castbar.noInterrupt))
	else
		castbar.Background:SetBackdropBorderColor(0, 0, 0)
	end
end

-- Castbar animations
oUF_Hank.PostCastSucceeded = function(castbar, spell)
	-- No animation on instant casts (castbar text not set)
	if castbar.Text:GetText() == spell then
		castbar.Dummy.Fill:SetVertexColor(unpack(cfg.colors.castbar.castSuccess))
		castbar.Dummy:Show()
		castbar.Dummy.anim:Play()
	end
end

oUF_Hank.PostCastStop = function(castbar, unit, spellname, spellrank, castid)
	if not castbar.Dummy.anim:IsPlaying() then
		castbar.Dummy.Fill:SetVertexColor(unpack(cfg.colors.castbar.castFail))
		castbar.Dummy:Show()
		castbar.Dummy.anim:Play()
	end
end

oUF_Hank.PostChannelStop = function(castbar, unit, spellname, spellrank)
	if not spellname then
		castbar.Dummy.Fill:SetVertexColor(unpack(cfg.colors.castbar.castSuccess))
		castbar.Dummy:Show()
		castbar.Dummy.anim:Play()
	else
		castbar.Dummy.Fill:SetVertexColor(unpack(cfg.colors.castbar.castFail))
		castbar.Dummy:Show()
		castbar.Dummy.anim:Play()
	end
end

-- Frame constructor -----------------------------

oUF_Hank.sharedStyle = function(self, unit, isSingle)
	self.menu = oUF_Hank.menu
	self:SetScript("OnEnter", UnitFrame_OnEnter)
	self:SetScript("OnLeave", UnitFrame_OnLeave)
	self:RegisterForClicks("AnyDown")

	self.colors = cfg.colors

	-- HP%
	local health = {}
	local healthFill = {}

	if unit == "player" or unit == "target" or unit == "focus" or unit:find("boss") then
		self:RegisterEvent("UNIT_HEALTH", function(_, _, ...)
			if unit == ... then
				oUF_Hank.UpdateHealth(self)
			elseif unit == "player" and UnitHasVehicleUI("player") and ... == "vehicle" then
				oUF_Hank.UpdateHealth(self)
			end
		end)

		self:RegisterEvent("UNIT_MAXHEALTH", function(_, _, ...)
			if unit == ... then
				oUF_Hank.UpdateHealth(self)
			elseif unit == "player" and UnitHasVehicleUI("player") and ... == "vehicle" then
				oUF_Hank.UpdateHealth(self)
			end
		end)

		-- Health update on unit switch
		-- Thanks @ pelim for this approach
		tinsert(self.__elements, oUF_Hank.UpdateHealth)

		for i = unit:find("boss") and 1 or 3, 1, -1 do
			health[i] = self:CreateTexture(nil, "ARTWORK")
			health[i]:SetTexture("Interface\\AddOns\\oUF_Hank\\textures\\digits.blp")
			health[i]:Hide()
			healthFill[i] = self:CreateTexture(nil, "OVERLAY")
			healthFill[i]:SetTexture("Interface\\AddOns\\oUF_Hank\\textures\\digits.blp")
			healthFill[i]:SetVertexColor(unpack(cfg.colors.text))
			healthFill[i]:Hide()
		end

		if unit == "player" then
			health[3]:SetPoint("RIGHT")
			--health[3]:SetPoint("RIGHT", health[4], "LEFT")
			health[2]:SetPoint("RIGHT", health[3], "LEFT")
			health[1]:SetPoint("RIGHT", health[2], "LEFT")
		elseif unit == "target" or unit == "focus" then
			health[3]:SetPoint("LEFT")
			health[2]:SetPoint("LEFT", health[3], "RIGHT")
			health[1]:SetPoint("LEFT", health[2], "RIGHT")
			--health[1]:SetPoint("LEFT", health[2], "RIGHT")
		elseif unit:find("boss") then
			health[1]:SetPoint("RIGHT")
		end

		if not unit:find("boss") then
			--healthFill[4]:SetPoint("BOTTOM", health[4])
			healthFill[3]:SetPoint("BOTTOM", health[3])
			healthFill[2]:SetPoint("BOTTOM", health[2])
		end
		healthFill[1]:SetPoint("BOTTOM", health[1])

		self.health = health
		self.healthFill = healthFill

		-- Reanchoring handled in UpdateHealth()
	end

	local name, power
	local playerClass = select(2, UnitClass("player"))

	-- Power, threat
	if unit == "player" or unit == "target" or unit == "focus" or unit:find("boss") then
		power = self:CreateFontString(nil, "OVERLAY")
		power:SetFontObject("UFFontMedium")

		if unit == "player" then power:SetPoint("BOTTOMRIGHT", health[3], "BOTTOMLEFT", -5, 0)
		elseif unit == "target" or unit == "focus" then power:SetPoint("BOTTOMLEFT", health[3], "BOTTOMRIGHT", 5, 0)
		elseif unit:find("boss") then power:SetPoint("BOTTOMRIGHT", health[1], "BOTTOMLEFT", -5, 0) end

		if unit == "player" then 
			if playerClass == "DRUID" then
				self:Tag(power, "[apppDetailed]")
			else
				self:Tag(power, "[ppDetailed]")
			end
		elseif unit == "target" or unit == "focus" then self:Tag(power, cfg.ShowThreat and "[hpDetailed] || [ppDetailed] [threatPerc]" or "[hpDetailed] || [ppDetailed]")
		elseif unit:find("boss") then self:Tag(power, cfg.ShowThreat and "[threatBoss] || [perhp]%" or "[perhp]%") end

		self.power = power
	end

	-- Name
	if unit == "target" or unit == "focus" then
		name = self:CreateFontString(nil, "OVERLAY")
		name:SetFontObject("UFFontBig")
		name:SetPoint("BOTTOMLEFT", power, "TOPLEFT")
		self:Tag(name, "[statusName]")
	elseif unit:find("boss") then
		name = self:CreateFontString(nil, "OVERLAY")
		name:SetFontObject("UFFontBig")
		name:SetPoint("BOTTOMRIGHT", power, "TOPRIGHT")
		self:Tag(name, "[statusName]")
	elseif unit == "pet" then
		name = self:CreateFontString(nil, "OVERLAY")
		name:SetFontObject("UFFontSmall")
		name:SetPoint("RIGHT")
		self:Tag(name, "[petName] @[perhp]%")
	elseif unit == "targettarget" or  unit == "targettargettarget" or unit == "focustarget" then
		name = self:CreateFontString(nil, "OVERLAY")
		name:SetFontObject("UFFontSmall")
		name:SetPoint("LEFT")
		if unit == "targettarget" or unit == "focustarget" then self:Tag(name, "\226\128\186  [smartName] @[perhp]")
		elseif unit == "targettargettarget" then self:Tag(name, "\194\187 [smartName] @[perhp]") end
	end

	self.name = name

	-- Status icons
	if unit == "player" then
		-- Remove invalid or duplicate placeholders
		local fixedString = ""

		for placeholder in gmatch(cfg.StatusIcons, "[CRPMAL]") do
			fixedString = fixedString .. (match(fixedString, placeholder) and "" or placeholder)
		end

		cfg.StatusIcons = fixedString

		-- Create the status icons
		for i, icon in ipairs({
			{"C", "CombatIndicator"},
			{"R", "RestingIndicator"},
			{"L", "LeaderIndicator"},
			{"M", "MasterLooterIndicator"},
			{"P", "PvPIndicator"},
			{"A", "AssistantIndicator"},
		}) do
			if match(cfg.StatusIcons, icon[1]) then
				self[icon[2]] = self:CreateTexture(nil, "OVERLAY")
				self[icon[2]]:SetSize(24, 24)
				self[icon[2]]:SetTexture("Interface\\AddOns\\oUF_Hank\\textures\\statusicons.blp")
				self[icon[2]]:SetTexCoord((i - 1) * 24 / 256, i * 24 / 256, 0, 24 / 32)
				self[icon[2]].Override = oUF_Hank.UpdateStatus
			end

		end

		-- Anchoring handled in UpdateStatus()
	end

	-- Raid targets
	if unit == "player" then
		self.RaidTargetIndicator = self:CreateTexture(nil, "OVERLAY")
		self.RaidTargetIndicator:SetSize(40, 40)
		self.RaidTargetIndicator:SetTexture("Interface\\AddOns\\oUF_Hank\\textures\\raidicons.blp")
		self.RaidTargetIndicator:SetPoint("RIGHT", self.power, "LEFT", -15, 0)
		self.RaidTargetIndicator:SetPoint("TOP", self, "TOP", 0, -5)
	elseif unit == "target" or unit == "focus" then
		self.RaidTargetIndicator = self:CreateTexture(nil, "OVERLAY")
		self.RaidTargetIndicator:SetSize(40, 40)
		self.RaidTargetIndicator:SetTexture("Interface\\AddOns\\oUF_Hank\\textures\\raidicons.blp")
		self.RaidTargetIndicator:SetPoint("LEFT", self.name, "RIGHT", 10, 0)
		self.RaidTargetIndicator:SetPoint("TOP", self, "TOP", 0, -5)

		-- Anchoring on name update
		tinsert(self.__elements, oUF_Hank.PostUpdateName)
		self:RegisterEvent("PLAYER_FLAGS_CHANGED", function(_, _, unit)
			if unit == self.unit then
				oUF_Hank.PostUpdateName(unit)
			end
		end)
	elseif unit:find("boss") then
		self.RaidTargetIndicator = self:CreateTexture(nil)
		self.RaidTargetIndicator:SetDrawLayer("OVERLAY", 1)
		self.RaidTargetIndicator:SetSize(24, 24)
		self.RaidTargetIndicator:SetTexture("Interface\\AddOns\\oUF_Hank\\textures\\raidicons.blp")
		self.RaidTargetIndicator:SetPoint("BOTTOMRIGHT", health[1], 5, -5)
	end

	-- XP, reputation
	if unit == "player" and cfg.ShowXP then
		local xprep = self:CreateFontString(nil, "OVERLAY")
		xprep:SetFontObject("UFFontMedium")
		xprep:SetPoint("RIGHT", power, "RIGHT")
		xprep:SetAlpha(0)
		self:Tag(xprep, "[xpRep]")
		self.xprep = xprep

		-- Some animation dummies
		local xprepDummy = self:CreateFontString(nil, "OVERLAY")
		xprepDummy:SetFontObject("UFFontMedium")
		xprepDummy:SetAllPoints(xprep)
		xprepDummy:SetAlpha(0)
		xprepDummy:Hide()
		local powerDummy = self:CreateFontString(nil, "OVERLAY")
		powerDummy:SetFontObject("UFFontMedium")
		powerDummy:SetAllPoints(power)
		powerDummy:Hide()
		local raidIconDummy = self:CreateTexture(nil, "OVERLAY")
		raidIconDummy:SetTexture("Interface\\AddOns\\oUF_Hank\\textures\\raidicons.blp")
		raidIconDummy:SetAllPoints(self.RaidTargetIndicator)
		raidIconDummy:Hide()

		local animXPFadeIn = xprepDummy:CreateAnimationGroup()
		-- A short delay so the user needs to mouseover a short time for the xp/rep display to show up
		local delayXP = animXPFadeIn:CreateAnimation("Alpha")
		delayXP:SetFromAlpha(0)
		delayXP:SetToAlpha(0)
		delayXP:SetDuration(cfg.DelayXP)
		delayXP:SetOrder(1)
		local alphaInXP = animXPFadeIn:CreateAnimation("Alpha")
		alphaInXP:SetFromAlpha(0)
		alphaInXP:SetToAlpha(1)
		alphaInXP:SetSmoothing("OUT")
		alphaInXP:SetDuration(1.5)
		alphaInXP:SetOrder(2)

		local animPowerFadeOut = powerDummy:CreateAnimationGroup()
		local delayPower = animPowerFadeOut:CreateAnimation("Alpha")
		delayPower:SetFromAlpha(1)
		delayPower:SetToAlpha(1)
		delayPower:SetDuration(cfg.DelayXP)
		delayPower:SetOrder(1)
		local alphaOutPower = animPowerFadeOut:CreateAnimation("Alpha")
		alphaOutPower:SetFromAlpha(1)
		alphaOutPower:SetToAlpha(0)
		alphaOutPower:SetSmoothing("OUT")
		alphaOutPower:SetDuration(1.5)
		alphaOutPower:SetOrder(2)

		local animRaidIconFadeOut = raidIconDummy:CreateAnimationGroup()
		local delayIcon = animRaidIconFadeOut:CreateAnimation("Alpha")
		-- TODO confirm this change in raid
		-- delayIcon:SetChange(0)
		delayIcon:SetFromAlpha(1)
		delayIcon:SetToAlpha(1)
		delayIcon:SetDuration(cfg.DelayXP * .75)
		delayIcon:SetOrder(1)
		local alphaOutIcon = animRaidIconFadeOut:CreateAnimation("Alpha")
		-- TODO confirm this change in raid
		-- alphaOutIcon:SetChange(-1)
		alphaOutIcon:SetFromAlpha(1)
		alphaOutIcon:SetToAlpha(0)
		alphaOutIcon:SetSmoothing("OUT")
		alphaOutIcon:SetDuration(0.5)
		alphaOutIcon:SetOrder(2)

		animXPFadeIn:SetScript("OnFinished", function()
			xprep:SetAlpha(1)
			xprepDummy:Hide()
		end)
		animPowerFadeOut:SetScript("OnFinished", function() powerDummy:Hide() end)
		animRaidIconFadeOut:SetScript("OnFinished", function() raidIconDummy:Hide() end)

		self:HookScript("OnEnter", function(_, motion)
			if motion then
				self.power:SetAlpha(0)
				self.RaidTargetIndicator:SetAlpha(0)
				powerDummy:SetText(self.power:GetText())
				powerDummy:Show()
				xprepDummy:SetText(self.xprep:GetText())
				xprepDummy:Show()
				raidIconDummy:SetTexCoord(self.RaidTargetIndicator:GetTexCoord())
				if self.RaidTargetIndicator:IsShown() then raidIconDummy:Show() end
				animXPFadeIn:Play()
				animPowerFadeOut:Play()
				if self.RaidTargetIndicator:IsShown() then animRaidIconFadeOut:Play() end
			end
		end)

		self:HookScript("OnLeave", function()
			if animXPFadeIn:IsPlaying() then animXPFadeIn:Stop() end
			if animPowerFadeOut:IsPlaying() then animPowerFadeOut:Stop() end
			if animRaidIconFadeOut:IsPlaying() then animRaidIconFadeOut:Stop() end
			powerDummy:Hide()
			xprepDummy:Hide()
			raidIconDummy:Hide()
			self.xprep:SetAlpha(0)
			self.power:SetAlpha(1)
			self.RaidTargetIndicator:SetAlpha(1)
		end)
	end

	-- Combo points
	if unit == "player" and (playerClass == "ROGUE" or playerClass == "DRUID") then
		local bg = {}
		local fill = {}
		self.CPoints = {}
		-- MAX_COMBO_POINTS = 6, everything else should be handled by oUF_CPoints
		for i = 1, 6 do
			self.CPoints[i] = CreateFrame("Frame", nil, self)
			self.CPoints[i]:SetSize(16, 16)
			if i > 1 then self.CPoints[i]:SetPoint("LEFT", self.CPoints[i - 1], "RIGHT") end
			bg[i] = self.CPoints[i]:CreateTexture(nil, "ARTWORK")
			bg[i]:SetTexture("Interface\\AddOns\\oUF_Hank\\textures\\combo.blp")
			bg[i]:SetTexCoord(0, 16 / 64, 0, 1)
			bg[i]:SetAllPoints(self.CPoints[i])
			fill[i] = self.CPoints[i]:CreateTexture(nil, "OVERLAY")
			fill[i]:SetTexture("Interface\\AddOns\\oUF_Hank\\textures\\combo.blp")
			fill[i]:SetTexCoord(0.5, 0.75, 0, 1)
			--fill[i]:SetVertexColor(unpack(cfg.colors.power.ENERGY))
			fill[i]:SetVertexColor(1-(i-1)/(6-1),(i-1)/(6-1),0)
			fill[i]:SetAllPoints(self.CPoints[i])
		end
		self.CPoints[1]:SetPoint("TOP", self, "BOTTOM")
		self.CPoints.unit = "player"
	end

	-- Runes
	if unit == "player" and playerClass == "DEATHKNIGHT" then
		---@class PlayerRunes: Frame
		self.Runes = CreateFrame("Frame", nil, self)
		self.Runes:SetPoint("TOPRIGHT", self, "BOTTOMRIGHT")
		self.Runes:SetSize(96, 16)
		self.Runes.anchor = "TOPLEFT"
		self.Runes.growth = "RIGHT"
		self.Runes.height = 16
		self.Runes.width = 16
    	self.Runes.colorSpec = true
   		 self.colors.runes = oUF.colors.runes

		for i = 1, 6 do
      -- TODO why doesn't UnitPowerMax("player", SPELL_POWER_RUNES) return the 
      -- right number on init?
			self.Runes[i] = CreateFrame("StatusBar", nil, self.Runes)
			self.Runes[i]:SetStatusBarTexture("Interface\\AddOns\\oUF_Hank\\textures\\blank.blp")
			self.Runes[i]:SetSize(16, 16)

			if i == 1 then
				self.Runes[i]:SetPoint("TOPLEFT", self.Runes, "TOPLEFT")
			else
				self.Runes[i]:SetPoint("LEFT", self.Runes[i - 1], "RIGHT")
			end

			local backdrop = self.Runes[i]:CreateTexture(nil, "ARTWORK")
			backdrop:SetSize(16, 16)
			backdrop:SetAllPoints()
			backdrop:SetTexture("Interface\\AddOns\\oUF_Hank\\textures\\combo.blp")
			backdrop:SetTexCoord(0, 16 / 64, 0, 1)

			-- This is actually the fill layer, but "bg" gets automatically vertex-colored by the runebar module. So let's make use of that!
			self.Runes[i].bg = self.Runes[i]:CreateTexture(nil, "OVERLAY")
			self.Runes[i].bg:SetSize(16, 16)
			self.Runes[i].bg:SetPoint("BOTTOM")
			self.Runes[i].bg:SetTexture("Interface\\AddOns\\oUF_Hank\\textures\\combo.blp")
			self.Runes[i].bg:SetTexCoord(0.5, 0.75, 0, 1)

			-- Shine effect
			local shinywheee = CreateFrame("Frame", nil, self.Runes[i])
			shinywheee:SetAllPoints()
			shinywheee:SetAlpha(0)
			shinywheee:Hide()

			local shine = shinywheee:CreateTexture(nil, "OVERLAY")
			shine:SetAllPoints()
			shine:SetPoint("CENTER")
			shine:SetTexture("Interface\\Cooldown\\star4.blp")
			shine:SetBlendMode("ADD")

			local anim = shinywheee:CreateAnimationGroup()
			local alphaIn = anim:CreateAnimation("Alpha")
			-- alphaIn:SetChange(0.3)
			alphaIn:SetDuration(0.4)
			alphaIn:SetOrder(1)
			local rotateIn = anim:CreateAnimation("Rotation")
			rotateIn:SetDegrees(-90)
			rotateIn:SetDuration(0.4)
			rotateIn:SetOrder(1)
			local scaleIn = anim:CreateAnimation("Scale")
			scaleIn:SetScale(2, 2)
			scaleIn:SetOrigin("CENTER", 0, 0)
			scaleIn:SetDuration(0.4)
			scaleIn:SetOrder(1)
			local alphaOut = anim:CreateAnimation("Alpha")
			-- alphaOut:SetChange(-0.5)
			alphaOut:SetDuration(0.4)
			alphaOut:SetOrder(2)
			local rotateOut = anim:CreateAnimation("Rotation")
			rotateOut:SetDegrees(-90)
			rotateOut:SetDuration(0.3)
			rotateOut:SetOrder(2)
			local scaleOut = anim:CreateAnimation("Scale")
			scaleOut:SetScale(-2, -2)
			scaleOut:SetOrigin("CENTER", 0, 0)
			scaleOut:SetDuration(0.4)
			scaleOut:SetOrder(2)

			anim:SetScript("OnFinished", function() shinywheee:Hide() end)
			shinywheee:SetScript("OnShow", function() anim:Play() end)

			self.Runes[i]:SetScript("OnValueChanged", function(self, val)
				local start, duration, runeReady = GetRuneCooldown(i)
				if runeReady then
					self.last = 0
					-- Rune ready: show all 16x16px, play animation
					self.bg:SetSize(16, 16)
					self.bg:SetTexCoord(0.5, 0.75, 0, 1)
					shinywheee:Show()
				else
					-- Dot distance from top & bottom of texture: 4px
					self.bg:SetSize(16, 4 + 8 * val / 10)
					-- Show at least the empty 4 bottom pixels + val% of the 8 pixels of the actual dot = 12px max
					self.bg:SetTexCoord(0.25, 0.5, 12 / 16 - 8 * val / 10 / 16, 1)
				end
			end)
		end

	self.Runes.PostUpdate = function(self, runemap)
			for index, runeID in next, runemap do
				local rune = self[index]
				if(not rune) then break end

				local start, duration, runeReady = GetRuneCooldown(runeID)
				if not runeReady then
					local val = GetTime() - start
					-- Dot distance from top & bottom of texture: 4px
					rune.bg:SetSize(16, 4 + 8 * val / 10)
					-- Show at least the empty 4 bottom pixels + val% of the 8 pixels of the actual dot = 12px max
					rune.bg:SetTexCoord(0.25, 0.5, 12 / 16 - 8 * val / 10 / 16, 1)
				end
			end
		end
    --[[
		self.Runes.PostUpdate = function(self, rune, rid, start, duration, runeReady)
			if not runeReady then
				local val = GetTime() - start
				-- Dot distance from top & bottom of texture: 4px
				rune.bg:SetSize(16, 4 + 8 * val / 10)
				-- Show at least the empty 4 bottom pixels + val% of the 8 pixels of the actual dot = 12px max
				rune.bg:SetTexCoord(0.25, 0.5, 12 / 16 - 8 * val / 10 / 16, 1)
			end
		end
  ]]
	end

	local initClassIconAnimation, updateClassIconAnimation
	local initClassPower, initClassSingleIcon
	-- animation: fade in
	if unit == "player" and (playerClass == "MONK" or playerClass == "PALADIN" or playerClass == "WARLOCK" or playerClass == "EVOKER") then
		initClassIconAnimation = function(unitFrame, i)
			unitFrame.ClassPower.animations[i] = unitFrame.ClassPower[i]:CreateAnimationGroup()
			local alphaIn = unitFrame.ClassPower.animations[i]:CreateAnimation("Alpha")
			-- alphaIn:SetChange(1)
			alphaIn:SetFromAlpha(0)
			alphaIn:SetToAlpha(1)
			alphaIn:SetSmoothing("OUT")
			alphaIn:SetDuration(1)
			alphaIn:SetOrder(1)

			unitFrame.ClassPower.animations[i]:SetScript("OnFinished", function() unitFrame.ClassPower[i]:SetAlpha(1) end)
		end
		updateClassIconAnimation = function(unitFrame, current, max)
			if true then return end
			-- bail if we don't have ClassPower to animate
			if current == nil then return end

			unitFrame.ClassPower.animLastState = unitFrame.ClassPower.animLastState or 0
			if current > 0 then
				-- pretend this is still an int
				local current_floor = math.floor(current)
				if unitFrame.ClassPower.animLastState < current then
					-- Play animation only when we gain power
					unitFrame.ClassPower[current_floor]:SetAlpha(0)
					--print("Playing " .. current)
					unitFrame.ClassPower.animations[current_floor]:Play();
				end
			else
				for i = 1, max do
					-- no holy power, stop all running animations
					unitFrame.ClassPower.animLastState = current
					if unitFrame.ClassPower.animations[i]:IsPlaying() then
						unitFrame.ClassPower.animations[i]:Stop()
					end
				end
			end
			unitFrame.ClassPower.animLastState = current
		end
	end

	-- Totems (requires oUF_TotemBar)
	local showTotemBar = playerClass == "SHAMAN" and IsAddOnLoaded("oUF_TotemBar") and cfg.TotemBar
	if unit == "player" and showTotemBar then
		initClassPower = function(unitFrame)
			---@class PlayerTotemBar: Frame
			unitFrame.TotemBar = CreateFrame("Frame", "oUFHank_TotemBar", unitFrame)
			unitFrame.TotemBar.Destroy = cfg.ClickToDestroy
			unitFrame.TotemBar.delay = 0.3
			unitFrame.TotemBar.colors = cfg.colors.totems
		end
		updateClassIconAnimation = function(self, val, ...)
			if val == 0 then
				-- Totem expired
				self.glow:SetVertexColor(self:GetStatusBarColor())
				self.glowend:SetVertexColor(self:GetStatusBarColor())
				self.fill:Hide()
				self.glowywheee:Show()
			else
				self.fill:SetSize(23, 4 + 12 * val / 1)
				self.fill:SetTexCoord((1 + 23) / 128, ((23 * 2) + 1) / 128, 16 / 32 - 12 * val / 32, 20 / 32)
				-- 2DO: This eats performance!!
				self.fill:SetVertexColor(self:GetStatusBarColor())
				if self.glowywheee:IsVisible() then
					self.glowywheee:Hide()
					self.glowend:Hide()
				end
				if not self.fill:IsVisible() then self.fill:Show() end
			end
		end
		initClassSingleIcon = function(unitFrame, i, icon)
			local data = oUF_Hank.classResources[playerClass]

			-- DO NOT WANT! ;p
			icon:SetStatusBarTexture(data['inactive'][1])
			icon.backdrop:SetTexture(data['active'][1])
			icon.bg = icon:CreateTexture(nil)

			local fill = icon:CreateTexture(nil, "OVERLAY")
			fill:SetSize(data.size[1], data.size[2])
			fill:SetPoint("BOTTOM")
			fill:SetTexture(data['active'][1])
			if data['active'][2] then
				fill:SetTexCoord(unpack(data['active'][2]))
			else
				fill:SetTexCoord(0, 1, 0, 1)
			end
			icon.fill = fill

			-- Fill the totems
			unitFrame.TotemBar[i]:SetScript("OnValueChanged", updateClassIconAnimation)
		end
		initClassIconAnimation = function(unitFrame, i, icon)
			local data = oUF_Hank.classResources[playerClass]

			local glowywheee = CreateFrame("Frame", nil, icon)
			glowywheee:SetAllPoints()
			glowywheee:SetAlpha(0)
			glowywheee:Hide()
			icon.glowywheee = glowywheee

			local glow = glowywheee:CreateTexture(nil, "OVERLAY")
			glow:SetAllPoints()
			glow:SetPoint("CENTER")
			glow:SetTexture(data['active'][1])
			glow:SetTexCoord((2 + 2 * 23) / 128, ((23 * 3) + 2) / 128, 0, 20 / 32)
			icon.glow = glow

			local glowend = icon:CreateTexture(nil, "OVERLAY")
			glowend:SetAllPoints()
			glowend:SetTexture(data['active'][1])
			glowend:SetTexCoord((2 + 2 * 23) / 128, ((23 * 3) + 2) / 128, 0, 20 / 32)
			glowend:SetAlpha(0.5)
			glowend:Hide()
			icon.glowend = glowend

			local anim = glowywheee:CreateAnimationGroup()
			local alphaIn = anim:CreateAnimation("Alpha")
			-- alphaIn:SetChange(0.5)
			alphaIn:SetSmoothing("OUT")
			alphaIn:SetDuration(1.5)
			alphaIn:SetOrder(1)

			glowywheee:SetScript("OnShow", function()
				glowend:Hide()
				anim:Play()
			end)

			anim:SetScript("OnFinished", function()
				glowend:Show()
				glowend:SetAlpha(0.5)
			end)
		end
	end

	-- Holy power
	if unit == "player" and playerClass == "PALADIN" then
		initClassPower = function(unitFrame)
			unitFrame.ClassPower.animLastState = UnitPower("player", SPELL_POWER_HOLY_POWER)
		end
		initClassSingleIcon = function(unitFrame, i)
			unitFrame.ClassPower[i]:SetVertexColor(unpack(cfg.colors.power.HOLY_POWER))
		end
	end

	-- StatusBarIcons: Totems / Soul Shards / Burning Embers / Demonic Fury
	if unit == "player" and showTotemBar  then
		local data = oUF_Hank.classResources[playerClass]
		local displayType = "TotemBar"

		if initClassPower then
			initClassPower(self)
		end

		for i = 1, oUF_Hank.classResources[playerClass].max do
			---@class PlayerClassResourceIcon: StatusBar
			local icon = CreateFrame("StatusBar", nil, self)
			icon:SetSize(data.size[1], data.size[2])
			icon:SetStatusBarTexture(data['active'][1])
			icon:SetOrientation("VERTICAL")

			local backdrop = icon:CreateTexture(nil, "BACKGROUND")
			backdrop:SetAllPoints()
			backdrop:SetTexture(data['inactive'][1])
			if data['inactive'][2] then
				backdrop:SetTexCoord(unpack(data['inactive'][2]))
			else
				backdrop:SetTexCoord(0, 1, 0, 1)
			end
			icon.backdrop = backdrop

			if i == 1 then
				icon:SetPoint(data.inverse and "TOPRIGHT" or "TOPLEFT", self, "BOTTOMRIGHT", data.offset or -90, 0)
			else
				icon:SetPoint(data.inverse and "RIGHT" or "LEFT", self[displayType][i - 1], data.inverse and "LEFT" or "RIGHT", data.spacing or 0,
					0)
			end

			self[displayType][i] = icon

			if initClassSingleIcon then
				initClassSingleIcon(self, i, icon)
			end
			if initClassIconAnimation then
				initClassIconAnimation(self, i, icon)
			end
		end
	-- ClassPower: Harmony Orbs / Holy Power / Warlock Shards
	elseif unit == "player" and (playerClass == "MONK" or playerClass == "PALADIN" or playerClass == "WARLOCK" or playerClass == "EVOKER") then
		local data = oUF_Hank.classResources[playerClass]
		local bg = {}
		self.ClassPower = {}
		self.ClassPower.animations = {}

		if initClassPower then
			initClassPower(self)
		end

		for i = 1, oUF_Hank.classResources[playerClass].max do
			bg[i] = CreateFrame("Frame", nil, self)
			bg[i]:SetSize(data.size[1] or 28, data.size[2] or 28)

			bg[i].tex = bg[i]:CreateTexture(nil, "ARTWORK")
			bg[i].tex:SetTexture(data['inactive'][1])
			if data['inactive'][2] then
				bg[i].tex:SetTexCoord(unpack(data['inactive'][2]))
			else
				bg[i].tex:SetTexCoord(0, 1, 0, 1)
			end
			bg[i].tex:SetAllPoints(bg[i])

			if i == 1 then
				bg[i]:SetPoint("TOPRIGHT", self, "BOTTOMRIGHT", data.offset or -78, 0)
				bg[i].hank_placement = { "TOPRIGHT", self, "BOTTOMRIGHT", data.offset or -78, 0 }
			else
				bg[i]:SetPoint(
					data.inverse and "RIGHT" or "LEFT",
					bg[i - 1],
					data.inverse and "LEFT" or "RIGHT",
					data.spacing or 0,
					0
				)
				bg[i].hank_placement = {
					data.inverse and "RIGHT" or "LEFT",
					bg[i - 1],
					data.inverse and "LEFT" or "RIGHT",
					data.spacing or 0,
					0
				}
			end

			self.ClassPower[i] = bg[i]:CreateTexture(nil, "OVERLAY")
			self.ClassPower[i]:SetTexture(data['active'][1])
			if data['active'][2] then
				self.ClassPower[i]:SetTexCoord(unpack(data['active'][2]))
			else
				self.ClassPower[i]:SetTexCoord(0, 1, 0, 1)
			end
			self.ClassPower[i]:SetAllPoints(bg[i])

			-- need access to the background in the PostUpdate function
			self.ClassPower[i].bg = bg[i].tex

			-- start hidden
			self.ClassPower[i]:Hide()
			self.ClassPower[i].bg:Hide()

			-- we don't use a statusbar for monk/pala/wl, so
			-- remove the update function
			self.ClassPower.UpdateColor = function()
			end
			self.ClassPower[i].SetValue = function()
			end

			if initClassSingleIcon then
				initClassSingleIcon(self, i)
			end
			if initClassIconAnimation then
				initClassIconAnimation(self, i)
			end
		end

		self.ClassPower.PostUpdate = function(_, current, max, changed, powerType, event)
			local hide = false

			for i = 1, oUF_Hank.classResources[playerClass].max do
				if hide or max == nil or i > max then
					self.ClassPower[i]:Hide()
					self.ClassPower[i].bg:Hide()
				else
					self.ClassPower[i].bg:Show()
				end
			end
			if updateClassIconAnimation then
				updateClassIconAnimation(self, current, max)
			end
		end
	end

	-- Auras
	if unit == "target" or unit == "focus" or (cfg.PlayerBuffs and unit == "player") then
		local offset = 0
		local relative
		-- Buffs
		---@class UnitFrameBuffs: Frame
		self.Buffs = CreateFrame("Frame", unit .. "_Buffs", self) -- ButtonFace needs a name
		if unit == "player" then
			if self.CPoints then
				relative = self.CPoints[1]
			elseif self.Runes then
				relative = self.Runes
			elseif self.ClassPower then
				relative = self.ClassPower[1]
			else
				relative = self
				offset = 40
			end
			self.Buffs:SetPoint("TOPLEFT", relative, "BOTTOMLEFT", offset, -5)
		else
			relative = self
			self.Buffs:SetPoint("TOPLEFT", self, "BOTTOMLEFT", offset, -5)
		end
		self.Buffs:SetHeight(cfg.BuffSize)
		self.Buffs:SetWidth(225)
		self.Buffs.size = cfg.BuffSize
		self.Buffs.spacing = cfg.AuraSpacing
		self.Buffs.initialAnchor = "LEFT"
		self.Buffs["growth-y"] = "DOWN"
		self.Buffs.num = cfg["Auras" .. upper(unit)].MaxBuffs
		self.Buffs.filter = "HELPFUL" -- Explicitly set the filter or the first customFilter call won't work

		-- Debuffs
		---@class UnitFrameDebuffs: Frame
		self.Debuffs = CreateFrame("Frame", unit .. "_Debuffs", self)
		self.Debuffs:SetPoint("TOPLEFT", self.Buffs, "BOTTOMLEFT", 0, -cfg.AuraSpacing)
		self.Debuffs:SetHeight(cfg.DebuffSize)
		self.Debuffs:SetWidth(225)
		self.Debuffs.size = cfg.DebuffSize
		self.Debuffs.spacing = cfg.AuraSpacing
		self.Debuffs.initialAnchor = "LEFT"
		self.Debuffs["growth-y"] = "DOWN"
		self.Debuffs.num = cfg["Auras" .. upper(unit)].MaxDebuffs
		self.Debuffs.filter = "HARMFUL"

		-- Buff magnification effect on mouseover
		---@class UnitFrameHightlightAura: Frame
		self.HighlightAura = CreateFrame("Frame", nil, self)
		self.HighlightAura:SetFrameLevel(5) -- Above auras (level 3) and their cooldown overlay (4)
		--self.HighlightAura:SetBackdrop()--{bgFile = cfg.AuraBorder})
		--self.HighlightAura:SetBackdropColor(0, 0, 0, 1)
		self.HighlightAura.icon = self.HighlightAura:CreateTexture(nil, "ARTWORK")
		self.HighlightAura.icon:SetPoint("CENTER")
		self.HighlightAura.border = self.HighlightAura:CreateTexture(nil, "OVERLAY")
		self.HighlightAura.border:SetTexture(cfg.AuraBorder)
		self.HighlightAura.border:SetPoint("CENTER")

		self.Buffs.PostUpdateButton = oUF_Hank.PostUpdateButton
		self.Debuffs.PostUpdateButton = oUF_Hank.PostUpdateButton
		self.Buffs.PostCreateButton = oUF_Hank.PostCreateButton
		self.Debuffs.PostCreateButton = oUF_Hank.PostCreateButton
		self.Buffs.PostUpdate = oUF_Hank.BuffsPostUpdate
		self.Buffs.FilterAura = oUF_Hank.FilterAura
		self.Debuffs.FilterAura = oUF_Hank.FilterAura
	end

	-- Support for oUF_SpellRange. The built-in oUF range check sucks :/
	if (unit == "target" or unit == "focus") and cfg.RangeFade and IsAddOnLoaded("oUF_SpellRange") then
		self.SpellRange = {
			insideAlpha = 1,
			outsideAlpha = cfg.RangeFadeOpacity
		}
	end

	-- Initial size
	if unit == "player" then
		self:SetSize(175, 50)
	elseif  unit == "target" or unit == "focus" then
		self:SetSize(250, 50)
	elseif unit== "pet" or unit == "targettarget" or unit == "targettargettarget" or unit == "focustarget" then
		self:SetSize(125, 16)
	elseif unit:find("boss") then
		self:SetSize(250, 50)
	end

end

-- custom modifications hooks --------------------------

local modList

for modName, modHooks in pairs(oUF_Hank_hooks) do

	local modErr = false
	local numHooks = 0

	for k, v in pairs(modHooks) do
		numHooks = numHooks + 1
		local success, ret = pcall(hooksecurefunc, oUF_Hank, k, v)
		if not success then
			modErr = true
			DEFAULT_CHAT_FRAME:AddMessage("oUF_Hank: Couldn't create hook for function " .. k .. "() in |cFFFF5033" .. modName .. "|r: \"" .. ret .. "\"", cfg.colors.text[1], cfg.colors.text[2], cfg.colors.text[3])
		end
	end

	if numHooks > 0 then
		if not modErr then
			modList = (modList or "") .. "|cFFFFFFFF" .. modName .. "|r, "
		else
			modList = (modList or "") .. "|cFFFF5033" .. modName .. " (see errors)|r, "
		end
	end

end

if modList then
	--DEFAULT_CHAT_FRAME:AddMessage("oUF_Hank: Applied custom modifications: " .. strsub(modList, 1, -3), cfg.colors.text[1], cfg.colors.text[2], cfg.colors.text[3])
	modList = nil
end

-- Frame creation --------------------------------
oUF:RegisterStyle("Hank", oUF_Hank.sharedStyle)
oUF:SetActiveStyle("Hank")
S.unitFrames.player = oUF:Spawn("player", "oUF_player")
S.unitFrames.player:SetPoint("RIGHT", UIParent, "CENTER", -cfg.FrameMargin[1], -cfg.FrameMargin[2])
S.unitFrames.pet = oUF:Spawn("pet", "oUF_pet")
S.unitFrames.pet:SetPoint("BOTTOMRIGHT", oUF_player, "TOPRIGHT")
S.unitFrames.target = oUF:Spawn("target", "oUF_target")
S.unitFrames.target:SetPoint("LEFT", UIParent, "CENTER", cfg.FrameMargin[1], -cfg.FrameMargin[2])
S.unitFrames.targettarget = oUF:Spawn("targettarget", "oUF_ToT")
S.unitFrames.targettarget:SetPoint("BOTTOMLEFT", oUF_target, "TOPLEFT")
S.unitFrames.targettargettarget = oUF:Spawn("targettargettarget", "oUF_ToTT")
S.unitFrames.targettargettarget:SetPoint("BOTTOMLEFT", oUF_ToT, "TOPLEFT")
S.unitFrames.focus = oUF:Spawn("focus", "oUF_focus")
S.unitFrames.focus:SetPoint("CENTER", UIParent, "CENTER", -cfg.FocusFrameMargin[1], -cfg.FocusFrameMargin[2])
S.unitFrames.focustarget = oUF:Spawn("focustarget", "oUF_ToF")
S.unitFrames.focustarget:SetPoint("BOTTOMLEFT", oUF_focus, "TOPLEFT", 0, 5)

oUF_player:SetScale(cfg.FrameScale)
oUF_pet:SetScale(cfg.FrameScale)
oUF_target:SetScale(cfg.FrameScale)
oUF_ToT:SetScale(cfg.FrameScale)
oUF_ToTT:SetScale(cfg.FrameScale)
oUF_focus:SetScale(cfg.FrameScale * cfg.FocusFrameScale)
if cfg.FocusFrameScale <= 0.7 then
	oUF_ToF:SetScale(cfg.FrameScale * cfg.FocusFrameScale * 1.25)
else
	oUF_ToF:SetScale(cfg.FrameScale * cfg.FocusFrameScale)
end

if cfg.RangeFade and not IsAddOnLoaded("oUF_SpellRange") then
	DEFAULT_CHAT_FRAME:AddMessage("oUF_Hank: Please download and install oUF_SpellRange before enabling range checks!", cfg.colors.text[1], cfg.colors.text[2], cfg.colors.text[3])
elseif cfg.TotemBar and not IsAddOnLoaded("oUF_TotemBar") then
	DEFAULT_CHAT_FRAME:AddMessage("oUF_Hank: Please download and install oUF_TotemBar before enabling the totem bar!", cfg.colors.text[1], cfg.colors.text[2], cfg.colors.text[3])
end
