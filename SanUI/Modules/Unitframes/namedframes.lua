local _, addon = ...
local S,C = unpack(addon)

local oUF = addon.oUF

local Scale = S.Scale
local scales = C.sizes.scales
local rfsizes = C.sizes.namedframes

--local font2 = C["Medias"].UnitFrameFont
local font1 = C["medias"].fonts.Font
local font2 = font1
local normTex = C["medias"].textures.StatusbarNormal

local evobuffs = {
	{
		-- Prescience
		spellID = 410089,
		pos = {"CENTER", nil, "CENTER", -12, -2 },
		color = { 1, 1, 1},
		anyCaster = false,
		cooldownAnim = false,
		timers = { {2, {1, 0, 0}}, {6, {1, 1, 0}} },
	},
	{
		-- Ebon Might
		spellID = 395296,
		pos = {"CENTER", nil, "CENTER", 0, -2},
		color = { 219/255, 163/255, 7/255},
		anyCaster = false,
		cooldownAnim = true,
	},
	{
		-- Blistering Scales
		spellID = 360827,
		pos = {"TOP", nil, "TOP", -9, 0},
		color = {0.4, 0.8, 0.2, 0},
		anyCaster = false,
		count = { size = 9 }
		--timers = { {2, {1, 0, 0}}, {4.5, {1, 1, 0}} },
	},
}
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

--need to override this function because we don't have self.Health.value for 
--raid units anymore
S.PostUpdateHealthRaid = function(health, unit, min, max)
	-- doing this here to force friendly unit (vehicle or pet) very far away from you to update color correcly
	-- because if vehicle or pet is too far away, unitreaction return nil and color of health bar is white.
	if not UnitIsPlayer(unit) and UnitIsFriend(unit, "player") and C["UnitFrames"].unicolor ~= true then
		local c = S.Colors.reaction[5]
		local r, g, b = c[1], c[2], c[3]
		health:SetStatusBarColor(r, g, b)
		health.bg:SetTexture(.1, .1, .1)
	end

end

local updateThreat = function(self, event, unit)
	if (self.unit ~= unit) then return end

	local threat = UnitThreatSituation(unit)

	if threat and threat > 1 then
		self.Health.bg:SetVertexColor(120/255,12/255,12/255)
		self.Health.bg:SetColorTexture(.8,.8,.8)
		self.Health:SetStatusBarColor(.3,.3,.3,.7)

		local fontName, fontHeight, fontFlags = self.Name:GetFont()
		self.Name:SetFont(fontName,fontHeight,"OUTLINE")
	else
		self.Health.bg:SetColorTexture(.3,.3,.3)
		self.Health.bg:SetVertexColor(0,0,0,1)
		self.Health:SetStatusBarColor(.2,.2,.2,1)

		local fontName, fontHeight, fontFlags = self.Name:GetFont()
		self.Name:SetFont(fontName,fontHeight,"")
	end

end

