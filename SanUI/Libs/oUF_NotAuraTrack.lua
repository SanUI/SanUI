local _, addon = ...

local oUF = addon.oUF
assert(oUF, "oUF_NotAuraTrack cannot find an instance of oUF. If your oUF is embedded into a layout, it may not be embedded properly.")

--[[
	By Tavore of EU-Kargath. Heavily modified version of oUF_AuraTrack by Tukz of tukui.org
	
	Element frame.NotAuraTrack has the following entries
	
	.Icons Table of buff icons to show
		Keys: spellID
		Values: Tables with the following Keys:
			.anyCaster If true(thy) show regardless of caster. If false(y), show only when the player is the caster
			.cd  (optional) A cooldown frame, will be updated by NotAuraWatch
			.setTex (optional) If true(thy), set the texture to the one belonging to the spellID (usefull when using
			                   several spellIDs on the same buff icon)
			.tex (Only needed when .color or .timers or .setTex is set) The texture of the icon that color/texture gets applied to
			.color (optional) The color of the texture (leave nil for showing images)
			.timers (optional) Array (table indexed by integers) of timers. A timer is a table of the form { time, { r, g, b} }, where the icon texture 
		            is colored by SetVertexColor(r, g, b) if the remaining duration of the buff is <time. The first one matching wins.
			.count (optional) Fontstring, will be set the the number of stacks (if > 1)	
	.Texts Table of FontString instances to show
		Keys: spellID
		Values: Tables with the following Keys:
			.anyCaster If true(thy) show regardless of caster. If false(y), show only when the player is the caster
			.format The format string when printing the time left, passed as an argument to SetFormattedText
			.res The maximum time between updates (should be at most half of the lowest digit needed for the format string)
			.timers (optional) Array (table indexed by integers) of timers. A timer is a table of the form { time, format, res}, where whenever the remaining
			       duration of the buff is <time, we use the format string format and a maximum update time of res (see the notes above)
]]

local UnitAura = C_UnitAuras.GetAuraDataByIndex

--[[ key for swiftmend, will get special treatment
local smid = 18562
local rjname = GetSpellInfo(774) --rejuvenation
local rgname = GetSpellInfo(8936) --regrowth
local wgname = GetSpellInfo(48438) -- wild growth
local germname = GetSpellInfo(155777) --germination
local rbloomname = GetSpellInfo(364365) -- renewing bloom, 4pc tier set bonus
local smhots = {
	[rjname] = true,
	[rgname] = true,
	[wgname] = true,
	[germname] = true,
	[rbloomname] = true,
}
--]]

local function UpdateText(text, current_time)
	local buf_remaining = text.expiration - current_time

	local format = text.format
	local res = text.res

	for _, timer in ipairs(text.timers) do
		if buf_remaining < timer[1] then
			format = timer[2]
			res = timer[3]
			break
		end
	end
	text:SetFormattedText(format, buf_remaining)

	if not text.timer_running then
		C_Timer.After(res, function()
			text.timer_running = false
			if text:IsShown() then
				UpdateText(text, GetTime())
			end
		end)
		text.running_timer = true
	end
end

local Update = function(self, event, unit)
	if self.unit ~= unit then
		return
	end

	local nat = self.NotAuraTrack
	nat.lastUpdate = GetTime()
	local icons = nat.Icons
	local texts = nat.Texts
	local showing = { icons = {}, texts = {} }
	--local swiftmendable = false

	-- do 41 when reactivating swiftment handling, so we have at least one nil return value
	-- for UnitAura so we can handle swiftmend in all cases
	for i = 1, 40 do
		local data = UnitAura(unit, i, "HELPFUL")
		if not data then break end
		local texture = data.icon
		local count = data.charges
		local duration = data.duration
		local expiration = data.expirationTime
		local caster = data.sourceUnit
		local spellID = data.spellId

		--[=[
		if not name then 
			if not swiftmendable or showing.icons[icons[smid]] then
				break
			end
			spellID = smid
			caster = "player" -- otherwise icon isn't shown
		end
		--]=]

		local icon = icons[spellID]
		--[=[
		if smhots[name] and caster == "player" then
			swiftmendable = true
		end
		--]=]

		if  icon and (icon.anyCaster or caster == "player") then
			if icon.setTex then
				icon.tex:SetTexture(texture)
			end

			if icon.cd then
				icon.cd:SetCooldown(expiration - duration, duration)
			end

			if count ~= nil and icon.count then
				icon.count:SetText(count)
			end

			local color = icon.color
			if icon.timers then
				local buf_remaining = expiration - nat.lastUpdate
				for _, timer in ipairs(icon.timers) do
					if buf_remaining < timer[1] then
						color = timer[2]
						break
					end
				end
			end

			if color then
				icon.tex:SetVertexColor(unpack(color))
			end
			icon:Show()
			showing.icons[icon] = true
		end

		local text = texts[spellID]
		if text and (text.anyCaster or caster == "player") then
			text.expiration = expiration
			UpdateText(text, nat.lastUpdate)
			text:Show()
			if text.spellIDs then
			  --sharing a text between multiple spellIDs, need to register them all for being shown
				for _, id in ipairs(text.spellIDs) do
					showing.texts[id] = true
				end
			else
				showing.texts[spellID] = true
			end
		end
	end

	for _, icon in pairs(icons) do
		if not showing.icons[icon] then
			icon:Hide()
		end
	end

	for spellID, text in pairs(texts) do
		if not showing.texts[spellID] then
			text:Hide()
		end
	end
end

local ForceUpdate = function(element)
	return Update(element.__owner, "ForceUpdate", element.__owner.unit)
end

local function Enable(self)
	local nat = self.NotAuraTrack

	if (nat) then
		nat.__owner = self
		nat.ForceUpdate = ForceUpdate
		self:RegisterEvent("UNIT_AURA", Update)
		nat.lastUpdate = GetTime() - 0.6
		nat.Ticker = C_Timer.NewTicker(0.6, function() if GetTime() - nat.lastUpdate > 0.5 then ForceUpdate(nat) end end)
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
end

oUF:AddElement("NotAuraTrack", Update, Enable, Disable)
