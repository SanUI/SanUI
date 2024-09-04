local _, addon = ...
local S = unpack(addon)

local function Noop() end

local hide = function(self) self:Hide() end

S.disableMicroMenu = function()
    for _, button in ipairs({
        CharacterMicroButton, SpellbookMicroButton, TalentMicroButton, 
        QuestLogMicroButton, GuildMicroButton, LFDMicroButton, 
        EJMicroButton, StoreMicroButton, MainMenuMicroButton,
        CollectionsMicroButton, HelpMicroButton, AchievementMicroButton
    }) do
		hooksecurefunc(button, "Show", hide)
        button:SetShown(false)
		button:Hide()
    end
    
    -- Specifically handle the StoreMicroButton (Shop button)
	hooksecurefunc(StoreMicroButton:GetParent(), "Show", hide)
    StoreMicroButton:GetParent():SetShown(false)
	StoreMicroButton:GetParent():Hide()
end

function S.disableBlizzard()
	for i = 1, MAX_BOSS_FRAMES do
		local Boss = _G["Boss"..i.."TargetFrame"]
		local Health = _G["Boss"..i.."TargetFrame".."HealthBar"]
		local Power = _G["Boss"..i.."TargetFrame".."ManaBar"]

		Boss:UnregisterAllEvents()
		Boss.Show = Noop
		Boss:Hide()
	end

	local PartyFrame = PartyFrame
	
	if PartyFrame then
		PartyFrame:SetParent(S.Hider)
	end

	if CompactRaidFrameManager then
		-- Disable Blizzard Raid Frames.
		CompactRaidFrameManager:SetParent(S.Hider)
		CompactRaidFrameManager:UnregisterAllEvents()
		CompactRaidFrameManager:Hide()

		CompactRaidFrameContainer:SetParent(S.Hider)
		CompactRaidFrameContainer:UnregisterAllEvents()
		CompactRaidFrameContainer:Hide()
		
		UIParent:UnregisterEvent("GROUP_ROSTER_UPDATE")
		CompactRaidFrameManager_SetSetting("IsShown", "0")
	end

	-- disable xp thingy
	StatusTrackingBarManager:UnregisterAllEvents()
	StatusTrackingBarManager:Hide()

	UIParent:UnregisterEvent("TALKINGHEAD_REQUESTED")	
	TalkingHeadFrame:UnregisterAllEvents()
	
	S.disableMicroMenu()
end

local f = CreateFrame("Frame")
f:RegisterEvent("PLAYER_LOSES_VEHICLE_DATA")
f:RegisterEvent("PET_BATTLE_CLOSE")
f:SetScript("OnEvent", function()
	S.disableMicroMenu()
end)