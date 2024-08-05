local _, addon = ...
local S,C = unpack(addon)

S.modCDTL2 = function()
    local l1 = CDTL2.db.profile.lanes.lane1
    l1.bgTexture = "Solid"
    l1.bgTextureColor.r = C.colors.BackdropColor[1]
    l1.bgTextureColor.b = C.colors.BackdropColor[2]
    l1.bgTextureColor.g = C.colors.BackdropColor[3]
    l1.bgTextureColor.a = 1
    l1.fgTextureColor.a = 0
    l1.border.style = "1 Pixel"
    l1.border.size = 1
    l1.border.color.a = 1
    l1.border.color.r = C.colors.BorderColor[1]
    l1.border.color.b = C.colors.BorderColor[2]
    l1.border.color.g = C.colors.BorderColor[3]
    l1.icons.bgTextureColor.a = 0
    l1.icons.bgTexture = nil
    l1.icons.border.color.a = 0
    l1.icons.text1.enabled = false
    l1.icons.text2.enabled = false
    l1.icons.text3.enabled = true
    CDTL2:RefreshAllIcons()
    CDTL2:RefreshLane(1)

    --S.CreateAnonymousBackdrop(CDTL2_Lane_1_BD)

    for i = 1, 3 do
        CDTL2.db.profile.ready["ready"..i]["enabled"] = false
        CDTL2:RefreshReady(i)

        CDTL2.db.profile.barFrames["frame"..i]["enabled"] = false
        CDTL2:RefreshBarFrame(i)
    end

    for i = 2, 3 do
        CDTL2.db.profile.lanes["lane"..i]["enabled"] = false
        CDTL2:RefreshLane(i)
    end
end

hooksecurefunc(CDTL2, "PLAYER_ENTERING_WORLD", function()
    ---@class Masque
    ---@field Group function
    local Masque = LibStub("Masque", true)
    if  Masque then
       local group = Masque:Group("CDTL2")
       group:__Enable()
       group:__Set("SkinID", "SanUI")
    end

    S.modCDTL2()
end)

