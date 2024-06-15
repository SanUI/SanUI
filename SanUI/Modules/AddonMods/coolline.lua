local addonName, addon = ...
local S,C = unpack(addon)

local Scale = S.Toolkit.Functions.Scale
local spacing = C["ActionBars"].ButtonSpacing
local buttonsize = C["ActionBars"].NormalButtonSize

-- executed  PLAYER_ENTERING_WORLD in Misc.lua
--Putting it above the middle action bar

local updatedLook = false

local function placeCoolLine(db)
	local NumForms = GetNumShapeshiftForms()
	
	local bg = CoolLine.Backdrop
	bg:ClearAllPoints()
	if TukuiStanceBar and NumForms > 0 then
		bg:SetPoint("TOPLEFT", TukuiStanceBar, "TOPRIGHT", spacing, -spacing)
		bg:SetPoint("BOTTOMRIGHT", TukuiActionBar3, "BOTTOMLEFT", -spacing, spacing)
	else
		bg:SetPoint("LEFT", TukuiActionBar1, "LEFT")
		bg:SetPoint("BOTTOM", TukuiActionBar3, "BOTTOM", 0, spacing)
		bg:SetPoint("TOPRIGHT", TukuiActionBar3, "TOPLEFT", -spacing, -spacing)
	end
	
	CoolLine:ClearAllPoints()
	CoolLine:SetPoint("TOPRIGHT", bg, -buttonsize/2, 0)
	CoolLine:SetPoint("BOTTOMLEFT", bg, buttonsize/2, 0)
	
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


function S.modCoolLine(event)
	local TukuiStanceBar = S["ActionBars"].Bars.Stance
	local db

	CoolLineDB = CoolLineDB or { }
	if CoolLineDB.perchar then
		db = CoolLineCharDB
	else
		db = CoolLineDB
	end

	
	if not CoolLine.Backdrop then
		S.CreateBackdrop(CoolLine)
	end
	
	db.h = buttonsize
	-- 11 instead of 12 so icons on either side fully fit inside
	db.w = 11*buttonsize - 2 * Scale(2) + 11 * spacing
	db.inactivealpha = 1
	db.bordercolor.a = 0
	db.bgcolor.a = 0
	db.iconplus = 0
	
	if S.ActionBars and S.ActionBars.Bars and S["ActionBars"].Bars.Bar1 then
		hooksecurefunc(CoolLine, "updatelook", function() placeCoolLine(db) end)
	end
	
	CoolLine.updatelook()	
	
	if not SanUIdb.stanceBarHasBeenPlaced then
		if S.placeStanceBar() == 1 then
			SanUIdb.stanceBarHasBeenPlaced = true
		end
	end
	
	CoolLine:SetParent(Tukui_PetBattleFrameHider)
end

function S.placeStanceBar()
	local TukuiStanceBar = S["ActionBars"].Bars.Stance
	if TukuiStanceBar then
		TukuiStanceBar:ClearAllPoints()
		TukuiStanceBar:SetPoint("BOTTOMLEFT",TukuiActionBar1,"TOPLEFT",0,Scale(2))
		return 1
	else
		print("No TukuiStanceBar or no CoolLine.Backdrop, can't place it!")
		return 0
	end
end

S.AddOnCommands["placestancebar"] = S.placeStanceBar
