--[[
	Cooldown Timeline, Vreenak (US-Remulos)
	https://www.curseforge.com/wow/addons/cooldown-timeline
]]--

local private = {}
private.updatePollRate = 2
private.autohidePollRate = 5

function CDTL2:CreateBarFrames()
	local frame1Enabled = CDTL2.db.profile.barFrames["frame1"]["enabled"]
	local frame2Enabled = CDTL2.db.profile.barFrames["frame2"]["enabled"]
	local frame3Enabled = CDTL2.db.profile.barFrames["frame3"]["enabled"]
	
	if frame1Enabled then
		if CDTL2_BarFrame_1 then
			CDTL2:RefreshBarFrame(1)
		else
			private.CreateBarFrame(1)
		end
	end
	
	if frame2Enabled then
		if CDTL2_BarFrame_2 then
			CDTL2:RefreshBarFrame(2)
		else
			private.CreateBarFrame(2)
		end
	end
	
	if frame3Enabled then
		if CDTL2_BarFrame_3 then
			CDTL2:RefreshBarFrame(3)
		else
			private.CreateBarFrame(3)
		end
	end
end

function CDTL2:RefreshBarFrame(i)
	local f = nil
	local s = nil
	if i == 1 then
		f = CDTL2_BarFrame_1
		s = CDTL2.db.profile.barFrames["frame1"]
	elseif i == 2 then
		f = CDTL2_BarFrame_2
		s = CDTL2.db.profile.barFrames["frame2"]
	elseif i == 3 then
		f = CDTL2_BarFrame_3
		s = CDTL2.db.profile.barFrames["frame3"]
	end
	
	if not f then
		return
	end
	
	f.name = s["name"]

	local anchor = "CENTER"
	if s["grow"] == "DOWN" then
		anchor = "TOP"
	elseif  s["grow"] == "UP" then
		anchor = "BOTTOM"
	end
	
	f:ClearAllPoints()
	f:SetPoint(s["relativeTo"], s["posX"], s["posY"])
	f:SetSize(s["width"], s["height"])

	f.mf:ClearAllPoints()
	f.mf:SetPoint("CENTER", 0, 0)
	f.mf:SetSize(s["width"], s["height"])
	
	-- MOVE FRAME BACKGROUND
	f.mf.bg:SetTexture(CDTL2.LSM:Fetch("statusbar", s["bgTexture"]))
	f.mf.bg:SetAllPoints(true)
	f.mf.bg:SetVertexColor(
		s["bgTextureColor"]["r"],
		s["bgTextureColor"]["g"],
		s["bgTextureColor"]["b"],
		s["bgTextureColor"]["a"]
	)
	
	-- BORDER
	if s["border"]["style"] ~= "None" then
		if not f.bd then
			f.mf.bd = CreateFrame("Frame", f:GetName().."_BD", UIParent, BackdropTemplateMixin and "BackdropTemplate" or nil)
			f.mf.bd:SetParent(f)
		end
	
		CDTL2:SetBorder(f.mf.bd, s["border"])
		f.mf.bd:SetFrameLevel(f.mf:GetFrameLevel() + 1)
	else
		if f.mf.bd then
			f.mf.bd:Hide()
		end
	end
	
	-- ANIMATION
	f.animateIn = f:CreateAnimationGroup()
	f.animateIn:SetLooping("NONE")
	f.animateIn:SetToFinalAlpha(true)
	local fadeIn = f.animateIn:CreateAnimation("Alpha")
	fadeIn:SetFromAlpha(0)
	fadeIn:SetToAlpha(1)
	fadeIn:SetDuration(0.3)
	fadeIn:SetSmoothing("OUT")
	fadeIn:SetOrder(1)
	
	f.animateOut = f:CreateAnimationGroup()
	f.animateOut:SetLooping("NONE")
	f.animateOut:SetToFinalAlpha(true)
	local fadeOut = f.animateOut:CreateAnimation("Alpha")
	fadeOut:SetFromAlpha(1)
	fadeOut:SetToAlpha(0)
	fadeOut:SetDuration(0.3)
	fadeOut:SetSmoothing("OUT")
	fadeOut:SetOrder(1)
	
	-- DEBUG/UNLOCK
	f.db:ClearAllPoints()
	f.db:SetPoint("CENTER", 0, 0)
	f.db.text:SetFont(CDTL2.LSM:Fetch("font", "Fira Sans Condensed"), 12, "NONE")
	f.db.text:ClearAllPoints()
	f.db.text:SetPoint("CENTER", 0, 0)
	f.db.text:SetText(f.name)
	f.db:SetSize(s["width"] + (s["padding"] * 2), s["height"] + (s["padding"] * 2))
	f.db.bg:SetAllPoints(true)
	f.db.bg:SetColorTexture( 
		CDTL2.colors["db"]["r"],
		CDTL2.colors["db"]["g"],
		CDTL2.colors["db"]["b"],
		CDTL2.colors["db"]["a"]
	)
	
	if s["enabled"] then
		f:Show()
		CDTL2:Autohide(f, s)
	else
		f:Hide()
	end
	
	if CDTL2.db.profile.global["unlockFrames"] then
		CDTL2:FrameUnlock(f)
	else
		CDTL2:FrameLock(f)
	end
	
	if CDTL2.db.profile.global["debugMode"] then
		CDTL2:DebugOn(f)
	else
		CDTL2:DebugOff(f)
	end
