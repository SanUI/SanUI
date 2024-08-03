local _, addon = ...
local S,C = unpack(addon)

local font = C.medias.fonts.Font
local fontsize = C.sizes.datatextfontsize

local format = format

local TankString = TANK
local HealerString = HEALER
local DPSString = DAMAGE
local Result = " %s %s %s"

local MakeString = function(tank, healer, damage, letter)
	local strtank = ""
	local strheal = ""
	local strdps = ""

	if tank then
		if letter then
			strtank = "T"
		else
			strtank = TankString
		end
	end

	if healer then
		if letter then
			strheal = "H"
		else
			strheal = HealerString
		end
	end

	if damage then
		if letter then
			strdps = "D"
		else
			strdps = DPSString
		end
	end

	return format(Result, strtank, strheal, strdps)
end

S.createCalltoarmsDT = function(frame)
	frame:RegisterEvent("LFG_UPDATE_RANDOM_INFO")
	frame:RegisterEvent("PLAYER_ENTERING_WORLD")

	local text = frame:CreateFontString(nil, "OVERLAY")
	text:SetPoint("CENTER", frame, "CENTER", 0, -S.scale1)
	text:SetJustifyH("CENTER")
	text:SetJustifyV("MIDDLE")
	text:SetFont(font, fontsize)

	frame.Text = text

	text:SetScript("OnMouseDown", function()
		if InCombatLockdown() then
			print("In combat - not opening LFD frame")
			return
		end

		PVEFrame_ToggleFrame()
	end)

	local update = function(event)
		local TankReward = false
		local HealerReward = false
		local DPSReward = false
		local Unavailable = true

		--Dungeons
		for i = 1, GetNumRandomDungeons() do
			local ID = GetLFGRandomDungeonInfo(i)

			for x = 1,LFG_ROLE_NUM_SHORTAGE_TYPES do
				local Eligible, ForTank, ForHealer, ForDamage, ItemCount = GetLFGRoleShortageRewards(ID, x)

				if Eligible then Unavailable = false end
				if Eligible and ForTank and ItemCount > 0 then TankReward = true end
				if Eligible and ForHealer and ItemCount > 0 then HealerReward = true end
				if Eligible and ForDamage and ItemCount > 0 then DPSReward = true end
			end
		end

		--LFR
		for i = 1, GetNumRFDungeons() do
			local ID = GetRFDungeonInfo(i)

			for x = 1,LFG_ROLE_NUM_SHORTAGE_TYPES do
				local Eligible, ForTank, ForHealer, ForDamage, ItemCount = GetLFGRoleShortageRewards(ID, x)

				if Eligible then Unavailable = false end
				if Eligible and ForTank and ItemCount > 0 then TankReward = true end
				if Eligible and ForHealer and ItemCount > 0 then HealerReward = true end
				if Eligible and ForDamage and ItemCount > 0 then DPSReward = true end
			end
		end

		if Unavailable then
			text:SetText("CtA NA")
		else
			if (TankReward or HealerReward or DPSReward) then
				text:SetText("CtA: "..MakeString(TankReward, HealerReward, DPSReward, true))
			else
				text:SetText("No CtA")
			end
		end
	end

	local OnEnter = function(self)
		update()
		GameTooltip:SetOwner(ChatFrame1Tab or frame, "ANCHOR_TOPLEFT")
		GameTooltip:ClearLines()
		GameTooltip:AddLine("Call to Arms")
		GameTooltip:AddLine(" ")

		local AllUnavailable = true
		local NumCTA = 0

		for i = 1, GetNumRandomDungeons() do
			local ID, Name = GetLFGRandomDungeonInfo(i)
			local TankReward = false
			local HealerReward = false
			local DPSReward = false
			local Unavailable = true

			for x = 1, LFG_ROLE_NUM_SHORTAGE_TYPES do
				local Eligible, ForTank, ForHealer, ForDamage, ItemCount = GetLFGRoleShortageRewards(ID, x)
				if Eligible then Unavailable = false end
				if Eligible and ForTank and ItemCount > 0 then TankReward = true end
				if Eligible and ForHealer and ItemCount > 0 then HealerReward = true end
				if Eligible and ForDamage and ItemCount > 0 then DPSReward = true end
			end

			if (not Unavailable) then
				AllUnavailable = false
				local RolesString = MakeString(TankReward, HealerReward, DPSReward)

				if (RolesString ~= "   ")  then
					GameTooltip:AddDoubleLine(Name .. ":", RolesString, 1, 1, 1)
				end

				if (TankReward or HealerReward or DPSReward) then
					NumCTA = NumCTA + 1
				end
			end
		end

		for i = 1, GetNumRFDungeons() do
			local ID, Name = GetRFDungeonInfo(i)
			local TankReward = false
			local HealerReward = false
			local DPSReward = false
			local Unavailable = true

			for x = 1, LFG_ROLE_NUM_SHORTAGE_TYPES do
				local Eligible, ForTank, ForHealer, ForDamage, ItemCount = GetLFGRoleShortageRewards(ID, x)
				if Eligible then Unavailable = false end
				if Eligible and ForTank and ItemCount > 0 then TankReward = true end
				if Eligible and ForHealer and ItemCount > 0 then HealerReward = true end
				if Eligible and ForDamage and ItemCount > 0 then DPSReward = true end
			end

			if (not Unavailable) then
				AllUnavailable = false
				local RolesString = MakeString(TankReward, HealerReward, DPSReward)

				if (RolesString ~= "   ")  then
				local numEncounters, numCompleted = GetLFGDungeonNumEncounters(ID)
					numEncounters = numEncounters or 0
					numCompleted = numCompleted or 0
					GameTooltip:AddDoubleLine(Name .. " (" .. numCompleted .. "/" .. numEncounters .. "):", RolesString, 1, 1, 1)
				end

				if (TankReward or HealerReward or DPSReward) then
					NumCTA = NumCTA + 1
				end
			end
		end

		if AllUnavailable then
			GameTooltip:AddLine("Could not get Call To Arms information.")
		elseif (NumCTA == 0) then
			GameTooltip:AddLine("No dungeons are currently offering a Call To Arms.")
		end
		frame:Show()
		GameTooltip:Show()
	end

	local OnLeave = function()
		GameTooltip:Hide()
	end

	frame:SetScript("OnEvent", update)
	frame:SetScript("OnEnter", OnEnter)
	frame:SetScript("OnLeave", OnLeave)
	text:SetScript("OnEnter", OnEnter)
	text:SetScript("OnLeave", OnLeave)

	update()
end
