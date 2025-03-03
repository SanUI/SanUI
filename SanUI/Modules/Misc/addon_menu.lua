-- Originally by safturento@tukui.org
-- modified for SanUI by Shimmer@EU-Mal'Ganis

-----Button Order-----
--Change the numbers below to change the
--order of the buttons to your liking.
--To disabled a button, set it to 0.
local _, addon = ...
local S,C = unpack(addon)

local Scale = S.Scale
local font = C.medias.fonts.Font
local fontsize = 12

local IsAddOnLoaded = C_AddOns.IsAddOnLoaded

local SanUIButtonOrder = {Grid=1, DBM=2, Hack=3}

if S["profiles"][S.MyName]["AddonMenu"] then
	SanUIButtonOrder = S["profiles"][S.MyName]["AddonMenu"]
	local btns = 0
	for _ in pairs(SanUIButtonOrder) do
		btns = btns + 1
	end
	if #S["profiles"][S.MyName]["modes"] >1 then
		for i = 1,#S["profiles"][S.MyName]["modes"] do
			local name = S["profiles"][S.MyName]["modes"][i]
			SanUIButtonOrder[name] = btns+i
		end
	end
end

-----How Many Buttons?-----
local Btns = 0

for _ in pairs(SanUIButtonOrder) do
	Btns = Btns +1
end
-- Toggles if the Open/Close button is hidden on mouseout
--HideMenuButton = false

-- Set to the offset of the menu if you have data texts under your minimap
local Offset = 19

--	Sets height of buttons
local BtnHeight = 20

-- Sets side of minimap that menu anchors to
-- DON'T CHANGE
local AnchorSide = true

-------------------------------------------------------------------
-- CREATING NEW MODULES -------------------------------------------
-------------------------------------------------------------------
--[[
-- The first step to create a new module is to give it an Order above. 

-- Then use and modify the basic code below to work with the addon:
-- First things first, rename all instances of "AddonButton" with whatever you want to name your button.
-- Once that's done, follow the steps commented out below:

-----Addon Toggle Button-----
if AddonOrder > 0 then
	local AddonButton = CreateFrame("Frame", "AddonButton", Menu)
	CreateButton(AddonButton, AddonOrder) --Replace this with the names of your Button followed by your Order

	if not IsAddOnLoaded("Addon") then 
		AddonButton.title:SetTextColor(0.6, 0.6, 0.6)
		AddonButton.title:SetText("Addon Disabled") ------ Replace this with the text you want to show when the addon is disabled
	else
		if AddonWindow:IsShown() then	------------------ Replace AddonWindow with the name of the frame you wish to toggle
			AddonButton.title:SetText("Hide Addon") ------ Replace "Hide Addon" with the text to want to be shown when the addon is shown
		else
			AddonButton.title:SetText("Show Addon")	------ Replace "Show Addon" with the text to want to be shown when the addon is hidden
		end
		
		AddonButton:SetScript("OnEnter", function()
			AddonButton.title:SetTextColor(1, 1, 0.5)
		end)
		AddonButton:SetScript("OnLeave", function()
			AddonButton.title:SetTextColor(1, 1, 1)
		end)
		AddonButton:SetScript("OnMouseDown", function()
			if AddonWindow:IsShown() then	-------------- replace AddonWindow with the name of the frame you wish to toggle
				AddonButton.title:SetText("Show Skada")	-- Replace "Hide Addon" with the text to want to be shown when the addon is shown
				ToggleFrame(FrameToToggle) --type /frame to find this name. If it says WorldFrame, type /framestack and mouseover to see a list of frames under your mouse.
			else
				AddonButton.title:SetText("Hide Skada")	-- Replace "Show Addon" with the text to want to be shown when the addon is hidden
				ToggleFrame(FrameToToggle)	--type /frame to find this name. If it says WorldFrame, type /framestack and mouseover to see a list of frames under your mouse.
			end
		end)
	end
end
]]--


