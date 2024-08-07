local _, addon = ...
local S, C = unpack(addon)

local medias = {}

local fonts = {
	Font = [[Interface\AddOns\WeakAuras\Media\Fonts\FiraSans-Medium.ttf]],
	sharednames = {
		Font = "Fira Sans Medium",
	},
	Hankfont = [[Interface/AddOns/WeakAuras/Media/Fonts/FiraSansCondensed-Medium.ttf]],
}
medias.fonts = fonts

local textures = {
	StatusbarNormal = [[Interface\Addons\SanUI\Medias\Textures\Flat.tga]],
	Blank = [[Interface\Addons\SanUI\Medias\Textures\No_Backdrop.tga]],
	Flat = [[Interface\Addons\SanUI\Medias\Textures\Flat.tga]],
	ArrowUp = [[Interface\AddOns\WeakAuras\Media\Textures\triangle-border.tga]]
}
medias.textures = textures

C.medias = medias