local function Shared(self, unit)
	self:SetFrameStrata("MEDIUM")
	self.colors = S.UnitColor
	self:RegisterForClicks("AnyUp")
	self:SetScript("OnEnter", UnitFrame_OnEnter)
	self:SetScript("OnLeave", UnitFrame_OnLeave)

	---@class SanUINamedHealthBar: StatusBar
	local health = CreateFrame("StatusBar", nil, self)
	health:SetPoint("TOPLEFT")
	health:SetPoint("TOPRIGHT")
	health:SetHeight(rfsizes.height)
	health:SetStatusBarTexture(normTex)
	health:SetFrameLevel(8)
	health:SetStatusBarColor(131/255, 148/255, 150/255, 1)
	health:SetOrientation("VERTICAL")
	self.Health = health

	health.bg = health:CreateTexture(nil, "BORDER")
	health.bg:SetAllPoints()
	health.bg:SetVertexColor(0,43/255,54/255,1)
	health.bg:SetTexture(normTex)

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

	-- highlight
	local glowBorder = {edgeFile = C["Medias"].Blank, edgeSize = 1}
	---@class SanUINamedHighlightTarget: Frame, BackdropTemplate
	local HighlightTarget = CreateFrame("Frame", nil, self.Health, "BackdropTemplate")

	HighlightTarget:SetFrameLevel(self.Health:GetFrameLevel() + 3)
	HighlightTarget:SetAllPoints()
	HighlightTarget:SetBackdrop(glowBorder)
	HighlightTarget.origColor = {0,0,0,1}
	HighlightTarget:SetBackdropBorderColor(unpack(HighlightTarget.origColor))

	self:RegisterEvent("PLAYER_TARGET_CHANGED", function(self,event,unit)
			if UnitIsUnit("target", self.unit) then
				self.HighlightTarget:SetBackdropBorderColor(1,1,1)
			else
				self.HighlightTarget:SetBackdropBorderColor(unpack(HighlightTarget.origColor))
			end
		end)

	self.HighlightTarget = HighlightTarget

	local name = HighlightTarget:CreateFontString(nil, "OVERLAY")
	name:SetPoint("BOTTOMRIGHT", HighlightTarget,"BOTTOMRIGHT", -scales[2],scales[2]) -- -1, 1)
	name:SetFont(font1, rfsizes.name)
	self:Tag(name, "[getnamecolor][nameshort]")
	self.Name = name

	local Dead = HighlightTarget:CreateFontString(nil, "OVERLAY")
	Dead:SetPoint("TOPRIGHT",HighlightTarget,"TOPRIGHT",0,0) -- -S.scale1,0)
	Dead:SetFont(C["Medias"].Font, 11)
	self:Tag(Dead, "[status]")
	self.Dead = Dead

	local RaidIcon = HighlightTarget:CreateTexture(nil, "OVERLAY")
	RaidIcon:SetHeight(rfsizes.raidicon)
	RaidIcon:SetWidth(rfsizes.raidicon)
	RaidIcon:SetPoint("CENTER", self, "TOP",-scales[12],-scales[2])
	RaidIcon:SetTexture("Interface\\AddOns\\Tukui\\medias\\textures\\Others\\RaidIcons.blp")
	RaidIcon.SetTexture = S.dummy -- idk why but RaidIcon:GetTexture() is returning nil in oUF, resetting icons to default ... stop it!
	self.RaidTargetIndicator  = RaidIcon
	RaidIcon:Hide() -- not sure if necessary, seems so from MOTHER's rooms

	---@class SanUINamedReadyCheck: Texture
	local ReadyCheck = self.Health:CreateTexture(nil, "OVERLAY")
	ReadyCheck:SetHeight(rfsizes.readycheck)
	ReadyCheck:SetWidth(rfsizes.readycheck)
	ReadyCheck:SetPoint("CENTER",self.Health,"TOP")
	ReadyCheck.readyTexture = READY_CHECK_READY_TEXTURE
	ReadyCheck.notReadyTexture = READY_CHECK_NOT_READY_TEXTURE
	ReadyCheck.waitingTexture = READY_CHECK_WAITING_TEXTURE

	self.ReadyCheckIndicator = ReadyCheck

	local ResurrectIcon = self.Health:CreateTexture(nil, "HIGHLIGHT", nil, 7)
	ResurrectIcon:SetSize(rfsizes.resurrecticon, rfsizes.resurrecticon)
	--ResurrectIcon:SetPoint("CENTER")
	ResurrectIcon:SetPoint("BOTTOMRIGHT",self.Health,"BOTTOMRIGHT",scales[4],-scales[4])
	ResurrectIcon:SetDrawLayer("OVERLAY", 7)
	self.ResurrectIndicator = ResurrectIcon

	local SummonIndicator = self.Health:CreateTexture(nil, "HIGHLIGHT", nil, 7)
	SummonIndicator:SetSize(rfsizes.summonindicator, rfsizes.summonindicator)
	SummonIndicator:SetPoint("BOTTOMRIGHT",self.Health,"BOTTOMRIGHT",scales[4],-scales[4])
	SummonIndicator:SetDrawLayer("OVERLAY", 7)
	self.SummonIndicator = SummonIndicator

	local range = {insideAlpha = 1, outsideAlpha = C["Raid"].RangeAlpha}
	range.PostUpdate = function(self, object, inRange, checkedRange, connected)
		if not connected then
			object:SetAlpha(self.outsideAlpha)
		end
		ResurrectIcon:SetAlpha(self.insideAlpha)
	end
	self.Range = range

	local mhpb = CreateFrame("StatusBar", nil, self.Health)
	mhpb:SetOrientation("VERTICAL")
	mhpb:SetPoint("BOTTOM", self.Health:GetStatusBarTexture(), "TOP", 0, 0)
	mhpb:SetWidth(rfsizes.width)
	mhpb:SetHeight(rfsizes.height)
	mhpb:SetStatusBarTexture(normTex)
	mhpb:SetStatusBarColor(0, 0.5, 0.15, 1)

	local ohpb = CreateFrame("StatusBar", nil, self.Health)
	ohpb:SetOrientation("VERTICAL")
	ohpb:SetPoint("BOTTOM", self.Health:GetStatusBarTexture(), "TOP", 0, 0)
	ohpb:SetWidth(rfsizes.width)
	ohpb:SetHeight(rfsizes.height)
	ohpb:SetStatusBarTexture(normTex)
	ohpb:SetStatusBarColor(0, 0.5, 0, 1)

	local absb = CreateFrame("StatusBar", nil, self.Health)
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

	---@class SanUINamedAuras: Frame
	local auras = CreateFrame("Frame", nil, self)
	auras:SetPoint("TOPLEFT", self.Health, scales[2], -scales[2])
	auras:SetPoint("BOTTOMRIGHT", self.Health, -scales[2], scales[2])
	auras:SetFrameLevel(self.Health:GetFrameLevel()+2)
	auras.Icons = {}
	auras.Texts = {}

	for _, spell in pairs(evobuffs) do
		---@class SanUINamedAurasIcon: Frame
		local icon = CreateFrame("Frame", nil, auras)
		spell.pos[2] = auras
		icon:SetPoint(unpack(spell.pos))
		icon.spellID = spell.spellID
		icon.anyCaster = spell.anyCaster
		icon.timers = spell.timers
		icon.cooldownAnim = spell.cooldownAnim
		icon.noCooldownCount = true -- needed for tullaCC to not show cooldown numbers
		icon:SetWidth(rfsizes.notauratrackicon)
		icon:SetHeight(rfsizes.notauratrackicon)

		if icon.cooldownAnim then
			---@class SanUINamedAurasIconCD: Cooldown
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
		tex:SetTexture(C.Medias.Blank)
		tex:SetVertexColor(unpack(spell.color))

		icon.tex = tex
		icon.color = spell.color

		auras.Icons[spell.spellID] = icon
		icon:Hide()
	end

	local roleframe = CreateFrame("Frame", nil, self)
	self.roleframe = roleframe
	--HighlightTarget has + 3, we want to be above that
	roleframe:SetFrameLevel(health:GetFrameLevel() + 4)
	roleframe:SetSize(rfsizes.turtleicon, rfsizes.turtleicon)
	roleframe:SetPoint('TOPRIGHT', self, S.scal2, S.scale2)
	--roleframe:SetTemplate()

    local RaidRoleIndicator = roleframe:CreateTexture(nil, 'OVERLAY')
    RaidRoleIndicator:SetAllPoints()

    -- Register it with oUF
    --self.RaidRoleIndicator = RaidRoleIndicator
	self.GroupRoleIndicator = RaidRoleIndicator

	---@class SanUINamedTurtleIcon: Frame
	local turtle_icon = CreateFrame("Frame", nil, auras)
	turtle_icon:SetPoint("TOPRIGHT", S.scale2, S.scale2)
	--RoleFrame has + 4, we want to be above that
	turtle_icon:SetFrameLevel(health:GetFrameLevel() + 5)
	turtle_icon.anyCaster = true
	turtle_icon.noCooldownCount = true -- needed for tullaCC to not show cooldown numbers	
	turtle_icon:SetWidth(rfsizes.turtleicon)
	turtle_icon:SetHeight(rfsizes.turtleicon)
	turtle_icon.setTex = true

	local tex = turtle_icon:CreateTexture(nil, "OVERLAY")
	tex:SetAllPoints(turtle_icon)
	tex:SetTexCoord(.1,.9,.1,.9)
	turtle_icon.tex = tex

	---@class SanUINamedTurtleIconCD: Cooldown
	local cd = CreateFrame("Cooldown", nil, turtle_icon,"CooldownFrameTemplate")
	cd:SetAllPoints(turtle_icon)
	cd.noCooldownCount = true -- needed for tullaCC to not show cooldown numbers
	cd:SetReverse(true)
	turtle_icon.cd = cd

	turtle_icon:Hide()

	for _, spellID in pairs(S["UnitFrames"].RaidBuffsTracking["ALL"]) do
		auras.Icons[spellID] = turtle_icon
	end

	for _, spell in ipairs(S["UnitFrames"].TextAuras[S.MyClass] or {}) do
		---@class SanUINamedTextAurasText: FontString
		local text = auras:CreateFontString(nil, "OVERLAY")
		text:SetFont("Fonts\\FRIZQT__.TTF", spell.textsize)--, "THINOUTLINE")
		text:SetPoint(unpack(spell.pos))

		text.anyCaster = spell.anyCaster
		text.format = spell.format
		text.res = 0.3
		text.timers = spell.timers

		if type(spell.spellID == "table") then
			for _, id in ipairs(spell.spellID) do
				auras.Texts[id] = text
			end
			text.spellIDs = spell.spellID
		else
			auras.Texts[spell.spellID] = text
			text.spellID = spell.spellID
		end
		text:Hide()
	end

	-- special: Showing regrowth (8936) AND swiftmend (18562), so put
	-- regrowth's icon above swiftmend's
	if auras.Icons[8936] and auras.Icons[18562] then
		auras.Icons[8936]:SetFrameLevel(auras.Icons[18562]:GetFrameLevel()+1)
	end

	self.NotAuraTrack = auras

	-- oUF_NotRaidDebuffs
	local raiddebuffs = S["UnitFrames"].RaidDebuffs
	self.NotRaidDebuffs = { } --forceShow = true }
	for i = 1,2 do
		---@class SanUINamedRaidDebuffs: Frame
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

		---@class SanUINamedRaidDebuffsIcon: Texture
		rd.icon = rd:CreateTexture(nil, "OVERLAY")
		rd.icon:SetTexCoord(.1,.9,.1,.9)
		rd.icon:SetPoint("CENTER")
		rd.icon:SetSize(rfsizes.raiddebuffsicon, rfsizes.raiddebuffsicon)

		---@class SanUINamedRaidDebuffsIconCD: Cooldown
		rd.cd = CreateFrame("Cooldown", nil, rd,"CooldownFrameTemplate")
		rd.cd:SetAllPoints(rd.icon)
		rd.cd.noOCC = true -- remove this line if you want cooldown number on it
		rd.cd.noCooldownCount = true -- needed for tullaCC to not show cooldown numbers
		rd.cd:SetReverse(true)

		rd.count = rd:CreateFontString(nil, "OVERLAY")
		rd.count:SetFont(font2, 9, "THINOUTLINE")
		rd.count:SetPoint("BOTTOMRIGHT", rd, "BOTTOMRIGHT", 0, S.scale2)
		rd.count:SetTextColor(1, .9, 0)

		rd.Debuffs = raiddebuffs

		self.NotRaidDebuffs[i] = rd
	end

	local ORD = addon.oUF_NotRaidDebuffs
	--ORD.ShowDispelableDebuff = true
	--ORD.FilterDispellableDebuff = true
	ORD.MatchBySpellName = true
	--ORD.SetDebuffTypeColor = RaidDebuffs.SetBorderColor

	ORD:ResetDebuffData()
	ORD:RegisterDebuffs(raiddebuffs)

	if not ORD.RegisteredSanUI then
		S["UnitFrames"].Debuffs.PvE.spells = raiddebuffs
		ORD:ResetDebuffData()
		ORD:RegisterDebuffs(raiddebuffs)
		ORD.RegisteredSanUI = true
	end

	return self
