local _, addon = ...
local S,C = unpack(addon)

local Scale = S.Scale
local font = C.medias.fonts.Font
local fontsize = 11

---@class RaidUtilitiesButton: Frame
local raidutilities  = CreateFrame("Frame", nil, UIParent)
raidutilities:SetSize(S.scale10, S.scale10)
raidutilities:SetPoint("BOTTOMLEFT", Minimap, "BOTTOMRIGHT", Scale(3), Scale(28))
S.CreateBackdrop(raidutilities)
raidutilities:SetFrameStrata("MEDIUM")
--button:SetParent(Tukui_PetBattleFrameHider)
S.raidutilities = raidutilities

local markbarbg

local Text = raidutilities:CreateFontString(nil, "OVERLAY")
Text:SetFont(font, 10)
Text:SetText("r")
Text:SetJustifyH("CENTER")
Text:SetJustifyV("MIDDLE")
Text:SetPoint("CENTER",raidutilities,0,0)
Text:Show()
raidutilities.text = Text

raidutilities:EnableMouse(true)
raidutilities:SetScript("OnMouseDown", function(self,clicked)
	if markbarbg:IsShown() then
		raidutilities:SetFrameStrata("MEDIUM")
		markbarbg:Hide()
		S.AddonMenuOpen:Show()
		raidutilities:SetSize(S.scale10, S.scale10)
		raidutilities:ClearAllPoints()
		raidutilities:SetPoint("BOTTOMLEFT", Minimap, "BOTTOMRIGHT", Scale(3), Scale(28))
		Text:SetFont(font, 10)
		raidutilities.text:SetText("r")
		raidutilities:Show()
		S.AddonMenuOpen:Show()
	else
		raidutilities:SetFrameStrata("DIALOG")
		markbarbg:Show()
		S.AddonMenuOpen:Hide()
		raidutilities:SetSize(S.Scale(137),Scale(19))
		raidutilities:ClearAllPoints()
		raidutilities:SetPoint("BOTTOM", markbarbg, "BOTTOM", 0, S.scale2)
		Text:SetFont(font, 12)
		raidutilities.text:SetText(CLOSE)
	end
end)

--button:SkinButton()
S.CreateBackdrop(raidutilities)
---------------------------------------------------------------
-- The following code has been taken from
-- Tukui Markbar version 1.14 - Battle for Azeroth - 02-01-2019
-- and been slightly modified for SanUI
---------------------------------------------------------------
local Minimap = Minimap --S.Maps.Minimap

---------------------------------------------------------------
-- Tukui MarkBar Background Panel
---------------------------------------------------------------
local function Enable()
	-- markbarbackground
	markbarbg = CreateFrame("Frame", "markbarbg", UIParent)
	S.CreateBackdrop(markbarbg)
	markbarbg:SetHeight((19*6) + (2*7))
	markbarbg:SetWidth(S.Scale(141))
	markbarbg:SetPoint("TOPLEFT", Minimap, "TOPRIGHT", Scale(17),0)
	markbarbg:SetFrameLevel(1)
	markbarbg:SetFrameStrata("DIALOG")
	markbarbg:SetAlpha(1)
	markbarbg:Hide()
	--markbarbg:CreateShadow()

