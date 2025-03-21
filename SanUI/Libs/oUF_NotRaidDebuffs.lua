local _, addon = ...
local oUF = addon.oUF

local ORD = {}

local S = unpack(addon) 

addon.oUF_NotRaidDebuffs = ORD

local libDispel = S.libDispel
local bleedList = libDispel:GetBleedList()

local abs, max = math.abs, math.max
local format, floor = format, floor
local type, pairs, wipe = type, pairs, wipe

local UnitCanAttack = UnitCanAttack
local UnitIsCharmed = UnitIsCharmed
local GetSpellInfo = GetSpellInfo
local UnitAura = C_UnitAuras.GetAuraDataByIndex
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

local blackList = {
	[105171] = true, -- Deep Corruption (Dragon Soul: Yor'sahj the Unsleeping)
	[108220] = true, -- Deep Corruption (Dragon Soul: Shadowed Globule)
	[116095] = true, -- Disable, Slow   (Monk: Windwalker)
}

local DispelColor = {
	Magic   = {0.2, 0.6, 1.0},
	Curse   = {0.6, 0, 1.0},
	Disease = {0.6, 0.4, 0},
	Poison  = {0, 0.6, 0},
	none    = {0.2, 0.2, 0.2}
}

local function add(spell, priority, stackThreshold)
	if type(spell) == 'number' then
		spell = GetSpellInfo(spell)
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
		if type(t[spell]) == 'boolean' then
			local oldValue = t[spell]
			t[spell] = { enable = oldValue, priority = 0, stackThreshold = 0 }
		else
			if t[spell].enable then
				add(spell, t[spell].priority or 0, t[spell].stackThreshold or 0)
			end
		end
	end
end

function ORD:ResetDebuffData()
	wipe(debuff_data)
end

function ORD:GetDispelColor()
	return DispelColor
end

local function formatTime(s)
	if s > 60 then
		return format('%dm', s/60), s%60
	elseif s < 1 then
		return format('%.1f', s), s - floor(s)
	else
		return format('%d', s), s - floor(s)
	end
end

local function OnTextUpdate(self, elapsed)
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

local function UpdateDebuffs(self, data)

	for index = 1,2 do
		local f = self.NotRaidDebuffs[index]
		local data = data[index]

		if (not f) then return end
		if (not data) then f:Hide() return end

		local name = data.name
		local icon = data.icon
		local count = data.count or 0
		local debuffType = data.debuffType
		local duration = data.duration
		local endTime = data.expiration
		local spellID = data.spellID
		local stackThreshold = data.stackThreshold


		if name and (count >= stackThreshold) then
			f.icon:SetTexture(icon)
			f.icon:Show()
			f.duration = duration
			f.reverse = f.ReverseTimer and f.ReverseTimer[spellID]

			if f.count then
				if count and (count > 1) then
					f.count:SetText(count)
					f.count:Show()
				else
					f.count:SetText("")
					f.count:Hide()
				end
			end

			if f.time then
				if duration and (duration > 0) then
					f.endTime = endTime
					f.nextUpdate = 0
					f:SetScript('OnUpdate', OnTextUpdate)
					f.time:Show()
				else
					f:SetScript('OnUpdate', nil)
					f.time:Hide()
				end
			end

			if f.cd then
				if duration and (duration > 0) then
					f.cd:SetCooldown(endTime - duration, duration)
					f.cd:Show()
				else
					f.cd:Hide()
				end
			end

			--print("dtype: "..debuffType)
			local c = DispelColor[debuffType] or DispelColor.none
			f.SetBackdropBorderColor(c)

			f:Show()
		else
			f:Hide()
		end
	end
end

local function debuffData(unit, index)
	local data = UnitAura(unit, index, 'HARMFUL')
	if not data then return end
	return {
		priority = -1,
		name = data.name,
		icon = data.icon,
		count = data.charges,
		debuffType = data.dispelName,
		duration = data.duration,
		expiration = data.expirationTime,
		spellID = data.spellId,
		stackThreshold = 0
	}
end

local function Update(self, event, unit, isFullUpdate, updatedAuras)
	if not unit or self.unit ~= unit then return end

	--we coudln't dispel if the unit its charmed, or its not friendly
	local shouldShowDispellable = (not UnitIsCharmed(unit)) and (not UnitCanAttack('player', unit))

	-- keep elements for the algorithm to work
	local toShow = { { priority = -1, stackThreshold = 0 }, { priority = -1, stackThreshold = 0 } }

	local index = 1
	local data = debuffData(unit, index)

	while data and data.name do

		if not blackList[data.spellID] then
				if bleedList[data.spellID] then
					data.debuffType = 'Bleed'
				end
			if shouldShowDispellable and data.debuffType then
				--Make Dispel buffs on top of Boss Debuffs
				if libDispel:IsDispellableByMe(data.debuffType) then--DispelFilter[data.debuffType] then
					data.priority = DispelPriority[data.debuffType]
				else
					data.debuffType = nil
				end
			end

			local debuff = debuff_data[data.name]

			if debuff then
				data.priority = max(data.priority, debuff.priority or 0)
				data.stackThreshold = debuff.stackThreshold or 0
			end

			if data.priority > -1 then
				if data.priority > toShow[1].priority then
					toShow[2] = toShow[1]
					toShow[1] = data
				elseif data.priority > toShow[2].priority then
					toShow[2] = data
				end
			end
		end

		index = index + 1
		data = debuffData(unit, index)
	end

	if self.NotRaidDebuffs.forceShow then
		local _spellID = 5782
		local _name, _, _icon = GetSpellInfo(_spellID)
		local _spellID2 = 8921
		local _name2, _, _icon2 = GetSpellInfo(_spellID2)
		toShow[1] = { priority = 0, name = _name, icon = _icon, count = 5, debuffType = 'Magic', duration = 0, expiration = 60, spellID = _spellID, stackThreshold = 0 }
		toShow[2] = { priority = 0, name = _name2, icon = _icon2, count = 4, debuffType = 'Disease', duration = 0, expiration = 60, spellID = _spellID2, stackThreshold = 0 }
	end

	if toShow[1].icon == toShow[2].icon then
		toShow[2] = nil
	end

	UpdateDebuffs(self, toShow)
end

local function Enable(self)
	if self.NotRaidDebuffs then
		if self.NotRaidDebuffs.blackList then
			for k,v in pairs(self.NotRaidDebuffs.blackList) do
				blackList[k] = v
			end
		end

		self:RegisterEvent('UNIT_AURA', Update)

		for index = 1,2 do
			local f = self.NotRaidDebuffs[index]
			if not f.Backdrop then
				S.CreateBackdrop(f)
			end
		end

		return true
	end
end

local function Disable(self)
	if self.NotRaidDebuffs then
		self:UnregisterEvent('UNIT_AURA', Update)

		self.NotRaidDebuffs:Hide()
	end
end
--[[
local frame = CreateFrame('Frame')
frame:SetScript('OnEvent', CheckDispel)
frame:RegisterEvent('UNIT_PET', CheckDispel)

frame:RegisterEvent('PLAYER_TALENT_UPDATE')
frame:RegisterEvent('PLAYER_SPECIALIZATION_CHANGED')
frame:RegisterEvent('CHARACTER_POINTS_CHANGED')
--]]

oUF:AddElement('NotRaidDebuffs', Update, Enable, Disable)
