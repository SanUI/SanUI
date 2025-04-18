--[[
	By Tuovi of EU-Mal'Ganis. Extremely modified version of oUF_AuraTrack by Tukz of tukui.org
	
	Element frame.NotAuraTrack has the following entries
	
	.Icons Table of buff icons to show
		Keys: spellId
		Values: Tables with the following Keys:
			.anyCaster If true(thy) show regardless of caster. If false(y), show only when the player is the caster
			.cd  (optional) A cooldown frame, will be updated by NotAuraWatch
			.setTex (optional) If true(thy), set the texture to the one belonging to the spellId (usefull when using
			                   several spellIds on the same buff icon)
			.tex (Only needed when .color or .timers or .setTex is set) The texture of the icon that color/texture gets applied to
			.color (optional) The color of the texture (leave nil for showing images)
			.timers (optional) Array (table indexed by integers) of timers. A timer is a table of the form { time, { r, g, b} }, where the icon texture 
		            is colored by SetVertexColor(r, g, b) if the remaining duration of the buff is <time. The first one matching wins.
			.count (optional) Fontstring, will be set the the number of stacks (if > 1)	
	.Texts Table of FontString instances to show
		Keys: spellId
		Values: Tables with the following Keys:
			.anyCaster If true(thy) show regardless of caster. If false(y), show only when the player is the caster
			.format The format string when printing the time left, passed as an argument to SetFormattedText
			.res The maximum time between updates (should be at most half of the lowest digit needed for the format string)
			.timers (optional) Sorted Array (table indexed by integers) of timers, lowest time first. A timer is a table of the form { time, format, res},
                where whenever the remaining duration of the buff is <time, we use the format string format and a maximum update time of res (see the notes above)
    .NotRaidDebuffs Table with 2 entries
        Keys: 1, 2
        Values: Frames with the following entries
            .icon Texture to show the debuff icon
            .Backdrop (optional, created otherwise) BackdropFrame to set the border color (Use SanUI[1].CreateBackdrop to create)
            .cd (optional) CooldownFrame
            .count (optional) FontString for the stack count
        Use the table addon.oUF_NotRaidDebuffs with the following functions:
            :RegisterDebuffs Register Debuffs, Argument table with
                Keys: SpellID,
                Values: Tables of the form {{
                    enable = true, --whether to enable
                    priority = priority or 0, -- priorities start at 50 for dispellable things, largest one wines
                    stackThreshold = 0 -- only show if at least this many stacks are present
                }}
            :ResetDebuffData Clear the debuff table
]]
local _, addon = ...
local S, C = unpack(addon)

local oUF = addon.oUF
assert(oUF, "oUF_NotAuraTrack cannot find an instance of oUF. If your oUF is embedded into a layout, it may not be embedded properly.")

local ORD = {}
addon.oUF_NotRaidDebuffs = ORD

local libDispel = S.libDispel
local bleedList = libDispel:GetBleedList()

local abs, max = math.abs, math.max
local format, floor = format, floor
local type, pairs, wipe = type, pairs, wipe

local UnitCanAttack = UnitCanAttack
local UnitIsCharmed = UnitIsCharmed
local GetSpellInfo = GetSpellInfo
local GetTime = GetTime

local debuff_data = {}
ORD.DebuffData = debuff_data

local DispelPriority = {
	Magic   = 54,
	Curse   = 53,
	Disease = 52,
	Poison  = 51,
	Bleed = 50
}