---------------------------------------------------------------
-- Button creation
---------------------------------------------------------------
	-- 1. Name, 2. Parent, 3. width, 4. height, 5. tooltip text, 6. text on button
	local CreateBtn = function(name, parent, w, h, tt_txt, txt)

		---@class AddonMenuButton: Button
		---@field Backdrop BackdropTemplate
		local b = CreateFrame("Button", nil, parent, "SecureActionButtonTemplate")
		b:SetWidth(Scale(w))
		b:SetHeight(Scale(h))
		S.CreateBackdrop(b)
		b.Backdrop:SetBackdropBorderColor(unpack(C.colors.BackdropColor))

		local btext=b:CreateFontString(nil, "OVERLAY")
		btext:SetFont(font, fontsize, nil)

		btext:SetText(txt)
		btext:SetTextColor(1, 1, 1)
		btext:SetPoint("CENTER", b, 'CENTER', 0, 0)
		btext:SetJustifyH("CENTER")

		b:SetScript("OnEnter", function(self)
			GameTooltip:SetOwner(markbarbg, "ANCHOR_RIGHT", 0, 4)
			GameTooltip:AddLine(tt_txt, 1, 1, 1)-- 1, 1, 1)
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
		b.icon = b:CreateTexture(nil, "OVERLAY")
		b.icon:SetSize(Scale(17), Scale(17))
		b.icon:SetPoint("CENTER", b, "CENTER", 0, 0)

		b:RegisterForClicks("AnyUp", "AnyDown")
		--b:SkinButton()

		raidutilities[name] = b
		return b
	end

---------------------------------------------------------------
-- CREATING BUTTONS Raid Markers
---------------------------------------------------------------
	-- Button 1 - White/Skull
	local mbbutton01 = CreateBtn("mbbutton01", markbarbg, 19, 19, "Set Raid Marker |cffFFFFFFSKULL|r", "")
	mbbutton01:SetPoint("TOPLEFT", markbarbg, "TOPLEFT", S.scale2, -S.scale2)
	mbbutton01:SetAttribute("macrotext1", "/tm 8")
	mbbutton01.icon:SetTexture([[Interface\AddOns\SanUI\Medias\Textures\markers\skull.blp]])

	-- Button 2 - Red/Cross
	local mbbutton02 = CreateBtn("mbbutton02", markbarbg, 19, 19, "Set Raid Marker |cffFF0000CROSS|r", "")
	mbbutton02:SetPoint("LEFT", mbbutton01, "RIGHT", S.scale2, 0)
	mbbutton02:SetAttribute("macrotext1", "/tm 7")
	mbbutton02.icon:SetTexture([[Interface\AddOns\SanUI\Medias\Textures\markers\cross.blp]])

	-- Button 3 - Blue/Square
	local mbbutton03 = CreateBtn("mbbutton03", markbarbg, 19, 19, "Set Raid Marker |cff0080FFSQUARE|r", "")
	mbbutton03:SetPoint("LEFT", mbbutton02, "RIGHT", S.scale2, 0)
	mbbutton03:SetAttribute("macrotext1", "/tm 6")
	mbbutton03.icon:SetTexture([[Interface\AddOns\SanUI\Medias\Textures\markers\square.blp]])

	-- Button 4 - Grey/Moon
	local mbbutton04 = CreateBtn("mbbutton04", markbarbg, 19, 19, "Set Raid Marker |cffCCCCFFMOON|r", "")
	mbbutton04:SetPoint("LEFT", mbbutton03, "RIGHT", S.scale2, 0)
	mbbutton04:SetAttribute("macrotext1", "/tm 5")
	mbbutton04.icon:SetTexture([[Interface\AddOns\SanUI\Medias\Textures\markers\moon.blp]])

	-- Button 5 - Green/Triangle
	local mbbutton05 = CreateBtn("mbbutton05", markbarbg, 19, 19, "Set Raid Marker |cff33FF33TRIANGLE|r", "")
	mbbutton05:SetPoint("TOPLEFT", mbbutton01, "BOTTOMLEFT", 0, -S.scale2)
	mbbutton05:SetAttribute("macrotext1", "/tm 4")
	mbbutton05.icon:SetTexture([[Interface\AddOns\SanUI\Medias\Textures\markers\triangle.blp]])

	-- Button 6 - Purple/Diamond
	local mbbutton06 = CreateBtn("mbbutton06", markbarbg, 19, 19, "Set Raid Marker |cffFF00FFDIAMOND|r", "")
	mbbutton06:SetPoint("LEFT", mbbutton05, "RIGHT", S.scale2, 0)
	mbbutton06:SetAttribute("macrotext1", "/tm 3")
	mbbutton06.icon:SetTexture([[Interface\AddOns\SanUI\Medias\Textures\markers\diamond.blp]])

	-- Button 7 - Orange/Circle
	local mbbutton07 = CreateBtn("mbbutton07", markbarbg, 19, 19, "Set Raid Marker |cffFF8000CIRCLE|r", "")
	mbbutton07:SetPoint("LEFT", mbbutton06, "RIGHT", S.scale2, 0)
	mbbutton07:SetAttribute("macrotext1", "/tm 2")
	mbbutton07.icon:SetTexture([[Interface\AddOns\SanUI\Medias\Textures\markers\circle.blp]])

	-- Button 8 - Yellow Star
	local mbbutton08 = CreateBtn("mbbutton08", markbarbg, 19, 19, "Set Raid Marker |cffFFFF00STAR|r", "")
	mbbutton08:SetPoint("LEFT", mbbutton07, "RIGHT", S.scale2, 0)
	mbbutton08:SetAttribute("macrotext1", "/tm 1")
	mbbutton08.icon:SetTexture([[Interface\AddOns\SanUI\Medias\Textures\markers\star.blp]])

	-- Button Clear targetmark
	local mbbclear = CreateBtn("mbbclear", markbarbg, 56, 19, "Clear Target Marker", "Clear")
	mbbclear:SetPoint("TOPRIGHT", markbarbg, "TOPRIGHT", -S.scale2, -S.scale2)
	mbbclear:SetAttribute("macrotext1", "/tm 0")

