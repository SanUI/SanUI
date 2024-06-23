local addonName, addon = ...
local S,C = unpack(addon)

local button_size = 30
local offset = 5
local Scale = S.Scale
local scale2 = Scale(2)
local floor = math.floor

local saf = {}
addon.saf = saf
saf.filters = {}
saf.hookedBuffFrame = false

saf.placeBuffFrame = function() 
	BuffFrame:ClearAllPoints()
	BuffFrame:SetPoint("TOPRIGHT",UIParent,"TOPRIGHT",0,-5)
end

saf.placedDebuffFrame = false

saf.placeDebuffFrame = function()
	if saf.placedDebuffFrame then
		saf.placedDebuffFrame = false
	else
		saf.placedDebuffFrame = true
		DebuffFrame:ClearAllPoints()
		DebuffFrame:SetPoint("TOPRIGHT", BuffFrame, "BOTTOMRIGHT", -5, -5)
	end
end

saf.hookBuffFrame = function()
	if not saf.hookedBuffFrame then
		saf.hookedBuffFrame = true
		
		-- those are a bit cargo culted, not sure which is really needed
		hooksecurefunc("UIParent_UpdateTopFramePositions",saf.placeBuffFrame)
		hooksecurefunc(BuffFrame, "UpdateAuraContainerAnchor", saf.placeBuffFrame)
		
		hooksecurefunc(DebuffFrame, "SetPoint", saf.placeDebuffFrame)
	end
end

saf.UpdateGrid = function(mixin)--self, aura)
	--local header = aura:GetParent()
	mixin.numHideableBuffs = 0;
	mixin.auraInfo = {};
	
	AuraUtil.ForEachAura("player", "HELPFUL", mixin.maxAuras, function(...)
		local name, texture, count, debuffType, duration, expirationTime, _, _, _, _, _, _, _, _, timeMod = ...;
		local hideUnlessExpanded = false
		
		if name and saf.filters[name] then
			hideUnlessExpanded = true
			mixin.numHideableBuffs = mixin.numHideableBuffs + 1
		end
		
		local index = #mixin.auraInfo + 1
		mixin.auraInfo[index] = { name = name, index = index, texture = texture, count = count, debuffType = debuffType, duration = duration,  expirationTime = expirationTime, timeMod = timeMod, hideUnlessExpanded = hideUnlessExpanded,
		auraType = "Buff"};

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
			S.CreateBackdrop(button)
			local flevel = button:GetFrameLevel()
			flevel = (flevel > 1 and flevel-1) or 1
			button.Backdrop:SetFrameLevel(flevel)
			button.Backdrop:ClearAllPoints()
			button.Backdrop:SetPoint("TOPRIGHT", button.Icon, scale2, scale2)
			button.Backdrop:SetPoint("BOTTOMLEFT", button.Icon, -scale2, -scale2)
			button.Icon:SetTexCoord(.1, .9, .1, .9)
			button.DebuffBorder:SetAlpha(0)
			button.TempEnchantBorder:SetAlpha(0)
			button.clickHooked = true
		end
	end
end
hooksecurefunc(BuffFrame, "UpdateAuraButtons", saf.hookButtons)
