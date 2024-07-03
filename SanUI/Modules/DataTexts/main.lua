local addonName, addon = ...
local S,C = unpack(addon)

local height = S.panels.bottomlefttextbox:GetHeight()

local durability = CreateFrame("Frame", nil, S.panels.bottomlefttextbox)
durability:SetHeight(height)
durability:SetWidth(32)
durability:SetPoint("LEFT", S.panels.bottomlefttextbox, "LEFT", S.Scale(4), 0)
S.createDurabilityDT(durability)

local guild = CreateFrame("Frame", nil, S.panels.bottomlefttextbox)
guild:SetHeight(height)
guild:SetWidth(32)
guild:SetPoint("LEFT", durability, "RIGHT")
S.createGuildDT(guild)

local cta = CreateFrame("Frame", nil, S.panels.bottomlefttextbox)
cta:SetHeight(height)
cta:SetWidth(48)
cta:SetPoint("LEFT", guild, "RIGHT")
S.createCalltoarmsDT(cta)