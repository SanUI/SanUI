local cfg = oUF_Hank_config
local oUF_Hank = {}
oUF_Hank_hooks = {}
local oUF = SanUI.oUF
local S, C = unpack(SanUI)

local _, ns = ...

local font1 = C.medias.fonts.Font
--local font2 = C["Medias"].UnitFrameFont
local font2 = font1
local normTex = C.medias.textures.StatusbarNormal
local playerClass = S.MyClass

local Scale = S.Scale


-- local backdrop = {
	-- bgFile = C["Medias"].Blank,
	-- insets = {top = -S.Mult, left = -S.Mult, bottom = -S.Mult, right = -S.Mult},
-- }
S.SetFontString = function(parent, fontName, fontHeight, fontStyle)
	local fs = parent:CreateFontString(nil, "OVERLAY")
	fs:SetFont(fontName, fontHeight, fontStyle)
	fs:SetJustifyH("LEFT")
	fs:SetShadowColor(0, 0, 0)
	fs:SetShadowOffset(1.25, -1.25)
	return fs
end

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

local function valShort(value)
	if(value >= 1e6) then
		return ("%.2f"):format(value / 1e6):gsub("%.?0+$", "") .. "m"
	elseif(value >= 1e4) then
		return ("%.1f"):format(value / 1e3):gsub("%.?0+$", "") .. "k"
	else
		return value
	end
end

oUF.Tags.Events["mergedPower"] = "UNIT_POWER_UPDATE"
oUF.Tags.Methods["mergedPower"] = function(unit)
   if not UnitIsDeadOrGhost(unit) then
      local curAlt = UnitPower(unit, ALTERNATE_POWER_INDEX)
      local maxAlt = UnitPowerMax(unit, ALTERNATE_POWER_INDEX)
      if maxAlt > 0  then
         return ("%s/%s"):format(valShort(curAlt),valShort(maxAlt))
      else
         local cur = UnitPower(unit)
         local max = UnitPowerMax(unit)

		 return ("%s/%s"):format(valShort(cur),valShort(max))

      end
   end
end

oUF_Hank_hooks.ReanchorDebuffs = {
sharedStyle = function(self, unit, isSingle)

	if self.Debuffs and self.Buffs then
		local col = 0
		local row = 0
		local sizex = self.Buffs.size + cfg.AuraSpacing
		local cols = math.floor(self.Buffs:GetWidth() / sizex + .5)

		self.Buffs.buffsPerRow = cols
	end

end,
--[[
PreSetPosition = function(buffs, max)
	local unit = buffs:GetParent().unit
	
	if unit == "target" then
		if buffs.visibleBuffs > 0 and buffs.buffsPerRow  and buffs.buffsPerRow  > 0 then
			-- Anchor debuff frame to bottomost buff icon, i.e the last buff row
			buffs:GetParent().Debuffs:ClearAllPoints()
			local rows = math.ceil(buffs.visibleBuffs/buffs.buffsPerRow)
			buffs:GetParent().Debuffs:SetPoint("TOPLEFT", buffs[(rows-1)*buffs.buffsPerRow + 1], "BOTTOMLEFT", 0, -cfg.AuraSpacing -2)
		else
			buffs:GetParent().Debuffs:SetPoint("TOPLEFT", buffs:GetParent(), "BOTTOMLEFT", 0, -25)
			
		end
	elseif (unit == "player" or unit == "focus") then
		if buffs.visibleBuffs > 0 then
			buffs:GetParent().Debuffs:SetPoint("TOPRIGHT", buffs, "BOTTOMRIGHT", 0, -cfg.AuraSpacing -2)
		else
			buffs:GetParent().Debuffs:SetPoint("TOPRIGHT", buffs:GetParent(), "BOTTOMRIGHT", 0, -25)
			
		end
	end
end,
--]]
}

