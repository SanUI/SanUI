local _, addon = ...
local S,C = unpack(addon)

local media = LibStub("LibSharedMedia-3.0")

local Scale = S.Scale
local sizes = C.sizes
local colors = C.colors

local map = BasicMinimap
--local font = C.medias.fonts.Font
local fontname = C.medias.fonts.sharednames.Font

local function UpdateFont(frame, db)
	local flags = nil
	if db.monochrome and db.outline ~= "NONE" then
		flags = "MONOCHROME," .. db.outline
	elseif db.monochrome then
		flags = "MONOCHROME"
	elseif db.outline ~= "NONE" then
		flags = db.outline
	end
	frame:SetFont(media:Fetch("font", db.font), db.fontSize, flags)
	
	-- Fix Size
	map.clock.text:SetText("99:99")
	local width = map.clock.text:GetUnboundedStringWidth()
	map.clock:SetWidth(width + 5)
	
	--UpdateClock()
end

S.modMinimap = function()
	map.db.profile.borderSize = 0
	map.db.profile.colorBorder = {0,0,0,0}
	map.backdrop:SetColorTexture(0,0,0,0)
	map.db.profile.size = sizes.minimap

	Minimap:ClearAllPoints()
	Minimap:SetPoint("TOPLEFT",UIParent,"TOPLEFT",5,-5)
	Minimap:SetSize(sizes.minimap,sizes.minimap)
	S.CreateBackdrop(Minimap)
	map.clock:ClearAllPoints()
	map.clock:SetPoint("CENTER",S.panels.minimap.dt_left, "CENTER", 0, -S.scale1)
	map.clock.text:SetJustifyH("CENTER")
	map.db.profile.clockConfig.font = fontname
	UpdateFont(map.clock.text, map.db.profile.clockConfig)
	
	S.createLootspecDT(S.panels.minimap.dt_right)
	
	map.db.profile.zoneTextConfig.y = -S.scale2
	map.zonetext:ClearAllPoints()
	map.zonetext:SetPoint("BOTTOM", map.backdrop, "TOP", map.db.profile.zoneTextConfig.x, -Scale(20))
end

hooksecurefunc(map, "LOADING_SCREEN_DISABLED", S.modMinimap)
