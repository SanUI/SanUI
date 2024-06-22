-- This file originated as oUF_ComboPointsBar of Tukui by Tukz (see tukui.org). It has been modified to fit the needs of SanUI, and is
-- distributed with SanUI per express permission of Tukz. For support, visit https://www.wowinterface.com/downloads/info18562-SanUI.html.

local _, ns = ...
local oUF = SanUI.oUF
assert(oUF, "oUF_CPoints cannot find an instance of oUF. If your oUF is embedded into a layout, it may not be embedded properly.")

local GetComboPoints = GetComboPoints
local MaxComboPts = 6

local Colors = {
	[1] = {.69, .31, .31, 1},
	[2] = {.65, .42, .31, 1},
	[3] = {.65, .63, .35, 1},
	[4] = {.50, .63, .35, 1},
	[5] = {.33, .63, .33, 1},
	[6] = {.03, .63, .33, 1},
}

local SetMaxCombo = function(self)
	local cpb = self.CPoints
	local MaxCombo = UnitPowerMax("player", Enum.PowerType.ComboPoints)

	if MaxCombo == MaxComboPts then
		for i = 1, MaxComboPts do
			cpb[i]:Show()
		end
	else
		for i = 1, MaxComboPts do
			
			if i > 5 then
				cpb[i]:Hide()
			else
				cpb[i]:Show()
			end
		end
	end
	
	cpb.MaxCombo = MaxCombo
end

local Update = function(self, event, unit, powerType)
	if(self.unit ~= unit and (powerType and (powerType ~= 'COMBO_POINTS'))) then return end

	local cpb = self.CPoints
	local points
	local max = UnitPowerMax("player", Enum.PowerType.ComboPoints)
	local currentmax = cpb.MaxCombo

	if cpb.PreUpdate then
		cpb:PreUpdate(points)
	end
	
	if max ~= currentmax then
		SetMaxCombo(self)
	end
	
	if UnitHasVehicleUI("player") then
		points = GetComboPoints("vehicle", "target")
	else
		points = GetComboPoints("player", "target")
	end

	if points then
		-- update combos display
		for i = 1, MaxComboPts do
			if i <= points then
				cpb[i]:SetAlpha(1)
			else
				cpb[i]:SetAlpha(0)
			end
		end
	end
	
	if self.Castbar.place then
		self.Castbar.place({ cpoints = points, str = "warakhhhhhhhh"})
	end
--[[
	if points > 0 then
		cpb:Show()
	else
		cpb:Hide()
	end

	if cpb.PostUpdate then
		cpb:PostUpdate(points)
	end
	]]
end

local Path = function(self, ...)
	return (self.CPoints.Override or Update) (self, ...)
end

local ForceUpdate = function(element)
	return Path(element.__owner, 'ForceUpdate', element.__owner.unit, "COMBO_POINTS")
end

local Enable = function(self, unit)
	local cpb = self.CPoints
	if(cpb) then
		cpb.__owner = self
		cpb.ForceUpdate = ForceUpdate

		self:RegisterEvent('UNIT_POWER_UPDATE', Path, true)
		self:RegisterEvent('PLAYER_TARGET_CHANGED', Path, true)
		self:RegisterEvent('PLAYER_TALENT_UPDATE', SetMaxCombo, true)
		self:RegisterEvent('UNIT_POWER_POINT_CHARGE', Path)

		for i = 1, MaxComboPts do
			local Point = cpb[i]

			--Point:SetFrameLevel(cpb:GetFrameLevel() + 1)		
			Point.Width = Point:GetWidth()
			Point:Hide()
		end
		
		--cpb:Hide()
		
		SetMaxCombo(self)

		return true
	end
end

local Disable = function(self)
	local cpb = self.CPoints
	if(cpb) then
		self:UnregisterEvent('UNIT_POWER_UPDATE', Path)
		self:UnregisterEvent('PLAYER_TARGET_CHANGED', Path)
		self:UnregisterEvent('PLAYER_TALENT_UPDATE', SetMaxCombo)
		self:UnregisterEvent('UNIT_POWER_POINT_CHARGE', Path)
	end
end

oUF:AddElement('CPoints', Path, Enable, Disable)
