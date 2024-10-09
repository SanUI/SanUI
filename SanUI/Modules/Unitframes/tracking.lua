local _, addon = ...
local S,C = unpack(addon)

local Scale = S.Scale

if not S.UnitFrames then
	S.UnitFrames = {}
end

if not S["UnitFrames"].RaidBuffsTracking then
	S["UnitFrames"].RaidBuffsTracking = {}
end

-- Cornerbuffs:
-- .spellId The spells ID
-- .pos Table. The position, unpacked into arguments to SetPoint, relative inside the auras frame
-- .color The standard color to apply to the texture (leave nil for images, probably)
-- .anyCaster If truthy, show regardless of caster. If falsy, show only if the player was the caster
-- .cooldownAnim If truthy, show a cooldown sweep animation
-- .timers Array (table indexed by integers) of timers. A timer is a table of the form { time, { r, g, b} }, where the icon texture 
--         is colored by SetVertexColor(r, g, b) if the remaining duration of the buff is <time. The first one matching wins.
-- .count Table { size } where size is fontsize
S["UnitFrames"].RaidBuffsTracking["Druid"] = {
  -- Rejuvenation
	{
    spellId = 774,
    pos = {"CENTER", nil, "CENTER", -Scale(14), 0},
    color = {0.4, 0.8, 0.2},
    anyCaster = false,
    timers = { {2, {1, 0, 0}}, {4.5, {1, 1, 0}} },

  },
  -- Germination
	{
    spellId = 155777,
    pos = {"CENTER", nil, "CENTER", -Scale(14), -Scale(9)},
    color = {0.4, 0.8, 0.2},
    anyCaster = false,
    timers = { {2, {1, 0, 0}}, {4.5, {1, 1, 0}} }
  },
  -- Wild Growth
	{
    spellId = 48438,
    pos = {"CENTER", nil, "CENTER", -Scale(5), 0},
    color = {0, 1, 1},
    anyCaster = false,
    cooldownAnim = true
  },
  -- Regrowth
	{
    spellId = 8936,
    pos = {"CENTER", nil, "CENTER", Scale(3), 0},
    color = {0.4, 0.8, 0.2},
    anyCaster = false,
    timers = { {2, {1, 0, 0}}, {3.6, {1, 1, 0}} }
  },
	--[[ swiftmend -- SPECIAL DON'T CHANGE THIS (commenting out is ok)
	{
		spellId = 18562,
		pos = {"TOPLEFT",0,-Scale(7)},
		color = {1,1,1},
		anyCaster = false,
	}, 
	--]]
	-- adaptive swarm necro
	{
	  spellId = 325748,
    pos = {"CENTER", nil, "CENTER", Scale(12), 0},
    color = {153/255, 102/255, 0},
    anyCaster = false,
    count = { size = 9 },
		cooldownAnim = true

  },
  	-- adaptive swarm talent
	{
	  spellId = 391891,
    pos = {"LEFT", nil, "CENTER", Scale(12), 0},
    color = {153/255, 102/255, 0},
    anyCaster = false,
    count = { size = 9 },
		cooldownAnim = true

  },
}

S["UnitFrames"].RaidBuffsTracking["Priest"] = {
	{
		-- Atonement
		spellId = 194384,
		pos = {"TOP", nil, "TOP", 0, -2 },
		color = { 1, 1, 1},
		anyCaster = false,
		cooldownAnim = true,
	},
	{
		-- PWS
		spellId = 17,
		pos = {"TOP", nil, "TOP", 8, -2 },
		color = { 219/255, 163/255, 7/255},
		anyCaster = false,
		cooldownAnim = false,
	},
	{
		-- Renew
		spellId = 139,
		pos = {"CENTER", nil, "CENTER", 0, 0 },
		color = {0.4, 0.8, 0.2},
		anyCaster = false,
		timers = { {2, {1, 0, 0}}, {4.5, {1, 1, 0}} },
	},
}

if not S["UnitFrames"].TextAuras then
	S["UnitFrames"].TextAuras = {}
end

S["UnitFrames"].TextAuras["Druid"] = S["UnitFrames"].TextAuras["Druid"] or {}

