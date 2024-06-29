local addonName, addon = ...
local S,C = unpack(addon)

local Scale = S.Scale
local bnames = {
	main1 = "DominosActionButton",
	main2 = "MultiBarBottomLeftActionButton",
	right_of_coolline = "MultiBarBottomRightActionButton",
	stance = "DominosStanceButton",
	right = "MultiBarLeftActionButton"
}

local absize = C.sizes.actionbuttons
local abspacing = C.sizes.actionbuttonspacing
local Size = absize
local Spacing = abspacing
local uiscale = UIParent:GetScale()

S.styleActionButton = function(button)
	S.Kill(button.IconMask)
	S.Kill(button.SlotBackground)
	S.Kill(button.NormalTexture)
	S.Kill(button.Border)
	
	button:SetSize(absize, absize)
	S.CreateBackdrop(button, "Transparent")
	
	-- This works better for me...
	local br = button.Backdrop.BorderRight
	br:ClearAllPoints()
	br:SetPoint("TOPRIGHT", button.Backdrop, "TOPRIGHT", S.scale1, 0)
	br:SetPoint("BOTTOMRIGHT", button.Backdrop, "BOTTOMRIGHT", S.scale1, 0)
	
	-- Highlight Texture
	S.Kill(button.HighlightTexture)
	local Highlight = button:CreateTexture()
	Highlight:SetColorTexture(1, 1, 1, 0.3)
	--Highlight:SetInside()
	button:SetHighlightTexture(Highlight)
	button.HighlightTexture = Highlight
	
	-- Pushed Texture
	S.Kill(button.PushedTexture)
	local Pushed = button:CreateTexture()
	Pushed:SetColorTexture(0.9, 0.8, 0.1, 0.3)
	--Pushed:SetInside()
	button.PushedTexture = Pushed
	button:SetPushedTexture(Pushed)

	-- Checked Texture
	S.Kill(button.CheckedTexture)
	local Checked = button:CreateTexture()
	Checked:SetColorTexture(0, 1, 0, 0.3)
	--Checked:SetInside()
	button.CheckedTexture = Checked
	button:SetCheckedTexture(Checked)

	button.cooldown:SetAllPoints()
	button.icon:SetTexCoord(0.1, 0.9, 0.1, 0.9)
	button.styled = true
	
	button.Count:ClearAllPoints()
	button.Count:SetPoint("BOTTOMRIGHT", button, "BOTTOMRIGHT", -S.scale1, S.scale1)
	
	button.HotKey:ClearAllPoints()
	button.HotKey:SetPoint("TOPRIGHT", button, "TOPRIGHT", -S.scale1, -S.scale2)
end

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
		  local b = _G[bnames.main2 .. i]
		  local c = _G[bnames.main1 .. 13-i]
		  b:ClearAllPoints()
		  c:ClearAllPoints()
		  
		  if not b.styled then
			S.styleActionButton(b)
		  end
		  if not c.styled then
			S.styleActionButton(c)
		  end
		  
		  if i == 1 then
			b:SetPoint("BOTTOMLEFT", UIParent, "BOTTOM", Spacing/2, 3 + Spacing)
			c:SetPoint("BOTTOMRIGHT", UIParent, "BOTTOM", -Spacing/2, 3 + Spacing)
		  else
			local xoff = (i-1)*Size + i * Spacing - Spacing / 2
			b:SetPoint("BOTTOMLEFT", UIParent, "BOTTOM", xoff, 3 + Spacing)
			c:SetPoint("BOTTOMRIGHT", UIParent, "BOTTOM", -xoff, 3 + Spacing)
		  end
		end
		
		DominosFrame5:SetNumButtons(8)
		-- same as buttons below, plus half the panel height plus have a spacing
		local yoff = 3 + Spacing + S.panels.actionbarpanel1:GetHeight()-- + Spacing/2 
		for i = 1, 8 do
			local b = _G[bnames.right_of_coolline .. i]
			b:ClearAllPoints()
			if not b.styled then
				S.styleActionButton(b)
			end
			
			local xoff = (i+4-1)*Size + (i+3) * Spacing + Spacing / 2
			b:SetPoint("BOTTOMLEFT", UIParent, "BOTTOM", xoff, yoff)
		end
		
		
		for i = 1,5 do
			local b = _G[bnames.stance .. i]
			
			if b then
				b:ClearAllPoints()
				if not b.styled then
					S.styleActionButton(b)
				end
				
				xoff = (i-12-1)*Size + (i-13) * Spacing + Spacing / 2
				b:SetPoint("BOTTOMLEFT", UIParent, "BOTTOM", xoff, yoff)
			end
		end
		
		local barright = S.panels.actionbarright
		for i = 1,12 do
			local b = _G[bnames.right .. i]
			b:ClearAllPoints()
			if not b.styled then
				S.styleActionButton(b)
				-- Whyever we need this...
				b.HotKey:ClearAllPoints()
				b.HotKey:SetPoint("TOPRIGHT", b, "TOPRIGHT", -S.scale1, -S.scale4)
			end
			
			b:SetPoint("TOP", barright, "TOP", 0, - i * abspacing - (i-1)*absize)
		end
		
	end	
end
local hookfun = function()
	if S["Modes"][SanUIdb["Mode"]]["ActionButtons"] then
		S.switchActionButtons(S["Modes"][SanUIdb["Mode"]]["ActionButtons"])
	else
		print("No ActionButtons profile for mode "..SanUIdb["Mode"].."! Can't Switch!")
	end
end
hooksecurefunc(Dominos.ActionButtons,"PLAYER_ENTERING_WORLD", hookfun)