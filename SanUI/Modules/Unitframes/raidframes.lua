-- File originally written by Tukz of Tukui (see general SanUI credits). Lots of changes
-- by me, so never bug Tukz about any problem with this, please.
--if true then return end
local _, addon = ...
local S,C = unpack(addon)

local oUF = addon.oUF
local reaction_colors = oUF.colors.reaction

local Scale = S.Scale
local scales = C.sizes.scales
local rfsizes = C.sizes.raidframes

--local font2 = C["Medias"].UnitFrameFont
local font1 = C["medias"].fonts.Font
local font2 = font1
local normTex = C["medias"].textures.StatusbarNormal

-- disable blizzard party and raid frames
--InterfaceOptionsFrameCategoriesButton11:SetScale(0.00001)
--InterfaceOptionsFrameCategoriesButton11:SetAlpha(0)

-- TODO: Replace with atlases in the next major
local READY_CHECK_READY_TEXTURE = "Interface\\RaidFrame\\ReadyCheck-Ready"
local READY_CHECK_NOT_READY_TEXTURE = "Interface\\RaidFrame\\ReadyCheck-NotReady"
local READY_CHECK_WAITING_TEXTURE = "Interface\\RaidFrame\\ReadyCheck-Waiting"

local utf8sub = function(string, i, dots)
	if not string then return end
	local bytes = #string
	if (bytes <= i) then
		return string
	else
		local len, pos = 0, 1
		while(pos <= bytes) do
			len = len + 1
			local c = string:byte(pos)
			if (c > 0 and c <= 127) then
				pos = pos + 1
			elseif (c >= 192 and c <= 223) then
				pos = pos + 2
			elseif (c >= 224 and c <= 239) then
				pos = pos + 3
			elseif (c >= 240 and c <= 247) then
				pos = pos + 4
			end
			if (len == i) then break end
		end

		if (len == i and pos <= bytes) then
			return string:sub(1, pos - 1)..(dots and '...' or '')
		else
			return string
		end
	end
end

oUF.Tags.Events["enhdead"] = "UNIT_HEALTH UNIT_CONNECTION PLAYER_FLAGS_CHANGED"
oUF.Tags.Methods["enhdead"] = function(u)
	if(UnitIsDead(u)) then
		return 'Dead'
	elseif(UnitIsGhost(u)) then
		return 'Ghost'
	elseif(not UnitIsConnected(u)) then
		return 'Off'
	end
end

--need to override this function because we don't have self.Health.value for 
--raid units anymore
S.PostUpdateHealthRaid = function(health, unit, min, max)
	-- doing this here to force friendly unit (vehicle or pet) very far away from you to update color correcly
	-- because if vehicle or pet is too far away, unitreaction return nil and color of health bar is white.
	if not UnitIsPlayer(unit) and UnitIsFriend(unit, "player") and C["UnitFrames"].unicolor ~= true then
		local c = reaction_colors[5]
		local r, g, b = c[1], c[2], c[3]
		health:SetStatusBarColor(r, g, b)
		health.bg:SetTexture(.1, .1, .1)
	end

end

oUF.Tags.Events['getnamecolor'] = 'UNIT_POWER_UPDATE'
oUF.Tags.Methods['getnamecolor'] = function(unit)
	if (UnitIsPlayer(unit)) then
		return _TAGS['raidcolor'](unit)
	else
		local reaction = UnitReaction(unit, 'player')

		if (reaction) then
			local c = reaction_colors[reaction]
			return string.format('|cff%02x%02x%02x', c[1] * 255, c[2] * 255, c[3] * 255)
		else
			local r, g, b = .84,.75,.65
			return string.format('|cff%02x%02x%02x', r * 255, g * 255, b * 255)
		end
	end
end

oUF.Tags.Events['nameshort'] = 'UNIT_NAME_UPDATE PARTY_LEADER_CHANGED GROUP_ROSTER_UPDATE'
oUF.Tags.Methods['nameshort'] = function(unit)
	local name = UnitName(unit)

	if not name then
		return ""
	end

	return utf8sub(name, 10, false)
end

