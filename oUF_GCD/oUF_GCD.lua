local oUF = SanUI.oUF

-- based on oUF_GCD by Exactly.

--[[

Spell IDs to check if they are available as GCD refs. The
original oUF_GCD used spell names and did'nt play well
with other locales. We use the spell id to lookup the
spell name and look that up in the spell book ...

Not all these spells are available at level 1 (most
are learned at level 4). If you have a better suggestion(s),
post a comment at:

http://www.wowinterface.com/downloads/info14769-oUF_GCD-HungtarsoUFGlobalCooldownBar.html

--]]
local referenceSpells = {
	47541,			-- Death Coil (Death Knight)
	45902,			-- Blood Strike (Death Knight) (was 66215)
	186257,			-- Aspect of the Cheetah (Hunter)
	585,			-- Smite (Priest)
	35395,			-- Crusader Strike (Paladin)
	172,			-- Corruption (Warlock)
	1464,			-- Slam (Warrior)
	116,                    -- Frostbolt (Mage)
	188196,			-- Lightning Bolt (Shaman)
	1752,			-- Sinister Strike (Rogue)
	5176,			-- Wrath (Druid)
	100780,			-- Jab (Monk)
	162794,			-- Chaos Strike (Demon Hunter, Havoc)
	222030,			-- Soul Cleave (Demon Hunter, Vengeance)
	362969,			-- Azure Strike (Evoker)
}


local GetTime = GetTime
local BOOKTYPE_SPELL = BOOKTYPE_SPELL
local GetSpellCooldown = GetSpellCooldown


local spellid = nil


--
-- find a spell to use.
--
local Init = function()
	local FindInSpellbook = function(spell)
		for tab = 1, 4 do
			local _, _, offset, numSpells = GetSpellTabInfo(tab)
			for i = (1+offset), (offset + numSpells) do
				local bspell = GetSpellBookItemName(i, BOOKTYPE_SPELL)
				if (bspell == spell) then
					return i   
				end
			end
		end
		return nil
	end

	for _, lspell in pairs(referenceSpells) do
		local na = GetSpellInfo (lspell)
		local x = FindInSpellbook(na)
		if x ~= nil then
			spellid = lspell
			break
		end
	end

	if spellid == nil then
		-- XXX: print some error ..
		print ("Spell not found: "..spell.."!")
	end

	return spellid
end


local OnUpdateGCD = function(self)
	local perc = (GetTime() - self.starttime) / self.duration
	if perc > 1 then
		self:Hide()
	else
		self:SetValue(perc)
	end
end


local OnHideGCD = function(self)
 	self:SetScript('OnUpdate', nil)
end


local OnShowGCD = function(self)
	self:SetScript('OnUpdate', OnUpdateGCD)
end


local Update = function(self, event, unit)
	if self.GCD then
		if spellid == nil then
			if Init() == nil then
				return
			end
		end

		local start, dur = GetSpellCooldown(spellid)

		if (not start) then return end
		if (not dur) then dur = 0 end

		if (dur == 0) then
			self.GCD:Hide() 
		else
			self.GCD.starttime = start
			self.GCD.duration = dur
			self.GCD:Show()
		end
	end
end


local Enable = function(self)
	if (self.GCD) then
		self.GCD:Hide()
		self.GCD.starttime = 0
		self.GCD.duration = 0
		self.GCD:SetMinMaxValues(0, 1)

		self:RegisterEvent('ACTIONBAR_UPDATE_COOLDOWN', Update, true)
		self.GCD:SetScript('OnHide', OnHideGCD)
		self.GCD:SetScript('OnShow', OnShowGCD)
	end
end


local Disable = function(self)
	if (self.GCD) then
		self:UnregisterEvent('ACTIONBAR_UPDATE_COOLDOWN')
		self.GCD:Hide()  
	end
end


oUF:AddElement('GCD', Update, Enable, Disable)
