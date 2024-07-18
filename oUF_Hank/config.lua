--local oUF = SanUI.oUF

oUF_Hank_config_changes = {
FocusFrameScale = 0.7,
FrameScale = 0.75,
FrameMargin = {200, 195},
FocusFrameMargin = {415, 450},

Castbar = false,
CastbarTexture = "Interface\\AddOns\\oUF_Hank_v3\\textures\\flat.blp",
CastbarBorderTexture = "Interface\\AddOns\\oUF_Hank_v3\\textures\\2px_glow.blp",
CastbarBackdropTexture = "Interface\\AddOns\\oUF_Hank_v3\\textures\\flat.blp",

AuraBorder = false,
AuraStickyColor = {1, 1, 1},

RangeFade = false,

TotemBar = false,

AdditionalPower = true,

----------------------- Aura filters ------------------------
-------------------------------------------------------------

-- Aura settings for target
AurasTARGET = {
	-- Maximum number of buffs shown
	MaxBuffs = 32,
	-- Maximum number of debuffs shown
	MaxDebuffs = 40,

	-- Set to true, these kinds of auras will *ALWAYS* be shown and are colored.
	-- Overrides white- and blacklists (see below)!
	StickyAuras = {
                -- Debuffs on a friendly unit (true/false)
                debuffsOnFriendly = true,
                -- Buffs on a hostile unit (true/false)
                buffsOnHostile = true,
		-- Buffs casted by player on friendly units (true/false)
		myBuffs = true,
		-- Debuffs afflicted by player on hostile units (true/false)
		myDebuffs = true,
		-- Debuffs afflicted by player's pet on hostile units (true/false)
		petDebuffs = true,
		-- Debuffs on friendly units that you can cure (true/false)
		curableDebuffs = true,
		-- Buffs a hostile unit casted on itself (true/false)
		enemySelfBuffs = true,
	},

	-- All non-sticky auras (see above) will be filtered using the following method ("BLACKLIST" / "WHITELIST")
	-- Leave empty to not filter at all
	FilterMethod = {
		Buffs = "",
		Debuffs = "",
	},

	-- If the filter method is set to "BLACKLIST" the following auras will be hidden (unless sticky)
	BlackList = {
		"Essence of Wintergrasp",
		"Honorless Target",
		"Drinking",
		"Ghost",
		-- etc.
	},

	-- If the filter method is set to "WHITELIST" only (unless sticky) the following auras will be shown
	WhiteList = {
		"Heroism",
		"Mark of the Fallen Champion",
		-- etc.
	},
},

-- Aura settings for focus
-- Please refer to the explanations above
AurasFOCUS = {
	MaxBuffs = 32,
	MaxDebuffs = 40,

	StickyAuras = {
                debuffsOnFriendly = true,
                buffsOnHostile = true,
		myBuffs = false,
		myDebuffs = true,
		petDebuffs = false,
		curableDebuffs = true,
		enemySelfBuffs = true,
	},

	FilterMethod = {
		Buffs = "WHITELIST",
		Debuffs = "WHITELIST",
	},

	BlackList = {
	},

	WhiteList = {
	},
},

}

for key, value in pairs(oUF_Hank_config_changes) do
	oUF_Hank_config[key] = value
end