local updateThreat = function(self, event, unit)
	if (self.unit ~= unit) then return end

	local threat = UnitThreatSituation(unit)

	if threat and threat > 1 then
		self.Health:SetStatusBarColor(.4, .2, .2)
		self.SetBackdropColor({.2, 0, 0})

		local fontName, fontHeight, fontFlags = self.Name:GetFont()
		self.Name:SetFont(fontName,fontHeight,"OUTLINE")
	else

		self.SetBackdropColor({0, 0, 0, 1})
		self.Health:SetStatusBarColor(unpack(C.colors.Healthbar))

		local fontName, fontHeight, fontFlags = self.Name:GetFont()
		self.Name:SetFont(fontName,fontHeight,"")
	end

end

local function Shared(self, unit)
	self:SetAlpha(0.5)
	self.colors = S.UnitColor
	self:RegisterForClicks("AnyUp")
	self:SetScript("OnEnter", UnitFrame_OnEnter)
	self:SetScript("OnLeave", UnitFrame_OnLeave)

	---@class SanUIRaidFramesHealth: StatusBar
	local health = CreateFrame("StatusBar", nil, self)
	--health:SetAllPoints()
	health:SetPoint("TOPLEFT",S.scale1,-S.scale1)
	health:SetPoint("BOTTOMRIGHT",-S.scale1,S.scale1)

	health:SetStatusBarTexture(normTex)
	health:SetFrameLevel(8)
	health:SetStatusBarColor(unpack(C.colors.Healthbar))
	health:SetOrientation("VERTICAL")
	S.CreateBackdrop(self)

	self.SetBackdropColor(C.colors.Healthbarbackdrop)
	self.Health = health

	health.colorDisconnected = false
	health.colorClass = false
	health.colorTapping = false
	health.colorClassNPC = false
	health.colorClassPet = false
	health.colorReaction = false
	health.colorSmooth = false
	health.colorHealth = false
	health.Smooth = true

	table.insert(self.__elements, updateThreat)
	self:RegisterEvent("PLAYER_TARGET_CHANGED", updateThreat, true)
	self:RegisterEvent("UNIT_THREAT_LIST_UPDATE", updateThreat)
	self:RegisterEvent("UNIT_THREAT_SITUATION_UPDATE", updateThreat)

	self:RegisterEvent("PLAYER_TARGET_CHANGED", function(self,event,unit)
			if UnitIsUnit("target", self.unit) then
				self.SetBackdropBorderColor({1,1,1})
			else
				self.SetBackdropBorderColor(C.colors.BorderColor)
			end
		end)

	local name = health:CreateFontString(nil, "OVERLAY")
	name:SetPoint("BOTTOMRIGHT", health,"BOTTOMRIGHT", -1, 0)
	name:SetFont(font1, rfsizes.name)
	self:Tag(name, "[getnamecolor][nameshort]")
	self.Name = name

	local Dead = health:CreateFontString(nil, "OVERLAY")
	Dead:SetPoint("TOPRIGHT",health,"TOPRIGHT",-1,0)
	Dead:SetFont(font1, 11)
	self:Tag(Dead, "[status]")
	self.Dead = Dead

	local RaidIcon = health:CreateTexture(nil, "OVERLAY")
	RaidIcon:SetHeight(rfsizes.raidicon)
	RaidIcon:SetWidth(rfsizes.raidicon)
	RaidIcon:SetPoint("CENTER", self, "TOP",-scales[12],-scales[2])
	RaidIcon:SetTexture("Interface\\AddOns\\Tukui\\medias\\textures\\Others\\RaidIcons.blp")
	RaidIcon.SetTexture = S.dummy -- idk why but RaidIcon:GetTexture() is returning nil in oUF, resetting icons to default ... stop it!
	self.RaidTargetIndicator  = RaidIcon
	RaidIcon:Hide() -- not sure if necessary, seems so from MOTHER's rooms

	---@class SanUIRaidFramesReadyCheck: Texture
	local ReadyCheck = health:CreateTexture(nil, "OVERLAY")
	ReadyCheck:SetHeight(rfsizes.readycheck)
	ReadyCheck:SetWidth(rfsizes.readycheck)
	ReadyCheck:SetPoint("CENTER",self.Health,"TOP")
	ReadyCheck.readyTexture = READY_CHECK_READY_TEXTURE
	ReadyCheck.notReadyTexture = READY_CHECK_NOT_READY_TEXTURE
	ReadyCheck.waitingTexture = READY_CHECK_WAITING_TEXTURE

	self.ReadyCheckIndicator = ReadyCheck

	local ResurrectIcon = health:CreateTexture(nil, "HIGHLIGHT", nil, 7)
	ResurrectIcon:SetSize(rfsizes.resurrecticon, rfsizes.resurrecticon)
	--ResurrectIcon:SetPoint("CENTER")
	ResurrectIcon:SetPoint("BOTTOMRIGHT",self.Health,"BOTTOMRIGHT",scales[4],-scales[4])
	ResurrectIcon:SetDrawLayer("OVERLAY", 7)
	self.ResurrectIndicator = ResurrectIcon

	local SummonIndicator = health:CreateTexture(nil, "HIGHLIGHT", nil, 7)
	SummonIndicator:SetSize(rfsizes.summonindicator, rfsizes.summonindicator)
	SummonIndicator:SetPoint("BOTTOMRIGHT",self.Health,"BOTTOMRIGHT",scales[4],-scales[4])
	SummonIndicator:SetDrawLayer("OVERLAY", 7)
	self.SummonIndicator = SummonIndicator

	local range = {insideAlpha = 1, outsideAlpha = C.colors.RangeAlpha}
	range.PostUpdate = function(self, object, inRange, checkedRange, connected)
		if not connected then
			object:SetAlpha(self.outsideAlpha)
		end
		ResurrectIcon:SetAlpha(self.insideAlpha)
	end
	self.Range = range

	local mhpb = CreateFrame("StatusBar", nil, health)
	mhpb:SetOrientation("VERTICAL")
	mhpb:SetPoint("BOTTOM", self.Health:GetStatusBarTexture(), "TOP", 0, 0)
	mhpb:SetWidth(rfsizes.width)
	mhpb:SetHeight(rfsizes.height)
	mhpb:SetStatusBarTexture(normTex)
	mhpb:SetStatusBarColor(0, 0.5, 0.15, 1)

	local ohpb = CreateFrame("StatusBar", nil, health)
	ohpb:SetOrientation("VERTICAL")
	ohpb:SetPoint("BOTTOM", self.Health:GetStatusBarTexture(), "TOP", 0, 0)
	ohpb:SetWidth(rfsizes.width)
	ohpb:SetHeight(rfsizes.height)
	ohpb:SetStatusBarTexture(normTex)
	ohpb:SetStatusBarColor(0, 0.5, 0, 1)

	local absb = CreateFrame("StatusBar", nil, health)
	absb:SetOrientation("VERTICAL")
	absb:SetPoint("BOTTOM", self.Health:GetStatusBarTexture(), "TOP", 0, 0)
	absb:SetWidth(rfsizes.width)
	absb:SetHeight(rfsizes.height)
	absb:SetStatusBarTexture(normTex)
	absb:SetStatusBarColor(0.5, 0.5, 0, 1)

	self.HealthPrediction = {
		myBar = mhpb,
		otherBar = ohpb,
		absorbBar = absb,
		maxOverflow = 1,
	}

	self.Name:SetParent(absb)

	---@class SanUIRaidFramesAuras: Frame
	local auras = CreateFrame("Frame", nil, self)
	auras:SetPoint("TOPLEFT", health, scales[2], -scales[2])
	auras:SetPoint("BOTTOMRIGHT", health, -scales[2], scales[2])
	auras:SetFrameLevel(self.Health:GetFrameLevel()+2)
	auras.Icons = {}
	auras.Texts = {}

	for _, spell in pairs(S["UnitFrames"].RaidBuffsTracking[S.MyClass] or {}) do
		---@class SanUIRaidFramesAurasIcon: Frame
		local icon = CreateFrame("Frame", nil, auras)
		spell.pos[2] = auras
		icon:SetPoint(unpack(spell.pos))
		icon.spellId = spell.spellId
		icon.anyCaster = spell.anyCaster
		icon.timers = spell.timers
		icon.cooldownAnim = spell.cooldownAnim
		icon.noCooldownCount = true -- needed for tullaCC to not show cooldown numbers
		icon:SetWidth(rfsizes.notauratrackicon)
		icon:SetHeight(rfsizes.notauratrackicon)

		if icon.cooldownAnim then
			---@class SanUIRaidFramesAurasIconCD: Cooldown
			local cd = CreateFrame("Cooldown", nil, icon,"CooldownFrameTemplate")
			cd:SetAllPoints(icon)
			cd.noCooldownCount = icon.noCooldownCount or false -- needed for tullaCC to not show cooldown numbers
			cd:SetReverse(true)
			icon.cd = cd
		end

		if spell.count then
			icon.count = icon:CreateFontString(nil, "OVERLAY")
			icon.count:SetFont(font1, spell.count.size, "THINOUTLINE")
			icon.count:SetPoint("LEFT", icon, "RIGHT", 0, 0)
			icon.count:SetTextColor(1, 1, 1)
		end

		local tex = icon:CreateTexture(nil, "OVERLAY")
		tex:SetAllPoints(icon)
		tex:SetTexture(normTex)
		tex:SetVertexColor(unpack(spell.color))

		icon.tex = tex
		icon.color = spell.color

		auras.Icons[spell.spellId] = icon
		icon:Hide()
	end

	local rej_icon = auras.Icons[774]
	if rej_icon and not self.unit:find("pet") then
		--rej_icon:CreateBackdrop("Transparent")
		---@class SanUIRaidFramesRejFrame: Frame
		local b = CreateFrame("Frame", nil, auras)
		b:SetAllPoints(rej_icon)
		local t = b:CreateTexture(nil, "OVERLAY")
		t:SetAllPoints(b)
		t:SetTexture(normTex)
		t:SetVertexColor(.5,.5,.5)

		rej_icon.Backdrop = b
		b.tex = t
		b:SetFrameLevel(rej_icon:GetFrameLevel()-1)

