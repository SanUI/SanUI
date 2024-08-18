local _, addon = ...
local S,C = unpack(addon)

local height = S.panels.bottomlefttextbox:GetHeight()
local width = S.panels.bottomlefttextbox:GetWidth()
width = width - 2* S.Scale(2)

local durability = CreateFrame("Frame", nil, S.panels.bottomlefttextbox)
durability:SetHeight(height)
durability:SetWidth(width/4)
durability:SetPoint("LEFT", S.panels.bottomlefttextbox, "LEFT", S.Scale(2), 0)
S.createDurabilityDT(durability)

local guild = CreateFrame("Frame", nil, S.panels.bottomlefttextbox)
guild:SetHeight(height)
guild:SetWidth(width/4)
guild:SetPoint("BOTTOMRIGHT", S.panels.bottomlefttextbox, "BOTTOM", 0, 0)
S.createGuildDT(guild)

local cta = CreateFrame("Frame", nil, S.panels.bottomlefttextbox)
cta:SetHeight(height)
cta:SetWidth(width/4)
cta:SetPoint("BOTTOMLEFT", S.panels.bottomlefttextbox, "BOTTOM", 0, 0)
S.createCalltoarmsDT(cta)

local friends = CreateFrame("Frame", nil, S.panels.bottomlefttextbox)
friends:SetHeight(height)
friends:SetWidth(width/4)
friends:SetPoint("RIGHT", S.panels.bottomlefttextbox, "RIGHT", -S.Scale(2), 0)
S.createFriendsDT(friends)

width = S.panels.bottomrighttextbox:GetWidth()
height = S.panels.bottomrighttextbox:GetHeight()

width = width - 2* S.Scale(2)

local spells = CreateFrame("Frame", nil, S.panels.bottomrighttextbox)
spells:SetHeight(height)
spells:SetWidth(width/7)
spells:SetPoint("LEFT", S.panels.bottomrighttextbox, "LEFT", S.Scale(2), 0)
S.createSpellbookDT(spells)

local talents = CreateFrame("Frame", nil, S.panels.bottomrighttextbox)
talents:SetHeight(height)
talents:SetWidth(width/7)
talents:SetPoint("LEFT", spells, "RIGHT", 0, 0)
S.createTalentDT(talents)

local quests = CreateFrame("Frame", nil, S.panels.bottomrighttextbox)
quests:SetHeight(height)
quests:SetWidth(width/7)
quests:SetPoint("LEFT", talents, "RIGHT", 0, 0)
S.createQuestDT(quests)

local profs = CreateFrame("Frame", nil, S.panels.bottomrighttextbox)
profs:SetHeight(height)
profs:SetWidth(width/7)
profs:SetPoint("LEFT", quests, "RIGHT", 0, 0)
S.createProfessionsDT(profs)

local achievements = CreateFrame("Frame", nil, S.panels.bottomrighttextbox)
achievements:SetHeight(height)
achievements:SetWidth(width/7)
achievements:SetPoint("LEFT", profs, "RIGHT", 0, 0)
S.createAchievementDT(achievements)

local collections = CreateFrame("Frame", nil, S.panels.bottomrighttextbox)
collections:SetHeight(height)
collections:SetWidth(width/7)
collections:SetPoint("LEFT", achievements, "RIGHT", 0, 0)
S.createCollectionsDT(collections)

local guide = CreateFrame("Frame", nil, S.panels.bottomrighttextbox)
guide:SetHeight(height)
guide:SetWidth(width/7)
guide:SetPoint("LEFT", collections, "RIGHT", 0, 0)
S.createGuideDT(guide)



