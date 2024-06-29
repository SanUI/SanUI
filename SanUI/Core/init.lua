--we just import the full Tukui, and modify it to our hearts desire
local addonName, addon = ...

--[[
if not Tukui then
  print("Tukui not installed! If you want to use SanUI, install a recent Tukui!")
  return
end
--]]

addon[1] = (Tukui and Tukui[1]) or {} -- S, functions, constants, variables
addon[2] = (Tukui and Tukui[2]) or {} -- C, config
addon[3] = (Tukui and Tukui[3]) or {} -- C, config
addon[4] = (Tukui and Tukui[4]) or {} -- C, config

local S = addon[1]
local C = addon[2]

-- additional stuff
S.myname = UnitName("player")
S.MyName = UnitName("player")
S.MyClass = UnitClass("player")
				
addon.oUF = Tukui and Tukui.oUF

SanUI = addon -- Allow other addons to use SanUI



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

	--if Value == 0 then
		-- print(size .. " -> " .. Value)
	-- end
	return Value
end

S.Scale = Scale


addon[1].scale1 = Scale(1)
addon[1].scale2 = Scale(2)
addon[1].scale4 = Scale(4)
addon[1].scale6 = Scale(6)
addon[1].scale10 = Scale(10)

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
	borderright:SetPoint("TOPRIGHT", f, "TOPRIGHT", S.scale1, 0)
	borderright:SetPoint("BOTTOMRIGHT", f, "BOTTOMRIGHT", S.scale1, 0)
	borderright:SetSnapToPixelGrid(false)
	borderright:SetTexelSnappingBias(0)
	backdrop.BorderRight = borderright
	
	local r, g, b = unpack(colors.BorderColor)
	bordertop:SetColorTexture(r, g, b)
	borderright:SetColorTexture(r, g, b)
	borderbottom:SetColorTexture(r, g, b)
	borderleft:SetColorTexture(r, g, b)
	
	f.Backdrop = backdrop
	f.SetBackdropBorderColor = function(t)
		bordertop:SetColorTexture(t[1], t[2], t[3])
		borderright:SetColorTexture(t[1], t[2], t[3])
		borderbottom:SetColorTexture(t[1], t[2], t[3])
		borderleft:SetColorTexture(t[1], t[2], t[3])
	end
	f.SetBackdropColor = function(t)
		backdrop:SetBackdropColor(t[1], t[2], t[3], t[4] or bgalpha)
	end
end