--[[
		if auras.Icons[8936] then
			b:SetParent(auras.Icons[8936])
			
		else
			b:SetParent(self.Health)
		end
		--]]
	end

	---@class SanUIRaidFramesTurtleIcon: Frame
	local turtle_icon = CreateFrame("Frame", nil, auras)
	turtle_icon:SetPoint("TOPRIGHT", S.scale2, S.scale2)
	--HighlightTarget has + 3, we want to be above that
	turtle_icon:SetFrameLevel(health:GetFrameLevel() + 4)
	turtle_icon.anyCaster = true
	turtle_icon.noCooldownCount = true -- needed for tullaCC to not show cooldown numbers	
	turtle_icon:SetWidth(rfsizes.turtleicon)
	turtle_icon:SetHeight(rfsizes.turtleicon)
	turtle_icon.setTex = true

	local tex = turtle_icon:CreateTexture(nil, "OVERLAY")
	tex:SetAllPoints(turtle_icon)
	tex:SetTexCoord(.1,.9,.1,.9)
	turtle_icon.tex = tex

	---@class SanUIRaidFramesTurtleIconCD: Cooldown
	local cd = CreateFrame("Cooldown", nil, turtle_icon,"CooldownFrameTemplate")
	cd:SetAllPoints(turtle_icon)
	cd.noCooldownCount = true -- needed for tullaCC to not show cooldown numbers
	cd:SetReverse(true)
	turtle_icon.cd = cd

	turtle_icon:Hide()

	for _, spellId in pairs(S["UnitFrames"].RaidBuffsTracking["ALL"]) do
		auras.Icons[spellId] = turtle_icon
	end

	for _, spell in ipairs(S["UnitFrames"].TextAuras[S.MyClass] or {}) do
		---@class SanUIRaidFramesTextAurasText: FontString
		local text = auras:CreateFontString(nil, "OVERLAY")
		text:SetFont("Fonts\\FRIZQT__.TTF", spell.textsize)--, "THINOUTLINE")
		text:SetPoint(unpack(spell.pos))

		text.anyCaster = spell.anyCaster
		text.formatstr = spell.formatstr
		text.res = 0.3
		text.timers = spell.timers

		if type(spell.spellId == "table") then
			for _, id in ipairs(spell.spellId) do
				auras.Texts[id] = text
			end
			text.spellIds = spell.spellId
		else
			auras.Texts[spell.spellId] = text
			text.spellId = spell.spellId
		end
		text:Hide()
	end

	-- special: Showing regrowth (8936) AND swiftmend (18562), so put
	-- regrowth's icon above swiftmend's
	if auras.Icons[8936] and auras.Icons[18562] then
		auras.Icons[8936]:SetFrameLevel(auras.Icons[18562]:GetFrameLevel()+1)
	end

	-- oUF_NotRaidDebuffs
	local raiddebuffs = S["UnitFrames"].RaidDebuffs
	local notraiddebuffs = { } --forceShow = true }
	
	for i = 1,2 do
		---@class SanUIRaidFramesRaidDebuffs: Frame
		local rd = CreateFrame("Frame", nil, self)
		rd:SetHeight(rfsizes.raiddebuffs)
		rd:SetWidth(rfsizes.raiddebuffs)

		if i == 1 then
			rd:SetPoint("BOTTOMLEFT",self,0,0)-- scales[1], scales[1])
		else
			rd:SetPoint("TOPLEFT",self,0,0)-- scales[1], -scales[1])
		end
		rd:SetFrameStrata(health:GetFrameStrata())
		--HighlightTarget has + 3, we want to be above that
		rd:SetFrameLevel(health:GetFrameLevel() + 4)

		S.CreateBackdrop(rd)

		---@class SanUIRaidFramesRaiddebuffsIcon: Texture
		rd.icon = rd:CreateTexture(nil, "OVERLAY")
		rd.icon:SetTexCoord(.1,.9,.1,.9)
		rd.icon:SetPoint("CENTER")
		rd.icon:SetSize(rfsizes.raiddebuffsicon, rfsizes.raiddebuffsicon)

		---@class SanUIRaidFramesRaiddebuffsIconCD: Cooldown
		rd.cd = CreateFrame("Cooldown", nil, rd,"CooldownFrameTemplate")
		rd.cd:SetAllPoints(rd.icon)
		rd.cd.noOCC = true -- remove this line if you want cooldown number on it
		rd.cd.noCooldownCount = true -- needed for tullaCC to not show cooldown numbers
		rd.cd:SetReverse(true)

		rd.count = rd:CreateFontString(nil, "OVERLAY")
		rd.count:SetFont(font2, 10, "THINOUTLINE")
		rd.count:SetPoint("BOTTOMRIGHT", rd, "BOTTOMRIGHT", 0, S.scale2)
		rd.count:SetTextColor(1, .9, 0)

		rd.Debuffs = raiddebuffs
		notraiddebuffs[i] = rd
	end

	local ORD = addon.oUF_NotRaidDebuffs
	--ORD.ShowDispelableDebuff = true
	--ORD.FilterDispellableDebuff = true
	--ORD.MatchBySpellName = true
	--ORD.SetDebuffTypeColor = RaidDebuffs.SetBorderColor

	ORD:ResetDebuffData()
	ORD:RegisterDebuffs(raiddebuffs)

	if not ORD.RegisteredSanUI then
		--S["UnitFrames"].Debuffs.PvE.spells = raiddebuffs
		ORD:ResetDebuffData()
		ORD:RegisterDebuffs(raiddebuffs)
		ORD.RegisteredSanUI = true
	end

	auras.NotRaidDebuffs = notraiddebuffs

	self.NotAuraTrack = auras

	return self