oUF_Hank_hooks.ButtonStyleTuk = {
--[[
PostCreateIcon = function(icons, icon)
	
	if(icons.__owner.unit == "player" or icons.__owner.unit == "target" ) then
		S.CreateBackdrop(icon)
		
		icon.remaining = S.SetFontString(icon, font1,11, "THINOUTLINE")
		icon.remaining:SetPoint("CENTER", Scale(1), 0)
		
		icon.Cooldown.noOCC = true		 	-- hide OmniCC CDs
		icon.Cooldown.noCooldownCount = true	-- hide CDC CDs
		
		icon.Cooldown:SetReverse()
		icon.Icon:SetPoint("TOPLEFT", Scale(2), Scale(-2))
		icon.Icon:SetPoint("BOTTOMRIGHT", Scale(-2), Scale(2))
		icon.Icon:SetTexCoord(0.08, 0.92, 0.08, 0.92)
		icon.Icon:SetDrawLayer('ARTWORK')
		
		icon.Count:SetPoint("BOTTOMRIGHT", Scale(3), 0) --Scale(1.5))
		icon.Count:SetJustifyH("RIGHT")
		icon.Count:SetFont(C["Medias"].Font, 9, "THICKOUTLINE")
		icon.Count:SetTextColor(0.84, 0.75, 0.65)
		
		icon.overlayFrame = CreateFrame("frame", nil, icon, nil)
		icon.Cooldown:SetFrameLevel(icon:GetFrameLevel() + 1)
		icon.Cooldown:ClearAllPoints()
		icon.Cooldown:SetPoint("TOPLEFT", icon, "TOPLEFT", Scale(2), Scale(-2))
		icon.Cooldown:SetPoint("BOTTOMRIGHT", icon, "BOTTOMRIGHT", Scale(-2), Scale(2))
		icon.overlayFrame:SetFrameLevel(icon.Cooldown:GetFrameLevel() + 1)	   
		icon.Overlay:SetParent(icon.overlayFrame)
		icon.Count:SetParent(icon.overlayFrame)
		icon.remaining:SetParent(icon.overlayFrame)
	end
end,
--]]

OnEnterAura = function(self, icon)

	if(self.unit == "player" or self.unit == "target") then

		S.CreateBackdrop(self.HighlightAura)
		self.HighlightAura:SetFrameLevel(6) -- cd on icon seems to have frame level 5

		self.HighlightAura.icon.remaining = S.SetFontString(icon, font1, 11, "THINOUTLINE")
		self.HighlightAura.icon.remaining:SetPoint("CENTER", Scale(1), 0)

		self.HighlightAura.icon:SetPoint("TOPLEFT", Scale(2), Scale(-2))
		self.HighlightAura.icon:SetPoint("BOTTOMRIGHT", Scale(-2), Scale(2))
		self.HighlightAura.icon:SetTexCoord(0.08, 0.92, 0.08, 0.92)
		self.HighlightAura.icon:SetDrawLayer('ARTWORK')
		self.HighlightAura.icon.overlayFrame = CreateFrame("frame", nil, icon, nil)
		self.HighlightAura.icon.remaining:SetParent(icon.overlayFrame)
		self.HighlightAura.oldicon = icon

		icon.Count:SetPoint("BOTTOMRIGHT", self.HighlightAura, Scale(3), 0) --Scale(1.5))
		icon.Count:SetJustifyH("RIGHT")
		icon.Count:SetFont(font1, 9*cfg.AuraMagnification, "THICKOUTLINE")
	end
end,

OnLeaveAura = function(self)
	if self.HighlightAura.oldicon then
		self.HighlightAura.oldicon.Count:SetPoint("BOTTOMRIGHT",self.HighlightAura.oldicon, Scale(3), 0) --Scale(1.5))
		self.HighlightAura.oldicon.Count:SetJustifyH("RIGHT")
		self.HighlightAura.oldicon.Count:SetFont(font1, 9, "THICKOUTLINE")
	end
end,
}

-- oUF.Tags.Methods["classColor"] = function(unit)
	-- local color = RAID_CLASS_COLORS[select(2, UnitClass(unit))]
	-- if not color then
		-- color = {}
		-- color.r = 1
		-- color.g = 1
		-- color.b = 1
	-- end

	-- return ("FF%.2x%.2x%.2x"):format(color.r * 255, color.g * 255, color.b * 255)
