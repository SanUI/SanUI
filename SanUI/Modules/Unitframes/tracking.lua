local addonName, addon = ...
local S,C,L = unpack(addon) 
local oUF = addon.oUF

local Scale = S.Toolkit.Functions.Scale

if not S["UnitFrames"].RaidBuffsTracking then
	S["UnitFrames"].RaidBuffsTracking = {}
end

-- Cornerbuffs:
-- .spellID The spells ID
-- .pos Table. The position, unpacked into arguments to SetPoint, relative inside the auras frame
-- .color The standard color to apply to the texture (leave nil for images, probably)
-- .anyCaster If truthy, show regardless of caster. If falsy, show only if the player was the caster
-- .cooldownAnim If truthy, show a cooldown sweep animation
-- .timers Array (table indexed by integers) of timers. A timer is a table of the form { time, { r, g, b} }, where the icon texture 
--         is colored by SetVertexColor(r, g, b) if the remaining duration of the buff is <time. The first one matching wins.
-- .count Table { size } where size is fontsize
S["UnitFrames"].RaidBuffsTracking["DRUID"] = {
  -- Rejuvenation
	{
    spellID = 774,
    pos = {"CENTER", nil, "CENTER", -Scale(14), 0},
    color = {0.4, 0.8, 0.2},
    anyCaster = false,
    timers = { {2, {1, 0, 0}}, {4.5, {1, 1, 0}} },

  },
  -- Germination
	{
    spellID = 155777,
    pos = {"CENTER", nil, "CENTER", -Scale(14), -Scale(9)},
    color = {0.4, 0.8, 0.2},
    anyCaster = false,
    timers = { {2, {1, 0, 0}}, {4.5, {1, 1, 0}} }
  },
  -- Wild Growth
	{
    spellID = 48438,
    pos = {"CENTER", nil, "CENTER", -Scale(5), 0},
    color = {0, 1, 1},
    anyCaster = false,
    cooldownAnim = true
  },
  -- Regrowth
	{
    spellID = 8936,
    pos = {"CENTER", nil, "CENTER", Scale(3), 0},
    color = {0.4, 0.8, 0.2},
    anyCaster = false,
    timers = { {2, {1, 0, 0}}, {3.6, {1, 1, 0}} }
  },
	--[[ swiftmend -- SPECIAL DON'T CHANGE THIS (commenting out is ok)
	{
		spellID = 18562,
		pos = {"TOPLEFT",0,-Scale(7)},
		color = {1,1,1},
		anyCaster = false,
	}, 
	--]]
	-- adaptive swarm necro
	{
	  spellID = 325748,
    pos = {"CENTER", nil, "CENTER", Scale(12), 0},
    color = {153/255, 102/255, 0},
    anyCaster = false,
    count = { size = 9 },
		cooldownAnim = true

  },
  	-- adaptive swarm talent
	{
	  spellID = 391891,
    pos = {"LEFT", nil, "CENTER", Scale(12), 0},
    color = {153/255, 102/255, 0},
    anyCaster = false,
    count = { size = 9 },
		cooldownAnim = true

  },
}

if not S["UnitFrames"].TextAuras then
	S["UnitFrames"].TextAuras = {}
end

S["UnitFrames"].TextAuras["DRUID"] = S["UnitFrames"].TextAuras["DRUID"] or {}

table.insert(
	S["UnitFrames"].TextAuras["DRUID"],
	{
		spellID = {33763, 33778, 43421, 188550, 290754, 186371},
		pos = {"TOP",0,1},
		textsize = 10, 
		format = "|cFF00FF00%u|r", 
		timers = { { 2, "|cFFFF0000%.1f|r", 0.05}, { 4.5, "|cFFFFFF00%u|r", 0.3} },
		anyCaster = false,
	}
)

