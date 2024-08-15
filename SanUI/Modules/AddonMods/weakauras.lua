local _, addon = ...
local S,C = unpack(addon)

local Scale = S.Scale

local IsAddOnLoaded = C_AddOns.IsAddOnLoaded

function S.weakAurasDialog(new_version, old_version)
	---@class WeakAurasDialog: Frame
	local main = CreateFrame("Frame", nil, UIParent)
	main:SetPoint("CENTER")
	main:SetSize(500,200)
	S.CreateBackdrop(main)

	local text1 = main:CreateFontString(nil, "OVERLAY")
	text1:SetFont(C.medias.fonts.Font, 12)
	text1:SetJustifyH("LEFT")
	text1:SetShadowColor(0, 0, 0)
	text1:SetShadowOffset(1, 1)
	text1:SetPoint("CENTER")
	text1:SetText("SanUI's weakauras installed: version "..(old_version or "None") ..
	              "\n\n"..
				  "SanUI's weakauras available: version "..(new_version or "None")..
				  "\n\nShould we add SanUI's weakauras to yours? "..
				  "\n\n\n"..
				  "Note: I'll not ask again. To reopen this dialog, type" ..
				  "\n" ..
				  "              /sanui addweakauras "..
				  "\n" ..
				  "into your chat (don't put a space before the /)." )

	main.LeftButton = CreateFrame("Button", nil, main)
	main.LeftButton:SetPoint("TOPRIGHT", main, "BOTTOMRIGHT", 0, -6)
	main.LeftButton:SetSize(128, 25)
	--main.LeftButton:SkinButton()
	--main.LeftButton:CreateShadow()

	local text2 = main.LeftButton:CreateFontString(nil, "OVERLAY")
	text2:SetFont(C.medias.fonts.Font, 12)
	text2:SetJustifyH("LEFT")
	text2:SetShadowColor(0, 0, 0)
	text2:SetShadowOffset(1, 1)
	text2:SetPoint("CENTER")
	text2:SetPoint("CENTER")
	text2:SetText("Add and reload")

	main.LeftButton:SetScript("OnClick", function()
		S.addWeakAuras()
		SanUIdb.addedWeakAuras = new_version
		SanUIdb.askedWeakAuras = new_version
		ReloadUI()
	end)

	main.RightButton = CreateFrame("Button", nil, main)
	main.RightButton:SetPoint("TOPLEFT", main, "BOTTOMLEFT", 0, -6)
	main.RightButton:SetSize(128, 25)
	-- main.RightButton:SkinButton()
	-- main.RightButton:CreateShadow()

	local text3 = main.RightButton:CreateFontString(nil, "OVERLAY")
	text3:SetFont(C.medias.fonts.Font, 12)
	text3:SetJustifyH("LEFT")
	text3:SetShadowColor(0, 0, 0)
	text3:SetShadowOffset(1, 1)
	text3:SetPoint("CENTER")
	text3:SetPoint("CENTER")
	text3:SetText("Do nothing")

	main.RightButton:SetScript("OnClick", function()
		SanUIdb.askedWeakAuras = new_version
		S.Kill(main.RightButton)
		S.Kill(main.LeftButton)
		S.Kill(main)
	end)

end

function S.addWeakAuras()

	if not IsAddOnLoaded("WeakAuras") then print("WeakAuras not loaded!") return end
	if not WeakAurasSaved then print("WeakAurasSaved not loaded!") return end

	for key, _ in pairs(WeakAurasSaved.displays) do
		if key:sub(1, #"SanUI_") == "SanUI_" then
			WeakAurasSaved.displays[key] = nil
		end
	end

	for key, value in pairs(S.weakAuras.displays) do
		if key:sub(1, #"SanUI_") == "SanUI_" then
			WeakAurasSaved.displays[key] = value
		end
	end
end

--[[
-- Adapted from AddonSkins by Azilroka
-- conceived by Elv
local function skinWaFrame(frame, type)
	frame:CreateBackdrop()
	if type == 'icon' then
	frame.Backdrop:SetBackdropColor(0,0,0,0)
	end

	if type == 'aurabar' or type == 'icon' then
	frame.Backdrop:ClearAllPoints()
	frame.Backdrop:SetPoint("TOPLEFT", frame, "TOPLEFT", -S.scale1, S.scale1)
	frame.Backdrop:SetPoint("BOTTOMRIGHT", frame, "BOTTOMRIGHT", S.scale1, -S.scale1)
		frame.Backdrop:Show()
	end
end

local function Create_Icon(parent, data)
	local region = WeakAuras.regionTypes.icon.OldCreate(parent, data)
	skinWaFrame(region, 'icon')
	
	return region
end
WeakAuras.regionTypes.icon.OldCreate = WeakAuras.regionTypes.icon.create
WeakAuras.regionTypes.icon.create = Create_Icon

local function Create_Aurabar(parent)
	local region = WeakAuras.regionTypes.aurabar.OldCreate(parent)
	skinWaFrame(region, 'aurabar')

	return region
end
WeakAuras.regionTypes.aurabar.OldCreate = WeakAuras.regionTypes.aurabar.create
WeakAuras.regionTypes.aurabar.create = Create_Aurabar

local function Modify_Icon(parent, region, data)
	WeakAuras.regionTypes.icon.OldModify(parent, region, data)

	skinWaFrame(region, 'icon')
end
WeakAuras.regionTypes.icon.OldModify = WeakAuras.regionTypes.icon.modify
WeakAuras.regionTypes.icon.modify = Modify_Icon

local function Modify_Aurabar(parent, region, data)
	WeakAuras.regionTypes.aurabar.OldModify(parent, region, data)

	skinWaFrame(region, 'aurabar')
end
WeakAuras.regionTypes.aurabar.OldModify = WeakAuras.regionTypes.aurabar.modify
WeakAuras.regionTypes.aurabar.modify = Modify_Aurabar

for weakAura, _ in pairs(WeakAuras.regions) do
	if WeakAuras.regions[weakAura].regionType == 'icon'
	   or WeakAuras.regions[weakAura].regionType == 'aurabar' then
		skinWaFrame(WeakAuras.regions[weakAura].region, WeakAuras.regions[weakAura].regionType)
	end
end

S.skinWaFrame = skinWaFrame
--]]
