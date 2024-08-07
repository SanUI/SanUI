local _, addon = ...
local S,C = unpack(addon)

S.overwriteCDTL2Profile = function(pname)
    local import = S.CDTL2profiles[pname]
    local db = CDTL2.db

    ---@class LibDeflate 
    ---@field DecodeForPrint function
    ---@field DecompressDeflate function
    local LibDeflate = LibStub:GetLibrary("LibDeflate")
    local unprintable = LibDeflate:DecodeForPrint(import)
    local inflated = LibDeflate:DecompressDeflate(unprintable)

    -- SERIALIZE
    local LibAceSerializer = LibStub:GetLibrary("AceSerializer-3.0")
    local success, data = LibAceSerializer:Deserialize(inflated)

    if success then
        --CDTL2.db.profile = data
        db.profile.global = data.global
        db.profile.lanes = data.lanes
        db.profile.barFrames = data.barFrames
        db.profile.ready = data.ready
        db.profile.holders = data.holders
        db.profile.tables = data.tables

        CDTL2:RefreshConfig()
        CDTL2:ToggleFrameLock()	
        --CDTL2:Print("Data Imported?")
    else
        print("Could not load CDTL2 profile '"..pname.."'")
    end
end

S.createCDTL2Profile = function(pname)
    local db = CDTL2.db

    db:SetProfile(pname)  
end

S.switchCDTL2 = function(profile)
    local db = CDTL2.db

    local profiles = db:GetProfiles()

    for _, v in pairs(profiles) do
        if v == profile then
            db:SetProfile(profile)
            return
        end
    end

    -- did not find profile, create and see if we can overwrite the settings
    S.createCDTL2Profile(profile)

    if S.CDTL2profiles[profile] then
        S.overwriteCDTL2Profile(profile)
    end
end

--[[
S.modCDTL2 = function()
    ---@class AceAddon
    ---@field db table
    ---@field RefreshAllIcons function
    ---@field RefreshLane function
    ---@field RefreshReady function
    ---@field RefreshBarFrame function
    local CDTL2 = CDTL2


end
--]]

hooksecurefunc(CDTL2, "PLAYER_ENTERING_WORLD", function()
    ---@class Masque
    ---@field Group function
    local Masque = LibStub("Masque", true)
    if  Masque then
       local group = Masque:Group("CDTL2")
       group:__Enable()
       group:__Set("SkinID", "SanUI")
    end

    --S.modCDTL2()
end)

