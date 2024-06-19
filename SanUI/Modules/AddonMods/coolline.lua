local addonName, addon = ...
local S,C = unpack(addon)

local Scale = S.Toolkit.Functions.Scale
local panels = S.panels
local ab1 = panels.actionbarpanel1

local spacing = C.sizes.actionbuttonspacing
local buttonsize = C.sizes.actionbuttons



-- executed  PLAYER_ENTERING_WORLD in Misc.lua
--Putting it above the middle action bar

local updatedLook = false

local function placeCoolLine(db)
	local bg = CoolLine.Backdrop
	bg:ClearAllPoints()
	
	local stancebuttonname = "DominosStanceButton"
	
	local laststancebutton = _G[stancebuttonname.."1"]
	local i = 2
	while _G[stancebuttonname..i] do
		if _G[stancebuttonname..i]:IsShown() then
			laststancebutton =  _G[stancebuttonname..i]
		end
		i = i + 1
	end
	
	if laststancebutton then
		bg:SetPoint("TOPLEFT", laststancebutton, "TOPRIGHT", spacing, 0)
		bg:SetPoint("BOTTOMRIGHT", "MultiBarBottomRightActionButton1", "BOTTOMLEFT", -spacing, 0)
	else
		bg:SetPoint("LEFT", ab1, "LEFT")
		bg:SetPoint("BOTTOM", "MultiBarBottomRightActionButton1", "BOTTOM", 0, spacing)
		bg:SetPoint("TOPRIGHT", "MultiBarBottomRightActionButton1", "TOPLEFT", -spacing, -spacing)
	end
	
	CoolLine:ClearAllPoints()
	CoolLine:SetPoint("TOPRIGHT", bg, -spacing/2, 0)
	CoolLine:SetPoint("BOTTOMLEFT", bg, spacing/2, 0)
	
	S.placeStanceBar()
	
	db.h = CoolLine:GetHeight()
	db.w = CoolLine:GetWidth()
	
	if not updatedLook then
		updatedLook = true
		CoolLine.updatelook()
	else
		updatedLook = false
	end
end

local f = CreateFrame("Frame")
f:RegisterEvent("PLAYER_TALENT_UPDATE")

f:SetScript("OnEvent", function(event)
	S.modCoolLine(event)
end)

function S.modCoolLine(event)
	local db

	CoolLineDB = CoolLineDB or { }
	if CoolLineDB.perchar then
		db = CoolLineCharDB
	else
		db = CoolLineDB
	end

	
	if not CoolLine.Backdrop then
		S.CreateBackdrop(CoolLine, "Transparent")
	end
	
	db.h = buttonsize
	-- 11 instead of 12 so icons on either side fully fit inside
	db.w = 11*buttonsize - 2 * Scale(2) + 11 * spacing
	db.inactivealpha = 1
	db.bordercolor.a = 0
	db.bgcolor.a = 0
	db.iconplus = 0
	
	if ab1 and not ab1.coollinehooked then
		hooksecurefunc(CoolLine, "updatelook", function() placeCoolLine(db) end)
		ab1.coollinehooked = true
	end
	
	CoolLine.updatelook()	
	
	if not SanUIdb.stanceBarHasBeenPlaced then
		if S.placeStanceBar() == 1 then
			SanUIdb.stanceBarHasBeenPlaced = true
		end
	end
	
	CoolLine:SetParent(S.panels.PetBattleHider)
end

function S.placeStanceBar()
	if DominosFrameclass then
		DominosFrameclass:ClearAllPoints()
		DominosFrameclass:SetPoint("BOTTOMLEFT",ab1,"TOPLEFT",0,Scale(2))
		return 1
	else
		print("No DominosFrameclass or no CoolLine.Backdrop, can't place it!")
		return 0
	end
end

S.AddOnCommands["placestancebar"] = S.placeStanceBar