end

private.CreateBarFrame = function(frameNumber)
	local frameName = "CDTL2_BarFrame_"..frameNumber
	local f = CreateFrame("Frame", frameName, UIParent, BackdropTemplateMixin and "BackdropTemplate" or nil)
	
	f.number = frameNumber
	--f.updateCount = 1
	f.childCount = 0
	f.validChildren = {}
	f.overrideAutohide = false
		
	f.mf = CreateFrame("Frame", frameName.."_MF", UIParent, BackdropTemplateMixin and "BackdropTemplate" or nil)
	f.mf:SetParent(f)
	f.mf.bg = f.mf:CreateTexture(nil, "BACKGROUND")
	--f.mf.bd = CreateFrame("Frame", frameName.."_BD", UIParent, BackdropTemplateMixin and "BackdropTemplate" or nil)
	--f.mf.bd:SetParent(f.mf)
	
	f.currentCount = 0
	f.previousCount = 0
	f.mf.triggerUpdate = false

	f.db = CreateFrame("Frame", frameName.."_DB", UIParent, BackdropTemplateMixin and "BackdropTemplate" or nil)
	f.db:SetParent(f)
	f.db.bg = f.db:CreateTexture(nil, "BACKGROUND")
	f.db.text = f.db:CreateFontString(nil,"ARTWORK")
	
	-- ON UPDATE
	f:HookScript("OnUpdate", function(self, elapsed)
		private.BarFrameUpdate(self, elapsed)
	end)
	
	-- DRAG AND DROP MOVEMENT
	f:RegisterForDrag("LeftButton")
	f:SetScript("OnDragStart", f.StartMoving)
	f:SetScript("OnDragStop", f.StopMovingOrSizing)
	
	CDTL2:RefreshBarFrame(frameNumber)
	table.insert(CDTL2.barFrames, f)
end