---------------------------------------------------------------
-- Additional functions / Raid tools
---------------------------------------------------------------
	-- Button Readycheck
	local pulltimerbutton = CreateBtn("pulltimerbutton", markbarbg, 80, 19, "Start a DBM pull timer", "DBM Pull")
	pulltimerbutton:SetPoint("TOPLEFT", mbbutton05, "BOTTOMLEFT", 0, -S.scale2)
	pulltimerbutton:SetAttribute("macrotext1", "/pull 13")

	-- Button Set Main Tank
	local maintankbutton = CreateBtn("maintankbutton", markbarbg, 56, 19, "Set Main Tank", "")
	maintankbutton:SetPoint("TOPRIGHT", mbbclear, "BOTTOMRIGHT", 0, -S.scale2)
	maintankbutton:SetAttribute("macrotext1", "/mt")
	maintankbutton.icon:SetTexture([[Interface\AddOns\SanUI\Medias\Textures\tank.tga]])

	-- Button Set Main Assist
	local mainassistbutton = CreateBtn("mainassistbutton", markbarbg, 56, 19, "Set Main Assist", "")
	mainassistbutton:SetPoint("TOPRIGHT", maintankbutton, "BOTTOMRIGHT", 0, -S.scale2)
	mainassistbutton:SetAttribute("macrotext1", "/ma")
	mainassistbutton.icon:SetTexture([[Interface\AddOns\SanUI\Medias\Textures\mainassist.tga]])

	-- Button Readycheck
	local rcbutton = CreateBtn("rcbutton", markbarbg, 56, 19, "Start a readycheck", "")
	rcbutton:SetPoint("TOPRIGHT", mainassistbutton, "BOTTOMRIGHT", 0, -S.scale2)
	rcbutton:SetAttribute("macrotext1", "/readycheck")
	rcbutton.icon:SetSize(Scale(34), Scale(17))
	rcbutton.icon:SetTexture([[Interface\AddOns\SanUI\Medias\Textures\readycheck.tga]])