-------------------------------------------------------------------
-- CREATE MENU ----------------------------------------------------
-------------------------------------------------------------------
-- Open/Close Button
---@class AddonMenuOpen: Frame
local AddonMenuOpen = CreateFrame("Frame", "MenuOpen", UIParent)
S.CreateBackdrop(AddonMenuOpen)
AddonMenuOpen.origPoint = {"BOTTOMLEFT", Minimap, "BOTTOMRIGHT", Scale(2), 0}
if AnchorSide == true then
	AddonMenuOpen:SetSize(C.sizes.minimapbuttons, C.sizes.minimapbuttons)
	AddonMenuOpen.origsize = C.sizes.minimapbuttons
---@diagnostic disable-next-line: param-type-mismatch
	AddonMenuOpen:SetPoint(unpack(AddonMenuOpen.origPoint))
else
	AddonMenuOpen:SetSize(Minimap:GetWidth()+S.scale4 , Scale(14))
	AddonMenuOpen:SetPoint("BOTTOM", Minimap, "TOP", 0, Scale(5 + Offset))
end
S.AddonMenuOpen = AddonMenuOpen

local Text = AddonMenuOpen:CreateFontString(nil, "OVERLAY")
Text:SetFont(font, 12)
AddonMenuOpen.fontsize = 12
Text:SetText("a")
Text:SetJustifyH("CENTER")
Text:SetJustifyV("MIDDLE")
Text:SetPoint("CENTER", AddonMenuOpen)
Text:Show()

AddonMenuOpen.text = Text

AddonMenuOpen:EnableMouse(true)
AddonMenuOpen:SetFrameStrata("MEDIUM")

-- Menu Background
local Menu = CreateFrame("Frame", "MinimapMenu", UIParent)
if AnchorSide == true then
	--Menu:CreatePanel("", MenuOpen:GetWidth(),(Btns*(BtnHeight+1))+3, "TOP", Minimap, "BOTTOM",0, -5 - Offset)
	Menu:SetSize(Scale(Minimap:GetWidth()), Scale((Btns*(BtnHeight+1))+3))
	Menu:SetPoint("TOPLEFT", Minimap, "TOPRIGHT", Scale(17),0)
	S.CreateBackdrop(Menu)
else
	--Menu:CreatePanel("", MenuOpen:GetWidth(),(Btns*(BtnHeight+1))+3, "BOTTOM", Minimap, "TOP",0, 5 + Offset)
	Menu:SetSize(Scale(AddonMenuOpen:GetWidth()),Scale((Btns*(BtnHeight+1))+3))
	Menu:SetPoint("BOTTOM", Minimap, "TOP",0, Scale(5 + Offset))
	S.CreateBackdrop(Menu)
end
Menu:Hide()
Menu:SetFrameStrata("MEDIUM") --BACKGROUND")
Menu:EnableMouse(true)

--MenuOpen:SkinButton()
S.CreateBackdrop(AddonMenuOpen)
local function MenuMouseDown()
	if Menu:IsShown() then
		AddonMenuOpen:SetFrameStrata("MEDIUM")
		Menu:Hide()
		S.raidutilities:Show()
		AddonMenuOpen:SetSize(AddonMenuOpen.origsize, AddonMenuOpen.origsize)
		AddonMenuOpen:ClearAllPoints()
        ---@diagnostic disable-next-line: param-type-mismatch
		AddonMenuOpen:SetPoint(unpack(AddonMenuOpen.origPoint))
		Text:SetFont(font, AddonMenuOpen.fontsize)
		AddonMenuOpen.text:SetText("a")
		AddonMenuOpen:Show()
	else
		AddonMenuOpen:SetFrameStrata("HIGH")
		Menu:Show()
		S.raidutilities:Hide()
		AddonMenuOpen:SetSize(Scale(Minimap:GetWidth()), Scale(BtnHeight))
		AddonMenuOpen:ClearAllPoints()
		AddonMenuOpen:SetPoint("TOP", Menu, "BOTTOM", 0, -Scale(3))
		Text:SetFont(font, fontsize)
		AddonMenuOpen.text:SetText(CLOSE)
	end
