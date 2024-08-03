local _, addon = ...
local S,C = unpack(addon)

local Scale = S.Scale

local panels = {}

local Hider = CreateFrame("Frame", nil, UIParent)
Hider:Hide()

panels.Hider = Hider
--provided by oUF
local PetBattleHider = SanUI_PetBattleFrameHider
panels.PetBattleHider = PetBattleHider

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