local debuffBlackList = {
	[105171] = true, -- Deep Corruption (Dragon Soul: Yor'sahj the Unsleeping)
	[108220] = true, -- Deep Corruption (Dragon Soul: Shadowed Globule)
	[116095] = true, -- Disable, Slow   (Monk: Windwalker)
}

local DispelColor = {
	Magic   = oUF.colors.debuff.Magic,
	Curse   = oUF.colors.debuff.Curse,
	Disease = oUF.colors.debuff.Disease,
	Poison  = oUF.colors.debuff.Poison,
	none    = C.colors.BorderColor,
}

local function add_debuff(spell, priority, stackThreshold)
	if type(spell) == 'number' then
		spell = C_Spell.GetSpellName(spell)
	end

	if spell then
		debuff_data[spell] = {
			priority = priority,
			stackThreshold = stackThreshold,
		}
	end
end

function ORD:RegisterDebuffs(t)
	for spell, value in pairs(t) do
		if type(value) == 'boolean' then
			local oldValue = value
			t[spell] = { enable = oldValue, priority = 0, stackThreshold = 0 }
		else
			if value.enable then
				add_debuff(spell, value.priority or 0, value.stackThreshold or 0)
			end
		end
	end
end

function ORD:ResetDebuffData()
	wipe(debuff_data)
end

--[[
local function formatTime(s)
	if s > 60 then
		return format('%dm', s/60), s%60
	elseif s < 1 then
		return format('%.1f', s), s - floor(s)
	else
		return format('%d', s), s - floor(s)
	end
end


local function OnDebuffTextUpdate(self, elapsed)
	self.elapsed = (self.elapsed or 0) + elapsed
	if self.elapsed >= 0.1 then
		local timeLeft = self.endTime - GetTime()

		if self.reverse and self.duration then
			timeLeft = abs(timeLeft - self.duration)
		end

		if timeLeft > 0 then
			local text = formatTime(timeLeft)
			self.time:SetText(text)
		else
			self:SetScript('OnUpdate', nil)
			self.time:Hide()
		end

		self.elapsed = 0
	end
end
--]]

local function UpdateBuffText(text, nat, current_time)
    local data = text.data

    if not data then
        local instanceId, cdata = next(text.candidates)
        if instanceId then
            text.data = cdata
            text.candidates[instanceId] = nil
            data = text.data
        end
    end

    if data then
        local buf_remaining = data.expirationTime - current_time

        local formatstr = text.formatstr
        local res = text.res

        for _, timer in ipairs(text.timers) do
            if buf_remaining < timer[1] then
                formatstr = timer[2]
                res = timer[3]
                break
            end
        end
        text:SetFormattedText(formatstr, buf_remaining)

        if not text.timer_running then
            C_Timer.After(res, function()
                text.timer_running = false
                if text:IsShown() then
                    UpdateBuffText(text, nat, GetTime())
                end
            end)
            text.running_timer = true
        end

        text:Show()
    else
        text:Hide()
    end
end

--[[
local function recomputeRaidDebuffsShowing(notraiddebuffs)
    local candidates = notraiddebuffs.candidates
    local showing = notraiddebuffs.showing

    wipe(showing)

    for _, data in pairs(candidates) do
        if (not showing[1]) or data.priority > showing[1].priority then
            showing[2] = showing[1]
            showing[1] = data.auraInstanceID
        elseif (not showing[2]) or data.priority > showing[2].priority then
            showing[2] = data.auraInstanceID
        end
    end

	if showing[2] and showing[1].icon == showing[2].icon then
		showing[2] = nil
	end
end


local function addOneRaidDebuff(nat, data)
    local candidates = nat.NotRaidDebuffs.candidates
    local showing = nat.NotRaidDebuffs.showing

    candidates[data.auraInstanceID] = data

    if (not showing[1]) or data.priority > showing[1].priority then
        showing[2] = showing[1]
        showing[1] = data.auraInstanceID
        return true
    elseif (not showing[2]) or data.priority > showing[2].priority then
        showing[2] = data.auraInstanceID
        return true
    else
        return false
    end
end
--]]

local function UpdateRaidDebuffs(notraiddebuffs)
    local candidates = notraiddebuffs.candidates
    local showing = notraiddebuffs.showing

    wipe(showing)

    for _, data in pairs(candidates) do
        if (not showing[1]) or data.priority > candidates[showing[1]].priority then
            showing[2] = showing[1]
            showing[1] = data.auraInstanceID
        elseif (not showing[2]) or data.priority > candidates[showing[2]].priority then
            showing[2] = data.auraInstanceID
        end
    end

	if showing[2] and candidates[showing[1]].icon == candidates[showing[2]].icon then
		showing[2] = nil
	end

	for index = 1,2 do
		local f = notraiddebuffs[index]
		local data = notraiddebuffs.candidates[showing[index]]

		if (not data) then
            f:Hide()
            showing[index] = nil
        else
            local applications = data.applications or 0
            local duration = data.duration
            local expirationTime = data.expirationTime
            local stackThreshold = data.stackThreshold or 0

            if data.name and (applications >= stackThreshold) then
                f.icon:SetTexture(data.icon)
                f.icon:Show()
                f.duration = duration
                f.reverse = f.ReverseTimer and f.ReverseTimer[data.spellId]

                local count = f.count
                if count then
                    if applications and (applications > 1) then
                        count:SetText(applications)
                        count:Show()
                    else
                        count:SetText("")
                        count:Hide()
                    end
                end

                if f.cd then
                    if duration and (duration > 0) then
                        f.cd:SetCooldown(expirationTime - duration, duration)
                        f.cd:Show()
                    else
                        f.cd:Hide()
                    end
                end

                local c = DispelColor[data.dispelName] or DispelColor.none
                f.SetBackdropBorderColor(c)

                f:Show()
            else
                f:Hide()
            end
        end
	end
end

local function setTimedIconColor(icon)
    local data = icon.data

    if not data then return end

    local now = GetTime()
    local timeleft = data.expirationTime - now
    local timers = icon.timers

    local next_timer
    if timeleft > timers[#timers][1] then
        next_timer = timers[#timers]
    else
        for i = 1, #timers  do
            local timer = timers[i]
            if timeleft <= timer[1] then
                icon.tex:SetVertexColor(unpack(timer[2]))
                next_timer = i > 1 and timers[i-1]
                break
            end
        end
    end

    if next_timer then
       local nextUpdateIn = timeleft - next_timer[1] + 0.01 -- ware of rounding errors? 
       C_Timer.After(nextUpdateIn, function() setTimedIconColor(icon) end)
    end
end

local function UpdateBuffIcon(icon, nat)
    local data = icon.data

    if not data then
        local instanceId, cdata = next(icon.candidates)
        if instanceId then
            icon.data = cdata
            icon.candidates[instanceId] = nil
            data = icon.data
        end
    end

    if data then
        local duration = data.duration
        local expiration = data.expirationTime

        if icon.setTex then
            icon.tex:SetTexture(data.icon)
        end

        if icon.cd then
            icon.cd:SetCooldown(expiration - duration, duration)
        end

        if icon.count then
            icon.count:SetText(data.applications)
            icon.count:Show()
        end

        local color = icon.color
        if color then
            icon.tex:SetVertexColor(unpack(color))
        end
        if icon.timers then
            setTimedIconColor(icon)
            --[[
            local buf_remaining = expiration - nat.lastUpdate
            for _, timer in ipairs(icon.timers) do
                if buf_remaining < timer[1] then
                    color = timer[2]
                    break
                end
            end
            --]]
        end

        icon:Show()
        -- TODO is this needed? icon.auraInstanceID = data.auraInstanceID
    else
        icon:Hide()
    end
end

local function processDebuffData(data, unit)
    data.priority = -1
    data.stackThreshold = 0

    if bleedList[data.spellId] then
        data.dispelName = 'Bleed'
    end
    --we coudln't dispel if the unit its charmed, or its not friendly
    local shouldShowDispellable = (not UnitIsCharmed(unit)) and (not UnitCanAttack('player', unit))

    if shouldShowDispellable and data.dispelName then
        --Make Dispel buffs on top of Boss Debuffs
        if libDispel:IsDispellableByMe(data.dispelName) then
            data.priority = DispelPriority[data.dispelName]
        else
            data.dispelName = nil
        end
    end

    local debuff = debuff_data[data.name]

    if debuff then
        data.priority = max(data.priority, debuff.priority or 0)
        data.stackThreshold = debuff.stackThreshold or 0
    end
end

--[[
S.logMouseoverNat = function()
    local frame
    SanUIdb.natState = {}
    local state = SanUIdb.natState
    for i = 1, 40 do
        local f = _G["SanUIRaidUnitButton"..i]
        if f and  MouseIsOver(f) then
            frame = f
            state.unit = "SanUIRaidUnitButton"..i
        end
    end

    if not frame then print("No mouseover SanUI frame") end

    local nat = frame.NotAuraTrack

    state.raiddebuffs = {}
    local rd = state.raiddebuffs

    local candidates = nat.NotRaidDebuffs.candidates
    local showing = nat.NotRaidDebuffs.showing

    rd.showing = {}
    for idx, instanceID in pairs(showing) do
        rd.showing[idx] = { idx, instanceID, candidates[instanceID].name }
    end

    rd.candidates = {}
    for idx, data in pairs(candidates) do
        rd.candidates[idx] = { data.auraInstanceID, data.name }
    end

    state.icons = {}
    local ic = state.icons

    ic.showing = {}
    for instanceID, icon in pairs(nat.showing.icons) do
        local cands = {}

        for instanceID, data in pairs(icon.candidates) do
            tinsert(cands, {instanceID, data.name})
        end
        tinsert(ic.showing, {["showingKey"]=instanceID, ["icon"]=tostring(icon), ["cands"]=cands,["data"]={icon.data.auraInstanceID, icon.data.name}})
    end
end

local shouldLog = false

S.startNatLog = function()
    shouldLog = true
end

S.stopNatLog = function()
    shouldLog = false
end

S.clearNatLog = function()
    wipe(SanUIdb.natlog)
end

S.stopAndKeepThis = function()

    S.stopNatLog()

    local frame
    local state = {}
    for i = 1, 40 do
        local f = _G["SanUIRaidUnitButton"..i]
        if f and  MouseIsOver(f) then
            frame = f
            state.unit = "SanUIRaidUnitButton"..i
        end
    end

    if not frame then 
        print("No mouseover SanUI frame") 
        return
    end

    local nat = frame.NotAuraTrack

    state.raiddebuffs = {}
    local rd = state.raiddebuffs

    local candidates = nat.NotRaidDebuffs.candidates
    local showing = nat.NotRaidDebuffs.showing

    rd.showing = {}
    for idx, instanceID in pairs(showing) do
        rd.showing[idx] = { idx, instanceID, candidates[instanceID].name }
    end

    rd.candidates = {}
    for idx, data in pairs(candidates) do
        rd.candidates[idx] = { data.auraInstanceID, data.name }
    end

    tinsert(SanUIdb.natlog[state.unit], state)

    for k, _ in pairs(SanUIdb.natlog) do
        if k ~= state.unit then
            SanUIdb.natlog[k] = nil
        end
    end
end

local log = function(frame, updateInfo)
    if not shouldLog then
        return
    end

    local logEntry = {}

    if (not updateInfo or updateInfo.isFullUpdate) then
        tinsert(logEntry, "FullUpdate")
    else
        logEntry.removed = updateInfo.removedAuraInstanceIDs or {}
        logEntry.updated = updateInfo.updatedAuraInstanceIDs or {}

        logEntry.addedNotHelpful = {}
        for _, data in ipairs(updateInfo.addedAuras or {}) do
            if not data.isHelpful then
                tinsert(logEntry.addedNotHelpful, {data.auraInstanceID, data.name})
            end
        end
    end

    local framename = frame:GetName()

    SanUIdb.natlog = SanUIdb.natlog or {}
    SanUIdb.natlog[framename] = SanUIdb.natlog[framename] or {}
    tinsert(SanUIdb.natlog[framename], logEntry)
end
--]]

local toCheck = { ["Ironbark"] = true, ["Blistering Scales"] = true }

--[[
local allUpdateIcons = {}
local allUpdateTexts = {}
--]]
local updateIcons = {}
local updateTexts = {}


local Update = function(self, event, unit, updateInfo)
	if self.unit ~= unit then
		return
	end

   -- log(self, updateInfo)

	local nat = self.NotAuraTrack
	nat.lastUpdate = GetTime()

    local showing_icons = nat.showing.icons
    local showing_texts = nat.showing.texts
    local notraiddebuffs = nat.NotRaidDebuffs
    local isFullUpdate = not updateInfo or updateInfo.isFullUpdate

    if isFullUpdate then
        for _, icon in pairs(showing_icons) do
            icon.data = nil
            wipe(icon.candidates)
            icon:Hide()
        end
        for _, text in pairs(showing_texts) do
            text.data = nil
            wipe(text.candidates)
            text:Hide()
        end

        wipe(showing_icons)
        wipe(showing_texts)

        local slots = {C_UnitAuras.GetAuraSlots(unit, "HELPFUL")}
        for i = 2, #slots do -- #1 return is continuationToken, we don't care about it
            local data = C_UnitAuras.GetAuraDataBySlot(unit, slots[i]) or {}

            if data.name and toCheck[data.name] then
                print("FullUpdate: ".. data.name .." from "..data.sourceUnit)
            end
            local icon = nat.Icons[data.spellId]
            if  icon and (icon.anyCaster or data.sourceUnit == "player") then
                showing_icons[data.auraInstanceID] = icon
                if icon.data then
                    icon.candidates[data.auraInstanceID] = data
                else
                    icon.data = data
                end
            end

            local text = nat.Texts[data.spellId]
            if text and (text.anyCaster or data.sourceUnit == "player") then
                showing_texts[data.auraInstanceID] = text
                if text.data then
                    text.candidates[data.auraInstanceID] = data
                else
                    text.data = data
                end
            end
        end
      
        if  notraiddebuffs then
            wipe(notraiddebuffs.candidates)

            slots = {C_UnitAuras.GetAuraSlots(unit, "HARMFUL")}
            for i = 2, #slots do -- #1 return is continuationToken, we don't care about it
                ---@class DebuffData: AuraData
                ---@field priority number
                local data =  C_UnitAuras.GetAuraDataBySlot(unit, slots[i])

                if not notraiddebuffs.blackList[data.spellId] then
                    processDebuffData(data, unit)

                    if data.priority > -1 then
                        notraiddebuffs.candidates[data.auraInstanceID] = data
                    end
                end
            end
            UpdateRaidDebuffs(notraiddebuffs)
        end

        -- This was a full update, everything might have changed
        for _, icon in pairs(showing_icons) do
            UpdateBuffIcon(icon, nat)
        end
        for _, text in pairs(showing_texts) do
            UpdateBuffText(text, nat, nat.lastUpdate)
        end
    else
        --[[
        local updateIcons = allUpdateIcons[unit]
        local updateTexts = allUpdateTexts[unit]

        if not updateIcons then
            allUpdateIcons[unit] = {}
            updateIcons = allUpdateIcons[unit]
        else
            wipe(updateIcons)
        end

        if not updateTexts then
            allUpdateTexts[unit] = {}
            updateTexts = allUpdateTexts[unit]
        else
            wipe(updateTexts)
        end
        --]]

        wipe(updateIcons)
        wipe(updateTexts)

        local rdsNeedUpdate = false

        for _, data in ipairs(updateInfo.addedAuras or {}) do
            if toCheck[data.name] then
                print("Added: ".. data.name .." from "..data.sourceUnit)
            end
            if data.isHelpful then
                local icon = nat.Icons[data.spellId]
                if  icon and (icon.anyCaster or data.sourceUnit == "player") then
                    showing_icons[data.auraInstanceID] = icon
                    if icon.data then
                        icon.candidates[data.auraInstanceID] = data
                    else
                        icon.data = data
                        updateIcons[icon] = true
                    end
                else
                    local text = nat.Texts[data.spellId]
                    if text and (text.anyCaster or data.sourceUnit == "player") then
                        showing_texts[data.auraInstanceID] = text
                        if text.data then
                            text.candidates[data.auraInstanceID] = data
                        else
                            text.data = data
                            updateTexts[text] = true
                        end
                    end
                end
            else
                if notraiddebuffs and not notraiddebuffs.blackList[data.spellId] then
                    processDebuffData(data, unit)
                    local rdcands = notraiddebuffs.candidates

                    if data.priority > -1 then
                        rdcands[data.auraInstanceID] = data
                        rdsNeedUpdate = true
                    end
                end
            end
        end

        for _, updatedId in ipairs(updateInfo.updatedAuraInstanceIDs or {}) do
            local icon = showing_icons[updatedId]
            local text = showing_texts[updatedId]

            if icon then
                if icon.data and toCheck[icon.data.name] then
                    print("Updated: ".. icon.data.name .." from ".. icon.data.sourceUnit)
                end
                if icon.data and icon.data.auraInstanceID == updatedId then
                    icon.data = C_UnitAuras.GetAuraDataByAuraInstanceID(unit, updatedId)
                    updateIcons[icon] = true
                elseif icon.candidates[updatedId] then
                    icon.candidates[updatedId] = C_UnitAuras.GetAuraDataByAuraInstanceID(unit, updatedId)
                end
            elseif text then
                if text.data and toCheck[text.data.name] then
                    print("Updated: ".. text.data.name .." from "..text.data.sourceUnit)
                end
                if text.data and text.data.auraInstanceID == updatedId then
                    text.data = C_UnitAuras.GetAuraDataByAuraInstanceID(unit, updatedId)
                    updateTexts[text] = true
                elseif text.candidates[updatedId] then
                    text.candidates[updatedId] = C_UnitAuras.GetAuraDataByAuraInstanceID(unit, updatedId)
                end
            elseif notraiddebuffs then
                local rdcands = notraiddebuffs.candidates

                ---@class DebuffData: AuraData
                local data = C_UnitAuras.GetAuraDataByAuraInstanceID(unit, updatedId)
                if data and rdcands[updatedId]  then -- if it's in canditdates, it's not blacklisted
                    processDebuffData(data, unit)
                    if data.priority > -1 then
                        rdcands[updatedId] = data
                        rdsNeedUpdate = true
                    else
                        rdcands[updatedId] = nil
                        local rdshowing = notraiddebuffs.showing
                        for _, instanceID in ipairs(rdshowing) do
                            if instanceID == updatedId then
                                rdsNeedUpdate = true
                            end
                        end
                    end
                end
            end
        end

        for _, removedId in ipairs(updateInfo.removedAuraInstanceIDs or {}) do
            local icon = showing_icons[removedId]
            local text = showing_texts[removedId]

            if icon then
                if icon.data and toCheck[icon.data.name] then
                    print("Removed: ".. icon.data.name .." from ".. icon.data.sourceUnit)
                end
                --tinsert(SanUIdb.nat2log, {"Removing Icon "..tostring(removedId) })
                showing_icons[removedId] = nil
                if icon.data and icon.data.auraInstanceID == removedId then
                    icon.data = nil
                    updateIcons[icon] = true
                elseif icon.candidates[removedId] then
                    icon.candidates[removedId] = nil
                    showing_icons[removedId] = nil
                end
            elseif text then
                if text.data and toCheck[text.data.name] then
                    print("Removed: ".. text.data.name .." from "..text.data.sourceUnit)
                end
                --tinsert(SanUIdb.nat2log, {"Removing Text "..tostring(removedId) })
                showing_texts[removedId] = nil
                if text.data and text.data.auraInstanceID == removedId then
                    text.data = nil
                    updateTexts[text] = true
                elseif text.candidates[removedId] then
                    text.candidates[removedId] = nil
                    showing_texts[removedId] = nil
                end
            elseif notraiddebuffs then
                local rdcands = notraiddebuffs.candidates

                if rdcands[removedId] then
                    rdcands[removedId] = nil

                    for _, instanceID in ipairs(notraiddebuffs.showing) do
                        if instanceID == removedId then
                            rdsNeedUpdate = true
                        end
                    end
                end
            end
        end

        for icon, _ in pairs(updateIcons) do
            UpdateBuffIcon(icon, nat)
        end

        for text, _ in pairs(updateTexts) do
            UpdateBuffText(text, nat, nat.lastUpdate)
        end

        if rdsNeedUpdate then
            UpdateRaidDebuffs(notraiddebuffs)
        end
    end
end

local ForceUpdate = function(element)
	return Update(element.__owner, "ForceUpdate", element.__owner.unit, {isFullUpdate = true})
end

local function Enable(self)
	local nat = self.NotAuraTrack

	if (nat) then
		nat.__owner = self
		nat.ForceUpdate = ForceUpdate
		self:RegisterEvent("UNIT_AURA", Update)

        nat.showing = { icons = {}, texts = {} }

        for _, icon in pairs(nat.Icons) do
            icon.candidates = {}
        end

        for _, text in pairs(nat.Texts) do
            text.candidates = {}
        end

        local raiddebuffs = nat.NotRaidDebuffs
        if raiddebuffs then
            raiddebuffs.blackList = raiddebuffs.blackList or {}
            raiddebuffs.candidates = {}
            raiddebuffs.showing = {}
            for k,v in pairs(debuffBlackList) do
                raiddebuffs.blackList[k] = v
            end

            -- Backdrops needed for border debuff coloring
            for _, f in ipairs(raiddebuffs) do
                if not f.Backdrop then
                    S.CreateBackdrop(f)
                end
                f:Hide()
            end
        end

        return true
    end
end

local function Disable(self)
	local nat = self.NotAuraTrack

	if (nat) then
		self:UnregisterEvent("UNIT_AURA", Update)
		if nat.Ticker then
			nat.Ticker:Cancel()
		end
	end

    if nat.NotRaidDebuffs then
		nat.NotRaidDebuffs:Hide()
	end
end

oUF:AddElement("NotAuraTrack2", Update, Enable, Disable)