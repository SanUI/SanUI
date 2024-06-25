local addonName, addon = ...
local S,C = unpack(addon)

local Scale = S.Scale
local height = C.sizes.raidframes.height
local smallheight = C.sizes.raidframes.smallheight
--local RaidButtonSize = 28

local function changeAuras(frame,auras)
	local nat = frame.NotAuraTrack
	
	if not nat then
		print("Frame "..frame:GetName().." not watched by NotAuraTrack, can't change Auras!")
		return
	end
	
	if not nat.nonwatched then  nat.nonwatched =  {} end
		
	if not auras then
		for k,v in pairs(nat.nonwatched) do
			nat.Icons[k] = v
			nat.nonwatched[k] = nil
		end

	else
		local icons = nat.Icons
		if icons then
			for _,spellID in ipairs(auras) do
				if icons[spellID] ~= nil then 
					nat.nonwatched[spellID] = icons[spellID]
					icons[spellID] = nil
					nat.nonwatched[spellID]:Hide()
				end
			end
		end
	end
end

local function SetAttributeByProxy(frame,name, value)
    if name == "point" or name == "columnAnchorPoint" or name == "unitsPerColumn" then
        local count = 1
        local uframe = frame:GetAttribute("child" .. count)
        while uframe do
            uframe:ClearAllPoints()
            count = count + 1
            uframe = frame:GetAttribute("child" .. count)
        end
    end
    frame:SetAttribute(name, value)
end

local function showRaidPets(show)
	local pets = SanUIRaidPets
	
	if not pets then
		print("No Pet frames, can't show/hide them")
		return
	end
	
	-- show == false mean hide, show = true means show up
	pets:SetAttribute("showSolo",show)
	pets:SetAttribute("showParty",show)
	pets:SetAttribute("showRaid",show)
	pets:SetAttribute("showPlayer",show)
end

S.ModRaidButton = function(button,unit,size,auras)
	button:SetHeight(Scale(size))
	button.Health:SetHeight(Scale(size))
	button.Health.bg:SetHeight(Scale(size))

	if button.HealPrediction then
		button.HealPrediction.myBar:SetHeight(Scale(size))
		button.HealPrediction.otherBar:SetHeight(Scale(size))
		button.HealPrediction.absorbBar:SetHeight(Scale(size))
	end
	
	changeAuras(button,auras)
end

local function changeRaidButtons(size,auras)
	local i = 1
	
	local frame = _G["SanUIRaidUnitButton1"]
	while frame do
		S.ModRaidButton(frame,"raid"..i,size,auras)
		i = i+1
		frame =  _G["SanUIRaidUnitButton" .. i]
	end
	
	frame = _G["SanUIRaidPetsUnitButton1"]
	while frame do
		S.ModRaidButton(frame,"raidpet"..i,size,auras)
		i = i+1
		frame =  _G["SanUIRaidUnitButton" .. i]
	end
	
end

local function changeRaid(numRaid) end

local dealWith40 = CreateFrame("Frame")
dealWith40:RegisterEvent("PLAYER_ENTERING_WORLD")
dealWith40:RegisterEvent("RAID_ROSTER_UPDATE")
dealWith40:RegisterEvent("GROUP_ROSTER_UPDATE")
dealWith40:RegisterEvent("PARTY_LEADER_CHANGED")
--dealWith40:RegisterEvent("PARTY_MEMBERS_CHANGED")
dealWith40:RegisterEvent("ZONE_CHANGED_NEW_AREA")

dealWith40:SetScript("OnEvent", function(self)
	if InCombatLockdown() then
		dealWith40:RegisterEvent("PLAYER_REGEN_ENABLED")
	else
		dealWith40:UnregisterEvent("PLAYER_REGEN_ENABLED")
		
		local inInstance, instanceType = IsInInstance()
		local _, _, _, _, maxPlayers, _, _ = GetInstanceInfo()
		local curPlayers = GetNumGroupMembers()
		
		if not inInstance or not maxPlayers then
			changeRaid(curPlayers)
		else
			changeRaid(min(maxPlayers,curPlayers))
		end
	end
end)