end

local point = "LEFT"
local columnAnchorPoint = "TOP"
local pa1, pa2, px, py = "TOPLEFT", "BOTTOMLEFT", 0, -3

oUF:RegisterStyle("SanUIRaid", Shared)

local function GetRaidFrameAttributes()
	return
	"SanUIRaid",
	nil,
	"solo,party,raid",
	"oUF-initialConfigFunction", [[
		local header = self:GetParent()
		self:SetWidth(header:GetAttribute("initial-width"))
		self:SetHeight(header:GetAttribute("initial-height"))
	]],
	"initial-width", rfsizes.width, --Scale(66),
	"initial-height", rfsizes.height, --Scale(28),
	"showParty", true,
	"showRaid", true,
	"showPlayer", true,
	"showSolo", true,
	"xoffset", scales[2],
	"yOffset", scales[-2],
	"point", point,
	"groupFilter", "1,2,3,4,5,6,7,8",
	"groupingOrder", "HEAL, TANK, DAMAGER", --"1,2,3,4,5,6,7,8",
	"groupBy", "ROLE",
	"maxColumns", 8,
	"unitsPerColumn", 5,
	"columnSpacing", scales[2],
	"columnAnchorPoint", columnAnchorPoint
end
S.RaidFrameAttributes = GetRaidFrameAttributes

