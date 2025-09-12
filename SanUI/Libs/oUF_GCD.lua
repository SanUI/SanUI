local _, addon = ...
local S, C = unpack(SanUI)

local GetTime = GetTime
local GetSpellCooldown = C_Spell.GetSpellCooldown
local GetCVar = GetCVar
local Scale = S.Scale
local normTex = C.medias.textures.StatusbarNormal

local spellid = 61304

local OnUpdateGCD = function(self)
	local perc = (GetTime() - self.starttime) / self.duration
	if perc > 1 then
		self:Hide()
		self:SetStatusBarColor(self.orig_r, self.orig_g, self.orig_b, self.orig_a)
	else
		self:SetValue(perc)
		
		if perc > 1 - self.queue_perc then
			self:SetStatusBarColor(0,0.8,0)
		end
	end
end

local OnHideGCD = function(self)
	self.queue_tick:Hide()
 	self:SetScript('OnUpdate', nil)
end


local OnShowGCD = function(self)
	self:SetScript('OnUpdate', OnUpdateGCD)
	local spell_queue_window = GetCVar("SpellQueueWindow")/1000
	self.queue_perc = spell_queue_window / self.duration
	self.queue_tick:ClearAllPoints()
	self.queue_tick:SetPoint("RIGHT", self, "RIGHT", -self.queue_perc * self:GetWidth(),0)
	self.queue_tick:Show()
end

local Update = function(self, event, unit)
	--aif self.GCD then
		local cdinfo = GetSpellCooldown(spellid)

		local start = cdinfo.startTime
		if (not start) then return end

		local dur = cdinfo.duration or 0

		if (dur == 0) then
			self.GCD:Hide()
		else
			self.GCD.starttime = start
			self.GCD.duration = dur
			self.GCD:Show()
		end
	--end
end


local Enable = function(self)
	if (self.GCD) then
		self.GCD:Hide()
		self.GCD.starttime = 0
		self.GCD.duration = 0
		self.GCD:SetMinMaxValues(0, 1)
		
		self.GCD.orig_r, self.GCD.orig_g, self.GCD.orig_b, self.GCD.orig_a = self.GCD:GetStatusBarColor()
		self.spell_queue_window = GetCVar("SpellQueueWindow")/1000
		
		local queue_tick = CreateFrame("Frame", nil, self.GCD)
		queue_tick:SetWidth(Scale(3))
		queue_tick:SetHeight(self.GCD:GetHeight())
		S.CreateBackdrop(queue_tick)
		queue_tick.SetBackdropColor({0.8,0,0})
		queue_tick.SetBackdropBorderColor({0.8,0,0})
		--local tex = queue_tick:CreateTexture()
		--tex:SetTexture(normTex)
		--tex:SetColorTexture(1,1,1)

		queue_tick:Hide()
		--queue_tick.tex = tex
		self.GCD.queue_tick = queue_tick
		
		self:RegisterEvent('ACTIONBAR_UPDATE_COOLDOWN', Update, true)
		self.GCD:SetScript('OnHide', OnHideGCD)
		self.GCD:SetScript('OnShow', OnShowGCD)
	end
end


local Disable = function(self)
	if (self.GCD) then
		self:UnregisterEvent('ACTIONBAR_UPDATE_COOLDOWN')
		self.GCD:Hide()
	end
end

addon.oUF:AddElement('GCD', Update, Enable, Disable)