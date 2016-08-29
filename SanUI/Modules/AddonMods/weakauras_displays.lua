local S = unpack(SanUI)

S.weakAuras = {
	["displays"] = {
		["Rip Ratio"] = {
			["textFlags"] = "None",
			["stacksSize"] = 12,
			["xOffset"] = 80,
			["displayText"] = "%c",
			["yOffset"] = -230,
			["anchorPoint"] = "CENTER",
			["borderColor"] = {
				1, -- [1]
				1, -- [2]
				1, -- [3]
				0.5, -- [4]
			},
			["rotateText"] = "NONE",
			["actions"] = {
				["start"] = {
					["do_custom"] = false,
					["custom"] = "",
				},
				["init"] = {
				},
				["finish"] = {
					["do_custom"] = false,
					["custom"] = "",
				},
			},
			["selfPoint"] = "CENTER",
			["barColor"] = {
				1, -- [1]
				0.725490196078431, -- [2]
				0, -- [3]
				1, -- [4]
			},
			["desaturate"] = false,
			["font"] = "2002",
			["load"] = {
				["class"] = {
					["single"] = "DRUID",
					["multi"] = {
						["DRUID"] = true,
					},
				},
				["use_never"] = false,
				["talent"] = {
					["multi"] = {
					},
				},
				["use_name"] = false,
				["spec"] = {
					["single"] = 2,
					["multi"] = {
						[2] = true,
					},
				},
				["use_zone"] = false,
				["use_spec"] = true,
				["use_class"] = true,
				["race"] = {
					["multi"] = {
					},
				},
				["name"] = "",
				["faction"] = {
					["multi"] = {
					},
				},
				["pvptalent"] = {
					["multi"] = {
					},
				},
				["role"] = {
					["multi"] = {
					},
				},
				["difficulty"] = {
					["multi"] = {
					},
				},
				["size"] = {
					["multi"] = {
					},
				},
			},
			["timerColor"] = {
				1, -- [1]
				1, -- [2]
				1, -- [3]
				1, -- [4]
			},
			["regionType"] = "text",
			["stacks"] = true,
			["texture"] = "DF Statusbar 3",
			["textFont"] = "Friz Quadrata TT",
			["borderOffset"] = 5,
			["auto"] = true,
			["timerFont"] = "Friz Quadrata TT",
			["alpha"] = 1,
			["borderInset"] = 11,
			["textColor"] = {
				1, -- [1]
				1, -- [2]
				1, -- [3]
				1, -- [4]
			},
			["outline"] = "OUTLINE",
			["borderBackdrop"] = "Blizzard Tooltip",
			["parent"] = "Feral Bleed Snapshots",
			["customText"] = "function()\n    Rip_sDamage = Rip_sDamage or {}\n    if Rip_sDamage[UnitGUID(\"target\")] then\n        local RatioPercent = floor(WA_stats_RipTick5/Rip_sDamage[UnitGUID(\"target\")]*100 + .5)\n        if RatioPercent >= 110 then\n            return format(\"|cFF00FF00%d|r\", RatioPercent+.01)\n        elseif RatioPercent <= 90 then\n            return format(\"|cFFFF0000%d|r\", RatioPercent+.01)\n        else\n            return format(\"|cFF999999%d|r\", RatioPercent+.01)\n        end        \n    else return ''\n    end\nend\n\n\n\n\n",
			["untrigger"] = {
				["custom"] = "function()\n    return false\nend",
			},
			["activeTriggerMode"] = 0,
			["customTextUpdate"] = "update",
			["displayTextLeft"] = " ",
			["animation"] = {
				["start"] = {
					["duration_type"] = "seconds",
					["type"] = "none",
				},
				["main"] = {
					["duration_type"] = "seconds",
					["type"] = "none",
				},
				["finish"] = {
					["duration_type"] = "seconds",
					["type"] = "none",
				},
			},
			["trigger"] = {
				["ownOnly"] = true,
				["names"] = {
					"Rip", -- [1]
				},
				["custom_hide"] = "custom",
				["type"] = "aura",
				["subeventPrefix"] = "SPELL",
				["custom_type"] = "status",
				["subeventSuffix"] = "_CAST_START",
				["spellIds"] = {
				},
				["event"] = "Chat Message",
				["customStacks"] = "\n\n",
				["customDuration"] = "",
				["customName"] = "",
				["events"] = "SPELL_AURA_APPLIED, SPELL_AURA_REFRESHED, SPELL_AURA_REMOVED",
				["debuffType"] = "HARMFUL",
				["check"] = "update",
				["custom"] = "function()\n    return true\nend",
				["unevent"] = "auto",
				["unit"] = "target",
			},
			["text"] = true,
			["stickyDuration"] = false,
			["timer"] = true,
			["timerFlags"] = "None",
			["backdropColor"] = {
				1, -- [1]
				1, -- [2]
				1, -- [3]
				0.5, -- [4]
			},
			["fontSize"] = 12,
			["border"] = false,
			["borderEdge"] = "None",
			["borderSize"] = 16,
			["icon_side"] = "RIGHT",
			["stacksFont"] = "Friz Quadrata TT",
			["disjunctive"] = "all",
			["icon"] = false,
			["textSize"] = 12,
			["timerSize"] = 12,
			["stacksColor"] = {
				1, -- [1]
				1, -- [2]
				1, -- [3]
				1, -- [4]
			},
			["justify"] = "CENTER",
			["inverse"] = false,
			["id"] = "Rip Ratio",
			["height"] = 11.9466772079468,
			["frameStrata"] = 5,
			["width"] = 6.82673835754395,
			["barInFront"] = true,
			["additional_triggers"] = {
			},
			["numTriggers"] = 1,
			["displayTextRight"] = " ",
			["orientation"] = "HORIZONTAL",
			["color"] = {
				1, -- [1]
				1, -- [2]
				1, -- [3]
				1, -- [4]
			},
			["stacksFlags"] = "None",
			["backgroundColor"] = {
				0.67843137254902, -- [1]
				0.67843137254902, -- [2]
				0.67843137254902, -- [3]
				1, -- [4]
			},
		},
		["Feral Stat Logic"] = {
			["textFlags"] = "None",
			["stacksSize"] = 13,
			["xOffset"] = 0,
			["displayText"] = "%c",
			["yOffset"] = 0,
			["anchorPoint"] = "CENTER",
			["borderColor"] = {
				1, -- [1]
				1, -- [2]
				1, -- [3]
				1, -- [4]
			},
			["rotateText"] = "NONE",
			["icon"] = true,
			["useTooltip"] = false,
			["selfPoint"] = "CENTER",
			["barColor"] = {
				0.345098039215686, -- [1]
				0.317647058823529, -- [2]
				0.749019607843137, -- [3]
				1, -- [4]
			},
			["desaturate"] = false,
			["progressPrecision"] = 1,
			["font"] = "Micron55",
			["load"] = {
				["class"] = {
					["single"] = "DRUID",
					["multi"] = {
					},
				},
				["use_never"] = false,
				["talent"] = {
					["multi"] = {
					},
				},
				["use_name"] = false,
				["spec"] = {
					["single"] = 2,
					["multi"] = {
						[2] = true,
					},
				},
				["role"] = {
					["multi"] = {
					},
				},
				["use_spec"] = true,
				["use_class"] = true,
				["race"] = {
					["multi"] = {
					},
				},
				["name"] = "",
				["faction"] = {
					["multi"] = {
					},
				},
				["pvptalent"] = {
					["multi"] = {
					},
				},
				["use_zone"] = false,
				["difficulty"] = {
					["multi"] = {
					},
				},
				["size"] = {
					["multi"] = {
						["party"] = true,
						["ten"] = true,
						["twentyfive"] = true,
						["arena"] = true,
						["pvp"] = true,
					},
				},
			},
			["timerColor"] = {
				1, -- [1]
				1, -- [2]
				1, -- [3]
				1, -- [4]
			},
			["regionType"] = "text",
			["stacks"] = false,
			["texture"] = "fer25",
			["textFont"] = "MARKEN",
			["borderOffset"] = 2,
			["auto"] = true,
			["timerFont"] = "MARKEN",
			["alpha"] = 1,
			["borderInset"] = 1,
			["displayIcon"] = "Interface\\Icons\\Ability_Druid_Berserk",
			["textColor"] = {
				1, -- [1]
				1, -- [2]
				1, -- [3]
				1, -- [4]
			},
			["outline"] = "OUTLINE",
			["borderBackdrop"] = "None",
			["color"] = {
				1, -- [1]
				1, -- [2]
				1, -- [3]
				1, -- [4]
			},
			["customText"] = "function()\n    if WA_calcStats_feral then\n        WA_calcStats_feral()\n    end\n    \n    return \"\"\nend\n\n\n\n\n\n\n\n\n",
			["barInFront"] = false,
			["activeTriggerMode"] = 0,
			["customTextUpdate"] = "update",
			["textSize"] = 8,
			["animation"] = {
				["start"] = {
					["duration_type"] = "seconds",
					["type"] = "none",
				},
				["main"] = {
					["duration_type"] = "seconds",
					["type"] = "none",
				},
				["finish"] = {
					["duration_type"] = "seconds",
					["type"] = "none",
				},
			},
			["trigger"] = {
				["autoclone"] = false,
				["spellId"] = "108381",
				["use_unit"] = true,
				["subeventPrefix"] = "SPELL",
				["custom_hide"] = "custom",
				["names"] = {
				},
				["type"] = "custom",
				["debuffType"] = "HELPFUL",
				["custom_type"] = "event",
				["countOperator"] = "~=",
				["spellIds"] = {
				},
				["event"] = "Chat Message",
				["custom"] = "function()\n    \n    local tf = GetSpellInfo(5217)\n    local sr = GetSpellInfo(52610)\n    local bt = GetSpellInfo(155672)\n    local inc = GetSpellInfo(102543)\n    local prowl = GetSpellInfo(5215)\n    local sm = GetSpellInfo(58984)\n    \n    function WA_calcStats_feral()\n        local DamageMult = 1 --select(7, UnitDamage(\"player\"))\n        \n        local CP = GetComboPoints(\"player\", \"target\")\n        if CP == 0 then CP = 5 end\n        \n        if UnitBuff(\"player\", tf) then\n            DamageMult = DamageMult * 1.15\n        end\n        \n        if UnitBuff(\"player\", sr) then\n            DamageMult = DamageMult * 1.4\n        end\n        \n        WA_stats_BTactive = WA_stats_BTactive or  0\n        if UnitBuff(\"player\", bt) then\n            WA_stats_BTactive = GetTime()\n            DamageMult = DamageMult * 1.3\n        elseif GetTime() - WA_stats_BTactive < .2 then\n            DamageMult = DamageMult * 1.3\n        end\n        \n        local RakeMult = 1\n        WA_stats_prowlactive = WA_stats_prowlactive or  0\n        if UnitBuff(\"player\", inc) then\n            RakeMult = 2\n        elseif UnitBuff(\"player\", prowl) or UnitBuff(\"player\", sm) then\n            WA_stats_prowlactive = GetTime()\n            RakeMult = 2\n        elseif GetTime() - WA_stats_prowlactive < .2 then\n            RakeMult = 2\n        end\n        \n        WA_stats_RipTick = CP*DamageMult\n        WA_stats_RipTick5 = 5*DamageMult\n        WA_stats_RakeTick = DamageMult*RakeMult\n        WA_stats_ThrashTick = DamageMult\n    end\n    \n    return true\nend",
				["name_operator"] = "==",
				["use_spellId"] = true,
				["count"] = "0",
				["events"] = "PLAYER_ENTERING_WORLD,ACTIVE_TALENT_GROUP_CHANGED,PLAYER_REGEN_DISABLED",
				["check"] = "event",
				["subeventSuffix"] = "_CAST_START",
				["unevent"] = "auto",
				["unit"] = "player",
			},
			["text"] = true,
			["stickyDuration"] = false,
			["timer"] = true,
			["timerFlags"] = "None",
			["backdropColor"] = {
				0, -- [1]
				0, -- [2]
				0, -- [3]
				1, -- [4]
			},
			["fontSize"] = 8,
			["border"] = true,
			["borderEdge"] = "fer09",
			["borderSize"] = 11,
			["icon_side"] = "LEFT",
			["parent"] = "Feral Bleed Snapshots",
			["untrigger"] = {
			},
			["stacksFont"] = "Emblem",
			["displayTextRight"] = "%p",
			["stacksColor"] = {
				1, -- [1]
				1, -- [2]
				1, -- [3]
				1, -- [4]
			},
			["justify"] = "CENTER",
			["actions"] = {
				["start"] = {
				},
				["init"] = {
				},
				["finish"] = {
				},
			},
			["additional_triggers"] = {
			},
			["numTriggers"] = 1,
			["frameStrata"] = 5,
			["width"] = 5.97339582443237,
			["timerSize"] = 8,
			["id"] = "Feral Stat Logic",
			["inverse"] = false,
			["height"] = 7.68008089065552,
			["orientation"] = "HORIZONTAL",
			["displayTextLeft"] = "Dream of Cenarius [%s]",
			["stacksFlags"] = "None",
			["backgroundColor"] = {
				0.203921568627451, -- [1]
				0.203921568627451, -- [2]
				0.203921568627451, -- [3]
				1, -- [4]
			},
		},
		["SanUI_TargetDebuffs"] = {
			["grow"] = "RIGHT",
			["controlledChildren"] = {
				"SanUI_Thrash", -- [1]
				"SanUI_Moonfire", -- [2]
			},
			["animate"] = false,
			["xOffset"] = 199.679946018324,
			["untrigger"] = {
			},
			["border"] = "None",
			["yOffset"] = -113.493018440225,
			["anchorPoint"] = "CENTER",
			["expanded"] = true,
			["sort"] = "none",
			["activeTriggerMode"] = 0,
			["space"] = 8,
			["background"] = "None",
			["actions"] = {
				["start"] = {
				},
				["finish"] = {
				},
			},
			["constantFactor"] = "RADIUS",
			["selfPoint"] = "LEFT",
			["borderOffset"] = 16,
			["align"] = "CENTER",
			["animation"] = {
				["start"] = {
					["duration_type"] = "seconds",
					["type"] = "none",
				},
				["main"] = {
					["duration_type"] = "seconds",
					["type"] = "none",
				},
				["finish"] = {
					["duration_type"] = "seconds",
					["type"] = "none",
				},
			},
			["trigger"] = {
				["type"] = "aura",
				["spellIds"] = {
				},
				["names"] = {
				},
				["debuffType"] = "HELPFUL",
				["unit"] = "player",
			},
			["backgroundInset"] = 0,
			["frameStrata"] = 1,
			["width"] = 88,
			["rotation"] = 0,
			["radius"] = 200,
			["numTriggers"] = 1,
			["stagger"] = 0,
			["height"] = 40,
			["id"] = "SanUI_TargetDebuffs",
			["load"] = {
				["talent"] = {
					["multi"] = {
					},
				},
				["spec"] = {
					["multi"] = {
					},
				},
				["difficulty"] = {
					["multi"] = {
					},
				},
				["role"] = {
					["multi"] = {
					},
				},
				["faction"] = {
					["multi"] = {
					},
				},
				["pvptalent"] = {
					["multi"] = {
					},
				},
				["race"] = {
					["multi"] = {
					},
				},
				["class"] = {
					["single"] = "DRUID",
					["multi"] = {
					},
				},
				["use_class"] = "true",
				["size"] = {
					["multi"] = {
					},
				},
			},
			["regionType"] = "dynamicgroup",
		},
		["ThrashCat Ratio"] = {
			["textFlags"] = "None",
			["stacksSize"] = 12,
			["xOffset"] = 176,
			["displayText"] = "%c",
			["yOffset"] = -11,
			["anchorPoint"] = "CENTER",
			["borderColor"] = {
				1, -- [1]
				1, -- [2]
				1, -- [3]
				0.5, -- [4]
			},
			["rotateText"] = "NONE",
			["actions"] = {
				["start"] = {
					["do_custom"] = false,
					["custom"] = "",
				},
				["init"] = {
				},
				["finish"] = {
					["do_custom"] = false,
					["custom"] = "",
				},
			},
			["selfPoint"] = "CENTER",
			["barColor"] = {
				1, -- [1]
				0.725490196078431, -- [2]
				0, -- [3]
				1, -- [4]
			},
			["desaturate"] = false,
			["font"] = "Micron55",
			["load"] = {
				["class"] = {
					["single"] = "DRUID",
					["multi"] = {
						["DRUID"] = true,
					},
				},
				["use_never"] = true,
				["talent"] = {
					["multi"] = {
					},
				},
				["use_name"] = false,
				["spec"] = {
					["single"] = 2,
					["multi"] = {
						[2] = true,
					},
				},
				["role"] = {
					["multi"] = {
					},
				},
				["use_spec"] = true,
				["use_class"] = true,
				["race"] = {
					["multi"] = {
					},
				},
				["name"] = "",
				["faction"] = {
					["multi"] = {
					},
				},
				["pvptalent"] = {
					["multi"] = {
					},
				},
				["use_zone"] = false,
				["difficulty"] = {
					["multi"] = {
					},
				},
				["size"] = {
					["multi"] = {
					},
				},
			},
			["timerColor"] = {
				1, -- [1]
				1, -- [2]
				1, -- [3]
				1, -- [4]
			},
			["regionType"] = "text",
			["stacks"] = true,
			["texture"] = "DF Statusbar 3",
			["textFont"] = "Friz Quadrata TT",
			["stacksFont"] = "Friz Quadrata TT",
			["auto"] = true,
			["timerFont"] = "Friz Quadrata TT",
			["alpha"] = 1,
			["borderInset"] = 11,
			["textColor"] = {
				1, -- [1]
				1, -- [2]
				1, -- [3]
				1, -- [4]
			},
			["outline"] = "OUTLINE",
			["borderBackdrop"] = "Blizzard Tooltip",
			["color"] = {
				1, -- [1]
				1, -- [2]
				1, -- [3]
				1, -- [4]
			},
			["customText"] = "function()\n    Thrash_sDamage = Thrash_sDamage or {}\n    if Thrash_sDamage[UnitGUID(\"target\")] then\n        local RatioPercent = floor(WA_stats_ThrashTick/Thrash_sDamage[UnitGUID(\"target\")]*100 + .5)\n        if RatioPercent >= 110 then\n            return format(\"|cFF00FF00%d|r\", RatioPercent)\n        elseif RatioPercent <= 90 then\n            return format(\"|cFFFF0000%d|r\", RatioPercent)\n        else\n            return format(\"|cFF999999%d|r\", RatioPercent)\n        end        \n    else return ''\n    end\nend\n\n\n\n\n",
			["barInFront"] = true,
			["activeTriggerMode"] = 0,
			["customTextUpdate"] = "update",
			["textSize"] = 12,
			["animation"] = {
				["start"] = {
					["duration_type"] = "seconds",
					["type"] = "none",
				},
				["main"] = {
					["duration_type"] = "seconds",
					["type"] = "none",
				},
				["finish"] = {
					["duration_type"] = "seconds",
					["type"] = "none",
				},
			},
			["trigger"] = {
				["spellId"] = "106830",
				["ownOnly"] = true,
				["names"] = {
					"Thrash", -- [1]
				},
				["unit"] = "target",
				["debuffType"] = "HARMFUL",
				["custom_hide"] = "custom",
				["name_operator"] = "==",
				["type"] = "aura",
				["events"] = "SPELL_AURA_APPLIED, SPELL_AURA_REFRESHED, SPELL_AURA_REMOVED",
				["subeventSuffix"] = "_CAST_START",
				["use_spellId"] = true,
				["spellIds"] = {
				},
				["event"] = "Chat Message",
				["customStacks"] = "\n\n",
				["customDuration"] = "",
				["customName"] = "",
				["custom"] = "function()\n    if WA_thrashc then return true end\nend",
				["name"] = "Thrash",
				["check"] = "update",
				["unevent"] = "auto",
				["custom_type"] = "status",
				["subeventPrefix"] = "SPELL",
			},
			["text"] = true,
			["stickyDuration"] = false,
			["timer"] = true,
			["timerFlags"] = "None",
			["backdropColor"] = {
				1, -- [1]
				1, -- [2]
				1, -- [3]
				0.5, -- [4]
			},
			["fontSize"] = 8,
			["border"] = false,
			["borderEdge"] = "None",
			["borderSize"] = 16,
			["icon_side"] = "RIGHT",
			["borderOffset"] = 5,
			["displayTextLeft"] = " ",
			["backgroundColor"] = {
				0.67843137254902, -- [1]
				0.67843137254902, -- [2]
				0.67843137254902, -- [3]
				1, -- [4]
			},
			["justify"] = "CENTER",
			["additional_triggers"] = {
			},
			["stacksColor"] = {
				1, -- [1]
				1, -- [2]
				1, -- [3]
				1, -- [4]
			},
			["timerSize"] = 12,
			["numTriggers"] = 1,
			["id"] = "ThrashCat Ratio",
			["parent"] = "Feral Bleed Snapshots",
			["frameStrata"] = 5,
			["width"] = 5.97316598892212,
			["untrigger"] = {
				["custom"] = "function()\n    if not WA_thrashc then return true end\nend",
			},
			["height"] = 7.68008089065552,
			["inverse"] = false,
			["displayTextRight"] = " ",
			["orientation"] = "HORIZONTAL",
			["icon"] = false,
			["stacksFlags"] = "None",
			["disjunctive"] = "all",
		},
		["SanUI_Moonfire"] = {
			["xOffset"] = 19.9999942779541,
			["yOffset"] = 0,
			["anchorPoint"] = "CENTER",
			["activeTriggerMode"] = 0,
			["customTextUpdate"] = "update",
			["actions"] = {
				["start"] = {
				},
				["init"] = {
				},
				["finish"] = {
				},
			},
			["fontFlags"] = "OUTLINE",
			["animation"] = {
				["start"] = {
					["duration_type"] = "seconds",
					["type"] = "none",
				},
				["main"] = {
					["duration_type"] = "seconds",
					["type"] = "none",
				},
				["finish"] = {
					["duration_type"] = "seconds",
					["type"] = "none",
				},
			},
			["trigger"] = {
				["type"] = "aura",
				["subeventSuffix"] = "_CAST_START",
				["ownOnly"] = true,
				["event"] = "Health",
				["unit"] = "target",
				["spellIds"] = {
					8921, -- [1]
				},
				["custom_hide"] = "timed",
				["names"] = {
					"Moonfire", -- [1]
				},
				["subeventPrefix"] = "SPELL",
				["debuffType"] = "HARMFUL",
			},
			["desaturate"] = false,
			["font"] = "Friz Quadrata TT",
			["height"] = 40,
			["load"] = {
				["talent"] = {
					["multi"] = {
					},
				},
				["spec"] = {
					["single"] = 1,
					["multi"] = {
						true, -- [1]
					},
				},
				["use_class"] = true,
				["difficulty"] = {
					["multi"] = {
					},
				},
				["role"] = {
					["multi"] = {
					},
				},
				["use_name"] = false,
				["faction"] = {
					["multi"] = {
					},
				},
				["class"] = {
					["single"] = "DRUID",
					["multi"] = {
					},
				},
				["pvptalent"] = {
					["multi"] = {
					},
				},
				["race"] = {
					["multi"] = {
					},
				},
				["size"] = {
					["multi"] = {
					},
				},
			},
			["fontSize"] = 12,
			["displayStacks"] = "%c",
			["regionType"] = "icon",
			["init_completed"] = 1,
			["color"] = {
				1, -- [1]
				1, -- [2]
				1, -- [3]
				1, -- [4]
			},
			["stacksContainment"] = "INSIDE",
			["zoom"] = 0.3,
			["auto"] = true,
			["cooldown"] = true,
			["id"] = "SanUI_Moonfire",
			["stickyDuration"] = false,
			["frameStrata"] = 1,
			["width"] = 39.9999885559082,
			["selfPoint"] = "CENTER",
			["numTriggers"] = 1,
			["inverse"] = false,
			["untrigger"] = {
			},
			["parent"] = "SanUI_TargetDebuffs",
			["icon"] = true,
			["stacksPoint"] = "BOTTOMRIGHT",
			["textColor"] = {
				1, -- [1]
				1, -- [2]
				1, -- [3]
				1, -- [4]
			},
		},
		["Rake Ratio"] = {
			["textFlags"] = "None",
			["stacksSize"] = 12,
			["xOffset"] = -80,
			["stacksFlags"] = "None",
			["yOffset"] = -230,
			["anchorPoint"] = "CENTER",
			["borderColor"] = {
				1, -- [1]
				1, -- [2]
				1, -- [3]
				0.5, -- [4]
			},
			["rotateText"] = "NONE",
			["backgroundColor"] = {
				0.67843137254902, -- [1]
				0.67843137254902, -- [2]
				0.67843137254902, -- [3]
				1, -- [4]
			},
			["selfPoint"] = "CENTER",
			["barColor"] = {
				1, -- [1]
				0.725490196078431, -- [2]
				0, -- [3]
				1, -- [4]
			},
			["desaturate"] = false,
			["font"] = "2002",
			["load"] = {
				["class"] = {
					["single"] = "DRUID",
					["multi"] = {
						["DRUID"] = true,
					},
				},
				["use_never"] = false,
				["talent"] = {
					["multi"] = {
					},
				},
				["use_name"] = false,
				["spec"] = {
					["single"] = 2,
					["multi"] = {
						[2] = true,
					},
				},
				["use_zone"] = false,
				["use_spec"] = true,
				["use_class"] = true,
				["race"] = {
					["multi"] = {
					},
				},
				["name"] = "",
				["faction"] = {
					["multi"] = {
					},
				},
				["pvptalent"] = {
					["multi"] = {
					},
				},
				["role"] = {
					["multi"] = {
					},
				},
				["difficulty"] = {
					["multi"] = {
					},
				},
				["size"] = {
					["multi"] = {
					},
				},
			},
			["timerColor"] = {
				1, -- [1]
				1, -- [2]
				1, -- [3]
				1, -- [4]
			},
			["regionType"] = "text",
			["stacks"] = true,
			["texture"] = "DF Statusbar 3",
			["textFont"] = "Friz Quadrata TT",
			["stacksFont"] = "Friz Quadrata TT",
			["auto"] = true,
			["timerFont"] = "Friz Quadrata TT",
			["alpha"] = 1,
			["borderInset"] = 11,
			["textColor"] = {
				1, -- [1]
				1, -- [2]
				1, -- [3]
				1, -- [4]
			},
			["outline"] = "OUTLINE",
			["borderBackdrop"] = "Blizzard Tooltip",
			["parent"] = "Feral Bleed Snapshots",
			["customText"] = "function()\n    Rake_sDamage = Rake_sDamage or {}\n    if Rake_sDamage[UnitGUID(\"target\")] then\n        local RatioPercent = floor(WA_stats_RakeTick/Rake_sDamage[UnitGUID(\"target\")]*100 + .5)\n        if RatioPercent >= 110 then\n            return format(\"|cFF00FF00%d|r\", RatioPercent)\n        elseif RatioPercent <= 90 then\n            return format(\"|cFFFF0000%d|r\", RatioPercent)\n        else\n            return format(\"|cFF999999%d|r\", RatioPercent)\n        end\n    else return ''\n    end\nend",
			["barInFront"] = true,
			["activeTriggerMode"] = 0,
			["customTextUpdate"] = "update",
			["displayTextLeft"] = " ",
			["animation"] = {
				["start"] = {
					["duration_type"] = "seconds",
					["type"] = "none",
				},
				["main"] = {
					["duration_type"] = "seconds",
					["type"] = "none",
				},
				["finish"] = {
					["duration_type"] = "seconds",
					["type"] = "none",
				},
			},
			["trigger"] = {
				["spellId"] = "155722",
				["ownOnly"] = true,
				["names"] = {
					"Rake", -- [1]
				},
				["unit"] = "target",
				["debuffType"] = "HARMFUL",
				["custom_hide"] = "custom",
				["name_operator"] = "==",
				["type"] = "aura",
				["events"] = "SPELL_AURA_APPLIED, SPELL_AURA_REFRESHED, SPELL_AURA_REMOVED",
				["subeventSuffix"] = "_CAST_START",
				["use_spellId"] = true,
				["spellIds"] = {
				},
				["event"] = "Chat Message",
				["customStacks"] = "\n\n",
				["customDuration"] = "",
				["customName"] = "",
				["custom"] = "function()\n    if WA_rake then return true end\nend",
				["name"] = "Rake",
				["check"] = "update",
				["custom_type"] = "status",
				["unevent"] = "auto",
				["subeventPrefix"] = "SPELL",
			},
			["text"] = true,
			["stickyDuration"] = false,
			["height"] = 11.9466772079468,
			["timerFlags"] = "None",
			["backdropColor"] = {
				1, -- [1]
				1, -- [2]
				1, -- [3]
				0.5, -- [4]
			},
			["fontSize"] = 12,
			["border"] = false,
			["borderEdge"] = "None",
			["borderSize"] = 16,
			["icon_side"] = "RIGHT",
			["borderOffset"] = 5,
			["disjunctive"] = "all",
			["actions"] = {
				["start"] = {
					["do_custom"] = false,
					["custom"] = "",
				},
				["init"] = {
				},
				["finish"] = {
					["do_custom"] = false,
					["custom"] = "\n\n",
				},
			},
			["textSize"] = 12,
			["timerSize"] = 12,
			["stacksColor"] = {
				1, -- [1]
				1, -- [2]
				1, -- [3]
				1, -- [4]
			},
			["displayTextRight"] = " ",
			["numTriggers"] = 1,
			["additional_triggers"] = {
			},
			["timer"] = true,
			["frameStrata"] = 5,
			["width"] = 6.82673835754395,
			["untrigger"] = {
				["custom"] = "function()\n    if not WA_rake then return true end\nend",
			},
			["id"] = "Rake Ratio",
			["inverse"] = false,
			["justify"] = "CENTER",
			["orientation"] = "HORIZONTAL",
			["color"] = {
				1, -- [1]
				1, -- [2]
				1, -- [3]
				1, -- [4]
			},
			["displayText"] = "%c",
			["icon"] = false,
		},
		["SanUI_Thrash"] = {
			["xOffset"] = 224.266584007226,
			["yOffset"] = -103.253054428009,
			["anchorPoint"] = "CENTER",
			["activeTriggerMode"] = 0,
			["customTextUpdate"] = "update",
			["actions"] = {
				["start"] = {
				},
				["init"] = {
				},
				["finish"] = {
				},
			},
			["fontFlags"] = "OUTLINE",
			["animation"] = {
				["start"] = {
					["duration_type"] = "seconds",
					["type"] = "none",
				},
				["main"] = {
					["duration_type"] = "seconds",
					["type"] = "none",
				},
				["finish"] = {
					["duration_type"] = "seconds",
					["type"] = "none",
				},
			},
			["trigger"] = {
				["type"] = "aura",
				["subeventSuffix"] = "_CAST_START",
				["ownOnly"] = true,
				["event"] = "Health",
				["names"] = {
					"Thrash", -- [1]
				},
				["spellIds"] = {
					106832, -- [1]
				},
				["debuffType"] = "HARMFUL",
				["subeventPrefix"] = "SPELL",
				["unit"] = "target",
				["custom_hide"] = "timed",
			},
			["stickyDuration"] = false,
			["font"] = "Friz Quadrata TT",
			["height"] = 40,
			["load"] = {
				["talent"] = {
					["multi"] = {
					},
				},
				["spec"] = {
					["single"] = 3,
					["multi"] = {
					},
				},
				["use_name"] = false,
				["difficulty"] = {
					["multi"] = {
					},
				},
				["use_class"] = true,
				["role"] = {
					["multi"] = {
					},
				},
				["use_spec"] = true,
				["faction"] = {
					["multi"] = {
					},
				},
				["class"] = {
					["single"] = "DRUID",
					["multi"] = {
					},
				},
				["pvptalent"] = {
					["multi"] = {
					},
				},
				["race"] = {
					["multi"] = {
					},
				},
				["size"] = {
					["multi"] = {
					},
				},
			},
			["fontSize"] = 19,
			["displayStacks"] = "     %s",
			["regionType"] = "icon",
			["init_completed"] = 1,
			["color"] = {
				1, -- [1]
				1, -- [2]
				1, -- [3]
				1, -- [4]
			},
			["stacksContainment"] = "INSIDE",
			["zoom"] = 0.3,
			["auto"] = true,
			["cooldown"] = true,
			["id"] = "SanUI_Thrash",
			["desaturate"] = false,
			["frameStrata"] = 1,
			["width"] = 39.9999885559082,
			["selfPoint"] = "CENTER",
			["numTriggers"] = 1,
			["inverse"] = false,
			["untrigger"] = {
			},
			["parent"] = "SanUI_TargetDebuffs",
			["icon"] = true,
			["stacksPoint"] = "BOTTOM",
			["textColor"] = {
				1, -- [1]
				1, -- [2]
				1, -- [3]
				1, -- [4]
			},
		},
		["Feral Snapshot Logic"] = {
			["user_y"] = 0,
			["user_x"] = -0.0200000107288361,
			["color"] = {
				1, -- [1]
				1, -- [2]
				1, -- [3]
				1, -- [4]
			},
			["displayText"] = "",
			["untrigger"] = {
				["custom"] = "",
			},
			["foregroundColor"] = {
				1, -- [1]
				0.0549019607843137, -- [2]
				0.0549019607843137, -- [3]
				1, -- [4]
			},
			["desaturateBackground"] = false,
			["activeTriggerMode"] = 0,
			["sameTexture"] = false,
			["desaturateForeground"] = false,
			["actions"] = {
				["start"] = {
				},
				["init"] = {
				},
				["finish"] = {
					["do_custom"] = false,
				},
			},
			["backgroundOffset"] = 2,
			["backgroundColor"] = {
				0.101960784313726, -- [1]
				0.101960784313726, -- [2]
				0.101960784313726, -- [3]
				1, -- [4]
			},
			["selfPoint"] = "CENTER",
			["trigger"] = {
				["type"] = "custom",
				["debuffType"] = "HELPFUL",
				["unevent"] = "auto",
				["subeventPrefix"] = "SPELL",
				["names"] = {
				},
				["event"] = "Health",
				["use_unit"] = true,
				["unit"] = "player",
				["spellIds"] = {
				},
				["events"] = "COMBAT_LOG_EVENT_UNFILTERED,PLAYER_REGEN_ENABLED,PLAYER_ENTERING_WORLD,PLAYER_ALIVE",
				["custom"] = "function (event, _, param, _, source, ...)\n    Rip_sDamage = Rip_sDamage or {}\n    Rake_sDamage = Rake_sDamage or {}\n    Thrash_sDamage = Thrash_sDamage or {}\n    \n    if event == \"COMBAT_LOG_EVENT_UNFILTERED\" and source == UnitGUID(\"player\") then\n        local _, _, _, destination, _, _, _, spell = ...\n        \n        -- snapshot on spellcast\n        if spell == 1079 and param == \"SPELL_CAST_SUCCESS\" then\n            WA_calcStats_feral()\n            Rip_sDamage_cast = WA_stats_RipTick\n        elseif spell == 1822 and (param == \"SPELL_CAST_SUCCESS\" or param == \"SPELL_DAMAGE\" or param == \"SPELL_MISSED\") then\n            WA_calcStats_feral()\n            Rake_sDamage_cast = WA_stats_RakeTick\n        elseif spell == 106830 and param == \"SPELL_CAST_SUCCESS\" then\n            WA_calcStats_feral()\n            Thrash_sDamage_cast = WA_stats_ThrashTick\n        end\n        \n        -- but only record the snapshot if it successfully applied\n        if spell == 1079 and (param == \"SPELL_AURA_APPLIED\" or param == \"SPELL_AURA_REFRESH\") then\n            Rip_sDamage[destination] = Rip_sDamage_cast\n        elseif spell == 155722 and (param == \"SPELL_AURA_APPLIED\" or param == \"SPELL_AURA_REFRESH\") then\n            Rake_sDamage[destination] = Rake_sDamage_cast\n        elseif spell == 106830 and (param == \"SPELL_AURA_APPLIED\" or param == \"SPELL_AURA_REFRESH\") then\n            Thrash_sDamage[destination] = Thrash_sDamage_cast\n        end\n        \n        -- clean up out of combat\n    elseif (not UnitAffectingCombat(\"player\")) and (not IsEncounterInProgress()) then\n        Rip_sDamage = {}\n        Rake_sDamage = {}\n        Thrash_sDamage = {}\n    end\nend",
				["check"] = "event",
				["subeventSuffix"] = "_CAST_START",
				["custom_type"] = "event",
				["custom_hide"] = "custom",
			},
			["displayIcon"] = "Interface\\Icons\\",
			["yOffset"] = 0,
			["desaturate"] = false,
			["discrete_rotation"] = 0,
			["font"] = "Friz Quadrata TT",
			["outline"] = "OUTLINE",
			["numTriggers"] = 1,
			["height"] = 0.999942064285278,
			["rotate"] = true,
			["load"] = {
				["class"] = {
					["single"] = "DRUID",
					["multi"] = {
					},
				},
				["use_never"] = false,
				["talent"] = {
					["multi"] = {
					},
				},
				["use_name"] = false,
				["spec"] = {
					["single"] = 2,
					["multi"] = {
						[2] = true,
					},
				},
				["role"] = {
					["multi"] = {
					},
				},
				["use_spec"] = true,
				["use_class"] = true,
				["race"] = {
					["multi"] = {
					},
				},
				["name"] = "",
				["faction"] = {
					["multi"] = {
					},
				},
				["pvptalent"] = {
					["multi"] = {
					},
				},
				["use_zone"] = false,
				["difficulty"] = {
					["multi"] = {
					},
				},
				["size"] = {
					["multi"] = {
					},
				},
			},
			["stickyDuration"] = false,
			["animation"] = {
				["start"] = {
					["duration_type"] = "seconds",
					["type"] = "none",
				},
				["main"] = {
					["duration_type"] = "seconds",
					["type"] = "none",
				},
				["finish"] = {
					["duration_type"] = "seconds",
					["type"] = "none",
				},
			},
			["backgroundTexture"] = "Interface\\AddOns\\WeakAuras\\Media\\Textures\\Square_White_Border",
			["displayStacks"] = "%s",
			["foregroundTexture"] = "Interface\\AddOns\\WeakAuras\\Media\\Textures\\Square_White",
			["anchorPoint"] = "CENTER",
			["alpha"] = 1,
			["mirror"] = false,
			["fontSize"] = 12,
			["regionType"] = "text",
			["id"] = "Feral Snapshot Logic",
			["blendMode"] = "BLEND",
			["crop_y"] = 0,
			["justify"] = "LEFT",
			["icon"] = true,
			["texture"] = "Interface\\AddOns\\WeakAuras\\Media\\Textures\\Square_White_Border",
			["stacksContainment"] = "INSIDE",
			["zoom"] = 0,
			["auto"] = true,
			["compress"] = false,
			["additional_triggers"] = {
			},
			["customTextUpdate"] = "update",
			["frameStrata"] = 5,
			["width"] = 0.999942064285278,
			["xOffset"] = 0,
			["parent"] = "Feral Bleed Snapshots",
			["inverse"] = false,
			["rotation"] = 0,
			["orientation"] = "HORIZONTAL",
			["crop_x"] = 0.459999978542328,
			["stacksPoint"] = "BOTTOMRIGHT",
			["textColor"] = {
				1, -- [1]
				1, -- [2]
				1, -- [3]
				1, -- [4]
			},
		},
		["Feral Bleed Snapshots"] = {
			["backdropColor"] = {
				1, -- [1]
				1, -- [2]
				1, -- [3]
				0.5, -- [4]
			},
			["controlledChildren"] = {
				"Feral Stat Logic", -- [1]
				"Feral Snapshot Logic", -- [2]
				"Rake Ratio", -- [3]
				"Rip Ratio", -- [4]
				"ThrashCat Ratio", -- [5]
			},
			["borderBackdrop"] = "Blizzard Tooltip",
			["xOffset"] = 0,
			["border"] = false,
			["yOffset"] = 0,
			["regionType"] = "group",
			["borderSize"] = 16,
			["borderColor"] = {
				1, -- [1]
				1, -- [2]
				1, -- [3]
				0.5, -- [4]
			},
			["expanded"] = true,
			["borderOffset"] = 5,
			["untrigger"] = {
			},
			["selfPoint"] = "BOTTOMLEFT",
			["id"] = "Feral Bleed Snapshots",
			["anchorPoint"] = "CENTER",
			["frameStrata"] = 1,
			["borderEdge"] = "None",
			["trigger"] = {
				["subeventPrefix"] = "SPELL",
				["type"] = "aura",
				["spellIds"] = {
				},
				["subeventSuffix"] = "_CAST_START",
				["debuffType"] = "HELPFUL",
				["names"] = {
				},
				["event"] = "Health",
				["unit"] = "player",
			},
			["borderInset"] = 11,
			["numTriggers"] = 1,
			["animation"] = {
				["start"] = {
					["duration_type"] = "seconds",
					["type"] = "none",
				},
				["main"] = {
					["duration_type"] = "seconds",
					["type"] = "none",
				},
				["finish"] = {
					["duration_type"] = "seconds",
					["type"] = "none",
				},
			},
			["actions"] = {
				["start"] = {
				},
				["finish"] = {
				},
			},
			["additional_triggers"] = {
			},
			["load"] = {
				["talent"] = {
					["multi"] = {
					},
				},
				["spec"] = {
					["multi"] = {
					},
				},
				["difficulty"] = {
					["multi"] = {
					},
				},
				["role"] = {
					["multi"] = {
					},
				},
				["faction"] = {
					["multi"] = {
					},
				},
				["pvptalent"] = {
					["multi"] = {
					},
				},
				["race"] = {
					["multi"] = {
					},
				},
				["class"] = {
					["single"] = "DRUID",
					["multi"] = {
					},
				},
				["use_class"] = "true",
				["size"] = {
					["multi"] = {
					},
				},
			},
			["activeTriggerMode"] = 0,
		},
	},
}