end

local function GetEvoFrameAttributes()
	return
	"SanUINamed",
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
	--"point", point,
	"nameList", "",
	"maxColumns", 1,
	"groupBy", "ROLE",
	"groupingOrder", "TANK, HEALER, DAMAGER, DAMAGER, DAMAGER",
	"unitsPerColumn", 5,
	"columnSpacing", scales[2],
	"columnAnchorPoint", "BOTTOM"
end

---[[	

local function MouseoverName(escape)
	local name, realm = UnitName("mouseover")
	if not name then return end

--[[
	if (UnitIsPlayer("mouseover") and not realm) then
		realm = "" --GetRealmName()
	end
--]]

	local player
	if name and not realm then
		player = name
	else
		if escape then
			player = name.."%-"..realm
		else
			player = name.."-"..realm
		end
	end

	return player
end

S.addPlayer2NamedFrames = function()
	if not S.unitFrames.namedFrames then return end

	local player = MouseoverName(false)

	if player then
		local oldlist = S.unitFrames.namedFrames:GetAttribute("nameList")
		local newlist =  oldlist..","..player
		print("newlist: "..newlist)
		S.unitFrames.namedFrames:SetAttribute("nameList", newlist)
	else
		print("No name")
end
	end

S.removePlayerFromNamedFrames = function()
	if not S.unitFrames.namedFrames then return end

	local player = MouseoverName(true)

	if player then
		local oldlist = S.unitFrames.namedFrames:GetAttribute("nameList")
		local newlist =  oldlist:gsub(player..",","")
		newlist = newlist:gsub(","..player,"")
		print("player: "..player)
		print("newlist: "..newlist)
		S.unitFrames.namedFrames:SetAttribute("nameList", newlist)
	end
end

if S.MyClass == "EVOKER" then
	oUF:RegisterStyle("SanUINamed", Shared)
	oUF:SetActiveStyle("SanUINamed")
	local evoframes = oUF:SpawnHeader(GetEvoFrameAttributes())
	evoframes:SetParent(SanUI_PetBattleFrameHider)
	evoframes:ClearAllPoints()
	evoframes:SetPoint("BOTTOM",UIParent,"CENTER",240,-130)
	S.unitFrames = S.unitFrames or {}
	S.unitFrames.namedFrames = evoframes
end
	--]]
