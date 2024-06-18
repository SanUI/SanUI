-- Original from Masque_ElvUI, adapted for SanUI
-- by Tuovi of EU-Mal'Ganis

local addonName, addon = ...
local S, C = unpack(addon)


local Masque = LibStub("Masque", true)
if not Masque then return end

local size = C.sizes.actionbuttons + 2

Masque:AddSkin("SanUI", {
	Author = "Tuovi-Mal'Ganis",
	Version = "1.0.0",
	Masque_Version = 100207,
	Shape = "Square",
	Backdrop = {
		Width = size,
		Height = size,
		Color = { 1, 0, 0, 0 },
		Texture = [[Interface\AddOns\SanUI\Medias\Textures\No_Backdrop]],
	},
	Icon = {
		Width = C.sizes.actionbuttons,
		Height = C.sizes.actionbuttons,
		TexCoords = {0.07,0.93,0.07,0.93},
	},
	Flash = {
		Width = size,
		Height = size,
		Color = {1, 1, 1, 0.5},
		Texture = [[Interface\AddOns\SanUI\Medias\Textures\Flash]],
	},
	Cooldown = {
		Width = size,
		Height = size,
	},
	Pushed = {
		Width = size,
		Height = size,
		Color = {1, 0.8, 0.0, 0.25},
		Texture = [[Interface\AddOns\SanUI\Medias\Textures\Flash]],
	},
	Normal = {
		Width = size,
		Height = size,
		Static = true,
		Color = C.colors.BorderColor,
		Texture = [[Interface\AddOns\WeakAuras\Media\Textures\square_border_1px]],
	},
	Disabled = {
		Hide = true,
	},
	Checked = {
		Width = size,
		Height = size,
		BlendMode = "ADD",
		Color = {1, 1, 1, 1},
		Texture = [[Interface\AddOns\SanUI\Medias\Textures\Border]],
	},
	Border = {
		Width = size,
		Height = size,
		BlendMode = "ADD",
		Color = {1, 0, 0 },--C.colors.BorderColor,
		OffsetX = 0,
		OffsetY = 0,
		Texture = [[Interface\AddOns\SanUI\Medias\Textures\Border]],
	},
	Gloss = {
		Hide = true,
	},
	AutoCastable = {
		Width = size,
		Height = size,
		OffsetX = 0.5,
		OffsetY = -0.5,
		Texture = [[Interface\Buttons\UI-AutoCastableOverlay]],
	},
	Highlight = {
		Width = size,
		Height = size,
		BlendMode = "ADD",
		Color = {1, 1, 1, 0.25},
		Texture = [[Interface\AddOns\SanUI\Medias\Textures\Highlight]],
	},
	Name = {
		Width = size,
		Height = 10,
		OffsetY = 2,
	},
	Count = {
		Width = size,
		Height = 10,
		OffsetX = -2,
		OffsetY = 2,
		FontSize = 13,
	},
	HotKey = {
		Width = size,
		Height = 16,
		OffsetX = -2,
		OffsetY = -2,
	},
	AutoCast = {
		Width = size,
		Height = size,
		OffsetX = 1,
		OffsetY = -1,
	},
}, true)

local addons = { "Dominos", "WeakAuras" }


S.skinByMasque = function()
	for _, addon in ipairs(addons) do
		local g = Masque:GetGroupByID(addon)
		g:__Set("SkinID", "SanUI")
	end
end