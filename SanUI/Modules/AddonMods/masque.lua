local addonName, addon = ...
local S, C = unpack(addon)

---@class Masque table
---@field AddSkin function
---@field GetGroupByID function
local Masque = LibStub("Masque", true)
if not Masque then return end

local bsize = 36
local othersize = 38

Masque:AddSkin("SanUI", {
	Author = "Tuovi",
	Version = "11.0.0",
	Masque_Version = 110000,
	Shape = "Square",
	Backdrop = {
		Width = othersize,
		Height = othersize,
		Color = {1,0,0,0},
		Texture = [[Interface\AddOns\Masque_ElvUI\Textures\Backdrop]],
	},
	Icon = {
		Width = bsize,
		Height = bsize,
		TexCoords = {0.07,0.93,0.07,0.93},
	},
	Flash = {
		Width = othersize,
		Height = othersize,
		Color = {1, 1, 1, 0.5},
		Texture = [[Interface\AddOns\Masque_ElvUI\Textures\Flash]],
	},
	Cooldown = {
		Width = othersize,
		Height = othersize,
	},
	Pushed = {
		Width = othersize,
		Height = othersize,
		Color = {1, 0.8, 0.0, 0.25},
		Texture = [[Interface\AddOns\Masque_ElvUI\Textures\Flash]],
	},
	Normal = {
		Width = othersize,
		Height = othersize,
		Static = true,
		Color = {0,0,0,0},--C.colors.BorderColor,
		Texture = [[Interface\AddOns\Masque_ElvUI\Textures\Normal]],
	},
	Disabled = {
		Hide = true,
	},
	Checked = {
		Width = othersize,
		Height = othersize,
		BlendMode = "ADD",
		Color = {1, 1, 1, 1},
		Texture = [[Interface\AddOns\Masque_ElvUI\Textures\Border]],
	},
	Border = {
		Width = othersize,
		Height = othersize,
		BlendMode = "ADD",
		Color = C.colors.BorderColor, --{0, 0, 0, 1},
		OffsetX = -6,
		OffsetY = -6,
		Texture = [[Interface\AddOns\Masque_ElvUI\Textures\Border]],
	},
	Gloss = {
		Hide = true,
	},
	AutoCastable = {
		Width = othersize,
		Height = othersize,
		OffsetX = 0.5,
		OffsetY = -0.5,
		Texture = [[Interface\Buttons\UI-AutoCastableOverlay]],
	},
	Highlight = {
		Width = othersize,
		Height = othersize,
		BlendMode = "ADD",
		Color = {1, 1, 1, 0.25},
		Texture = [[Interface\AddOns\Masque_ElvUI\Textures\Highlight]],
	},
	Name = {
		Width = othersize,
		Height = 10,
		OffsetY = 6,
	},
	Count = {
		Width = othersize,
		Height = 10,
		OffsetX = -2,
		OffsetY = 2,
		FontSize = 13,
        --Font = C.medias.fonts.Font
	},
	HotKey = {
		Width = othersize,
		Height = 10,
		OffsetX = 0,
		OffsetY = 0,
		Point = "TOPRIGHT",
		RelPoint = "TOPRIGHT",
	},
	AutoCast = {
		Width = othersize,
		Height = othersize,
		OffsetX = 1,
		OffsetY = -1,
	},
}, true)