end

-- Create Open/Close Scripts
AddonMenuOpen:SetScript("OnMouseDown", MenuMouseDown)

-------------------------------------------------------------------
-- MODULES --------------------------------------------------------
-------------------------------------------------------------------
-- Create Button Function
local function CreateButton(f, o) --(Frame,ButtonOrderName)
	if AnchorSide == true then
		--f:CreatePanel("", Menu:GetWidth()-4, BtnHeight, "BOTTOM", Menu, "TOP", 0, -o*(BtnHeight+1)-1)
		f:SetSize(Scale(Menu:GetWidth()-4), Scale(BtnHeight))
		f:SetPoint("BOTTOM", Menu, "TOP", 0, -Scale(o*(BtnHeight+1)+1))
		S.CreateBackdrop(f)

		f:SetFrameStrata("DIALOG")

		f.title = f:CreateFontString()
		f.title:SetPoint("CENTER", f, "CENTER", 0, S.scale1)
		f.title:SetFont(font, fontsize, "OUTLINE") --14
		f.title:SetTextColor(1, 1, 1)

		f:EnableMouse(true)
	else
		--f:CreatePanel("", Menu:GetWidth()-4, BtnHeight, "TOP", Menu, "BOTTOM", 0, o*(BtnHeight+1)+1)
		f:SetSize(Scale(Menu:GetWidth()-4), Scale(BtnHeight))
		f:SetPoint("TOP", Menu, "BOTTOM", 0, Scale(o*(BtnHeight+1)+1))
		S.CreateBackdrop(f)
		f:SetFrameStrata("DIALOG")

		f.title = f:CreateFontString()
		f.title:SetPoint("CENTER", f, "CENTER", 0, S.scale1)
		f.title:SetFont(font, fontsize, "OUTLINE") --14
		f.title:SetTextColor(1, 1, 1)

		f:EnableMouse(true)
	end

  S.CreateBackdrop(f)
  --f:SkinButton()
end

-----World State Button-----
if SanUIButtonOrder["WorldFrame"] then
	---@class AddonMenuButton: Frame
	---@field title FontString
	local WSButton = CreateFrame("Frame", "WorldStateToggle", Menu)
	CreateButton(WSButton, SanUIButtonOrder["WorldFrame"])

	if WorldStateAlwaysUpFrame and WorldStateAlwaysUpFrame:IsShown() then
		WSButton.title:SetText("Hide World Frame")
	else
		WSButton.title:SetText("Show World Frame")
	end

	WSButton:SetScript("OnMouseDown", function()
		if WorldStateAlwaysUpFrame and WorldStateAlwaysUpFrame:IsShown() then
			WorldStateAlwaysUpFrame:Hide()
			WSButton.title:SetText("Show World Frame")
		else
			if WorldStateAlwaysUpFrame then
				WorldStateAlwaysUpFrame:Show()
			end
			WSButton.title:SetText("Hide World Frame")
		end
	end)

end

-----Profile Button-----
if #S["profiles"][S.myname]["modes"] >1 then
	for i = 1,#S["profiles"][S.myname]["modes"] do
		local profile = S["profiles"][S.myname]["modes"][i]
		---@class AddonMenuButton
		local Button = CreateFrame("Frame",profile.."ToggleButton",Menu)
		CreateButton(Button,SanUIButtonOrder[profile])

		Button.title:SetText(profile)

		Button:SetScript("OnMouseDown", function()
			S.switch2Mode(profile)
			MenuMouseDown()
		end)

	end
end

