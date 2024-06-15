--we just import the full Tukui, and modify it to our hearts desire
local addonName, addon = ...

if not Tukui then
  print("Tukui not installed! If you want to use SanUI, install a recent Tukui!")
  return
end

addon[1] = Tukui[1] -- S, functions, constants, variables
addon[2] = Tukui[2] -- C, config
addon[3] = Tukui[3] -- L, localization
addon[4] = Tukui[4] -- G, globals (Optionnal)

-- additional stuff
addon[1].myname = UnitName("player")
addon[1].MyName = UnitName("player")
				
addon.oUF = Tukui.oUF

SanUI = addon -- Allow other addons to use SanUI

local Scale = addon[1].Toolkit.Functions.Scale
addon[1].scale1 = Scale(1)
addon[1].scale2 = Scale(2)
addon[1].scale4 = Scale(4)
addon[1].scale6 = Scale(6)
addon[1].scale10 = Scale(10)

local S = addon[1]
local C = addon[2]
local L = addon[3]
local G = addon[4]

S.CreateBackdrop = function(frame, BackgroundTemplate, BackgroundTexture, BorderTemplate)
	local f = frame
	local colors = C.colors
	
	if (f.Backdrop) then
		return
	end

	local backdrop = CreateFrame("Frame", nil, f, "BackdropTemplate")
	backdrop:SetAllPoints()
	backdrop:SetFrameLevel(f:GetFrameLevel())
	backdrop:SetBackdrop({bgFile = BackgroundTexture or colors.NormalTexture})
	
	local bgalpha = (BackgroundTemplate == "Transparent" and colors.BackdropTransparency) or (1)
	backdrop:SetBackdropColor(colors.BackdropColor[1], colors.BackdropColor[2], colors.BackdropColor[3], bgalpha)

	local BorderSize = Scale(1)

	local bordertop = backdrop:CreateTexture(nil, "BORDER", nil, 1)
	bordertop:SetSize(BorderSize, BorderSize)
	bordertop:SetPoint("TOPLEFT", backdrop, "TOPLEFT", 0, 0)
	bordertop:SetPoint("TOPRIGHT", backdrop, "TOPRIGHT", 0, 0)
	bordertop:SetSnapToPixelGrid(false)
	bordertop:SetTexelSnappingBias(0)
	backdrop.BorderTop = bordertop

	local borderbottom = backdrop:CreateTexture(nil, "BORDER", nil, 1)
	borderbottom:SetSize(BorderSize, BorderSize)
	borderbottom:SetPoint("BOTTOMLEFT", backdrop, "BOTTOMLEFT", 0, 0)
	borderbottom:SetPoint("BOTTOMRIGHT", backdrop, "BOTTOMRIGHT", 0, 0)
	borderbottom:SetSnapToPixelGrid(false)
	borderbottom:SetTexelSnappingBias(0)
	backdrop.BorderBottom = borderbottom

	local borderleft = backdrop:CreateTexture(nil, "BORDER", nil, 1)
	borderleft:SetSize(BorderSize, BorderSize)
	borderleft:SetPoint("TOPLEFT", backdrop, "TOPLEFT", 0, 0)
	borderleft:SetPoint("BOTTOMLEFT", backdrop, "BOTTOMLEFT", 0, 0)
	borderleft:SetSnapToPixelGrid(false)
	borderleft:SetTexelSnappingBias(0)
	backdrop.BorderLeft = borderleft

	local borderright = backdrop:CreateTexture(nil, "BORDER", nil, 1)
	borderright:SetSize(BorderSize, BorderSize)
	borderright:SetPoint("TOPRIGHT", backdrop, "TOPRIGHT", 0, 0)
	borderright:SetPoint("BOTTOMRIGHT", backdrop, "BOTTOMRIGHT", 0, 0)
	borderright:SetSnapToPixelGrid(false)
	borderright:SetTexelSnappingBias(0)
	backdrop.BorderRight = borderright

	backdrop:SetBorderColor(colors.BorderColor[1], colors.BorderColor[2], colors.BorderColor[3])
	
	f.Backdrop = backdrop
end