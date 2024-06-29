local addonName, addon = ...
local S,C = unpack(addon)

local Scale = S.Scale
local sizes = C.sizes

S.modMinimap = function()
	Minimap:ClearAllPoints()
	Minimap:SetPoint("TOPLEFT",UIParent,"TOPLEFT",5,-5)
	Minimap:SetSize(sizes.minimap,sizes.minimap)
end