-- Defensive cooldowns: Simple list of spellIDs
S["UnitFrames"].RaidBuffsTracking["ALL"] = {
	1022, -- Blessing of Protection
	102342, -- Ironbark
	104773, -- Unending Resolve
	108271, -- Astral Shift
	108416, -- Dark Pact
	113862, -- Greater Invisibility
	11426, -- Ice Barrier
	116849, -- Life Cocoon
	118038, -- Die by the Sword
	120954, -- Fortifying Brew
	122278, -- Dampen Harm
	122783, -- Diffuse Magic
	125174, -- Touch of Karma
	12975, -- Last Stand
	145629, -- Anti-Magic Zone
	147833, -- Intervene
	184364, -- Enraged Regeneration
	184662, -- Shield of Vengeance
	186265, -- Aspect of the Turtle
	187827, -- Metamorphosis
	193320, -- Umbilicus Eternus
	194679, -- Rune Tap
	194844, -- BoneStorm
	196555, -- Netherwalk
	1966, -- Feint
	198065, -- Prismatic Cloak
	198158, -- Mass Invisibility
	198760, -- Intercept
	199027, -- Veil of Midnight
	199038, -- Leave No Man Behind
	199507, -- Spreading The Word: Protection
	199754, -- Riposte
	200851, -- Rage of the Sleeper
	201318, -- Fortifying Elixir
	201939, -- Protector of the Pack 3
	201940, -- Protector of the Pack 2
	202043, -- Protector of the Pack 1
	202162, -- Guard
	203524, -- Neltharion's Fury
	203819, -- Demon Spikes
	204018, -- Blessing of Spellwarding
	205191, -- Eye for an Eye
	20594 , -- Stoneform
	207319, -- Corpse Shield
	207654, -- Servant of the Queen
	209426, -- Darkness
	210655, -- Protection of Ashamane
	210918, -- Ethereal Form
	212295, -- Nether Ward
	212641, -- Guardian of Ancien Kings (Glyph of the Queen)
	212800, -- Blur
	215479, -- Ironskin Brew
	215769, -- Spirit of Redemption
	219809, -- Tombstone
	223658, -- Safeguard
	228049, -- Guardian of the Forgotten Queen
	22812, -- Barkskin
	234081, -- Celestial Guardian
	235313, -- Blazing Barrier
	235450, -- Prismatic Barrier
	23920, -- Spell Reflection
	263648, -- Soul Barrier
	27827, -- Spirit of Redemption
	31224, -- Cloak of Shadows
	31850, -- Ardent Defender
	324867, -- Fleshcraft (Necrolord)
	33206, -- Pain Suppression
	353319, -- Peaceweaver (PvP)
	353362, -- Dematerialize (PvP)
	363522, -- Gladiator's Eternal Aegis
	363916, -- Obsidian Scales
	45182, -- Cheating Death
	45438, -- Ice Block
	47585, -- Dispersion
	47788, -- Guardian Spirit
	48707, -- Anti-Magic Shell
	48792, -- Icebound Fortitude
	498, -- Divine Protection
	5277, -- Evasion
	55233, -- Vampiric Blood
	61336, -- Survival Instincts
	6940, -- Blessing of Sacrifice
	81256, -- Dancing Rune Weapon
	81782, -- Power Word: Barrier
	86659, -- Guardian of Ancien Kings
	871, -- Shield Wall
	97463, -- Rallying Cry
	264735, -- Survival of the fittest
	388035, -- Fortitude of the bear
}

local function Defaults(priorityOverride)
	return {["enable"] = true, ["priority"] = priorityOverride or 0, ["stackThreshold"] = 0}
end


local function List(priority)
	return {
		enable = true,
		priority = priority or 0,
		stackThreshold = 0
	}
end

