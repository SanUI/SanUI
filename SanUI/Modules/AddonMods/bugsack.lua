if not C_AddOns.IsAddOnLoaded("BugSack") then return end

local _, addon = ...
local S,C = unpack(addon)

local Scale = S.Scale

---@class BugSackButton: Frame
local button  = CreateFrame("Frame", "BugSackButton", UIParent)
button:SetSize(C.sizes.minimapbuttons,C.sizes.minimapbuttons)
button:SetPoint("BOTTOMLEFT", Minimap, "BOTTOMRIGHT", Scale(2), Scale(18))
S.CreateBackdrop(button)
button:SetFrameStrata("MEDIUM")

local Text = button:CreateFontString(nil, "OVERLAY")
Text:SetFont(C.medias.fonts.Font, 12)
Text:SetText("b")
Text:SetJustifyH("CENTER")
Text:SetJustifyV("MIDDLE")
Text:SetPoint("CENTER",button,S.scale1,-S.scale1)
Text:Show()
button.text = Text

button:EnableMouse(true)
button:SetScript("OnMouseDown", function(self,clicked)
	if IsAltKeyDown() then
		BugSack:Reset()
	elseif BugSackFrame and BugSackFrame:IsShown() then
		BugSack:CloseSack()
	else
		BugSack:OpenSack()
	end
end)

--button:SkinButton()