S.position_tooltip_default = function(self, parent)
	local f = ChatFrame1Tab
	if (f and f:IsShown()) then
		self:ClearAllPoints()
		self:SetPoint("BOTTOMLEFT", f, "TOPLEFT", 0, 0)
	else
		self:ClearAllPoints()
		self:SetPoint("BOTTOMRIGHT", TukuiRightDataTextBox, 0, 2)
	end
end

S.position_tooltip = S.position_tooltip_default

--hooksecurefunc(S["Tooltips"], "SetTooltipDefaultAnchor", function(self, parent)
hooksecurefunc("GameTooltip_SetDefaultAnchor", function(self, parent)
	S.position_tooltip(self, parent)
end)

S.switchRaidFrames = function(profile)
	local frame = SanUIRaid
	local pets = SanUIRaidPets
	
	if not frame or not pets then
		print("Don't have Raid or Pet frames, can't switch to profile "..profile.."!")
		return
	end
	
	frame:ClearAllPoints()
	
	if profile == "SanHeal" then
		S.position_tooltip = S.position_tooltip_default
		
		SetAttributeByProxy(frame,"columnAnchorPoint","TOP")
		frame:SetPoint("TOP",UIParent,"CENTER",0,-150)
		frame:SetAttribute("maxColumns", 8)
		SetAttributeByProxy(frame,"unitsPerColumn", 5)
		SetAttributeByProxy(frame,"point","LEFT")
		
		SetAttributeByProxy(pets,"columnAnchorPoint","TOP")
		pets:SetPoint("TOPLEFT",frame,"BOTTOMLEFT",0,-S.scale4)
		pets:SetAttribute("maxColumns", 8)
		SetAttributeByProxy(pets,"unitsPerColumn", 5)
		SetAttributeByProxy(pets,"point","LEFT")
			
		changeRaid = function(numraid) --executed when raid roster etc changes, supposed to deal with raid size 40
			if numraid > 25 then
				showRaidPets(false)
				frame:SetAttribute("initial-height", smallheight)
				pets:SetAttribute("initial-height", smallheight)
				changeRaidButtons(smallheight)
			elseif  numraid < 26 then
				showRaidPets(true)
				frame:SetAttribute("initial-height", height)
				pets:SetAttribute("initial-height", height)
				changeRaidButtons(height)
			end
		end
		
		dealWith40:GetScript("OnEvent")()	
		
	elseif profile == "SanChicken" then
		S.position_tooltip = function(self, parent)
			local f = SanUIRaid
			if (f and f:IsShown()) then
				if SanUIRaidUnitButton6 and SanUIRaidUnitButton6:IsShown() then
					self:ClearAllPoints()
					self:SetPoint("BOTTOMLEFT", f, "BOTTOMRIGHT", 4, 0)
				else
					S.position_tooltip_default(self, parent)
				end
			end
		end
		SetAttributeByProxy(frame,"columnAnchorPoint","LEFT")
		frame:SetPoint("TOPLEFT",S.DataTexts.Panels.MinimapDataTextLeft,"BOTTOMLEFT",0,-20)
		frame:SetAttribute("maxColumns", 1)
		SetAttributeByProxy(frame,"unitsPerColumn", 25)
		SetAttributeByProxy(frame,"point","TOP")
		
		showRaidPets(false)
		
		changeRaid = function(numraid) --executed when raid roster etc changes, supposed to deal with raid size 40
			if numraid > 25 then
				frame:SetAttribute("maxColumns",2)
				SetAttributeByProxy(frame,"unitsPerColumn",20)
				frame:SetAttribute("initial-height", 23)
				pets:SetAttribute("initial-height", 23)
				changeRaidButtons(23,{18562})
			elseif numraid < 26 then
				frame:SetAttribute("maxColumns",1)
				SetAttributeByProxy(frame,"unitsPerColumn", 25)
				SetAttributeByProxy(frame,"point","TOP")
				frame:SetAttribute("initial-height", 23)
				pets:SetAttribute("initial-height", 23)
				changeRaidButtons(23,{18562})
			end
		end
		
		dealWith40:GetScript("OnEvent")()	

		--S.swiftmend_shown = false
	end
end