-- end
--[[
oUF_Hank_hooks.ClassToT_etc = {
sharedStyle = function(self, unit, isSingle)
	if unit == "targettarget" or unit == "focustarget" then self:Tag(name, "|c[classColor]\226\128\186  [smartName] @ [perhp]%|r")
	elseif unit == "targettargettarget" then self:Tag(name, "|c[classColor]\194\187 [smartName] @ [perhp]%|r") end
end,
}
--]]

oUF_Hank_hooks.FocusAuras = {
sharedStyle = function(self, unit, isSingle)
	if unit ~= "focus" then return end

	local auraHolder = CreateFrame("Frame", nil, self)
	auraHolder:SetPoint("BOTTOMRIGHT", self, "TOPRIGHT", 0, S.scale1)
	auraHolder:SetScale(1/cfg.FocusFrameScale)
	auraHolder:SetSize(36, 20)
	S.CreateBackdrop(auraHolder)

	---@class SanUIFocusAuras:Frame
	local auras = CreateFrame("Frame", nil, auraHolder)
	auras:SetPoint("TOP")
	auras:SetSize(36, 30)
	auras.Icons = {}
	auras.Texts = {}

	for _, spell in pairs(S["UnitFrames"].RaidBuffsTracking[S.MyClass] or {}) do
		---@class SanUIFocusAurasIcon: Frame
		local icon = CreateFrame("Frame", nil, auras)
		spell.pos[2] = auras
		icon:SetPoint(unpack(spell.pos))

		icon.spellId = spell.spellId
		icon.anyCaster = spell.anyCaster
		icon.timers = spell.timers
		icon.cooldownAnim = spell.cooldownAnim
		icon.noCooldownCount = true -- needed for tullaCC to not show cooldown numbers
		icon:SetWidth(S.scale6)
		icon:SetHeight(S.scale6)

		if icon.cooldownAnim then
			---@class SanUIFocusAurasIconCD: Cooldown
			local cd = CreateFrame("Cooldown", nil, icon,"CooldownFrameTemplate")
			cd:SetAllPoints(icon)
			cd.noCooldownCount = icon.noCooldownCount or false -- needed for tullaCC to not show cooldown numbers
			cd:SetReverse(true)
			icon.cd = cd
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

	for _, spell in ipairs(S["UnitFrames"].TextAuras[S.MyClass] or {}) do
		---@class SanUIFocusTextAurasText: FontString
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

	self.NotAuraTrack = auras
end,
}

oUF_Hank_hooks.HealthColored = {
	UpdateHealth = function(self)
		if self.unit == "player" then

			local h, hMax

			if UnitHasVehicleUI("player") then
				h, hMax = UnitHealth("pet"), UnitHealthMax("pet")
			else
				h, hMax = UnitHealth(self.unit), UnitHealthMax(self.unit)
			end

			if UnitIsConnected(self.unit) and not UnitIsGhost(self.unit) and not UnitIsDead(self.unit) then
				for i = self.unit:find("boss") and 3 or 1, 3 do
					self.healthFill[4 - i]:SetVertexColor(1 - h / hMax, h / hMax, 0)
				end
			end
		end
	end,
}

oUF_Hank_hooks.PetBattleHide = {
	sharedStyle = function(self,unit,isSingle)
		self:SetParent(S.panels.PetBattleHiderr)
	end
}

