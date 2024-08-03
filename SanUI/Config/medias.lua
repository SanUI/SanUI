local _, addon = ...
local S, C = unpack(addon)

local medias = {}

local fonts = {
	Font = [[Interface\AddOns\WeakAuras\Media\Fonts\FiraSans-Medium.ttf]],
	sharednames = {
		Font = "Fira Sans Medium",
	}
}
medias.fonts = fonts

local textures = {
	StatusbarNormal = [[Interface\Addons\SanUI\Medias\Textures\Flat.tga]],
	Blank = [[Interface\Addons\SanUI\Medias\Textures\No_Backdrop.tga]],
	Flat = [[Interface\Addons\SanUI\Medias\Textures\Flat.tga]],
}
medias.textures = textures

C.medias = medias
