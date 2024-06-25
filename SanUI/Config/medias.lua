local addonName, addon = ...
local S, C = unpack(addon)

local medias = {}

local fonts = {
	Font = [[Interface\AddOns\WeakAuras\Media\Fonts\FiraSans-Medium.ttf]]
}
medias.fonts = fonts

local textures = {
	StatusbarNormal = [[Interface\Addons\SanUI\Medias\Textures\Flash.tga]],
	Blank = [[Interface\Addons\SanUI\Medias\Textures\No_Backdrop.tga]],
}
medias.textures = textures

C.medias = medias