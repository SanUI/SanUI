local addonName, addon = ...
local S,C = unpack(addon)

local font = C.medias.fonts.Font
local fontsize = C.sizes.datatextfontsize

S.createSpellbookDT = function(frame)
	local text = frame:CreateFontString(nil, "OVERLAY")
	text:SetPoint("CENTER", frame, "CENTER", 0, -S.scale1)
	text:SetJustifyH("CENTER")
	text:SetJustifyV("MIDDLE")
	text:SetFont(font, fontsize)
	text:SetText("Spells")
	
	frame.Text = text
		
	frame:SetScript("OnMouseDown", function()

		if InCombatLockdown() then
			print("In combat - not opening spellbook frame")
			return
		end
		
		ToggleSpellBook(BOOKTYPE_SPELL)
	end)
end

S.createTalentDT = function(frame)
	local text = frame:CreateFontString(nil, "OVERLAY")
	text:SetPoint("CENTER", frame, "CENTER", 0, -S.scale1)
	text:SetJustifyH("CENTER")
	text:SetJustifyV("MIDDLE")
	text:SetFont(font, fontsize)
	text:SetText("Talents")
	
	frame.Text = text
		
	frame:SetScript("OnMouseDown", function()

		if InCombatLockdown() then
			print("In combat - not opening talent frame")
			return
		end
		
		ToggleTalentFrame()
	end)
end

S.createQuestDT = function(frame)
	local text = frame:CreateFontString(nil, "OVERLAY")
	text:SetPoint("CENTER", frame, "CENTER", 0, -S.scale1)
	text:SetJustifyH("CENTER")
	text:SetJustifyV("MIDDLE")
	text:SetFont(font, fontsize)
	text:SetText("Quests")
	
	frame.Text = text
		
	frame:SetScript("OnMouseDown", function()

		if InCombatLockdown() then
			print("In combat - not opening questlog frame")
			return
		end
		
		ToggleQuestLog()
	end)
end

S.createAchievementDT = function(frame)
	local text = frame:CreateFontString(nil, "OVERLAY")
	text:SetPoint("CENTER", frame, "CENTER", 0, -S.scale1)
	text:SetJustifyH("CENTER")
	text:SetJustifyV("MIDDLE")
	text:SetFont(font, fontsize)
	text:SetText("Achieve")
	
	frame.Text = text
		
	frame:SetScript("OnMouseDown", function()

		if InCombatLockdown() then
			print("In combat - not opening achievement frame")
			return
		end
		
		ToggleAchievementFrame()
	end)
end

S.createCollectionsDT = function(frame)
	local text = frame:CreateFontString(nil, "OVERLAY")
	text:SetPoint("CENTER", frame, "CENTER", 0, -S.scale1)
	text:SetJustifyH("CENTER")
	text:SetJustifyV("MIDDLE")
	text:SetFont(font, fontsize)
	text:SetText("Collect")
	
	frame.Text = text
		
	frame:SetScript("OnMouseDown", function()

		if InCombatLockdown() then
			print("In combat - not opening collections frame")
			return
		end
		
		ToggleCollectionsJournal()
	end)
end

S.createGuideDT = function(frame)
	local text = frame:CreateFontString(nil, "OVERLAY")
	text:SetPoint("CENTER", frame, "CENTER", 0, -S.scale1)
	text:SetJustifyH("CENTER")
	text:SetJustifyV("MIDDLE")
	text:SetFont(font, fontsize)
	text:SetText("Guide")
	
	frame.Text = text
		
	frame:SetScript("OnMouseDown", function(self, button)

		if InCombatLockdown() then
			print("In combat - not opening encounter journal frame")
			return
		end
		
		ToggleEncounterJournal()
	end)
end

S.createFriendsDT = function(frame)
	local text = frame:CreateFontString(nil, "OVERLAY")
	text:SetPoint("CENTER", frame, "CENTER", 0, -S.scale1)
	text:SetJustifyH("CENTER")
	text:SetJustifyV("MIDDLE")
	text:SetFont(font, fontsize)
	text:SetText("Friends")
	
	frame.Text = text
		
	frame:SetScript("OnMouseDown", function(self, button)

		if InCombatLockdown() then
			print("In combat - not opening friends frame")
			return
		end
		
		ToggleFriendsFrame(1)
	end)
end

