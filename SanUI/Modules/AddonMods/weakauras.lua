local S,C = unpack(SanUI)

local GetSpellName = function(id) return select(1,GetSpellInfo(id)) end
		
function S.weakAurasDialog()
	local main = CreateFrame("Frame", nil, UIParent)
	main:Point("CENTER")
	main:Size(500,200)
	main:SetTemplate()
	main:FontString("Text", C.Medias.Font, 12)
	main.Text:Point("CENTER")
	main.Text:SetText("You do not have SanUIs WeakAura displays added to your WeakAuras. Should I do that now?" ..
						"\n\n" ..
						"Note: I'll not ask again. To reopen this dialog, type" ..
						"\n" ..
						"--> /tukui addweakauras <-- "..
						"\n" ..
						"into your chat (leave out the arrows and don't put a space before the /." )
	main.Text:SetJustifyH("MIDDLE")

	main.LeftButton = CreateFrame("Button", nil, main)
	main.LeftButton:Point("TOPRIGHT", main, "BOTTOMRIGHT", 0, -6)
	main.LeftButton:Size(128, 25)
	main.LeftButton:SkinButton()
	main.LeftButton:CreateShadow()
	main.LeftButton:FontString("Text", C.Medias.Font, 12)
	main.LeftButton.Text:SetPoint("CENTER")
	main.LeftButton.Text:SetText("Add and reload")
	main.LeftButton:SetScript("OnClick", function()
		S.addWeakAuras()
		SanUIdb.addedWeakAuras = true
		ReloadUI()
	end)
	
	main.RightButton = CreateFrame("Button", nil, main)
	main.RightButton:Point("TOPLEFT", main, "BOTTOMLEFT", 0, -6)
	main.RightButton:Size(128, 25)
	main.RightButton:SkinButton()
	main.RightButton:CreateShadow()
	main.RightButton:FontString("Text", C.Medias.Font, 12)
	main.RightButton.Text:SetPoint("CENTER")
	main.RightButton.Text:SetText("Just reload")
	main.RightButton:SetScript("OnClick", function() 
		SanUIdb.addedWeakAuras = true
		ReloadUI()
	end)

end

S.AddOnCommands["addweakauras"] = S.weakAurasDialog

function S.addWeakAuras()

	if true then
		print("Not implemented yet, watch out for legion release!")
		return
	end

	if not IsAddOnLoaded("WeakAuras") then print("WeakAuras not loaded!") return end
	if not WeakAurasSaved then print("WeakAurasSaved not loaded!") return end

	local key,value
		
	for key,value in pairs(S.weakAuras.displays) do
		WeakAurasSaved.displays[key] = value
	end

	WeakAuras.frames["Addon Initialization Handler"]:GetScript("OnEvent")("ADDON_LOADED","WeakAuras")
end
	
-- Adapted from AddonSkins by Azilroka
-- conceived by Elv
local function skinWaFrame(frame, type)
	local backdrop = frame.backdrop or frame.Backdrop
	if not backdrop then
		frame:CreateBackdrop('Transparent')
		backdrop = frame.backdrop or frame.Backdrop
		if type == 'icon' then
			backdrop:HookScript('OnUpdate', function(self)
				self:SetAlpha(self:GetParent().icon:GetAlpha())
			end)
		end
	end

	if ftype == 'aurabar' then
		backdrop:Show()
	end
	--frame.icon:SetTexCoord(.1, .9, .1, .9)
	--frame.icon.SetTexCoord = function() end
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