oUF_Hank_hooks.customCastbar = {

sharedStyle = function(self, unit, isSingle)
	if (unit == "player" or unit == "target" or unit == "focus" or unit:find("boss")) then

		---@class SanUICastBar: StatusBar
		---@field Backdrop Frame
		---@field bg Frame
		local castbar = CreateFrame("StatusBar", self:GetName().."_Castbar", self)
		castbar:SetStatusBarTexture(normTex)
		castbar:SetStatusBarColor(unpack(C.colors.CastingColor))

		castbar.place = function(args)
			if (unit == "player" or unit:find("boss")) then
				if self.ClassPower then
					local nr_ClassPower = #self.ClassPower
					castbar:SetPoint("TOPRIGHT", self.ClassPower[nr_ClassPower]:GetParent(), "BOTTOMRIGHT", 0, Scale(-2))
				else
					castbar:ClearAllPoints()
					castbar:SetPoint("TOPRIGHT", self, "BOTTOMRIGHT", 0, Scale(-20))
				end
				castbar:SetHeight(Scale(15))
				castbar:SetWidth(Scale(150))
			elseif (unit == "target") then
				castbar:SetHeight(Scale(15))
				castbar:SetWidth(Scale(150))
				castbar:SetPoint("TOPLEFT",self,"BOTTOMLEFT",10,0)
			elseif (unit == "focus") then
				castbar:SetHeight(Scale(22))
				castbar:SetWidth(Scale(200))
				castbar:SetPoint("TOPRIGHT",self,"BOTTOMRIGHT",0,0)
			end
		end

		castbar.place()

		castbar.CustomTimeText = function(self, duration)
			---@diagnostic disable-next-line: undefined-field
			local Value = format("%.1f / %.1f", self.channeling and duration or self.max - duration, self.max)
			self.Time:SetText(Value)
		end
		
		castbar.CustomDelayText = function(self, duration)
			---@diagnostic disable-next-line: undefined-field
			local Value = format("%.1f |cffaf5050%s %.1f|r", self.channeling and duration or self.max - duration, self.channeling and "- " or "+", self.delay)
			self.Time:SetText(Value)
		end
		--castbar.PostCastStart = S["UnitFrames"].CheckCast
		castbar.PostCastStart = function(element, unit)
			--S["UnitFrames"].CheckChannel(element, unit)
			if (element.empowering) then
				element:SetStatusBarColor(unpack(C.colors.CastingColor))
			end
			if element.notInterruptible then
				element:SetStatusBarColor(0.2, 0.2, 0.2, 1)
			else
				element:SetStatusBarColor(unpack(C.colors.CastingColor))
			end
		end

		self.Castbar = castbar

		-- Castbar background
		if (unit == "player" or unit == "target") then
			S.CreateBackdrop(castbar)
		elseif (unit == "focus") then
			local castBarBG = CreateFrame("Frame",nil,castbar)
			castBarBG:SetAllPoints(castbar)
			castBarBG:SetFrameStrata(castbar:GetFrameStrata())
			castbar:SetFrameLevel(6)
			castBarBG:SetFrameLevel(5)
			self.Castbar.bg = castBarBG
		end

		--Castbar latency texture
		if unit == "player" then
			castbar.safezone = castbar:CreateTexture(nil, "ARTWORK")
			castbar.safezone:SetTexture(normTex)
			castbar.safezone:SetVertexColor(0.69, 0.31, 0.31, 0.75)
			castbar.SafeZone = castbar.safezone
		end

		--Castbar text string
		if(unit ~= "focus") then
			castbar.Text = S.SetFontString(castbar,font2, 12,"OUTLINE")
		else
			castbar.Text = S.SetFontString(castbar,font2, 16,"OUTLINE")
		end
		castbar.Text:SetJustifyV("MIDDLE")
		castbar.Text:SetShadowOffset(.8,-.8)
		castbar.Text:SetPoint("LEFT", castbar, "LEFT", Scale(4), 0)
		castbar.Text:SetTextColor(0.84, 0.75, 0.65)
		castbar.Text:SetWidth(castbar:GetWidth()*0.68)
		castbar.Text:SetHeight(castbar:GetHeight()*0.9)

		--Icon for Castbar	
		castbar.button = CreateFrame("Frame", nil, castbar)

		if (unit == "player") then
			castbar.button:SetSize(Scale(28), Scale(28))
		elseif (unit == "target") then
			castbar.button:SetSize(Scale(19), Scale(19))
		else
			castbar.button:SetSize(Scale(18), Scale(18))
		end

		S.CreateBackdrop(castbar.button)

		castbar.icon = castbar.button:CreateTexture(nil, "ARTWORK")
		
		castbar.icon:SetPoint("TOPLEFT", castbar.button, Scale(2), Scale(-2))
		castbar.icon:SetPoint("BOTTOMRIGHT", castbar.button, Scale(-2), Scale(2))
		castbar.icon:SetTexCoord(0.08, 0.92, 0.08, .92)

		if unit == "player" or unit:find("boss") then
			castbar.button:ClearAllPoints()
			castbar.button:SetPoint("TOPRIGHT",self.Castbar.bg,"TOPLEFT",-Scale(2),0)
		elseif unit == "target" then
			castbar.button:ClearAllPoints()
			castbar.button:SetPoint("LEFT",self.Castbar.bg,"RIGHT",Scale(2),0)
		end

		castbar.Icon = castbar.icon

		--cast bar latency on player
		if unit == "player" then
			castbar.safezone =	 castbar:CreateTexture(nil, "ARTWORK")
			castbar.safezone:SetTexture(normTex)
			castbar.safezone:SetVertexColor(0.69, 0.31, 0.31, 0.75)
			castbar.SafeZone = castbar.safezone
		end

		--Castbar time string
		castbar.time = castbar.button:CreateFontString(nil, "OVERLAY")
		--castbar.time:SetFontObject(font2)
		if(unit ~= "focus") then
			castbar.time:SetFont(font2, 12, "OUTLINE")
		else
			castbar.time:SetFont(font2, 16, "OUTLINE")
		end
		castbar.time:SetPoint("RIGHT", castbar, "RIGHT", Scale(-4), 0)
		castbar.time:SetTextColor(0.84, 0.75, 0.65)
		castbar.time:SetShadowOffset(0.8,-0.8)
		castbar.time:SetJustifyH("RIGHT")

		castbar.Time = castbar.time

		--castbar Spark
		local Spark = castbar:CreateTexture(nil, "OVERLAY")
		Spark:SetSize(20, 20)
		Spark:SetBlendMode("ADD")
		Spark:SetPoint("CENTER", castbar:GetStatusBarTexture(), "RIGHT", 0, 0)
		castbar.Spark = Spark

		-- Add Shield
		if unit ~= "player" then
			local Shield = castbar:CreateTexture(nil, 'OVERLAY')
			Shield:SetTexture(132360)
			Shield:SetSize(20, 20)
			Shield:SetPoint('RIGHT', castbar, 'LEFT')
			Shield:SetTexCoord(0.03, 0.97, 0.03, 0.97)
			castbar.Shield = Shield
		end
	
		-- GCD frame for player
		if (unit == "player") then
			---@class SanUICastBarGCD: StatusBar
			self.GCD = CreateFrame("StatusBar", nil, self)
			self.GCD:SetHeight(Scale(5))
			self.GCD:SetWidth(Scale(150))
			self.GCD:SetPoint('TOPLEFT',castbar, 'BOTTOMLEFT', 0, -Scale(4))
			self.GCD:SetPoint('TOPRIGHT',castbar, 'BOTTOMRIGHT', 0, -Scale(4))
			self.GCD:SetStatusBarTexture(normTex)
			self.GCD:SetStatusBarColor(0.8,0.8,0.8)

			---@class SanUICastBarGCDBorder: Frame
			---@field SetBackdropBorderColor function
			local gcdcastborder = CreateFrame("Frame", nil, self.GCD)
			gcdcastborder:SetSize(Scale(1), Scale(1))
			S.CreateBackdrop(gcdcastborder, "Transparent")
			gcdcastborder.SetBackdropBorderColor(C.colors.BackdropColor)
			gcdcastborder:ClearAllPoints()
			gcdcastborder:SetPoint("TOPLEFT", self.GCD, -Scale(2), Scale(2))
			gcdcastborder:SetPoint("BOTTOMRIGHT", self.GCD, Scale(2), Scale(-2))
			gcdcastborder:SetFrameStrata(self.GCD:GetFrameStrata())
			gcdcastborder:SetFrameLevel(self.GCD:GetFrameLevel()-1)

			self.GCD.border = gcdcastborder
		end

		if (unit == "focus") then
			self.Buffs:SetPoint("TOPLEFT", self, "BOTTOMLEFT", 0, -Scale(25))
		elseif (unit == "target") then
			self.Buffs:SetPoint("TOPLEFT", self, "BOTTOMLEFT", 10, -Scale(25))
		end

		castbar.CreatePip = function(element, stage)
			---@class SanUICastBarPip: Frame
			---@field Backdrop BackdropTemplate
			---@field SetBackdropColor function
			local f = CreateFrame("Frame", nil, castbar, 'CastingBarFrameStagePipTemplate')
			f.maintex = f:CreateTexture(nil, 'OVERLAY')
			f.maintex:SetTexture(normTex)
			f.maintex:SetVertexColor(unpack(C.colors.BorderColor))
			f.maintex:SetAllPoints()
			--local arrow = CreateFrame("Frame", nil, f)
			f.tex = f:CreateTexture(nil, 'OVERLAY')
			f.tex:SetTexture(C.medias.textures.ArrowUp)
			f.tex:SetPoint("TOP", f, "BOTTOM", 0, -S.scale1)
			f.tex:SetWidth(8)
			f.tex:SetHeight(8)
			f:SetWidth(S.scale1)
			return f
		end
	end
end,
}

