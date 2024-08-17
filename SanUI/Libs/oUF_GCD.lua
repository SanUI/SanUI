local _, addon = ...

local GetTime = GetTime
local GetSpellCooldown = C_Spell.GetSpellCooldown

local spellid = 61304

local OnUpdateGCD = function(self)
	local perc = (GetTime() - self.starttime) / self.duration
	if perc > 1 then
		self:Hide()
	else
		self:SetValue(perc)
	end
end

local OnHideGCD = function(self)
 	self:SetScript('OnUpdate', nil)
end


local OnShowGCD = function(self)
	self:SetScript('OnUpdate', OnUpdateGCD)
end

local Update = function(self, event, unit)
	if self.GCD then
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
	end
end


local Enable = function(self)
	if (self.GCD) then
		self.GCD:Hide()
		self.GCD.starttime = 0
		self.GCD.duration = 0
		self.GCD:SetMinMaxValues(0, 1)

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