-- Show Raid Pets
local function GetPetFrameAttributes()
	return
	"SanUIRaidPets", "SecureGroupPetHeaderTemplate", "solo,party,raid",
	"showPlayer", true,
	"showParty", true,
	"showRaid", true,
	"showSolo", true,
	"maxColumns", 8,
	"point", point,
	"unitsPerColumn", 5,
	"columnSpacing", scales[2],
	"columnAnchorPoint", columnAnchorPoint,
	"yOffset", scales[-2],
	"xOffset", scales[2],
	"initial-width", rfsizes.width, --Scale(66),
	"initial-height", rfsizes.height, --Scale(28),
	"oUF-initialConfigFunction", [[
		local header = self:GetParent()
		self:SetWidth(header:GetAttribute("initial-width"))
		self:SetHeight(header:GetAttribute("initial-height"))
	]]
end
S.RaidFramePetAttributes = GetPetFrameAttributes

oUF:Factory(function(self)
	oUF:SetActiveStyle("SanUIRaid")

	local raid = oUF:SpawnHeader(GetRaidFrameAttributes())
	raid:SetParent(SanUI_PetBattleFrameHider)
	raid:ClearAllPoints()
	raid:SetPoint("CENTER",UIParent,0,-195)
	raid:SetFrameStrata("MEDIUM")
	S.unitFrames.raid = raid

	local pets = oUF:SpawnHeader(GetPetFrameAttributes())
	pets:SetParent(SanUI_PetBattleFrameHider)
	pets:SetPoint(pa1, raid, pa2, Scale(px), Scale(py))
	pets:SetFrameStrata("MEDIUM")
	S.unitFrames.pets = pets

	-- Max number of group according to Instance max players
	local ten = "1,2"
	local twentyfive = "1,2,3,4,5"
	local forty = "1,2,3,4,5,6,7,8"
	local twenty = "1,2,3,4,5,6"

	local MaxGroup = CreateFrame("Frame", "SanUIRaidMaxGroup")
	MaxGroup:RegisterEvent("PLAYER_ENTERING_WORLD")
	MaxGroup:RegisterEvent("ZONE_CHANGED_NEW_AREA")
	MaxGroup:SetScript("OnEvent", function(self, event)
		if InCombatLockdown() then
			MaxGroup:RegisterEvent("PLAYER_REGEN_ENABLED")
			return
		end

		if event == "PLAYER_REGEN_ENABLED" then
			MaxGroup:UnregisterEvent("PLAYER_REGEN_ENABLED")
		end

		local filter
		local inInstance, instanceType = IsInInstance()
		local _, _, _, _, maxPlayers, _, _ = GetInstanceInfo()

		if maxPlayers == 25 then
			filter = twentyfive
		elseif maxPlayers == 10 then
			filter = ten
		elseif maxPlayers == 20 then
			filter = twenty
		else
			filter = forty
		end

		if inInstance and instanceType == "raid" then
			raid:SetAttribute("groupFilter", filter)
			pets:SetAttribute("groupFilter", filter)
		else
			raid:SetAttribute("groupFilter", "1,2,3,4,5,6,7,8")
			pets:SetAttribute("groupFilter", "1,2,3,4,5,6,7,8")
		end
	end)
end)
