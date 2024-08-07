-- Contains misc stuff that does not fit anywhere else:
--
-- Glue code that involves more than 1 addon
-- Modifications of savedvars (event ADDON_LOADED)
-- Things to execute on PLAYER_ENTERING_WORLD
local addonName, addon = ...
local S,C = unpack(addon)

local GetAddOnMetadata = C_AddOns.GetAddOnMetadata

local sanui_version = GetAddOnMetadata(addonName, "Version")

local f = CreateFrame("frame")
f:RegisterEvent("ADDON_LOADED")

local sharedMedia = LibStub("LibSharedMedia-3.0")
sharedMedia:Register(sharedMedia.MediaType.STATUSBAR, "Tukui_Blank_Texture", [[Interface\AddOns\Tukui\Medias\Textures\Others\Blank]])

function S.misc(self,event,arg)
	if (event == "PLAYER_ENTERING_WORLD") then
		addon.saf.placeBuffFrame()
		addon.saf.placeDebuffFrame()
		addon.saf.hookBuffFrame()

		if WorldStateAlwaysUpFrame then
			WorldStateAlwaysUpFrame:ClearAllPoints()
			WorldStateAlwaysUpFrame:SetPoint("TOP", UIParent, "TOP", 0, -50)
		end

		S.disableBlizzard()

--		00S.modCoolLine(event)

		-- Most important call here
		-- Need to do it this way b/c mode switching depends on some things, e.g. dominos frames being modded
		hooksecurefunc(Dominos.ActionButtons,"PLAYER_ENTERING_WORLD", function()
			S.modDomFrames()
			S.switch2Mode(SanUIdb["Mode"])
		end)

		addon.saf.optionspanel:refresh()

		-- need to do those things only once
		self:UnregisterEvent("PLAYER_ENTERING_WORLD")

		-- Do this here so we don't get notified when talents are first available,
		-- since most of our stuff isn't by then
		f:RegisterEvent("ACTIVE_TALENT_GROUP_CHANGED")
		f:RegisterEvent("PLAYER_TALENT_UPDATE")

		--this should be last, it might induce a reloadui
		--local tukui_installed = TukuiDatabase.Variables[S.MyRealm][S.MyName].Installation.Done
		SanUIdb.addedWeakAuras = (type(SanUIdb.addedWeakAuras) == "string" and SanUIdb.addedWeakAuras) or "None"
		--local wa_installed = SanUIdb.addedWeakAuras and SanUIdb.addedWeakAuras == sanui_version
		local wa_asked = SanUIdb.askedWeakAuras and SanUIdb.askedWeakAuras == sanui_version

		--if tukui_installed and not wa_asked then
		if not wa_asked then
			S.weakAurasDialog(sanui_version, SanUIdb.addedWeakAuras)
		end
	end

	if(event == "ADDON_LOADED") then
		f:RegisterEvent("PLAYER_ENTERING_WORLD")
		local name = arg

		if name == "SanUI" then
			if  not SanUIdb then
				SanUIdb = {}
			end

			if not SanUIdb["Mode"] then
			--at this point we know this exists, profiles was loaded and makes sure of it
				if S["profiles"][S.MyName] then
					SanUIdb["Mode"] = S["profiles"][S.MyName]["modes"][1]
				else
					SanUIdb["Mode"] = S["profiles"]["DEFAULT"]["modes"][1]
				end
			end

			if not SanUIGlobaldb then
				SanUIGlobaldb = {}
			end
			if not SanUIGlobaldb.saf then
				SanUIGlobaldb.saf = {}
			end

			-- just start empty, switch2Mode will take care of it
			addon.saf.filters = { }

			addon.saf.optionspanel:create()
		end
	end

	--if(event == "PLAYER_TALENT_UPDATE" or event == "ACTIVE_TALENT_GROUP_CHANGED") then
--		S.modCoolLine(event)
--	end

end

f:SetScript("OnEvent",S.misc)

---@class MyConfigFrame: Frame
---@field category unknown
---@field layout unknown
---@field categoryID number
local main = CreateFrame("Frame", nil, InterfaceOptionsFramePanelContainer)
main.name = addonName
main:Hide()

function main.OnShow(self)
    local title = self:CreateFontString(nil, "ARTWORK", "GameFontNormalLarge")
	title:SetPoint("TOPLEFT", 16, -16)
	title:SetText(addonName)

	local v = self:CreateFontString(nil, "ARTWORK", "GameFontNormalSmall")
	v:SetWidth(75)
	v:SetPoint("TOPLEFT", title, "BOTTOMLEFT", 0, -6)
	v:SetJustifyH("LEFT")
	v:SetText(sanui_version)

	self:SetScript("OnShow", nil)
end

main:SetScript("OnShow", main.OnShow)

addon.optionspanel = main


local category, layout = Settings.RegisterCanvasLayoutCategory(main, addonName)
Settings.RegisterAddOnCategory(category)
addon.optionspanel.category = category
addon.optionspanel.categoryID = category:GetID()
addon.optionspanel.layout = layout

category, layout = Settings.RegisterCanvasLayoutSubcategory(addon.optionspanel.category, addon.saf.optionspanel, addon.saf.optionspanel.name)
addon.saf.optionspanel.category = category
addon.saf.optionspanel.categoryID = category:GetID()
addon.saf.optionspanel.layout = layout
--InterfaceOptions_AddCategory(main)
--InterfaceOptions_AddCategory(addon.saf.optionspanel)--, addon.optpanels.ABOUT)
