local _, addon = ...
local S,C = unpack(addon)

local Scale = S.Scale

local IsAddOnLoaded = C_AddOns.IsAddOnLoaded

S.weakAurasDialog = function(new_version)
	new_version = new_version or C_AddOns.GetAddOnMetadata("SanUI", "version")
	local old_version =  SanUIdb.addedWeakAuras
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
				  "\n\nShould we import SanUI's weakauras? "..
				  "\n\n\n"..
				  "Note: I'll not ask again. To reopen this dialog, type" ..
				  "\n" ..
				  "              /sanui addweakauras "..
				  "\n" ..
				  "into your chat (don't put a space before the /)." )

	main.LeftButton = CreateFrame("Button", nil, main)
	main.LeftButton:SetPoint("TOPRIGHT", main, "BOTTOMRIGHT", 0, -6)
	main.LeftButton:SetSize(128, 25)
	S.CreateBackdrop(main.LeftButton)
	--main.LeftButton:SkinButton()
	--main.LeftButton:CreateShadow()

	local text2 = main.LeftButton:CreateFontString(nil, "OVERLAY")
	text2:SetFont(C.medias.fonts.Font, 12)
	text2:SetJustifyH("LEFT")
	text2:SetShadowColor(0, 0, 0)
	text2:SetShadowOffset(1, 1)
	text2:SetPoint("CENTER")
	text2:SetPoint("CENTER")
	text2:SetText("Import")

	main.LeftButton:SetScript("OnClick", function()
		S.addWeakAuras()
		SanUIdb.addedWeakAuras = new_version
		SanUIdb.askedWeakAuras = new_version
		main:Hide()
	end)

	main.RightButton = CreateFrame("Button", nil, main)
	main.RightButton:SetPoint("TOPLEFT", main, "BOTTOMLEFT", 0, -6)
	main.RightButton:SetSize(128, 25)
	S.CreateBackdrop(main.RightButton)

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

local function makeLoader(k, fun)
	local k = k
	local fun = fun

	return function()
		print("Loading "..k)
		WeakAuras.Import(S.weakAuras[k], nil, fun)
	end
end

S.addWeakAuras = function()
	if not IsAddOnLoaded("WeakAuras") then print("WeakAuras not loaded!") return end

	local fun

	for k, _ in pairs(S.weakAuras) do
		fun = makeLoader(k, fun)
	end

	fun()
end