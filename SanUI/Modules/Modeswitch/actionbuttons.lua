local _, addon = ...
local S,C = unpack(addon)

local Scale = S.Scale

local bnames = {
	--- Standard Hauptbar linke 12 buttons
	main1 = "DominosActionButton",
	--- Standard: Hauptbar rechte 12 buttons
	main2 = "MultiBarBottomLeftActionButton",
	--- Standard: Recht von coolline, nur 8 buttons
	right_of_coolline = "MultiBarBottomRightActionButton",
	--- Standard: Links von coolline, nicht immer da
	stance = "DominosStanceButton",
	--- Standard: 12 Buttons rechts am Bildschirm
	right = "MultiBarLeftActionButton"
}

local hideDominosBars = function(bars)
	for _, bar in pairs(bars) do
		Dominos.modules.SlashCommands:OnCmd("hide "..bar)
	end
end

S.switchActionBars = {}

S.switchActionBars.main = function(profile)
	if profile == "SanBear" then
		DominosFrame1:ClearAllPoints()
		DominosFrame1:SetPoint("CENTER", UIParent, "CENTER", 0, -185)
		DominosFrame1.Backdrop:SetAlpha(0)
		DominosFrame1:SetColumns(6)

		DominosFrame6:ClearAllPoints()
		DominosFrame6:SetPoint("BOTTOMRIGHT", S.panels.bottomrighttextbox, "BOTTOMLEFT", -6, 0)
		DominosFrame6:SetColumns(12)
	elseif profile == "SanHeal" then
		DominosFrame1:ClearAllPoints()
		DominosFrame1:SetPoint("BOTTOMLEFT", S.panels.bottomlefttextbox, "BOTTOMRIGHT", 6, 0)
		DominosFrame1:SetColumns(12)

		DominosFrame6:ClearAllPoints()
		DominosFrame6:SetPoint("BOTTOMRIGHT", S.panels.bottomrighttextbox, "BOTTOMLEFT", -6, 0)
		DominosFrame6:SetColumns(12)

		DominosFrame1.Backdrop:SetAlpha(1)
	end

end

S.switchActionBars.roc = function()
	DominosFrame5:SetNumButtons(8)
	DominosFrame5:ClearAllPoints()
	DominosFrame5:SetPoint("BOTTOMRIGHT", DominosFrame6, "TOPRIGHT", 0, 0)
end

local redoStance = function() end

S.switchActionBars.stance = function(profile)
	-- this is neede b/c we hook this function below, might be called in
	-- combat
	if InCombatLockdown() then return end

	if profile == "SanHeal" then
		if DominosFrameclass then
			DominosFrameclass:ClearAllPoints()
			DominosFrameclass:SetPoint("BOTTOMLEFT", DominosFrame1, "TOPLEFT", 0, 0)
		end
		
		S.unitFrames.player.Power:Hide()
	elseif profile == "SanBear" then
		S.switchActionBars.main("SanHeal")
		S.switchActionBars.stance("SanHeal")

		if DominosFrameclass then
			local bot = DominosFrameclass:GetBottom()
			local left = DominosFrameclass:GetLeft()
			DominosFrameclass:ClearAllPoints()
			DominosFrameclass:SetPoint("BOTTOMLEFT", UIParent, "BOTTOMLEFT", left, bot)
		end

		--really hacky, but no better idea how to do this...
		-- yes, we need to do this here, yes the numbers work out, quit bugging me, future self
		local height = DominosFrame6.Backdrop:GetHeight()
		local width = DominosFrame6.Backdrop:GetWidth()
		local power = S.unitFrames.player.Power
		power:ClearAllPoints()
		power:SetPoint("BOTTOMLEFT", S.panels.bottomlefttextbox, "BOTTOMRIGHT", 6 + Scale(2), Scale(2))
		power:SetHeight(height - Scale(4))
		power:SetWidth(width - Scale(4))
		power:Show()

		S.switchActionBars.main("SanBear")
	end

	-- when switching to different profiles for the stance bar, update this
	redoStance = function() S.switchActionBars.stance(profile) end
end

redoStance = S.switchActionBars.stance

S.switchActionBars.right_pet = function()
	DominosFrame4:ClearAllPoints()
	DominosFrame4:SetPoint("RIGHT", UIParent, "RIGHT", -5, -54)
	DominosFrame4:SetColumns(1)

	if DominosFramepet then
		DominosFramepet:SetNumButtons(12)
		DominosFramepet:SetColumns(1)
		DominosFramepet:ClearAllPoints()
		DominosFramepet:SetPoint("RIGHT", DominosFrame4, "LEFT", -4, 0)
	end
end

S.switchActionButtons = function(profile)
	-- this is neede b/c we hook this function below, might be called in
	-- combat
	if InCombatLockdown() then return end

	if profile == "SanBear" then
		S.switchActionBars.stance(profile)
		S.switchActionBars.main(profile)
		S.switchActionBars.roc()
		S.switchActionBars.right_pet()
		hideDominosBars({2, 3, 7, 8, 9, 10, 11, 12, 13, 14, "bags"})
	elseif profile == "ToviAug" then
		S.switchActionBars.main(profile)
		S.switchActionBars.roc()
		S.switchActionBars.right_pet()
		S.switchActionBars.stance(profile)
	else
		S.switchActionBars.main("SanHeal")
		S.switchActionBars.roc()
		S.switchActionBars.stance("SanHeal")
		S.switchActionBars.right_pet()
		hideDominosBars({2, 3, 7, 8, 9, 10, 11, 12, 13, 14, "bags"})
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
if Dominos.modules.StanceBar then
	hooksecurefunc(Dominos.modules.StanceBar, "UpdateStanceButtons", redoStance)
end