S["UnitFrames"].RaidDebuffs = {
		----------------------------------------------------------
	-------------------- Mythic+ Specific --------------------
	----------------------------------------------------------
	-- General Affixes
		--[209858] = List(), -- Necrotic
		[226512] = List(), -- Sanguine
		[240559] = List(), -- Grievous
		[240443] = List(), -- Bursting
		[409492] = List(), -- Afflicted Cry
	----------------------------------------------------------
	---------------- Dragonflight  -----------------
	----------------------------------------------------------
	-- Dawn of the Infinite
		[413041] = List(), -- Sheared Lifespan 1
		[416716] = List(), -- Sheared Lifespan 2
		[413013] = List(), -- Chronoshear
		[413208] = List(), -- Sand Buffeted
		[408084] = List(), -- Necrofrost
		[415436] = List(), -- Tainted Sand
		[413142] = List(), -- Eon Shatter
		[409266] = List(), -- Extinction Blast 1
		[414300] = List(), -- Extinction Blast 2
		[401667] = List(), -- Time Stasis
		[412027] = List(), -- Chronal Burn
		[411994] = List(), -- Chronomeld
		[400681] = List(), -- Spark of Tyr
		[404141] = List(), -- Chrono-faded
		[407147] = List(), -- Blight Seep
		[410497] = List(), -- Mortal Wounds
		[407313] = List(), -- Shrapnel
		[407120] = List(), -- Serrated Axe
		[418009] = List(), -- Serrated Arrows
		[407406] = List(), -- Corrosion
		[401420] = List(), -- Sand Stomp
		[403912] = List(), -- Accelerating Time
		[403910] = List(), -- Decaying Time
	--[[ Court of Stars
		[207278] = List(), -- Arcane Lockdown
		[209516] = List(), -- Mana Fang
		[209512] = List(), -- Disrupting Energy
		[211473] = List(), -- Shadow Slash
		[207979] = List(), -- Shockwave
		[207980] = List(), -- Disintegration Beam 1
		[207981] = List(), -- Disintegration Beam 2
		[211464] = List(), -- Fel Detonation
		[208165] = List(), -- Withering Soul
		[209413] = List(), -- Suppress
		[209027] = List(), -- Quelling Strike
	-- Halls of Valor
		[197964] = List(), -- Runic Brand Orange
		[197965] = List(), -- Runic Brand Yellow
		[197963] = List(), -- Runic Brand Purple
		[197967] = List(), -- Runic Brand Green
		[197966] = List(), -- Runic Brand Blue
		[193783] = List(), -- Aegis of Aggramar Up
		[196838] = List(), -- Scent of Blood
		[199674] = List(), -- Wicked Dagger
		[193260] = List(), -- Static Field
		[193743] = List(), -- Aegis of Aggramar Wielder
		[199652] = List(), -- Sever
		[198944] = List(), -- Breach Armor
		[215430] = List(), -- Thunderstrike 1
		[215429] = List(), -- Thunderstrike 2
		[203963] = List(), -- Eye of the Storm
		[193659] = List(), -- Felblaze Rush
		[196497] = List(), -- Ravenous Leap
		[192048] = List(), -- Expel Light
		[193092] = List(), -- Bloodletting Sweep
	-- Shadowmoon Burial Grounds
		[156776] = List(), -- Rending Voidlash
		[153692] = List(), -- Necrotic Pitch
		[153524] = List(), -- Plague Spit
		[154469] = List(), -- Ritual of Bones
		[162652] = List(), -- Lunar Purity
		[164907] = List(), -- Void Cleave
		[152979] = List(), -- Soul Shred
		[158061] = List(), -- Blessed Waters of Purity
		[154442] = List(), -- Malevolence
		[153501] = List(), -- Void Blast
	-- Temple of the Jade Serpent
		[396150] = List(), -- Feeling of Superiority
		[397878] = List(), -- Tainted Ripple
		[106113] = List(), -- Touch of Nothingness
		[397914] = List(), -- Defiling Mist
		[397904] = List(), -- Setting Sun Kick
		[397911] = List(), -- Touch of Ruin
		[395859] = List(), -- Haunting Scream
		[374037] = List(), -- Overwhelming Rage
		[396093] = List(), -- Savage Leap
		[106823] = List(), -- Serpent Strike
		[396152] = List(), -- Feeling of Inferiority
		[110125] = List(), -- Shattered Resolve
		[397797] = List(), -- Corrupted Vortex
		[396007] = List(), -- Vicious Peck (Songbird Queen)
	-- Ruby Life Pools
		[392406] = List(), -- Thunderclap
		[372820] = List(), -- Scorched Earth
		[384823] = List(), -- Inferno 1
		[373692] = List(), -- Inferno 2
		[381862] = List(), -- Infernocore
		[372860] = List(), -- Searing Wounds
		[373869] = List(), -- Burning Touch
		[385536] = List(), -- Flame Dance
		[381518] = List(), -- Winds of Change
		[372858] = List(), -- Searing Blows
		[372682] = List(), -- Primal Chill 1
		[373589] = List(), -- Primal Chill 2
		[373693] = List(), -- Living Bomb
		[392924] = List(), -- Shock Blast
		[381515] = List(), -- Stormslam
		[396411] = List(), -- Primal Overload
		[384773] = List(), -- Flaming Embers
		[392451] = List(), -- Flashfire
		[372697] = List(), -- Jagged Earth
		[372047] = List(), -- Flurry
		[372963] = List(), -- Chillstorm
	-- The Nokhud Offensive
		[382628] = List(), -- Surge of Power
		[386025] = List(), -- Tempest
		[381692] = List(), -- Swift Stab
		[387615] = List(), -- Grasp of the Dead
		[387629] = List(), -- Rotting Wind
		[386912] = List(), -- Stormsurge Cloud
		[395669] = List(), -- Aftershock
		[384134] = List(), -- Pierce
		[388451] = List(), -- Stormcaller's Fury 1
		[388446] = List(), -- Stormcaller's Fury 2
		[395035] = List(), -- Shatter Soul
		[376899] = List(), -- Crackling Cloud
		[384492] = List(), -- Hunter's Mark
		[376730] = List(), -- Stormwinds
		[376894] = List(), -- Crackling Upheaval
		[388801] = List(), -- Mortal Strike
		[376827] = List(), -- Conductive Strike
		[376864] = List(), -- Static Spear
		[375937] = List(), -- Rending Strike
		[376634] = List(), -- Iron Spear
	-- The Azure Vault
		[388777] = List(), -- Oppressive Miasma
		[386881] = List(), -- Frost Bomb
		[387150] = List(), -- Frozen Ground
		[387564] = List(), -- Mystic Vapors
		[385267] = List(), -- Crackling Vortex
		[386640] = List(), -- Tear Flesh
		[374567] = List(), -- Explosive Brand
		[374523] = List(), -- Arcane Roots
		[375596] = List(), -- Erratic Growth Channel
		[375602] = List(), -- Erratic Growth
		[370764] = List(), -- Piercing Shards
		[384978] = List(), -- Dragon Strike
		[375649] = List(), -- Infused Ground
		[387151] = List(), -- Icy Devastator
		[377488] = List(), -- Icy Bindings
		[374789] = List(), -- Infused Strike
		[371007] = List(), -- Splintering Shards
		[375591] = List(), -- Sappy Burst
		[385409] = List(), -- Ouch, ouch, ouch!
	-- Algeth'ar Academy
		[389033] = List(), -- Lasher Toxin
		[391977] = List(), -- Oversurge
		[386201] = List(), -- Corrupted Mana
		[389011] = List(), -- Overwhelming Power
		[387932] = List(), -- Astral Whirlwind
		[396716] = List(), -- Splinterbark
		[388866] = List(), -- Mana Void
		[386181] = List(), -- Mana Bomb
		[388912] = List(), -- Severing Slash
		[377344] = List(), -- Peck
		[376997] = List(), -- Savage Peck
		[388984] = List(), -- Vicious Ambush
		[388544] = List(), -- Barkbreaker
		[377008] = List(), -- Deafening Screech
		--]]
	----------------------------------------------------------
	---------------- Dragonflight (Season 2) -----------------
	----------------------------------------------------------
	--[[ Brackenhide Hollow
		[385361] = List(), -- Rotting Sickness
		[378020] = List(), -- Gash Frenzy
		[385356] = List(), -- Ensnaring Trap
		[373917] = List(), -- Decaystrike 1
		[377864] = List(), -- Infectious Spit
		[376933] = List(), -- Grasping Vines
		[384425] = List(), -- Smell Like Meat
		[373912] = List(), -- Decaystrike 2
		[373896] = List(), -- Withering Rot
		[377844] = List(), -- Bladestorm 1
		[378229] = List(), -- Marked for Butchery
		[381835] = List(), -- Bladestorm 2
		[376149] = List(), -- Choking Rotcloud
		[384725] = List(), -- Feeding Frenzy
		[385303] = List(), -- Teeth Trap
		[368299] = List(), -- Toxic Trap
		[384970] = List(), -- Scented Meat 1
		[384974] = List(), -- Scented Meat 2
		[368091] = List(), -- Infected Bite
		[385185] = List(), -- Disoriented
		[387210] = List(), -- Decaying Strength
		[382808] = List(), -- Withering Contagion 1
		[383087] = List(), -- Withering Contagion 2
		[382723] = List(), -- Crushing Smash
		[382787] = List(), -- Decay Claws
		[385058] = List(), -- Withering Poison
		[383399] = List(), -- Rotting Surge
		[367484] = List(), -- Vicious Clawmangle
		[367521] = List(), -- Bone Bolt
		[368081] = List(), -- Withering
		[374245] = List(), -- Rotting Creek
		[367481] = List(), -- Bloody Bite
		[378229] = List(), -- Marked for Butchery
		[377184] = List(), -- Consume
		[375416] = List(), -- Bleeding
	-- Halls of Infusion
		[387571] = List(), -- Focused Deluge
		[383935] = List(), -- Spark Volley
		[385555] = List(), -- Gulp
		[384524] = List(), -- Titanic Fist
		[385963] = List(), -- Frost Shock
		[374389] = List(), -- Gulp Swog Toxin
		[386743] = List(), -- Polar Winds
		[389179] = List(), -- Power Overload
		[389181] = List(), -- Power Field
		[257274] = List(), -- Vile Coating
		[375384] = List(), -- Rumbling Earth
		[374563] = List(), -- Dazzle
		[389446] = List(), -- Nullifying Pulse
		[374615] = List(), -- Cheap Shot
		[391610] = List(), -- Blinding Winds
		[374724] = List(), -- Molten Subduction
		[385168] = List(), -- Thunderstorm
		[387359] = List(), -- Waterlogged
		[391613] = List(), -- Creeping Mold
		[374706] = List(), -- Pyretic Burst
		[389443] = List(), -- Purifying Blast
		[374339] = List(), -- Demoralizing Shout
		[374020] = List(), -- Containment Beam
		[391634] = List(), -- Deep Chill
		[393444] = List(), -- Gushing Wound
	-- Neltharus
		[374534] = List(), -- Heated Swings
		[373735] = List(), -- Dragon Strike
		[377018] = List(), -- Molten Gold
		[374842] = List(), -- Blazing Aegis 1
		[392666] = List(), -- Blazing Aegis 2
		[375890] = List(), -- Magma Eruption
		[396332] = List(), -- Fiery Focus
		[389059] = List(), -- Slag Eruption
		[376784] = List(), -- Flame Vulnerability
		[377542] = List(), -- Burning Ground
		--[374451] = List(), -- Burning Chain
		[372461] = List(), -- Imbued Magma
		[378818] = List(), -- Magma Conflagration
		[377522] = List(), -- Burning Pursuit
		[375204] = List(), -- Liquid Hot Magma
		[374482] = List(), -- Grounding Chain
		[372971] = List(), -- Reverberating Slam
		[384161] = List(), -- Mote of Combustion
		[374854] = List(), -- Erupted Ground
		[373089] = List(), -- Scorching Fusillade
		[372224] = List(), -- Dragonbone Axe
		[372570] = List(), -- Bold Ambush
		[372459] = List(), -- Burning
		[372208] = List(), -- Djaradin Lava
	-- Uldaman: Legacy of Tyr
		[368996] = List(), -- Purging Flames
		[369792] = List(), -- Skullcracker
		[372718] = List(), -- Earthen Shards
		[382071] = List(), -- Resonating Orb
		[377405] = List(), -- Time Sink
		[369006] = List(), -- Burning Heat
		[369110] = List(), -- Unstable Embers
		[375286] = List(), -- Searing Cannonfire
		[372652] = List(), -- Resonating Orb
		[377825] = List(), -- Burning Pitch
		[369411] = List(), -- Sonic Burst
		[382576] = List(), -- Scorn of Tyr
		[369366] = List(), -- Trapped in Stone
		[369365] = List(), -- Curse of Stone
		[369419] = List(), -- Venomous Fangs
		[377486] = List(), -- Time Blade
		[369818] = List(), -- Diseased Bite
		[377732] = List(), -- Jagged Bite
		[369828] = List(), -- Chomp
		[369811] = List(), -- Brutal Slam
		[376325] = List(), -- Eternity Zone
		[369337] = List(), -- Difficult Terrain
		[376333] = List(), -- Temporal Zone
		[377510] = List(), -- Stolen Time
	-- Freehold
		[258323] = List(), -- Infected Wound
		[257775] = List(), -- Plague Step
		[257908] = List(), -- Oiled Blade
		[257436] = List(), -- Poisoning Strike
		[274389] = List(), -- Rat Traps
		[274555] = List(), -- Scabrous Bites
		[258875] = List(), -- Blackout Barrel
		[256363] = List(), -- Ripper Punch
		[413131] = List(), -- Whirling Dagger
	-- Neltharion's Lair
		[199705] = List(), -- Devouring
		[199178] = List(), -- Spiked Tongue
		[210166] = List(), -- Toxic Retch 1
		[217851] = List(), -- Toxic Retch 2
		[193941] = List(), -- Impaling Shard
		[183465] = List(), -- Viscid Bile
		[226296] = List(), -- Piercing Shards
		[226388] = List(), -- Rancid Ooze
		[200154] = List(), -- Burning Hatred
		[183407] = List(), -- Acid Splatter
		[215898] = List(), -- Crystalline Ground
		[188494] = List(), -- Rancid Maw
		[192800] = List(), -- Choking Dust
	-- Underrot
		[265468] = List(), -- Withering Curse
		[278961] = List(), -- Decaying Mind
		[259714] = List(), -- Decaying Spores
		[272180] = List(), -- Death Bolt
		[272609] = List(), -- Maddening Gaze
		[269301] = List(), -- Putrid Blood
		[265533] = List(), -- Blood Maw
		[265019] = List(), -- Savage Cleave
		[265377] = List(), -- Hooked Snare
		[265625] = List(), -- Dark Omen
		[260685] = List(), -- Taint of G'huun
		[266107] = List(), -- Thirst for Blood
		[260455] = List(), -- Serrated Fangs
	-- Vortex Pinnacle
		[87618] = List(), -- Static Cling
		[410870] = List(), -- Cyclone
		[86292] = List(), -- Cyclone Shield
		[88282] = List(), -- Upwind of Altairus
		[88286] = List(), -- Downwind of Altairus
		[410997] = List(), -- Rushing Wind
		[411003] = List(), -- Turbulence
		[87771] = List(), -- Crusader Strike
		[87759] = List(), -- Shockwave
		[88314] = List(), -- Twisting Winds
		[76622] = List(), -- Sunder Armor
		[88171] = List(), -- Hurricane
		[88182] = List(), -- Lethargic Poison
		[87622] = List(), -- Chain Lightning
	--]]
	----------------------------------------------------------
	---------------- Dragonflight (Season 3) -----------------
	----------------------------------------------------------
	-- Darkheart Thicket
		[198408] = List(), -- Nightfall
		[196376] = List(), -- Grievous Tear
		[200182] = List(), -- Festering Rip
		[200238] = List(), -- Feed on the Weak
		[200289] = List(), -- Growing Paranoia
		[204667] = List(), -- Nightmare Breath
		[204611] = List(), -- Crushing Grip
		[199460] = List(), -- Falling Rocks
		[200329] = List(), -- Overwhelming Terror
		[191326] = List(), -- Breath of Corruption
		[204243] = List(), -- Tormenting Eye
		[225484] = List(), -- Grievous Rip
		[200642] = List(), -- Despair
		[199063] = List(), -- Strangling Roots
		[198477] = List(), -- Fixate
		[204246] = List(), -- Tormenting Fear
		[198904] = List(), -- Poison Spear
		[200684] = List(), -- Nightmare Toxin
		[200243] = List(), -- Waking Nightmare
		[200580] = List(), -- Maddening Roar
		[200771] = List(), -- Propelling Charge
		[200273] = List(), -- Cowardice
		[201365] = List(), -- Darksoul Drain
		[201839] = List(), -- Curse of Isolation
		[201902] = List(), -- Scorching Shot
	-- Black Rook Hold
		--[202019] = List(), -- Shadow Bolt Volley
		[197521] = List(), -- Blazing Trail
		[197478] = List(), -- Dark Rush
		[197546] = List(), -- Brutal Glaive
		[198079] = List(), -- Hateful Gaze
		[224188] = List(), -- Hateful Charge
		[201733] = List(), -- Stinging Swarm
		[194966] = List(), -- Soul Echoes
		[198635] = List(), -- Unerring Shear
		[225909] = List(), -- Soul Venom
		[198501] = List(), -- Fel Vomitus
		[198446] = List(), -- Fel Vomit
		[200084] = List(), -- Soul Blade
		[197821] = List(), -- Felblazed Ground
		[203163] = List(), -- Sic Bats!
		--[199368] = List(), -- Legacy of the Ravencrest
		[225732] = List(), -- Strike Down
		[199168] = List(), -- Itchy!
		[225963] = List(), -- Bloodthirsty Leap
		[214002] = List(), -- Raven's Dive
		[197974] = List(), -- Bonecrushing Strike I
		[200261] = List(), -- Bonecrushing Strike II
		[204896] = List(), -- Drain Life
		[199097] = List(), -- Cloud of Hypnosis
	-- Waycrest Manor
		[260703] = List(), -- Unstable Runic Mark
		[261438] = List(), -- Wasting Strike
		[261140] = List(), -- Virulent Pathogen
		[260900] = List(), -- Soul Manipulation I
		[260926] = List(), -- Soul Manipulation II
		[260741] = List(), -- Jagged Nettles
		--[268086] = List(), -- Aura of Dread
		[264712] = List(), -- Rotten Expulsion
		[271178] = List(), -- Ravaging Leap
		[264040] = List(), -- Uprooted Thorns
		[265407] = List(), -- Dinner Bell
		[265761] = List(), -- Thorned Barrage
		--[268125] = List(), -- Aura of Thorns
		--[268080] = List(), -- Aura of Apathy
		[264050] = List(), -- Infected Thorn
		[260569] = List(), -- Wildfire
		[263943] = List(), -- Etch
		[264378] = List(), -- Fragment Soul
		[267907] = List(), -- Soul Thorns
		[264520] = List(), -- Severing Serpent
		[264105] = List(), -- Runic Mark
		[265881] = List(), -- Decaying Touch
		[265882] = List(), -- Lingering Dread
		[278456] = List(), -- Infest I
		[278444] = List(), -- Infest II
		[265880] = List(), -- Dread Mark
	-- Atal'Dazar
		[250585] = List(), -- Toxic Pool
		[258723] = List(), -- Grotesque Pool
		[260668] = List(), -- Transfusion I
		[260666] = List(), -- Transfusion II
		[255558] = List(), -- Tainted Blood
		[250036] = List(), -- Shadowy Remains
		[257483] = List(), -- Pile of Bones
		[253562] = List(), -- Wildfire
		[254959] = List(), -- Soulburn
		[255814] = List(), -- Rending Maul
		[255582] = List(), -- Molten Gold
		[252687] = List(), -- Venomfang Strike
		[255041] = List(), -- Terrifying Screech
		[255567] = List(), -- Frenzied Charge
		[255836] = List(), -- Transfusion Boss I
		[255835] = List(), -- Transfusion Boss II
		[250372] = List(), -- Lingering Nausea
		[257407] = List(), -- Pursuit
		[255434] = List(), -- Serrated Teeth
		[255371] = List(), -- Terrifying Visage
	-- Everbloom
		[427513] = List(), -- Noxious Discharge
		[428834] = List(), -- Verdant Eruption
		[427510] = List(), -- Noxious Charge
		[427863] = List(), -- Frostbolt I
		[169840] = List(), -- Frostbolt II
		[428084] = List(), -- Glacial Fusion
		[426991] = List(), -- Blazing Cinders
		[169179] = List(), -- Colossal Blow
		[164886] = List(), -- Dreadpetal Pollen
		[169445] = List(), -- Noxious Eruption
		[164294] = List(), -- Unchecked Growth I
		[164302] = List(), -- Unchecked Growth II
		[165123] = List(), -- Venom Burst
		[169658] = List(), -- Poisonous Claws
		[169839] = List(), -- Pyroblast
		[164965] = List(), -- Choking Vines
	-- Throne of the Tides
		[429048] = List(), -- Flame Shock
		[427668] = List(), -- Festering Shockwave
		[427670] = List(), -- Crushing Claw
		[76363]  = List(), -- Wave of Corruption
		[426660] = List(), -- Razor Jaws
		[426727] = List(), -- Acid Barrage
		[428404] = List(), -- Blotting Darkness
		[428403] = List(), -- Grimy
		[426663] = List(), -- Ravenous Pursuit
		[426783] = List(), -- Mind Flay
		[75992]  = List(), -- Lightning Surge
		[428868] = List(), -- Putrid Roar
		[428407] = List(), -- Blotting Barrage
		[427559] = List(), -- Bubbling Ooze
		[76516]  = List(), -- Poisoned Spear
		[428542] = List(), -- Crushing Depths
		[426741] = List(), -- Shellbreaker
		[76820]  = List(), -- Hex
		[426608] = List(), -- Null Blast
		[426688] = List(), -- Volatile Acid
		[428103] = List(), -- Frostbolt
	-- unstructured
		[412922] = List(), -- Binding Grasp
		[412810] = List(), -- Blight Spew
		[225962] = List(), -- Bloodthirsty Leap
		[200261] = List(), -- Bonebreaking Strike
		[197974] = List(), -- Bonecrushing Strike
		[419351] = List(), -- Bronze Exhalation
		[419516] = List(), -- Chronal Eruption
		--[413013] = List(), -- Chronoshear
		[427223] = List(), -- Cinderbolt Salvo
		[199143] = List(), -- Cloud of Hypnosis
		[426845] = List(), -- Cold Fusion
		[258709] = List(), -- Corrupted Gold
		[427670] = List(), -- Crushing Claw
		[428542] = List(), -- Crushing Depths
		[204611] = List(), -- Crushing Grip
		[409558] = List(), -- Crushing Onslaught
		[201839] = List(), -- Curse of Isolation
		[273657] = List(), -- Dark Leap
		[201365] = List(), -- Darksoul Drain
		[265407] = List(), -- Dinner Bell
		[201400] = List(), -- Dread Inferno
		[265880] = List(), -- Dread Mark
		[407902] = List(), -- Earthquake
		[197687] = List(), -- Eye Beam
		[264378] = List(), -- Fragment Soul
		[255567] = List(), -- Frenzied Charge
		[196354] = List(), -- Grievous Leap
		[225484] = List(), -- Grievous Rip
		[196376] = List(), -- Grievous Tear
		[258723] = List(), -- Grotesque Pool
		[198079] = List(), -- Hateful Gaze
		[76820]  = List(), -- Hex
		[264050] = List(), -- Infected Thorn
		[260741] = List(), -- Jagged Nettles
		[407715] = List(), -- Kaboom!
		[251187] = List(), -- Leaping Trash
		--[199368] = List(), -- Legacy of the Ravencrest
		[265882] = List(), -- Lingering Dread
		[250372] = List(), -- Lingering Nausea
		[200580] = List(), -- Maddening Roar
		[426783] = List(), -- Mind Flay
		[200684] = List(), -- Nightmare Toxin
		[169445] = List(), -- Noxious Eruption
		[259572] = List(), -- Noxious Stench
		[426808] = List(), -- Null Blast
		[412129] = List(), -- Orb of Contemplation
		[265346] = List(), -- Pallid Glare
		[198904] = List(), -- Poison Spear
		[427376] = List(), -- Poisoned Spear
		[169658] = List(), -- Poisonous Claws
		[200768] = List(), -- Propelling Charge
		[214002] = List(), -- Raven's Dive
		[426663] = List(), -- Ravenous Pursuit
		[426660] = List(), -- Razor Jaws
		[194956] = List(), -- Reap Soul
		[412505] = List(), -- Rending Cleave
		[255814] = List(), -- Rending Maul
		[264105] = List(), -- Runic Mark
		[255434] = List(), -- Serrated Teeth
		[264520] = List(), -- Severing Serpent
		[426741] = List(), -- Shellbreaker
		[412215] = List(), -- Shrouding Sandstorm
		[203163] = List(), -- Sic Bats!
		[411700] = List(), -- Slobbering Bite
		[194966] = List(), -- Soul Echoes
		[260907] = List(), -- Soul Manipulation
		[412262] = List(), -- Staticky Punch
		[201733] = List(), -- Stinging Swarm
		[411958] = List(), -- Stonebolt
		[225732] = List(), -- Strike Down
		[407125] = List(), -- Sundering Slam
		[264556] = List(), -- Tearing Strike
		[419511] = List(), -- Temporal Link
		[429172] = List(), -- Terrifying Vision
		[76807]  = List(), -- Thrash
		[413427] = List(), -- Time Beam
		[413621] = List(), -- Timeless Curse
		[414496] = List(), -- Timeline Acceleration
		[413024] = List(), -- Titanic Bulwark
		[265352] = List(), -- Toad Blight
		[204243] = List(), -- Tormenting Eye
		[427459] = List(), -- Toxic Bloom
		[198635] = List(), -- Unerring Shear
		[200630] = List(), -- Unnerving Screech
		[252781] = List(), -- Unstable Hex
		[260702] = List(), -- Unstable Runic Mark
		[165123] = List(), -- Venom Burst
		[252687] = List(), -- Venomfang Strike
		[261440] = List(), -- Virulent Pathogen
		[426688] = List(), -- Volatile Acid
		[76363]  = List(), -- Wave of Corruption
		[250096] = List(), -- Wracking Pain
	---------------------------------------------------------
	---------------- Vault of the Incarnates ----------------
	---------------------------------------------------------
	--[[ Eranog
		[370648] = List(5), -- Primal Flow
		[390715] = List(6), -- Primal Rifts
		[370597] = List(6), -- Kill Order
	-- Terros
		[382776] = List(5), -- Awakened Earth 1
		[381253] = List(5), -- Awakened Earth 2
		[386352] = List(3), -- Rock Blast
		[382458] = List(6), -- Resonant Aftermath
	-- The Primal Council
		[371624] = List(5), -- Conductive Mark
		[372027] = List(4), -- Slashing Blaze
		[374039] = List(4), -- Meteor Axe
	-- Sennarth, the Cold Breath
		[371976] = List(4), -- Chilling Blast
		[372082] = List(5), -- Enveloping Webs
		[374659] = List(4), -- Rush
		[374104] = List(5), -- Wrapped in Webs Slow
		[374503] = List(6), -- Wrapped in Webs Stun
		[373048] = List(3), -- Suffocating Webs
	-- Dathea, Ascended
		[391686] = List(5), -- Conductive Mark
		--[378277] = List(2), -- Elemental Equilbrium (not here?)
		[388290] = List(4), -- Cyclone
	-- Kurog Grimtotem
		[377780] = List(5), -- Skeletal Fractures
		[372514] = List(5), -- Frost Bite
		[374554] = List(4), -- Lava Pool
		[374709] = List(4), -- Seismic Rupture
		[374023] = List(6), -- Searing Carnage
		[374427] = List(6), -- Ground Shatter
		[390920] = List(5), -- Shocking Burst
		[372458] = List(6), -- Below Zero
		[391055] = List(0), -- Enveloping Earth
		[372517] = List(6), -- Frozen Solid
	-- Broodkeeper Diurna
		[388920] = List(6), -- Frozen Shroud
		[378782] = List(5), -- Mortal Wounds
		[378787] = List(5), -- Crushing Stoneclaws
		[375620] = List(6), -- Ionizing Charge
		[375578] = List(4), -- Flame Sentry
	-- Raszageth the Storm-Eater
		[381615] = List(6), -- Static Charge
		[399713] = List(6), -- Magnetic Charge
		[385073] = List(5), -- Ball Lightning
		[377467] = List(6), -- Fulminating Charge
		[396037] = List(3), -- Surging Blast
		[390911] = List(3), -- Lingering Charge
		[395929] = List(3), -- Storm's Spite
		--[381251] = List(3), -- Electric Lash
		-- TODO: DF
	--]]
	---------------------------------------------------------
	------------ Aberrus, the Shadowed Crucible -------------
	---------------------------------------------------------
	--[[ Kazzara
		[406516] = List(), -- Dread Rifts
		[407199] = List(), -- Dread Rifts
		[407200] = List(), -- Dread Rifts
		[407198] = List(), -- Dread Rifts
		[408367] = List(), -- Infernal Heart
		[408372] = List(), -- Infernal Heart
		[408373] = List(), -- Infernal Heart
		[407069] = List(), -- Rays of Anguish
		[407068] = List(), -- Rays of Anguish
		[402219] = List(), -- Rays of Anguish
		[407196] = List(), -- Dread Rifts
	-- Molgoth
		[406730] = List(), -- Crucible Instability
	-- Experimentation of Dracthyr
		[410019] = List(), -- Volatile Spew
		[406358] = List(), -- Mutilation
		[405413] = List(), -- Disintegrate
		[406358] = List(), -- Rending Charge
	-- Zaqali Invasion
		[410791] = List(), -- Blazing Focus
		[409696] = List(), -- Molten Empowerment
		[408620] = List(), -- Scorching Roar
		[397383] = List(), -- Molten Barrier
		[409271] = List(), -- Magma Flow
		[409359] = List(), -- Desperate Immolation
		[406585] = List(), -- Ignara's Fury
		[411230] = List(), -- Ignara's Flame
	-- Rashok
		[401419] = List(), -- Siphon Energy
		[405091] = List(), -- Unyielding Rage
		[407706] = List(), -- Molten Wrath
		[403536] = List(), -- Lava Infusion
	-- Zskarn
		[404939] = List(), -- Searing Claws
		[409463] = List(), -- Reinforced
	-- Magmorax
		[404846] = List(), -- Incinerating Maws
		[402994] = List(), -- Molten Spittle
	-- Echo of Neltharion
		[404430] = List(), -- Wild Breath
		[403049] = List(), -- Shadow Barrier
		[404045] = List(), -- Annihilating Shadows
		[407088] = List(), -- Empowered Shadows
		[407039] = List(), -- Empower Shadows
	-- Scalecommander Sarkareth
		[404403] = List(), -- Desolate Blossom
		[404027] = List(), -- Void Bomb
	--]]
	---------------------------------------------------------
	------------ Amirdrassil: The Dream's Hope --------------
	---------------------------------------------------------
	-- Gnarlroot
		[421972] = List(), -- Controlled Burn
		--[424734] = List(), -- Uprooted Agony
		[426106] = List(), -- Dreadfire Barrage
		[425002] = List(), -- Ember-Charred I
		[421038] = List(), -- Ember-Charred II
	-- Igira the Cruel
		[414367] = List(), -- Gathering Torment
		[424065] = List(), -- Wracking Skewer I
		[416056] = List(), -- Wracking Skever II
		[414888] = List(), -- Blistering Spear
		[415624] = List(), -- Heart STopper
	-- Volcoross
		[419054] = List(), -- Molten Venom
		[421207] = List(), -- Coiling Flames
		[423494] = List(), -- Tidal Blaze
		[423759] = List(), -- Serpent's Crucible
	-- Council of Dreams
		[420948] = List(), -- Barreling Charge
		[421032] = List(), -- Captivating Finale
		[420858] = List(), -- Poisonous Javelin
		[418589] = List(), -- Polymorph Bomb
		[421031] = List(6), -- Song of the Dragon
		[426390] = List(), -- Corrosive Pollen
	-- Larodar, Keeper of the Flame
		[425888] = List(), -- Igniting Growth
		--[426249] = List(), -- Blazing Coalescence
		[421594] = List(), -- Smoldering Suffocation
		[427299] = List(), -- Flash Fire
		[428901] = List(), -- Ashen Devastation
	-- Nymue, Weaver of the Cycle
		--[423195] = List(), -- Inflorescence
		[427137] = List(), -- Threads of Life I
		[427138] = List(), -- Threads of Life II
		[426520] = List(), -- Weaver's Burden
		[427722] = List(), -- Weaver's Burden
		[428273] = List(), -- Woven Resonance
		[427721] = List(), -- Weavers Burden Dot
		--[425357] = List(), -- Surging Growth
		[420907] = List(), -- Viridian Rain
	-- Smolderon
		[426018] = List(), -- Seeking Inferno
		[421455] = List(), -- Overheated
		--[421643] = List(5), -- Emberscar's Mark
		[421656] = List(), -- Cauterizing Wound
		[425574] = List(), -- Lingering Burn
	-- Tindral Sageswift, Seer of the Flame
		[427297] = List(), -- Flame Surge
		[424581] = List(), -- Fiery Growth
		[424580] = List(), -- Falling Stars
		[424578] = List(), -- Blazing Mushroom
		[424579] = List(6), -- Suppressive Ember
		[424495] = List(), -- Mass Entanblement
		[424665] = List(), -- Seed of Flame
	-- Fyrakk the Blazing
}