oUF_Hank_hooks.ChangeFocus = {
sharedStyle = function(self, unit, isSingle)

	if (unit == "focustarget") then
		self.name:ClearAllPoints()
		self.name:SetPoint("RIGHT")
	end


	if (unit == "focus") then

		for i=1,3 do
			self.health[i]:ClearAllPoints()
		end

		self.health[3]:SetPoint("RIGHT")
		--self.health[3]:SetPoint("RIGHT", self.health[4], "LEFT")
		self.health[2]:SetPoint("RIGHT", self.health[3], "LEFT")
		self.health[1]:SetPoint("RIGHT", self.health[2], "LEFT")

		self.power:ClearAllPoints()
		self.name:ClearAllPoints()
		self.RaidTargetIndicator:ClearAllPoints()

		self.name:SetPoint("BOTTOMRIGHT",  self.power, "TOPRIGHT")
		self.power:SetPoint("BOTTOMRIGHT", self.health[1], "BOTTOMLEFT")
		self.RaidTargetIndicator:SetPoint("RIGHT",self.name,"LEFT",-10,0)
		self.RaidTargetIndicator:SetPoint("TOP", self, "TOP", 0, -5)


		self.Buffs.initialAnchor = "RIGHT"
		self.Buffs["growth-x"] = "LEFT"
		self.Debuffs.initialAnchor = "RIGHT"
		self.Debuffs["growth-x"] = "LEFT"

	end
end,

PostUpdateName = function(self)

	if self.unit ~= "focus" then return end

	if (self.name) then
		self.RaidTargetIndicator:ClearAllPoints()
		self.RaidTargetIndicator:SetPoint("TOP", self, "TOP", 0, -5)
		-- Reanchor raid icon to the largest string (either name or power)
		if self.name:GetWidth() >= self.power:GetWidth() then
			self.RaidTargetIndicator:SetPoint("RIGHT", self.name, "LEFT", -10, 0)
		else
			self.RaidTargetIndicator:SetPoint("RIGHT", self.power, "LEFT", -10, 0)
		end
	end

end,

UpdateHealth = function(self)

	if self.unit ~= "focus" then return end

	local h, hMax

	-- In vehicle
	h, hMax = UnitHealth(self.unit), UnitHealthMax(self.unit)


	local status = (not UnitIsConnected(self.unit) or nil) and "Off" or UnitIsGhost(self.unit) and "G" or UnitIsDead(self.unit) and "X"

	if not status then
		local hPerc = ("%d"):format(h / hMax * 100 + 0.5)
		local len = string.len(hPerc)

		for i = 1, 3 do
				if i > len then
					self.health[4 - i]:Hide()
					self.healthFill[4 - i]:Hide()
				else
					local digit = string.sub(hPerc , -i, -i)

					self.health[4 - i]:SetSize(oUF_Hank.digitTexCoords[digit][2], oUF_Hank.digitTexCoords["height"])
					self.health[4 - i]:SetTexCoord(oUF_Hank.digitTexCoords[digit][1] / oUF_Hank.digitTexCoords["texWidth"], (oUF_Hank.digitTexCoords[digit][1] + oUF_Hank.digitTexCoords[digit][2]) / oUF_Hank.digitTexCoords["texWidth"], 1 / oUF_Hank.digitTexCoords["texHeight"], (1 + oUF_Hank.digitTexCoords["height"]) / oUF_Hank.digitTexCoords["texHeight"])
					self.health[4 - i]:Show()
					self.healthFill[4 - i]:SetSize(oUF_Hank.digitTexCoords[digit][2], oUF_Hank.digitTexCoords["height"] * h / hMax)
					self.healthFill[4 - i]:SetTexCoord(oUF_Hank.digitTexCoords[digit][1] / oUF_Hank.digitTexCoords["texWidth"], (oUF_Hank.digitTexCoords[digit][1] + oUF_Hank.digitTexCoords[digit][2]) / oUF_Hank.digitTexCoords["texWidth"], (2 + 2 * oUF_Hank.digitTexCoords["height"] - oUF_Hank.digitTexCoords["height"] * h / hMax) / oUF_Hank.digitTexCoords["texHeight"], (2 + 2 * oUF_Hank.digitTexCoords["height"]) / oUF_Hank.digitTexCoords["texHeight"])
					self.healthFill[4 - i]:Show()
				end
			end



		self.power:ClearAllPoints()
		self.power:SetPoint("BOTTOMRIGHT", self.health[4-len], "BOTTOMLEFT", 0, 0)

	else

		self.power:ClearAllPoints()
		self.power:SetPoint("BOTTOMRIGHT", self.health[3], "BOTTOMLEFT", 0, 0)

	end
end,
}

