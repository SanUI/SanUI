local _, addon = ...
local S, C = unpack(addon)

local colors = {
	BackdropColor = {0.11, 0.11, 0.11},
	BorderColor = {0.3, 0.3, 0.3},
	BackdropTransparency = 0,
	Healthbar = { 0.2, 0.2, 0.2 },
	Healthbarbackdrop = { 0, 0, 0},
	NormalTexture =[[Interface\AddOns\Tukui\Medias\Textures\Status\Tukui]],
	RangeAlpha = 0.3,
	CastingColor = {0.29, 0.77, 0.30},
	Castbarbg = { 0.11,0.11,0.11}, --29/255, 63/255, 72/255 },
}

C.colors = colors