table.insert(
	S["UnitFrames"].TextAuras["Druid"],
	{
		spellId = {33763, 33778, 43421, 188550, 290754, 186371},
		pos = {"TOP",0,1},
		textsize = 10,
		formatstr = "|cFF00FF00%u|r",
		timers = { { 2, "|cFFFF0000%.1f|r", 0.05}, { 4.5, "|cFFFFFF00%u|r", 0.3} },
		anyCaster = false,
	}
)

-- Defensive cooldowns: Simple list of spellIds
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
	[440313] = List(), -- Void Rift (Xal'atath's Bargain: Devour)
	----------------------------------------------------------
	---------------- The War Within Dungeons -----------------
	----------------------------------------------------------
	-- The Stonevault (Season 1)
	[427329] = List(), -- Void Corruption
	[435813] = List(), -- Void Empowerment
	[423572] = List(), -- Void Empowerment
	[424889] = List(), -- Seismic Reverberation
	[424795] = List(), -- Refracting Beam
	[457465] = List(), -- Entropy
	[425974] = List(), -- Ground Pound
	[445207] = List(), -- Piercing Wail
	[428887] = List(), -- Smashed
	[427382] = List(), -- Concussive Smash
	[449154] = List(), -- Molten Mortar
	[427361] = List(), -- Fracture
	[443494] = List(), -- Crystalline Eruption
	[424913] = List(), -- Volatile Explosion
	[443954] = List(), -- Exhaust Vents
	[426308] = List(), -- Void Infection
	[429999] = List(), -- Flaming Scrap
	[429545] = List(), -- Censoring Gear
	[428819] = List(), -- Exhaust Vents
-- City of Threads (Season 1)
	[434722] = List(), -- Subjugate
	[439341] = List(), -- Splice
	[440437] = List(), -- Shadow Shunpo
	[448561] = List(), -- Shadows of Doubt
	[440107] = List(), -- Knife Throw
	[439324] = List(), -- Umbral Weave
	[442285] = List(), -- Corrupted Coating
	[440238] = List(), -- Ice Sickles
	[461842] = List(), -- Oozing Smash
	[434926] = List(), -- Lingering Influence
	[440310] = List(), -- Chains of Oppression
	[439646] = List(), -- Process of Elimination
	[448562] = List(), -- Doubt
	[441391] = List(), -- Dark Paranoia
	[461989] = List(), -- Oozing Smash
	[441298] = List(), -- Freezing Blood
	[441286] = List(), -- Dark Paranoia
	[452151] = List(), -- Rigorous Jab
	[451239] = List(), -- Brutal Jab
	[443509] = List(), -- Ravenous Swarm
	[443437] = List(), -- Shadows of Doubt
	[451295] = List(), -- Void Rush
	[443427] = List(), -- Web Bolt
	[461630] = List(), -- Venomous Spray
	[445435] = List(), -- Black Blood
	[443401] = List(), -- Venom Strike
	[443430] = List(), -- Silk Binding
	[443438] = List(), -- Doubt
	[443435] = List(), -- Twist Thoughts
	[443432] = List(), -- Silk Binding
	[448047] = List(), -- Web Wrap
	[451426] = List(), -- Gossamer Barrage
	[446718] = List(), -- Umbral Weave
	[450055] = List(), -- Gutburst
	[450783] = List(), -- Perfume Toss
-- The Dawnbreaker (Season 1)
	--[463428] = List(), -- Lingering Erosion
	[426736] = List(), -- Shadow Shroud
	[434096] = List(), -- Sticky Webs
	[453173] = List(), -- Collapsing Night
	[426865] = List(), -- Dark Orb
	[434090] = List(), -- Spinneret's Strands
	[434579] = List(), -- Corrosion
	[426735] = List(), -- Burning Shadows
	[434576] = List(), -- Acidic Stupor
	[452127] = List(), -- Animate Shadows
	[438957] = List(), -- Acid Pools
	[434441] = List(), -- Rolling Acid
	[451119] = List(), -- Abyssal Blast
	[453345] = List(), -- Abyssal Rot
	[449332] = List(), -- Encroaching Shadows
	[431333] = List(), -- Tormenting Beam
	[431309] = List(), -- Ensnaring Shadows
	[451107] = List(), -- Bursting Cocoon
	[434406] = List(), -- Rolling Acid
	[431491] = List(), -- Tainted Slash
	[434113] = List(), -- Spinneret's Strands
	[431350] = List(), -- Tormenting Eruption
	[431365] = List(), -- Tormenting Ray
	[434668] = List(), -- Sparking Arathi Bomb
	[460135] = List(), -- Dark Scars
	[451098] = List(), -- Tacky Nova
	[450855] = List(), -- Dark Orb
	[431494] = List(), -- Black Edge
	[451115] = List(), -- Terrifying Slam
	[432448] = List(), -- Stygian Seed