oUF.Tags.Events["myclassicpower"] = "UNIT_MAXPOWER UNIT_POWER_FREQUENT"
oUF.Tags.Methods["myclassicpower"] = function(unit)
	local mini = UnitPower(unit)
	local maxi = UnitPowerMax(unit)
	if(mini == 0 or maxi == 0 or not UnitIsConnected(unit) or UnitIsDead(unit) or UnitIsGhost(unit)) then return end
	local color = {1,1,1}
	return ("|cFF%.2x%.2x%.2x%s /%s|r"):format(color[1] * 255, color[2] * 255, color[3] * 255, mini, maxi)
end

oUF_Hank_hooks.customPowerBar = {
	sharedStyle = function(self, unit, isSingle)
	if unit == "player" then
		--this adds a second power bar
		--and does not replace the old one (which is self.power not self.Power)
		---@class SanUIPlayerExtraPowerBar: StatusBar
		local power = CreateFrame('StatusBar', "MyPower", self)
		power:SetWidth(248)
		power:SetHeight(15)
		power:SetPoint("BOTTOMRIGHT", self.health[4], "BOTTOMLEFT", 351, 33) ---160, -200
		power:SetFrameStrata("MEDIUM")
		power:SetFrameLevel(13)
		power:SetStatusBarTexture(normTex)
		power:SetMinMaxValues(0,UnitPowerMax(unit))

		local powerPanel = CreateFrame("Frame", "MyPowerPanel", power)
		S.CreateBackdrop(powerPanel)
		powerPanel:SetFrameStrata("MEDIUM")
		powerPanel:SetFrameLevel(power:GetFrameLevel()-1)
		powerPanel:SetPoint("TOPLEFT",Scale(-2), Scale(2))
		powerPanel:SetPoint("BOTTOMRIGHT",Scale(2), -Scale(2))

		local powerValue = power:CreateFontString(nil, "OVERLAY")
		powerValue:SetFont(font2,13,"OUTLINE")
		powerValue:SetPoint("RIGHT", power, "RIGHT", -4, -1)
		powerValue:SetJustifyH("CENTER")
		powerValue:SetTextColor(1, 1, 1)
		self.powerValue = powerValue
		self:Tag(powerValue, '[myclassicpower]')
		power.value = powerValue

		power.colorDisconnected = true
		power.Smooth = true

		--no idea why we need this...
		power:SetFrameLevel(powerPanel:GetFrameLevel()+1)

		self.Power = power

	end
	end,
 }
