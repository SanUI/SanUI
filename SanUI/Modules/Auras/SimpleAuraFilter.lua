local addonName, addon = ...
local S,C,L = unpack(addon)

local BUFFS_PER_ROW = C.Auras.BuffsPerRow
local button_size = 30
local offset = 5
local Scale = S.Toolkit.Functions.Scale

local floor = math.floor

local saf = {}
addon.saf = saf
saf.filters = {}
saf.hookedBuffFrame = false

saf.placeBuffFrame = function() 
	BuffFrame:ClearAllPoints()
	BuffFrame:SetPoint("TOPRIGHT",UIParent,"TOPRIGHT",0,-5)
end


saf.hookBuffFrame = function()
	if not saf.hookedBuffFrame then
		saf.hookedBuffFrame = true
		
		-- those are a bit cargo culted, not sure which is really needed
		hooksecurefunc("UIParent_UpdateTopFramePositions", function()
			saf.placeBuffFrame()
		end)
		hooksecurefunc(BuffFrame, "UpdateAuraContainerAnchor", function(self)
			saf.placeBuffFrame()
		end)
	end
end

saf.UpdateGrid = function(mixin)--self, aura)
	--local header = aura:GetParent()
	mixin.numHideableBuffs = 0;
	mixin.auraInfo = {};
	
	AuraUtil.ForEachAura("player", "HELPFUL", nil, function(...)
		local name, texture, count, debuffType, duration, expirationTime, _, _, _, _, _, _, _, _, timeMod = ...;
		local hideUnlessExpanded = false
		
		if name and saf.filters[name] then
			hideUnlessExpanded = true
			mixin.numHideableBuffs = mixin.numHideableBuffs + 1
		end
		local index = #mixin.auraInfo + 1
		mixin.auraInfo[index] = { name = name, index = index, texture = texture, count = count, debuffType = debuffType, duration = duration,  expirationTime = expirationTime, timeMod = timeMod, hideUnlessExpanded = hideUnlessExpanded};

		return #mixin.auraInfo > mixin.maxAuras;	
		
	end)
end

hooksecurefunc(BuffFrame,"UpdatePlayerBuffs", saf.UpdateGrid)

saf.rightClickHook = function(button) 

	if IsShiftKeyDown() then
		local idx = button.buttonInfo.index
		local name = BuffFrame.auraInfo[idx].name				
		if name then
			saf.filters[name] = true
		end
	end
end


saf.hookButtons = function()
	for _, button in ipairs(BuffFrame.auraFrames) do
		if not button.clickHooked then
			button:HookScript("OnClick", saf.rightClickHook)
			button:CreateBackdrop()
			local flevel = button:GetFrameLevel()
			flevel = (flevel > 1 and flevel-1) or 1
			button.Backdrop:SetFrameLevel(flevel)
			button.Backdrop:ClearAllPoints()
			button.Backdrop:SetPoint("TOPRIGHT", button.Icon, 2, 2)
			button.Backdrop:SetPoint("BOTTOMLEFT", button.Icon, -2, -2)
			button.Icon:SetTexCoord(.1, .9, .1, .9)
			button.clickHooked = true
		end
	end
end
hooksecurefunc(BuffFrame, "UpdateAuraButtons", saf.hookButtons)