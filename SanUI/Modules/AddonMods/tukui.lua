local addonName, addon = ...
local S,C,L = unpack(addon)

local Scale = S.Toolkit.Functions.Scale

S["ActionBars"].StartHighlight = function(self) end
S["ActionBars"].StopHighlight = function(self) end

hooksecurefunc(S["UnitFrames"], "Nameplates", function(self)
  self.Debuffs.disableMouse = true
  end)

-- Minimap
hooksecurefunc(S["Maps"]["Minimap"], "Enable", function()
  Minimap:ClearAllPoints()
  Minimap:SetPoint("TOPLEFT",UIParent,"TOPLEFT",5,-5)
  
  --[[
  local Mail = MiniMapMailFrame
  Mail:ClearAllPoints()
  Mail:SetPoint("TOPRIGHT", 0, 0)
  --]]
  
  -- This is needed for the tracking menu (left click on zone name), it's anchored to this
  MinimapBackdrop:ClearAllPoints()
  MinimapBackdrop:SetPoint("CENTER",Minimap,"BOTTOM")
  
  --QueueStatusMinimapButton:ClearAllPoints()
  --QueueStatusMinimapButton:SetPoint("BOTTOMRIGHT",Minimap,"BOTTOMRIGHT")
end)

-- Rearrange action bars
hooksecurefunc(S["ActionBars"], "Enable", function()
	if not C.ActionBars.Enable then return end
	local TukuiBar1 = S["ActionBars"].Bars.Bar1
	local TukuiBar2 = S["ActionBars"].Bars.Bar2
	local TukuiBar3 = TukuiActionBar3
	local TukuiBar4 = S["ActionBars"].Bars.Bar4
	local TukuiBar5 = S["ActionBars"].Bars.Bar5
	local PetBar = S["ActionBars"].Bars.Pet
	local TukuiStanceBar = S["ActionBars"].Bars.Stance

	-- Bars: Bar 1 will contain all main Buttons, Bar 2 is just moved on top of
	-- it, background made invisible, 3 and 4 must go, Bar 5 stays at the rigt, 6
	-- & 7 anchor to it

	local Size = C.ActionBars.NormalButtonSize
	local Spacing = C.ActionBars.ButtonSpacing

	TukuiBar1:SetHeight(Size + (Spacing * 2))
	TukuiBar1:SetWidth((Size * 24) + (Spacing * 25))
	TukuiBar1:SetPoint("BOTTOM", UIParent, "BOTTOM", 0, 3)

	TukuiBar1:HookScript("OnEvent", function(self, event, unit, ...)
	if InCombatLockdown() then return end

	for i=1, 12 do
	  local b = _G["MultiBarBottomLeftButton"..i]
	  local c = _G["ActionButton"..13-i]
	  b:ClearAllPoints()
	  c:ClearAllPoints()
	  b:SetSize(Scale(Size), Scale(Size))
	  c:SetSize(Scale(Size), Scale(Size))

	  -- Seems contrieved, but was the only way I really could align the buttons
	  -- and ActionBar1 properly
	  if i == 1 then
		b:SetPoint("BOTTOMLEFT", UIParent, "BOTTOM", Spacing/2, 3 + Spacing)
		c:SetPoint("BOTTOMRIGHT", UIParent, "BOTTOM", -Spacing/2, 3 + Spacing)
	  else
		local xoff = (i-1)*Size + (i-1)* Spacing + Spacing/2
		b:SetPoint("BOTTOMLEFT", UIParent, "BOTTOM", xoff, 3 + Spacing)
		c:SetPoint("BOTTOMRIGHT", UIParent, "BOTTOM", xoff, 3 + Spacing)
	  end
	end

	end)

	RegisterStateDriver(TukuiBar1, "visibility", "[petbattle] hide; show")
	
	-- [[
	-- TukuiBar1:SetAttribute("_onstate-page", [[
		-- if HasVehicleActionBar and HasVehicleActionBar() then
			-- newstate = GetVehicleBarIndex() or newstate
		-- elseif HasOverrideActionBar and HasOverrideActionBar() then
			-- newstate = GetOverrideBarIndex() or newstate
		-- elseif HasTempShapeshiftActionBar and HasTempShapeshiftActionBar() then
			-- newstate = GetTempShapeshiftBarIndex() or newstate
		-- elseif HasBonusActionBar and HasBonusActionBar() then
			-- local page = GetActionBarPage() or 0
			-- newstate = (page > 1 and page) or GetBonusBarIndex() or newstate
		-- end

		-- for i, Button in ipairs(Button) do
			-- Button:SetAttribute("actionpage", tonumber(newstate))
		-- end
	-- ]])

	MultiBarBottomLeft:SetParent(TukuiBar1)

	if TukuiBar2 then
		TukuiBar2:Kill()
	end
	
	if TukuiBar5 then
		TukuiBar5:SetPoint("RIGHT", UIParent, "RIGHT", -5, -54)
		TukuiBar5:SetHeight(Scale((Size*12)+(Spacing*13)))
	end
	
	if TukuiBar3 then
		TukuiBar3:ClearAllPoints()
		--TukuiBar3:SetHeight(Size + 2 * Spacing)
		TukuiBar3:SetPoint("BOTTOMRIGHT", TukuiActionBar1, "TOPRIGHT", 0, Scale(2))
	end
	
	if TukuiBar3.Backdrop then
		TukuiBar3.Backdrop:Kill()
	end
	
	if PetBar then
		local numPetButtons = C["ActionBars"].BarPetButtonsPerRow
		local Size = C["ActionBars"].PetButtonSize
	
		PetBar:ClearAllPoints()
		PetBar:SetPoint("RIGHT", TukuiBar5, "LEFT", -Scale(5), 0)
		PetBar:SetWidth(Size + Spacing*2)
		PetBar:SetHeight(Size*numPetButtons + Spacing*(numPetButtons + 1))
		
		TukuiPetActionBarButton1:ClearAllPoints()
		TukuiPetActionBarButton1:SetPoint("TOP", PetBar, 0, -Spacing)
		local prev = TukuiPetActionBarButton1
		for i = 2,numPetButtons do
			local b = _G["TukuiPetActionBarButton"..tostring(i)]
			if b then
				b:ClearAllPoints()
				b:SetPoint("TOP", prev, "BOTTOM", 0, -Spacing)
				prev = b
			end
		end
		
	end

	for i = 2, NUM_PET_ACTION_SLOTS do
		local Button = _G["PetActionButton"..i]
		local PreviousButton = _G["PetActionButton"..i-1]
		
		Button:ClearAllPoints()
		Button:SetPoint("TOP", PreviousButton, "BOTTOM", 0, -Spacing)
	end

	if TukuiStanceBar and TukuiStanceBar.Backdrop then
		TukuiStanceBar.Backdrop:Kill()
	end
end)


-- MinimapDataTextLeft
hooksecurefunc(S["Maps"].Minimap, "Enable", function()
  local dt_right = S.DataTexts.Panels.Minimap
  local backdrop = Minimap.Backdrop
  
  dt_right:ClearAllPoints()
  dt_right:SetPoint("TOPRIGHT", backdrop, "BOTTOMRIGHT", 0, S.scale1)
  dt_right:SetWidth(dt_right:GetWidth()/2)
  
  local dt_left = CreateFrame("Frame", nil, UIParent)
  dt_left:SetHeight(dt_right:GetHeight())
  dt_left:SetPoint("TOPLEFT", backdrop, "BOTTOMLEFT", 0, S.scale1)
  dt_left:SetPoint("RIGHT", dt_right, "LEFT", S.scale1,0)
  S.CreateBackdrop(dt_left)
  dt_left:SetFrameStrata("MEDIUM")
  S.DataTexts.Panels.MinimapDataTextLeft = dt_left
end)

hooksecurefunc(S["DataTexts"], "CreateAnchors", function(self)
  local DataTextLeft = S.DataTexts.Panels.Left
  local Anchor1 = self.Anchors[1]
  local MinimapDataTextLeft = S.DataTexts.Panels.MinimapDataTextLeft

  self.NumAnchors = self.NumAnchors + 1
  
  local Frame = CreateFrame("Button", nil, UIParent)
  Frame:SetSize((DataTextLeft:GetWidth() / 3) - S.scale1, DataTextLeft:GetHeight() - S.scale2)
  Frame:SetFrameLevel(DataTextLeft:GetFrameLevel() + 1)
  Frame:SetFrameStrata("HIGH")
  Frame:EnableMouse(false)
  Frame.SetData = Anchor1.SetData
  Frame.RemoveData = Anchor1.RemoveData
  Frame.Num = self.NumAnchors
  Frame.Tex = Frame:CreateTexture()
  Frame.Tex:SetAllPoints()
  Frame.Tex:SetTexture(0.2, 1, 0.2, 0)
  
  Frame:SetPoint("CENTER", MinimapDataTextLeft, 0, 0)
  Frame:SetSize(MinimapDataTextLeft:GetWidth() - S.scale2, MinimapDataTextLeft:GetHeight() - S.scale2)
  
  self.Anchors[self.NumAnchors] = Frame
end)

local function char_dt(self)
	local Green, Red
	Green = L.DataText.Slots[1][3] * 2
	Red = 1 - Green
	self.Text:SetText("Durability: " .. floor(L.DataText.Slots[1][3] * 100) .. "%")
	if Green < 0.3 then
		self.Text:SetTextColor(Red + 1, Green, 0, 1)
	end
end

S["DataTexts"]:GetDataText("Character"):HookScript("OnEvent", char_dt)
S["DataTexts"]:GetDataText("Character"):HookScript("OnUpdate", char_dt)

S.DataTexts.StatusColors[1] = "|cffFFFFFF"



hooksecurefunc(S["DataTexts"], "Register", function()
  for _, DT in pairs(S["DataTexts"].DataTexts) do
    if not DT.modded_GetToolTipAnchor then
      local _GetTooltipAnchor = DT.GetTooltipAnchor
      
      if not _GetTooltipAnchor then
        print("No DT with function GetTooltipAnchor found!")
        _GetTooltipAnchor = function() end
      end
      
      local GetTooltipAnchor = function(self)
        local From, Anchor, X, Y = _GetTooltipAnchor(self)

        if self.Position == 8 then
          Anchor = "ANCHOR_BOTTOMRIGHT"
          Y = Scale(-5)
          X = Scale(-50)
          From = S.DataTexts.Panels.MinimapDataTextLeft
        end
        
        return From, Anchor, X, Y
      end
      
      DT.GetTooltipAnchor = GetTooltipAnchor
      DT.modded_GetToolTipAnchor = true
    end
  end
end)

---[[ Hide Panels we don't want
hooksecurefunc(S["Chat"], "Enable", function()
  S["Chat"].Panels.LeftChat:Hide()
  S["Chat"].Panels.RightChat:Hide()
  S["Chat"].Panels.LeftChatTabs:Hide()
  S["Chat"].Panels.RightChatTabs:Hide()
  
  TukuiLeftDataTextBox:ClearAllPoints()
  TukuiRightDataTextBox:ClearAllPoints()
  TukuiLeftDataTextBox:SetPoint("BOTTOMLEFT",UIParent,5,Scale(3))
  TukuiRightDataTextBox:SetPoint("BOTTOMRIGHT",UIParent,-5,Scale(3))
end)
--]]
hooksecurefunc(S["Chat"], "SetChatFramePosition", function(self)
	local ID = self:GetID()
	if ID == 1 then
		self:ClearAllPoints()
		self:SetPoint("BOTTOMLEFT", S.DataTexts.Panels.Left, "TOPLEFT", 0, 4)
	end
end)

hooksecurefunc(S["Miscellaneous"].Experience, "Enable", function()
  S.Miscellaneous.Experience:Disable()
end)

hooksecurefunc(S["UnitFrames"], "Enable", function()
  RegisterStateDriver(Tukui_PetBattleFrameHider, "visibility", "[petbattle] hide;show")
end)

-- Move ChatFrame 4 in favor of space for a damage meter
local ChangeDefaultChatPosition = function(frame)

  if frame then

    local id = frame:GetID()
    local name = FCF_GetChatWindowInfo(id)

    if id == 4 and name == LOOT then
      if not frame.isDocked then
        if frame.isLocked then FCF_SetLocked(frame, 0) else print("NOT LOCKED") end
        frame:ClearAllPoints()
        frame:SetPoint("BOTTOMLEFT", TukuiInfoLeft, "TOPLEFT", 0, 6)
        frame:SetJustifyH("LEFT")
        FCF_DockFrame(ChatFrame4) 
      end
    end
  end
end
hooksecurefunc("FCF_RestorePositionAndDimensions", ChangeDefaultChatPosition)

hooksecurefunc(S["Tooltips"], "SetTooltipDefaultAnchor", function(self, parent)
--hooksecurefunc("GameTooltip_SetDefaultAnchor", function(self, parent)
	local f = ChatFrame1Tab
	if (f and f:IsShown()) then
		self:ClearAllPoints()
		self:SetPoint("BOTTOMLEFT", f, "TOPLEFT", 0, 0)
	else
		self:ClearAllPoints()
		self:SetPoint("BOTTOMRIGHT", TukuiRightDataTextBox, 0, 2)
	end
end)
--[[
-- put a 'c' on cubeleft, since clicking on it opens the chat menu
hooksecurefunc(S["Panels"],"Enable",function()
  local cubeleft = S.Panels["CubeLeft"]
    
  if cubeleft then
      local Text = cubeleft:CreateFontString(nil, "OVERLAY")
      Text:SetFont(C.Medias.Font, 10)
    Text:SetText("c")
      Text:SetJustifyH("CENTER")
      Text:SetJustifyV("MIDDLE")
    Text:Point("CENTER",cubeleft)
    Text:Show()
    
    cubeleft.text = Text
  end
end)
]]
  
--[[
S["ActionBars"].AddHooks = function(self)
  hooksecurefunc("ActionButton_Update", self.SkinButton)
  hooksecurefunc("ActionButton_UpdateFlyout", self.StyleFlyout)
  hooksecurefunc("SpellButton_OnClick", self.StyleFlyout)
  hooksecurefunc("ActionButton_UpdateHotkeys", self.UpdateHotKey)
  hooksecurefunc(ExtraActionButton1.style, "SetTexture", self.DisableExtraButtonTexture)
  hooksecurefunc("PetActionButton_SetHotkeys", self.UpdateHotKey)
end
]]
