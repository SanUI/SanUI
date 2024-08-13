local _, addon = ...
local S, C = unpack(addon)

local Masque = LibStub("Masque", true)
if not Masque then return end

Dominos.db.profile.showEmptyButtons = true
local fontsize = C.sizes.actionbuttonhotkey

local function maybeShowPetBackdrop()
    if DominosPetActionButton1 and DominosPetActionButton1:IsShown() then
        DominosFramepet.Backdrop:Show()
    else
        DominosFramepet.Backdrop:Hide()
    end
end

S.modButtonHotKeyFont = function(button, scale)
    scale = scale or 1
    local curfontname, _, curfontflags = button.HotKey:GetFont()
    button.HotKey:SetFont(curfontname, scale * fontsize, curfontflags)
end

S.modDomFrames = function()
    local domframes = { 1, 2, 3, 4, 5, 6, 8, 9, 10, 11, 12, 13, 14,  "class", "pet"}
    local backDropFrames  = {[1] = true, [4] = true, [6] = true, pet = true}

    for _, domframe in ipairs(domframes) do
        local f = _G["DominosFrame" .. domframe]
        
        if f then 
            f:SetPadding(1)
            f:SetSpacing(-8)
            if f.SetShowEmptyButtons then
                f:SetShowEmptyButtons(true)
            end

            if backDropFrames[domframe] then
                S.CreateBackdrop(f)
            end
        end

    end

    for button, _ in Dominos.ActionButtons:GetAll() do
        button.HotKey:ClearAllPoints()
        button.HotKey:SetPoint("TOPRIGHT", button.icon, "TOPRIGHT", S.scale2, -S.scale1)
        button.HotKey:SetJustifyH("RIGHT")
        S.modButtonHotKeyFont(button)
        S.CreateAnonymousBackdrop(button.icon, "Transparent")
    end

    -- Somehow, the pet bar is just different
    if DominosFramepet then
        DominosFramepet:SetPadding(6)
        DominosFramepet:SetSpacing(4)
        DominosPetActionButton1:HookScript("OnShow", maybeShowPetBackdrop)
        DominosPetActionButton1:HookScript("OnHide", maybeShowPetBackdrop)
        DominosFramepet.Backdrop:Hide()
    end

    -- Somehow, the stance bar is just even more different...
    if DominosFrameclass then
        DominosFrameclass:SetSpacing(-4)
        DominosFrameclass:SetPadding(1)
        DominosFrameclass:SetScale(1.33)
  
        for _, button in pairs(DominosFrameclass.buttons) do
            button.HotKey:ClearAllPoints()
            button.HotKey:SetJustifyH("RIGHT")
            S.modButtonHotKeyFont(button, 1)
            button.HotKey:SetPoint("TOPRIGHT", button.icon, "TOPRIGHT", S.scale2, -S.scale1)
        end
    end
end

hooksecurefunc(Dominos.ActionButtons,"PLAYER_ENTERING_WORLD", function()
    local group = Masque:GetGroupByID("Dominos")
    group:__Set("SkinID", "SanUI")

    S.modDomFrames()
end)