-- Ara-Kara, City of Echoes (Season 1)
	[461487] = List(), -- Cultivated Poisons
	[432227] = List(), -- Venom Volley
	[432119] = List(), -- Faded
	[433740] = List(), -- Infestation
	[439200] = List(), -- Voracious Bite
	[433781] = List(), -- Ceaseless Swarm
	[432132] = List(), -- Erupting Webs
	[434252] = List(), -- Massive Slam
	[432031] = List(), -- Grasping Blood
	[438599] = List(), -- Bleeding Jab
	[438618] = List(), -- Venomous Spit
	[436401] = List(), -- AUGH!
	[434830] = List(), -- Vile Webbing
	[436322] = List(), -- Poison Bolt
	[434083] = List(), -- Ambush
	[433843] = List(), -- Erupting Webs
-- The Rookery (Season 2)
-- Priory of the Sacred Flame (Season 2)
-- Cinderbrew Meadery (Season 2)
-- Darkflame Cleft (Season 2)
----------------------------------------------------------
--------------- The War Within (Season 1) ----------------
----------------------------------------------------------
-- Mists of Tirna Scithe
	[325027] = List(), -- Bramble Burst
	[323043] = List(), -- Bloodletting
	[322557] = List(), -- Soul Split
	[331172] = List(), -- Mind Link
	[322563] = List(), -- Marked Prey
	[322487] = List(), -- Overgrowth 1
	[322486] = List(), -- Overgrowth 2
	[328756] = List(), -- Repulsive Visage
	[325021] = List(), -- Mistveil Tear
	[321891] = List(), -- Freeze Tag Fixation
	[325224] = List(), -- Anima Injection
	[326092] = List(), -- Debilitating Poison
	[325418] = List(), -- Volatile Acid
-- The Necrotic Wake
	[321821] = List(), -- Disgusting Guts
	[323365] = List(), -- Clinging Darkness
	[338353] = List(), -- Goresplatter
	[333485] = List(), -- Disease Cloud
	[338357] = List(), -- Tenderize
	[328181] = List(), -- Frigid Cold
	[320170] = List(), -- Necrotic Bolt
	[323464] = List(), -- Dark Ichor
	[323198] = List(), -- Dark Exile
	[343504] = List(), -- Dark Grasp
	[343556] = List(), -- Morbid Fixation 1
	[338606] = List(), -- Morbid Fixation 2
	[324381] = List(), -- Chill Scythe
	[320573] = List(), -- Shadow Well
	[333492] = List(), -- Necrotic Ichor
	[334748] = List(), -- Drain Fluids
	[333489] = List(), -- Necrotic Breath
	[320717] = List(), -- Blood Hunger
	[320200] = List(), -- Stitchneedle
	[320596] = List(), -- Heaving Retch
-- Siege of Boralus
	[257168] = List(), -- Cursed Slash
	[272588] = List(), -- Rotting Wounds
	[272571] = List(), -- Choking Waters
	[274991] = List(), -- Putrid Waters
	[275835] = List(), -- Stinging Venom Coating
	[273930] = List(), -- Hindering Cut
	[257292] = List(), -- Heavy Slash
	[261428] = List(), -- Hangman's Noose
	[256897] = List(), -- Clamping Jaws
	[272874] = List(), -- Trample
	[273470] = List(), -- Gut Shot
	[272834] = List(), -- Viscous Slobber
	[257169] = List(), -- Terrifying Roar
	[272713] = List(), -- Crushing Slam
	[454439] = List(), -- Azerite Charge
	[463182] = List(), -- Fiery Ricochet
