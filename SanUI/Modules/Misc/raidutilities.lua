local addonName, addon = ...
local S,C = unpack(addon)

local Scale = S.Scale

local button  = CreateFrame("Frame", "RaidUtilitiesButton", UIParent)
button:SetSize(S.scale10, S.scale10)
button:SetPoint("BOTTOMLEFT", Minimap, "BOTTOMRIGHT", Scale(3), Scale(28))
S.CreateBackdrop(button)
button:SetFrameStrata("MEDIUM")
--button:SetParent(Tukui_PetBattleFrameHider)

local Text = button:CreateFontString(nil, "OVERLAY")
Text:SetFont(C.medias.fonts.Font, 10)
Text:SetText("r")
Text:SetJustifyH("CENTER")
Text:SetJustifyV("MIDDLE")
Text:SetPoint("CENTER",button,0,0)
Text:Show()
button.text = Text

button:EnableMouse(true)
button:SetScript("OnMouseDown", function(self,clicked)
	if markbarbg:IsShown() then
		button:SetFrameStrata("MEDIUM")
		markbarbg:Hide()
		MenuOpen:Show()
		button:SetSize(S.scale10, S.scale10)
		button:ClearAllPoints()
		button:SetPoint("BOTTOMLEFT", Minimap, "BOTTOMRIGHT", Scale(3), Scale(28))
		Text:SetFont(C.Medias.Font, 10)
		button.text:SetText("r")
		button:Show()
		MenuOpen:Show()
	else
		button:SetFrameStrata("DIALOG")
		markbarbg:Show()
		MenuOpen:Hide()
		button:SetSize(Minimap:GetWidth(),Scale(19))
		button:ClearAllPoints()
		button:SetPoint("BOTTOM", markbarbg, "BOTTOM", 0, S.scale2)
		Text:SetFont(C.Medias.Font, 12)
		button.text:SetText(CLOSE)
	end
end)

button:SkinButton()

---------------------------------------------------------------
-- The following code has been taken from
-- Tukui Markbar version 1.14 - Battle for Azeroth - 02-01-2019
-- and been slightly modified for SanUI
---------------------------------------------------------------
local Minimap = S.Maps.Minimap

---------------------------------------------------------------
-- Tukui MarkBar Background Panel
---------------------------------------------------------------
local function Enable()
	-- markbarbackground
	local markbarbg = CreateFrame("Frame", "markbarbg", UIParent)
	S.CreateBackdrop(markbarbg)
	markbarbg:SetHeight((19*6) + (2*7))
	markbarbg:SetWidth(Minimap:GetWidth() +4)
	markbarbg:SetPoint("TOPLEFT", Minimap, "TOPRIGHT", Scale(17),0)
	markbarbg:SetFrameLevel(1)
	markbarbg:SetFrameStrata("DIALOG")
	markbarbg:SetAlpha(1)
	markbarbg:Hide()
	markbarbg:CreateShadow()

---------------------------------------------------------------
-- Button creation
---------------------------------------------------------------
	local CreateBtn = function(name, parent, w, h, tt_txt, txt) 
	-- 1. Name, 2. Parent, 3. width, 4. height, 5. tooltip text, 6. text on button
		local b = CreateFrame("Button", name, parent, "SecureActionButtonTemplate")
		b:SetWidth(Scale(w))
		b:SetHeight(Scale(h))
		S.CreateBackdrop(b)
		b.Backdrop:SetBackdropBorderColor(unpack(C.colors.BackdropColor))

		local btext=b:CreateFontString(nil, "OVERLAY")
		btext:SetFont(C["Medias"].fonts.Font, 11, nil)

		btext:SetText(txt)
		btext:SetTextColor(1, 1, 1)
		btext:SetPoint("CENTER", b, 'CENTER', 0, 0)
		btext:SetJustifyH("CENTER")	
		
		b:SetScript("OnEnter", function(self)
			GameTooltip:SetOwner(markbarbg, "ANCHOR_RIGHT", 0, 4)
			GameTooltip:AddLine(tt_txt, 1, 1, 1, 1, 1, 1)
			GameTooltip:Show()
		btext:SetTextColor(1, 1, 1)
		b.Backdrop:SetBackdropBorderColor(0.336, 0.357, 0.357)
		end)
		
		b:SetScript("OnLeave", function(self)
			GameTooltip:Hide()
		btext:SetTextColor(1, 1, 1)
		b.Backdrop:SetBackdropBorderColor(unpack(C.colors.BackdropColor))
		end)
		
		b:SetAttribute("type1", "macro")
		b.icon = mbbutton01:CreateTexture(nil, "OVERLAY")
		b.icon:SetSize(Scale(17), Scale(17))
		b.icon:SetPoint("CENTER", b, "CENTER", 0, 0)

		b:RegisterForClicks("AnyUp", "AnyDown")
		b:SkinButton()

	end
	
