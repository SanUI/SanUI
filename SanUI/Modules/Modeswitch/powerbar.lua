local addonName, addon = ...
local S, C = unpack(addon)

local Scale = S.Scale

S.switchPowerbar = function(profile)
	local player = S.unitFrames.player

  local wrathname = GetSpellInfo(190984)
  local starfirename = GetSpellInfo(194153)
  local TukuiBar1 = S.ActionBars and S.ActionBars.Bars and S["ActionBars"].Bars.Bar1

  local Power = player.Power
  Power.update_surge = function(self, event, unit)
    self.Power:ForceUpdate(event, unit)
  end

  player:RegisterEvent('UNIT_SPELLCAST_START', Power.update_surge)
  player:RegisterEvent('UNIT_SPELLCAST_STOP', Power.update_surge)
  player:RegisterEvent('UNIT_SPELLCAST_FAILED', Power.update_surge)
  player:RegisterEvent('UNIT_SPELLCAST_SUCCEEDED', Power.update_surge)
  player:RegisterEvent('UNIT_DISPLAYPOWER', Power.update_surge)

	if not Power then
		print("No Power bar on oUF_player found!")
		return
	end

	if profile == "SanBear" or profile == "SahneUnholy" then
    Power.update_surge = function(self, event, unit) end
		Power.PostUpdate = function(self,unit, cur, min, max)
			local quotient = (max and max > 0) and cur/max or 0
			if quotient >= .6  and quotient < .9 then
				Power:SetStatusBarColor(1,.49,.04)
			elseif quotient >= .9 then
				Power:SetStatusBarColor(0.5,1,0)
			else
				Power:SetStatusBarColor(0.69, 0.31, 0.31)
			end
		end
	elseif profile == "SanChicken" then
		Power.PostUpdate = function(self,unit, cur, min, max)
      if cur > 80 then
        Power:SetStatusBarColor(0.69, 0.31, 0.31)
			elseif cur >= 50 and cur < 80 then
				Power:SetStatusBarColor(0,1,1)
      elseif cur >= 30 and cur < 80 then
        Power:SetStatusBarColor(0.5,1,0)
      else
        local _, _, _, _, _, _, _, _, spellID = UnitCastingInfo(unit)
        local spellname = GetSpellInfo(spellID) or ""

        if spellname == wrathname and cur + 6 >= 30 then
          Power:SetStatusBarColor(0.5,1,0)
        elseif spellname == starfirename and cur + 8 >= 30 then
          Power:SetStatusBarColor(0.5,1,0)
        else
          Power:SetStatusBarColor(0.69, 0.31, 0.31)
        end
      end
    end
	elseif profile == "SanCat" then
    Power.update_surge = function(self, event, unit) end
		Power.PostUpdate = function(self,unit, cur, min, max)
			local quotient = max and cur/max or 0
			if quotient >= .3  and quotient < .9 then
				Power:SetStatusBarColor(1,.49,.04)
			elseif quotient >= .9 then
				Power:SetStatusBarColor(0.5,1,0)
			else
				Power:SetStatusBarColor(0.69, 0.31, 0.31)
			end
		end
	else
    Power.update_surge = function(self, event, unit) end
		Power.PostUpdate = nil
	end

	if profile == "SanCat" or profile == "SanChicken" then
		Power:ClearAllPoints()
		Power:SetPoint("CENTER",UIParent,"CENTER",0,-188)
		Power:SetHeight(15)
		Power:SetWidth(288)
		Power:Show()
	elseif profile == "SanBear" then
		local Size = C.sizes.actionbuttons
		local Spacing = C.sizes.actionbuttonspacing
		Power:ClearAllPoints()
		--why are those offsets necessary? look at Bar1.lua from Tukui, this should be without offsets
		Power:SetPoint("LEFT",S.panels.actionbarpanel1,Spacing+1, 0)
		Power:SetWidth(8 * Size + 7 * Spacing-3)
		Power:SetHeight(Scale(Size)-3)
		Power:Show()
	elseif profile == "SahneUnholy" then
		Power:ClearAllPoints()
		--why are those offsets necessary? look at Bar1.lua from Tukui, this should be without offsets
		Power:SetPoint("BOTTOMLEFT",TukuiBar1,C["ActionBars"].ButtonSpacing+2, C["ActionBars"].ButtonSpacing+2)
		Power:SetPoint("RIGHT",ActionButton9,"LEFT",-C["ActionBars"].ButtonSpacing-1,0)
		Power:SetHeight(C["ActionBars"].NormalButtonSize-3)
		Power:Show()
	elseif profile == "Rogue" then
		Power:ClearAllPoints()
		Power:SetPoint("CENTER",UIParent,"CENTER",0,-190)
		Power:Show()
		Power:SetWidth(288)
	elseif profile == "Manyak" then
		Power:ClearAllPoints()
		Power:SetPoint("TOP",player.Castbar,"BOTTOM",0,-4)
		Power:SetHeight(10)
		Power:SetWidth(300)
		Power:Show()
	elseif profile == "Hidden" then
		Power:Hide()
	end

end
