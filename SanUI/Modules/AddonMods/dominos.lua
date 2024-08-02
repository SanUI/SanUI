local addonName, addon = ...
local S, C = unpack(addon)

local Masque = LibStub("Masque", true)
if not Masque then return end

Dominos.db.profile.showEmptyButtons = true

local function modDomFrames()
    local domframes = { 1, 2, 3, 4, 5, 6, 8, 9, 10, 11, 12, 13, 14,  "class"}
    local backDropFrames  = {[1] = true, [4] = true, [6] = true}

    for _, domframe in ipairs(domframes) do
        local f = _G["DominosFrame" .. domframe]
        
        if backDropFrames[domframe] then
          S.CreateBackdrop(f)
        end

        f:SetPadding(1)
        f:SetSpacing(-8)

    end

    for button, _ in Dominos.ActionButtons:GetAll() do
        button.HotKey:ClearAllPoints()
        button.HotKey:SetPoint("TOPRIGHT", button.icon, "TOPRIGHT", S.scale2, -S.scale1)
        button.HotKey:SetJustifyH("RIGHT")
        S.CreateAnonymousBackdrop(button.icon, "Transparent")
    end

    -- Somehow, the stance bar is just different...
    DominosFrameclass:SetSpacing(-4)
    DominosFrameclass:SetPadding(1)
    DominosFrameclass:SetScale(1.33)
    
    for _, button in pairs(DominosFrameclass.buttons) do
        local curfontname, curfontheight, curfontflags = button.HotKey:GetFont()
        button.HotKey:ClearAllPoints()
        button.HotKey:SetJustifyH("RIGHT")
        button.HotKey:SetFont(curfontname, curfontheight * 0.75, curfontflags)
        button.HotKey:SetPoint("TOPRIGHT", button.icon, "TOPRIGHT", S.scale2, -S.scale1)
    end
end

hooksecurefunc(Dominos.ActionButtons,"PLAYER_ENTERING_WORLD", function()
    local group = Masque:GetGroupByID("Dominos")
    group:__Set("SkinID", "SanUI")

    modDomFrames()
end)

