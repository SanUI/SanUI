local addonName, addon = ...
local S,C,L = unpack(addon)

local Scale = S.Toolkit.Functions.Scale

local absize = C.sizes.actionbuttons
local abspacing = C.sizes.actionbuttonspacing

local panels = {}

local Hider = CreateFrame("Frame", nil, UIParent)
local PetBattleHider = CreateFrame("Frame", nil, UIParent, "SecureHandlerStateTemplate")
Hider:Hide()
PetBattleHider:SetAllPoints()
PetBattleHider:SetFrameStrata("LOW")
RegisterStateDriver(PetBattleHider, "visibility", "[petbattle] hide; show")

panels.Hider = Hider
panels.PetBattleHider = PetBattleHider

local actionbarpanel1 = CreateFrame("Frame", nil, PetBattleHider)
S.CreateBackdrop(actionbarpanel1)
actionbarpanel1:SetHeight(Scale(absize + (abspacing * 2)))
actionbarpanel1:SetWidth(Scale((absize * 24) + (abspacing * 25)))
actionbarpanel1:SetPoint("BOTTOM", UIParent, "BOTTOM", 0, 3)
actionbarpanel1:SetFrameStrata("BACKGROUND")
panels.actionbarpanel1 = actionbarpanel1

local actionbarright = CreateFrame("Frame", nil, PetBattleHider)
S.CreateBackdrop(actionbarright)
actionbarright:SetPoint("RIGHT", UIParent, "RIGHT", -5, -54)
actionbarright:SetHeight(Scale((absize*12)+(abspacing*13)))
actionbarright:SetWidth(Scale(absize + (abspacing * 2)))
actionbarright:SetFrameStrata("BACKGROUND")
panels.actionbarright = actionbarright

S.panels = panels