-----DBM Toggle Button----
if SanUIButtonOrder["DBM"] then
	---@class AddonMenuButton
	local DBMButton = CreateFrame("Frame", "DBMToggle", Menu)
	CreateButton(DBMButton, SanUIButtonOrder["DBM"])

	if not IsAddOnLoaded("DBM-Core") then
		DBMButton.title:SetTextColor(0.6, 0.6, 0.6)
		DBMButton.title:SetText("DBM Disabled")
	else
		DBMButton.title:SetText("DBM")

		DBMButton:SetScript("OnMouseDown", function()
				SlashCmdList.DEADLYBOSSMODS('')
				MenuMouseDown()
		end)
	end
end

-----BigWigs Toggle Button----
if SanUIButtonOrder["BigWigs"] then
	---@class AddonMenuButton
	local BWButton = CreateFrame("Frame", "BWToggle", Menu)
	CreateButton(BWButton, SanUIButtonOrder["BigWigs"])

	if not IsAddOnLoaded("BigWigs") then
		BWButton.title:SetTextColor(0.6, 0.6, 0.6)
		BWButton.title:SetText("BW Disabled")
	else
		BWButton.title:SetText("BigWigs")

		BWButton:SetScript("OnMouseDown", function()
				SlashCmdList.BigWigs('')
				MenuMouseDown()
		end)
	end
end

-----Altoholic Button -------
if SanUIButtonOrder["Altoholic"] then
	---@class AddonMenuButton
	local AltoholicButton = CreateFrame("Frame", "AltoholicToggle", Menu)
	CreateButton(AltoholicButton, SanUIButtonOrder["Altoholic"])

	if not IsAddOnLoaded("Altoholic") then
		AltoholicButton.title:SetTextColor(0.6, 0.6, 0.6)
		AltoholicButton.title:SetText("Altoholic Disabled")
	else
		AltoholicButton.title:SetText("Altoholic")

		AltoholicButton:SetScript("OnMouseDown", function()
				Altoholic:ToggleUI()
				MenuMouseDown()
		end)
	end
end
-----Hack Button -------
if SanUIButtonOrder["Hack"] then
	---@class AddonMenuButton
	local HackButton = CreateFrame("Frame", "HackToggle", Menu)
	CreateButton(HackButton, SanUIButtonOrder["Hack"])

	if not IsAddOnLoaded("REHack") then
		HackButton.title:SetTextColor(0.6, 0.6, 0.6)
		HackButton.title:SetText("Hack Disabled")
	else
		HackButton.title:SetText("Hack")

		HackButton:SetScript("OnMouseDown", function()
			REHack_Toggle()
			MenuMouseDown()
		end)
	end
end
-----MethodDungeonTools Button -------
if SanUIButtonOrder["MDT"] then
	---@class AddonMenuButton
	local MDTButton = CreateFrame("Frame", "MDTToggle", Menu)
	CreateButton(MDTButton, SanUIButtonOrder["MDT"])

	local is_mdt = IsAddOnLoaded("MythicDungeonTools")
	local is_mandt = IsAddOnLoaded("ManbabyDungeonTools")
	local is_dt = IsAddOnLoaded("DungeonTools")

	if not (is_mdt or is_mandt or is_dt) then
		MDTButton.title:SetTextColor(0.6, 0.6, 0.6)
		MDTButton.title:SetText("MDT Disabled")
	else
		MDTButton.title:SetText("MDT")

		if is_mdt then
			MDTButton:SetScript("OnMouseDown", function()
					SlashCmdList.MYTHICDUNGEONTOOLS('')
					MenuMouseDown()
			end)
		elseif is_mandt then
			MDTButton:SetScript("OnMouseDown", function()
					SlashCmdList.MANBABYDUNGEONTOOLS('')
					MenuMouseDown()
			end)
		else --is_dt
			MDTButton:SetScript("OnMouseDown", function()
					SlashCmdList.DUNGEONTOOLS('')
					MenuMouseDown()
			end)
		end
	end
end