---------------------------------------------------------------
-- CREATING BUTTONS Raid Markers
---------------------------------------------------------------
	-- Button 1 - White/Skull
	CreateBtn("mbbutton01", markbarbg, 19, 19, "Set Raid Marker |cffFFFFFFSKULL|r", "")
	mbbutton01:SetPoint("TOPLEFT", markbarbg, "TOPLEFT", S.scale2, -S.scale2)
	mbbutton01:SetAttribute("macrotext1", "/tm 8")
		mbbutton01.icon:SetTexture([[Interface\AddOns\SanUI\Textures\markers\skull.blp]])

	-- Button 2 - Red/Cross
	CreateBtn("mbbutton02", markbarbg, 19, 19, "Set Raid Marker |cffFF0000CROSS|r", "")
	mbbutton02:SetPoint("LEFT", mbbutton01, "RIGHT", S.scale2, 0)
	mbbutton02:SetAttribute("macrotext1", "/tm 7")
		mbbutton02.icon:SetTexture([[Interface\AddOns\SanUI\Textures\markers\cross.blp]])

	-- Button 3 - Blue/Square
	CreateBtn("mbbutton03", markbarbg, 19, 19, "Set Raid Marker |cff0080FFSQUARE|r", "")
	mbbutton03:SetPoint("LEFT", mbbutton02, "RIGHT", S.scale2, 0)
	mbbutton03:SetAttribute("macrotext1", "/tm 6")
		mbbutton03.icon:SetTexture([[Interface\AddOns\SanUI\Textures\markers\square.blp]])

	-- Button 4 - Grey/Moon
	CreateBtn("mbbutton04", markbarbg, 19, 19, "Set Raid Marker |cffCCCCFFMOON|r", "")
	mbbutton04:SetPoint("LEFT", mbbutton03, "RIGHT", S.scale2, 0)
	mbbutton04:SetAttribute("macrotext1", "/tm 5")
		mbbutton04.icon:SetTexture([[Interface\AddOns\SanUI\Textures\markers\moon.blp]])

	-- Button 5 - Green/Triangle
	CreateBtn("mbbutton05", markbarbg, 19, 19, "Set Raid Marker |cff33FF33TRIANGLE|r", "")
	mbbutton05:SetPoint("TOPLEFT", mbbutton01, "BOTTOMLEFT", 0, -S.scale2)
	mbbutton05:SetAttribute("macrotext1", "/tm 4")
		mbbutton05.icon:SetTexture([[Interface\AddOns\SanUI\Textures\markers\triangle.blp]])

	-- Button 6 - Purple/Diamond
	CreateBtn("mbbutton06", markbarbg, 19, 19, "Set Raid Marker |cffFF00FFDIAMOND|r", "")
	mbbutton06:SetPoint("LEFT", mbbutton05, "RIGHT", S.scale2, 0)
	mbbutton06:SetAttribute("macrotext1", "/tm 3")
		mbbutton06.icon:SetTexture([[Interface\AddOns\SanUI\Textures\markers\diamond.blp]])

	-- Button 7 - Orange/Circle
	CreateBtn("mbbutton07", markbarbg, 19, 19, "Set Raid Marker |cffFF8000CIRCLE|r", "")
	mbbutton07:SetPoint("LEFT", mbbutton06, "RIGHT", S.scale2, 0)
	mbbutton07:SetAttribute("macrotext1", "/tm 2")
		mbbutton07.icon:SetTexture([[Interface\AddOns\SanUI\Textures\markers\circle.blp]])

	-- Button 8 - Yellow Star
	CreateBtn("mbbutton08", markbarbg, 19, 19, "Set Raid Marker |cffFFFF00STAR|r", "")
	mbbutton08:SetPoint("LEFT", mbbutton07, "RIGHT", S.scale2, 0)
	mbbutton08:SetAttribute("macrotext1", "/tm 1")
		mbbutton08.icon:SetTexture([[Interface\AddOns\SanUI\Textures\markers\star.blp]])

	-- Button Clear targetmark
	CreateBtn("mbbclear", markbarbg, 56, 19, "Clear Target Marker", "Clear")
	mbbclear:SetPoint("TOPRIGHT", markbarbg, "TOPRIGHT", -S.scale2, -S.scale2)
	mbbclear:SetAttribute("macrotext1", "/tm 0")

---------------------------------------------------------------
-- Additional functions / Raid tools
---------------------------------------------------------------
	-- Button Readycheck
	CreateBtn("pulltimerbutton", markbarbg, 82.5, 19, "Start a DBM pull timer", "DBM Pull")
	pulltimerbutton:SetPoint("TOPLEFT", mbbutton05, "BOTTOMLEFT", 0, -S.scale2)
	pulltimerbutton:SetAttribute("macrotext1", "/pull 13")

	-- Button Set Main Tank
	CreateBtn("maintankbutton", markbarbg, 56, 19, "Set Main Tank", "")
	maintankbutton:SetPoint("TOPRIGHT", mbbclear, "BOTTOMRIGHT", 0, -S.scale2)
	maintankbutton:SetAttribute("macrotext1", "/mt")
		maintankbutton.icon:SetTexture([[Interface\AddOns\SanUI\Textures\tank.tga]])

	-- Button Set Main Assist
	CreateBtn("mainassistbutton", markbarbg, 56, 19, "Set Main Assist", "")
	mainassistbutton:SetPoint("TOPRIGHT", maintankbutton, "BOTTOMRIGHT", 0, -S.scale2)
	mainassistbutton:SetAttribute("macrotext1", "/ma")
		mainassistbutton.icon:SetTexture([[Interface\AddOns\SanUI\Textures\mainassist.tga]])

	-- Button Readycheck
	CreateBtn("rcbutton", markbarbg, 56, 19, "Start a readycheck", "")
	rcbutton:SetPoint("TOPRIGHT", mainassistbutton, "BOTTOMRIGHT", 0, -S.scale2)
	rcbutton:SetAttribute("macrotext1", "/readycheck")
		rcbutton.icon:SetSize(Scale(34), Scale(17))
		rcbutton.icon:SetTexture([[Interface\AddOns\SanUI\Textures\readycheck.tga]])