private.BarFrameUpdate = function(f, elapsed)
	local s = nil
	if f.number == 1 then
		s = CDTL2.db.profile.barFrames["frame1"]
	elseif f.number == 2 then
		s = CDTL2.db.profile.barFrames["frame2"]
	elseif f.number == 3 then
		s = CDTL2.db.profile.barFrames["frame3"]
	end

	f.forceShow = false
	
	-- UPDATE
	if f.mf.triggerUpdate then
		local children = { f.mf:GetChildren() }
		f.validChildren = {}
		
		local count = 0
		for _, child in ipairs(children) do
			if child.valid then
				if child:GetAlpha() ~= 0 then
					count = count + 1
					table.insert(f.validChildren, child)
				end
			end
		end
		
		local bWidth = s["width"]
		local bHeight = s["height"]
		local bPadX = s["bar"]["xPadding"]
		local bPadY = s["bar"]["yPadding"]
		local fPad = s["padding"]
		
		local mfSizeX = bWidth + (fPad * 2)
		local mfSizeY = bHeight + (fPad * 2)
		local xInset = 0
		local yInset = 0
		local xOffset = 0
		local yOffset = 0
		local xMod = 0
		local yMod = 0
		local anchor = "TOP"
		local mfAnchor = "CENTER"
				
		if count == 1 then
			f.validChildren[1]:ClearAllPoints()	
			f.validChildren[1]:SetPoint("CENTER", xOffset, yOffset)
		elseif count > 1 then
			local anchor = "TOP"
			
			if s["grow"] == "UP" then
				mfAnchor = "BOTTOM"
				anchor = "BOTTOM"
				xInset = (-bPadX * (count - 1)) / 2
				yInset = fPad
				xMod = 0
				yMod = 1
				
				mfSizeX = bWidth + (fPad * 2) + (math.abs(bPadX) * (count - 1))
				mfSizeY = (bHeight * count) + (fPad * 2) + (bPadY * (count - 1))
				yOffset = -fPad
			
			elseif s["grow"] == "DOWN" then
				mfAnchor = "TOP"
				anchor = "TOP"
				xInset = (-bPadX * (count - 1)) / 2
				yInset = -fPad
				xMod = 0
				yMod = -1
				
				mfSizeX = bWidth + (fPad * 2) + (math.abs(bPadX) * (count - 1))
				mfSizeY = (bHeight * count) + (fPad * 2) + (-bPadY * (count - 1))
				yOffset = fPad
			
			elseif s["grow"] == "LEFT" then
				mfAnchor = "RIGHT"
				anchor = "LEFT"
				xInset = fPad
				yInset = (-bPadY * (count - 1)) / 2
				xMod = 1
				yMod = 0
				
				mfSizeX = (bWidth * count) + (fPad * 2) + (bPadX * (count - 1))
				mfSizeY = bHeight + (fPad * 2) + (math.abs(bPadY) * (count - 1))
				xOffset = fPad
			
			elseif s["grow"] == "RIGHT" then
				mfAnchor = "LEFT"
				anchor = "RIGHT"
				xInset = -fPad
				yInset = (-bPadY * (count - 1)) / 2
				xMod = -1
				yMod = 0
				
				mfSizeX = (bWidth * count) + (fPad * 2) + (-bPadX * (count - 1))
				mfSizeY = bHeight + (fPad * 2) + (math.abs(bPadY) * (count - 1))
				xOffset = -fPad
			
			elseif s["grow"] == "CENTER_V" then
				mfAnchor = "CENTER"
				anchor = "BOTTOM"
				xInset = (-bPadX * (count - 1)) / 2
				yInset = fPad
				xMod = 0
				yMod = 1
				
				mfSizeX = bWidth + (fPad * 2) + (math.abs(bPadX) * (count - 1))
				mfSizeY = (bHeight * count) + (fPad * 2) + (bPadY * (count - 1))
			
			elseif s["grow"] == "CENTER_H" then
				mfAnchor = "CENTER"
				anchor = "LEFT"
				xInset = fPad
				yInset = (-bPadY * (count - 1)) / 2
				xMod = 1
				yMod = 0
				
				mfSizeX = (bWidth * count) + (fPad * 2) + (bPadX * (count - 1))
				mfSizeY = bHeight + (fPad * 2) + (math.abs(bPadY) * (count - 1))
				
			end
			
			for k, child in ipairs(f.validChildren) do
				local x = (bWidth * (k - 1) * xMod) + (bPadX * (k - 1))
				local y = (bHeight * (k - 1) * yMod) + (bPadY * (k - 1))
							
				child:ClearAllPoints()		
				child:SetPoint(anchor, x + xInset, y + yInset)
			end
		end
		
		f.mf:SetSize(mfSizeX, mfSizeY)
		f.mf:ClearAllPoints()
		f.mf:SetPoint(mfAnchor, xOffset, yOffset)
		
		f.childCount = count
		
		if s["enabled"] then
			CDTL2:Autohide(f, s)
		else
			f:SetAlpha(0)
		end
		
		f.mf.triggerUpdate = false
	end
	
	if f:GetAlpha() ~= 0 then
		-- FRAME (UN)LOCKING
		if CDTL2.db.profile.global["unlockFrames"] then
			local _, _, relativeTo, xOfs, yOfs = f:GetPoint()
			
			s["relativeTo"] = relativeTo
			s["posX"] = xOfs
			s["posY"] = yOfs
		end
	end
	
	-- UPDATE COUNT
	--[[f.updateCount = f.updateCount + 1
	if f.updateCount > 12000 then
		f.updateCount = 1
	end]]--
end