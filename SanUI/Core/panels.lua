local addonName, addon = ...
local S,C = unpack(addon)

local Scale = S.Scale

local absize = C.sizes.actionbuttons
local abspacing = C.sizes.actionbuttonspacing

local panels = {}

local Hider = CreateFrame("Frame", nil, UIParent)
Hider:Hide()

panels.Hider = Hider
--provided by oUF
local PetBattleHider = SanUI_PetBattleFrameHider
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

local bottomlefttextbox = CreateFrame("Frame", nil, UIParent)
bottomlefttextbox:SetSize(350, 23)
S.CreateBackdrop(bottomlefttextbox)
bottomlefttextbox:SetFrameStrata("BACKGROUND")
bottomlefttextbox:SetFrameLevel(2)
bottomlefttextbox:SetPoint("BOTTOMLEFT",UIParent,5,Scale(3))
panels.bottomlefttextbox = bottomlefttextbox

local bottomrighttextbox = CreateFrame("Frame", nil, UIParent)
bottomrighttextbox:SetSize(350, 23)
S.CreateBackdrop(bottomrighttextbox)
bottomrighttextbox:SetFrameStrata("BACKGROUND")
bottomrighttextbox:SetFrameLevel(2)
bottomrighttextbox:SetPoint("BOTTOMRIGHT",UIParent,-5,Scale(3))
panels.bottomrighttextbox = bottomrighttextbox

local minimap = {}
local minimapsize = C.sizes.minimap
local height = C.sizes.minimappanelsheight

local dt_left = CreateFrame("Frame", nil, UIParent)
dt_left:SetSize(minimapsize/2, height)
dt_left:SetPoint("TOPLEFT", Minimap, "BOTTOMLEFT",0,1)
S.CreateBackdrop(dt_left)
dt_left:SetFrameStrata("LOW")
minimap.dt_left = dt_left

local dt_right = CreateFrame("Frame", nil, UIParent)
dt_right:SetSize(minimapsize/2, height)
dt_right:SetPoint("TOPRIGHT", Minimap, "BOTTOMRIGHT",0,1)
S.CreateBackdrop(dt_right)
dt_right:SetFrameStrata("LOW")
minimap.dt_right = dt_right

panels.minimap = minimap

S.panels = panels