-- Grim Batol
	[449885] = List(), -- Shadow Gale 1
	[461513] = List(), -- Shadow Gale 2
	[449474] = List(), -- Molten Spark
	[456773] = List(), -- Twilight Wind
	[448953] = List(), -- Rumbling Earth
	[447268] = List(), -- Skullsplitter
	[449536] = List(), -- Molten Pool
	[450095] = List(), -- Curse of Entropy
	[448057] = List(), -- Abyssal Corruption
	[451871] = List(), -- Mass Temor
	[451613] = List(), -- Twilight Flame
	[451378] = List(), -- Rive
	[76711] = List(), -- Sear Mind
	[462220] = List(), -- Blazing Shadowflame
	[451395] = List(), -- Corrupt
	[82850] = List(), -- Flaming Fixate
	[451241] = List(), -- Shadowflame Slash
	[451965] = List(), -- Molten Wake
	[451224] = List(), -- Enveloping Shadowflame
---------------------------------------------------------
------------------- Nerub'ar Palace ---------------------
---------------------------------------------------------
-- Ulgrax the Devourer
	[434705] = List(), -- Tenderized
	[435138] = List(), -- Digestive Acid
	[439037] = List(), -- Disembowel
	[439419] = List(), -- Stalker Netting
	[434778] = List(), -- Brutal Lashings
	[435136] = List(), -- Venomous Lash
	[438012] = List(), -- Hungering Bellows
-- The Bloodbound Horror
	--[442604] = List(), -- Goresplatter
	--[445570] = List(), -- Unseeming Blight
	[443612] = List(), -- Baneful Shift
	[443042] = List(), -- Grasp From Beyond
-- Sikran
	[435410] = List(), -- Phase Lunge
	[458277] = List(), -- Shattering Sweep
	[438845] = List(), -- Expose
	[433517] = List(), -- Phase Blades 1
	[434860] = List(), -- Phase Blades 2
	[459785] = List(), -- Cosmic Residue
	[459273] = List(), -- Cosmic Shards
-- Rasha'nan
	[439785] = List(), -- Corrosion
	[439786] = List(), -- Rolling Acid 1
	[439790] = List(), -- Rolling Acid 2
	[439787] = List(), -- Acidic Stupor
	[458067] = List(), -- Savage Wound
	[456170] = List(), -- Spinneret's Strands 1
	[439783] = List(), -- Spinneret's Strands 2
	[439780] = List(), -- Sticky Webs
	[439776] = List(), -- Acid Pool
	[455287] = List(), -- Infested Bite
-- Eggtender Ovi'nax
	[442257] = List(), -- Infest
	[442799] = List(), -- Sanguine Overflow
	[441362] = List(), -- Volatile Concotion
	[442660] = List(), -- Rupture
	[440421] = List(), -- Experimental Dosage
	[442250] = List(), -- Fixate
	[442437] = List(), -- Violent Discharge
	[443274] = List(), -- Reverberation
-- Nexus-Princess Ky'veza
	[440377] = List(), -- Void Shredders
	[436870] = List(), -- Assassination
	[440576] = List(), -- Chasmal Gash
	[437343] = List(), -- Queensbane
	[436664] = List(), -- Regicide 1
	[436666] = List(), -- Regicide 2
	[436671] = List(), -- Regicide 3
	[435535] = List(), -- Regicide 4
	[436665] = List(), -- Regicide 5
	[436663] = List(), -- Regicide 6
-- The Silken Court
	[450129] = List(), -- Entropic Desolation
	[449857] = List(), -- Impaled
	[438749] = List(), -- Scarab Fixation
	[438708] = List(), -- Stinging Swarm
	[438218] = List(), -- Piercing Strike
	[454311] = List(), -- Barbed Webs
	[438773] = List(), -- Shattered Shell
	[438355] = List(), -- Cataclysmic Entropy
	--[438656] = List(), -- Venomous Rain
	[441772] = List(), -- Void Bolt
	[441788] = List(), -- Web Vortex
	[440001] = List(), -- Binding Webs
-- Queen Ansurek
	-- TODO: No raid testing available for this boss
	-- [449960] = List(), for test, the carves at light's Blooming in Hallowfall do this
}