---------------------------------------------------------------
-- Tukui World Markers / flares
---------------------------------------------------------------
	-- Button 1 - White/Skull
	CreateBtn("wbbutton01", markbarbg, 19, 19, "Set World Marker |cffFFFFFFSKULL|r", "")
	wbbutton01:SetPoint("TOPLEFT", pulltimerbutton, "BOTTOMLEFT", 0, -S.scale2)
	wbbutton01:SetAttribute("macrotext1", "/wm 8")
		wbbutton01.icon:SetTexture([[Interface\AddOns\SanUI\Textures\flares\white.tga]])

	-- Button 2 - Red/Cross
	CreateBtn("wbbutton02", markbarbg, 19, 19, "Set World Marker |cffFF0000CROSS|r", "")
	wbbutton02:SetPoint("LEFT", wbbutton01, "RIGHT", S.scale2, 0)
	wbbutton02:SetAttribute("macrotext1", "/wm 4")
		wbbutton02.icon:SetTexture([[Interface\AddOns\SanUI\Textures\flares\red.tga]])

	-- Button 3 - blue/square
	CreateBtn("wbbutton03", markbarbg, 19, 19, "Set World Marker |cff0080FFSQUARE|r", "")
	wbbutton03:SetPoint("LEFT", wbbutton02, "RIGHT", S.scale2, 0)
	wbbutton03:SetAttribute("macrotext1", "/wm 1")
		wbbutton03.icon:SetTexture([[Interface\AddOns\SanUI\Textures\flares\blue.tga]])

	-- Button 4 - gray/moon
	CreateBtn("wbbutton04", markbarbg, 19, 19, "Set World Marker |cffCCCCFFMOON|r", "")
	wbbutton04:SetPoint("LEFT", wbbutton03, "RIGHT", S.scale2, 0)
	wbbutton04:SetAttribute("macrotext1", "/wm 7")
		wbbutton04.icon:SetTexture([[Interface\AddOns\SanUI\Textures\flares\grey.tga]])

	-- Button 5 - green/triangle
	CreateBtn("wbbutton05", markbarbg, 19, 19, "Set World Marker |cff33FF33TRIANGLE|r", "")
	wbbutton05:SetPoint("TOPLEFT", wbbutton01, "BOTTOMLEFT", 0, -S.scale2)
	wbbutton05:SetAttribute("macrotext1", "/wm 2")
		wbbutton05.icon:SetTexture([[Interface\AddOns\SanUI\Textures\flares\green.tga]])

	-- Button 6 - purple/diamond
	CreateBtn("wbbutton06", markbarbg, 19, 19, "Set World Marker |cffFF00FFDIAMOND|r", "")
	wbbutton06:SetPoint("LEFT", wbbutton05, "RIGHT", S.scale2, 0)
	wbbutton06:SetAttribute("macrotext1", "/wm 3")
		wbbutton06.icon:SetTexture([[Interface\AddOns\SanUI\Textures\flares\purple.tga]])

	-- Button 7 - orange/circle
	CreateBtn("wbbutton07", markbarbg, 19, 19, "Set World Marker |cffFF8000CIRCLE|r", "")
	wbbutton07:SetPoint("LEFT", wbbutton06, "RIGHT", S.scale2, 0)
	wbbutton07:SetAttribute("macrotext1", "/wm 6")
		wbbutton07.icon:SetTexture([[Interface\AddOns\SanUI\Textures\flares\orange.tga]])

	-- Button 8 - yellow/star
	CreateBtn("wbbutton08", markbarbg, 19, 19, "Set World Marker |cffFFFF00STAR|r", "")
	wbbutton08:SetPoint("LEFT", wbbutton07, "RIGHT", S.scale2, 0)
	wbbutton08:SetAttribute("macrotext1", "/wm 5")
		wbbutton08.icon:SetTexture([[Interface\AddOns\SanUI\Textures\flares\yellow.tga]])


	-- Button Clear World Marker
	CreateBtn("wbclear", markbarbg, 56, 19, "Clear World Marker", "Clear")
	wbclear:SetPoint("TOP", rcbutton, "BOTTOM", 0, -S.scale2)
	wbclear:SetAttribute("macrotext1", "/cwm all")
end
hooksecurefunc(Minimap, "Enable", Enable)
