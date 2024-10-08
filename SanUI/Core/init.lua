local _, addon = ...

addon[1] = {} -- S, functions, constants, variables
addon[2] = {} -- C, config

local S = addon[1]
local C = addon[2]

-- additional stuff
S.myname = UnitName("player")
S.MyName = UnitName("player")
S.MyClass = UnitClass("player")

SanUI = addon -- Allow other addons to use SanUI

S.unitFrames = {}

--[=[
local LSM = LibStub("LibSharedMedia-3.0")
local MediaType_BACKGROUND = LSM.MediaType.BACKGROUND
local MediaType_BORDER = LSM.MediaType.BORDER
local MediaType_FONT = LSM.MediaType.FONT
local MediaType_STATUSBAR = LSM.MediaType.STATUSBAR
LSM:Register(MediaType_STATUSBAR, "AAA1", [[Interface\Addons\SanUI\Medias\Textures\Flash.tga]])
--]=]

S.Kill = function(f)
	if (f.UnregisterAllEvents) then
		f:UnregisterAllEvents()
		f:SetParent(S.panels.Hider)
	else
		f.Show = f.Hide
	end

	if f.SetTexture then
		f:SetTexture(nil)
	end

	f:Hide()
end

--local Resolution = select(1, GetPhysicalScreenSize()).."x"..select(2, GetPhysicalScreenSize())
--local PixelPerfectScale = 768 / string.match(Resolution, "%d+x(%d+)")
local ppscale = 768/select(2, GetPhysicalScreenSize())
local Scale = function(size)
	local Mult = ppscale / GetCVar("uiScale")
	local Value = Mult * math.floor(size / Mult + .5)

	return Value
end

S.Scale = Scale


addon[1].scale1 = Scale(1)
addon[1].scale2 = Scale(2)
addon[1].scale4 = Scale(4)
addon[1].scale6 = Scale(6)
addon[1].scale10 = Scale(10)

S.CreateAnonymousBackdrop= function(frame, BackgroundTemplate, BackgroundTexture, BorderTemplate)
	local f = frame
	local colors = C.colors
	local parentFrame
	if f:IsObjectType("Frame") then 
		parentFrame = f
	else
		parentFrame = f:GetParent()
	end
	---@class SanUIBackdrop: BackdropTemplate, Frame
	local backdrop = CreateFrame("Frame", nil, parentFrame, "BackdropTemplate")
	backdrop:SetAllPoints(f)
	backdrop:SetFrameLevel(parentFrame:GetFrameLevel())
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

	local r, g, b = unpack(colors.BorderColor)
	bordertop:SetColorTexture(r, g, b)
	borderright:SetColorTexture(r, g, b)
	borderbottom:SetColorTexture(r, g, b)
	borderleft:SetColorTexture(r, g, b)

	return backdrop
end

S.CreateBackdrop = function(frame, BackgroundTemplate, BackgroundTexture, BorderTemplate)
	local f = frame
	local colors = C.colors

	if (f.Backdrop) then
		return
	end

	local bgalpha = (BackgroundTemplate == "Transparent" and colors.BackdropTransparency) or (1)
	local backdrop = S.CreateAnonymousBackdrop(f, BackgroundTemplate, BackgroundTexture, BorderTemplate)

	---@class SanUIBackdrop: BackdropTemplate, Frame
	f.Backdrop = backdrop
	f.SetBackdropBorderColor = function(t)
		backdrop.BorderTop:SetColorTexture(t[1], t[2], t[3])
		backdrop.BorderRight:SetColorTexture(t[1], t[2], t[3])
		backdrop.BorderBottom:SetColorTexture(t[1], t[2], t[3])
		backdrop.BorderLeft:SetColorTexture(t[1], t[2], t[3])
	end
	f.SetBackdropColor = function(t)
		backdrop:SetBackdropColor(t[1], t[2], t[3], t[4] or bgalpha)
	end
end