---------------------------------------------------------------
-- Tukui World Markers / flares
---------------------------------------------------------------
	-- Button 1 - White/Skull
	local wbbutton01 = CreateBtn("wbbutton01", markbarbg, 19, 19, "Set World Marker |cffFFFFFFSKULL|r", "")
	wbbutton01:SetPoint("TOPLEFT", pulltimerbutton, "BOTTOMLEFT", 0, -S.scale2)
	wbbutton01:SetAttribute("macrotext1", "/wm 8")
	wbbutton01.icon:SetTexture([[Interface\AddOns\SanUI\Medias\Textures\flares\white.tga]])

	-- Button 2 - Red/Cross
	local wbbutton02 = CreateBtn("wbbutton02", markbarbg, 19, 19, "Set World Marker |cffFF0000CROSS|r", "")
	wbbutton02:SetPoint("LEFT", wbbutton01, "RIGHT", S.scale2, 0)
	wbbutton02:SetAttribute("macrotext1", "/wm 4")
	wbbutton02.icon:SetTexture([[Interface\AddOns\SanUI\Medias\Textures\flares\red.tga]])

	-- Button 3 - blue/square
	local wbbutton03 = CreateBtn("wbbutton03", markbarbg, 19, 19, "Set World Marker |cff0080FFSQUARE|r", "")
	wbbutton03:SetPoint("LEFT", wbbutton02, "RIGHT", S.scale2, 0)
	wbbutton03:SetAttribute("macrotext1", "/wm 1")
	wbbutton03.icon:SetTexture([[Interface\AddOns\SanUI\Medias\Textures\flares\blue.tga]])

	-- Button 4 - gray/moon
	local wbbutton04 = CreateBtn("wbbutton04", markbarbg, 19, 19, "Set World Marker |cffCCCCFFMOON|r", "")
	wbbutton04:SetPoint("LEFT", wbbutton03, "RIGHT", S.scale2, 0)
	wbbutton04:SetAttribute("macrotext1", "/wm 7")
	wbbutton04.icon:SetTexture([[Interface\AddOns\SanUI\Medias\Textures\flares\grey.tga]])

	-- Button 5 - green/triangle
	local wbbutton05 = CreateBtn("wbbutton05", markbarbg, 19, 19, "Set World Marker |cff33FF33TRIANGLE|r", "")
	wbbutton05:SetPoint("TOPLEFT", wbbutton01, "BOTTOMLEFT", 0, -S.scale2)
	wbbutton05:SetAttribute("macrotext1", "/wm 2")
	wbbutton05.icon:SetTexture([[Interface\AddOns\SanUI\Medias\Textures\flares\green.tga]])

	-- Button 6 - purple/diamond
	local wbbutton06 = CreateBtn("wbbutton06", markbarbg, 19, 19, "Set World Marker |cffFF00FFDIAMOND|r", "")
	wbbutton06:SetPoint("LEFT", wbbutton05, "RIGHT", S.scale2, 0)
	wbbutton06:SetAttribute("macrotext1", "/wm 3")
	wbbutton06.icon:SetTexture([[Interface\AddOns\SanUI\Medias\Textures\flares\purple.tga]])

	-- Button 7 - orange/circle
	local wbbutton07 = CreateBtn("wbbutton07", markbarbg, 19, 19, "Set World Marker |cffFF8000CIRCLE|r", "")
	wbbutton07:SetPoint("LEFT", wbbutton06, "RIGHT", S.scale2, 0)
	wbbutton07:SetAttribute("macrotext1", "/wm 6")
	wbbutton07.icon:SetTexture([[Interface\AddOns\SanUI\Medias\Textures\flares\orange.tga]])

	-- Button 8 - yellow/star
	local wbbutton08 = CreateBtn("wbbutton08", markbarbg, 19, 19, "Set World Marker |cffFFFF00STAR|r", "")
	wbbutton08:SetPoint("LEFT", wbbutton07, "RIGHT", S.scale2, 0)
	wbbutton08:SetAttribute("macrotext1", "/wm 5")
	wbbutton08.icon:SetTexture([[Interface\AddOns\SanUI\Medias\Textures\flares\yellow.tga]])


	-- Button Clear World Marker
	local wbclear = CreateBtn("wbclear", markbarbg, 56, 19, "Clear World Marker", "Clear")
	wbclear:SetPoint("TOP", rcbutton, "BOTTOM", 0, -S.scale2)
	wbclear:SetAttribute("macrotext1", "/cwm all")
end
--hooksecurefunc(Minimap, "Enable", Enable)

Enable()
