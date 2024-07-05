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

local spells = CreateFrame("Frame", nil, S.panels.bottomrighttextbox)
spells:SetHeight(height)
spells:SetWidth(32)
spells:SetPoint("LEFT", S.panels.bottomrighttextbox, "LEFT", S.Scale(4), 0)
S.createSpellbookDT(spells)

local talents = CreateFrame("Frame", nil, S.panels.bottomrighttextbox)
talents:SetHeight(height)
talents:SetWidth(32)
talents:SetPoint("LEFT", spells, "RIGHT", S.Scale(4), 0)
S.createTalentDT(talents)

local quests = CreateFrame("Frame", nil, S.panels.bottomrighttextbox)
quests:SetHeight(height)
quests:SetWidth(32)
quests:SetPoint("LEFT", talents, "RIGHT", S.Scale(4), 0)
S.createQuestDT(quests)

local achievements = CreateFrame("Frame", nil, S.panels.bottomrighttextbox)
achievements:SetHeight(height)
achievements:SetWidth(32)
achievements:SetPoint("LEFT", quests, "RIGHT", S.Scale(4), 0)
S.createAchievementDT(achievements)

local collections = CreateFrame("Frame", nil, S.panels.bottomrighttextbox)
collections:SetHeight(height)
collections:SetWidth(32)
collections:SetPoint("LEFT", achievements, "RIGHT", S.Scale(4), 0)
S.createCollectionsDT(collections)

local guide = CreateFrame("Frame", nil, S.panels.bottomrighttextbox)
guide:SetHeight(height)
guide:SetWidth(32)
guide:SetPoint("LEFT", collections, "RIGHT", S.Scale(4), 0)
S.createGuideDT(guide)

local friends = CreateFrame("Frame", nil, S.panels.bottomrighttextbox)
friends:SetHeight(height)
friends:SetWidth(32)
friends:SetPoint("LEFT", guide, "RIGHT", S.Scale(4), 0)
S.createFriendsDT(friends)

