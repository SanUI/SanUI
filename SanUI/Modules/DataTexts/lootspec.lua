local addonName, addon = ...
local S,C = unpack(addon)

local lootSpecName
local currentSpecName

local font = C.medias.fonts.Font
local fontsize = C.sizes.datatextfontsize

S.createLootspecDT = function(frame)
	frame:RegisterEvent("PLAYER_TALENT_UPDATE")
	frame:RegisterEvent("PLAYER_LOOT_SPEC_UPDATED")
	frame:RegisterEvent("PLAYER_ENTERING_WORLD")
	
	local text = frame:CreateFontString(nil, "OVERLAY")
	text:SetPoint("CENTER", frame, "CENTER", 0, -S.scale1)
	text:SetJustifyH("CENTER")
	text:SetJustifyV("MIDDLE")
	text:SetFont(font, fontsize)
	
	frame.Text = text
	
	local update = function(Event)
		local lootSpec = GetLootSpecialization()
		lootSpecName = lootSpec and select(2, GetSpecializationInfoByID(lootSpec))
		local currentSpec = GetSpecialization()
		currentSpecName = currentSpec and select(2, GetSpecializationInfo(currentSpec))
		
		local text = "--"
		
		if (lootSpec ~=0 and lootSpecName == nil) or currentSpecName == nil then
			frame.Text:SetText("|cffff0000+--+|r")
			return
		end
		
		if lootSpec == 0 then
			lootSpecName = currentSpecName
		end
		
		frame.Text:SetText(lootSpecName)
		
		if lootSpecName == currentSpecName then
			frame.Text:SetTextColor(1,1,1)
		else
			frame.Text:SetTextColor(1,0,0)
		end	
	end
	
	frame:SetScript("OnEvent", update)
	update()
end