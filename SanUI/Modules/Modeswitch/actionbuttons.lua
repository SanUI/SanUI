local addonName, addon = ...
local S,C = unpack(addon)

S.hookActionBar1 = function() end
local Size = C.ActionBars.NormalButtonSize
local Spacing = C.ActionBars.ButtonSpacing

S.switchActionButtons = function(profile)

	-- this is neede b/c we hook this function below, might be called in
	-- combat
	if InCombatLockdown() then return end

	local button

	if profile == "SanBear" then
		for i = 1, 12 do
			button = _G["ActionButton"..i]
			button:ClearAllPoints()
			
			if i == 1 then
				button:SetPoint("CENTER",UIParent,-89,-185)
			elseif 1 < i and i < 7 then
				button:SetPoint("LEFT",_G["ActionButton"..(i-1)],"RIGHT",Spacing, 0)
			elseif i == 7 then
				button:SetPoint("TOPLEFT",ActionButton2,"BOTTOMLEFT",0, -Spacing)
			elseif i == 8 then
				button:SetPoint("TOPLEFT",ActionButton7,"BOTTOMLEFT",0, -Spacing)	
			else
				local xoff = (12-i)*Size + (12-i)* Spacing + Spacing/2
				button:SetPoint("BOTTOMRIGHT", UIParent, "BOTTOM", -xoff, 3 + Spacing)
			end
		end
	elseif profile == "SahneUnholy" then
		for i = 1, 12 do
			button = _G["ActionButton"..i]
			button:ClearAllPoints()
			if i == 1 then
				button:SetPoint("CENTER",UIParent,-89,-185)
			elseif i == 7 then
				button:SetPoint("TOPLEFT",ActionButton2,"BOTTOMLEFT",0,-7)
			elseif i == 9 then
				button:SetPoint("BOTTOMRIGHT", UIParent, "BOTTOM", 8 * Size + 8 * Spacing + Spacing/2, 3 + Spacing)	
			else
				local previous = _G["ActionButton"..i-1]
				button:SetPoint("LEFT", previous, "RIGHT", Spacing, 0)
			end
		end
	elseif profile == "PRet" then
		for i = 1, 12 do
			button = _G["ActionButton"..i]
			button:ClearAllPoints()
			if i == 1 then
				button:SetPoint("CENTER",UIParent,-89,-185)
			elseif i == 7 then
				button:SetPoint("TOPLEFT",ActionButton2,"BOTTOMLEFT",0, -C["ActionBars"].ButtonSpacing)
			elseif i == 9 then
				button:SetPoint("BOTTOMLEFT", 9*C["ActionBars"].NormalButtonSize + 3*C["ActionBars"].ButtonSpacing, C["ActionBars"].ButtonSpacing)	
			else
				local previous = _G["ActionButton"..i-1]
				button:SetPoint("LEFT", previous, "RIGHT", C["ActionBars"].ButtonSpacing, 0)
			end
		end
	elseif profile == "DoviBM" then
		for i = 1, 12 do
			button = _G["ActionButton"..i]
			button:ClearAllPoints()
			
			if i == 1 then
				button:SetPoint("CENTER",UIParent,-89,-100)
			elseif 1 < i and i < 7 then
				button:SetPoint("LEFT",_G["ActionButton"..(i-1)],"RIGHT",Spacing, 0)
			elseif i == 7 then
				button:SetPoint("TOPLEFT",ActionButton2,"BOTTOMLEFT",0, -Spacing)
			elseif i == 8 then
				button:SetPoint("TOPLEFT",ActionButton7,"BOTTOMLEFT",0, -Spacing)	
			else
				local xoff = (12-i)*Size + (12-i)* Spacing + Spacing/2
				button:SetPoint("BOTTOMRIGHT", UIParent, "BOTTOM", -xoff, 3 + Spacing)
			end
		end
	elseif profile == "ToviAug" then
		for i=1, 12 do
		  local b = _G["MultiBarBottomLeftButton"..i]
		  local c = _G["ActionButton"..13-i]
		  b:ClearAllPoints()
		  c:ClearAllPoints()

		  -- Seems contrieved, but was the only way I really could align the buttons
		  -- and ActionBar1 properly
		  if i == 1 then
			b:SetPoint("BOTTOMLEFT", UIParent, "BOTTOM", Spacing/2, 3 + Spacing)
			c:SetPoint("BOTTOMRIGHT", UIParent, "BOTTOM", -Spacing/2, 3 + Spacing)
		  else
			local xoff = (i-1)*Size + (i-1)* Spacing + Spacing/2
			local eightwidth = 8 * Size + 7 * Spacing
			if i >= 5 then
				b:SetPoint("BOTTOMLEFT", UIParent, "BOTTOM", xoff, 3 + Spacing)
				c:SetPoint("RIGHT", UIParent, "CENTER", -xoff + eightwidth + Spacing , -150)
			else
				b:SetPoint("BOTTOMLEFT", UIParent, "BOTTOM", xoff, 3 + Spacing)
				c:SetPoint("BOTTOMRIGHT", UIParent, "BOTTOM", -xoff, 3 + Spacing)
			end
		  end
		end
	else
		for i=1, 12 do
		  local b = _G["MultiBarBottomLeftButton"..i]
		  local c = _G["ActionButton"..13-i]
		  b:ClearAllPoints()
		  c:ClearAllPoints()

		  -- Seems contrieved, but was the only way I really could align the buttons
		  -- and ActionBar1 properly
		  if i == 1 then
			b:SetPoint("BOTTOMLEFT", UIParent, "BOTTOM", Spacing/2, 3 + Spacing)
			c:SetPoint("BOTTOMRIGHT", UIParent, "BOTTOM", -Spacing/2, 3 + Spacing)
		  else
			local xoff = (i-1)*Size + (i-1)* Spacing + Spacing/2
			b:SetPoint("BOTTOMLEFT", UIParent, "BOTTOM", xoff, 3 + Spacing)
			c:SetPoint("BOTTOMRIGHT", UIParent, "BOTTOM", -xoff, 3 + Spacing)
		  end
		end
	end	
	
	S.hookActionBar1 = function()
		S.switchActionButtons(profile)
	end

end

-- Tukui rearranges the buttons on each PLAYER_ENTERING_WORLD
-- so we get the function and hook this switch function
hooksecurefunc(S["ActionBars"],"Enable",function()
	if not (S.ActionBars and S.ActionBars.Bars and S["ActionBars"].Bars.Bar1) then
		print("No ActionBar1! Can't hook OnEvent!")
	else
		S["ActionBars"].Bars.Bar1:HookScript("OnEvent",function(self, event, unit, ...)
			--if event == "PLAYER_ENTERING_WORLD" then
				S.hookActionBar1()
			--end
		end)
	end
end)
