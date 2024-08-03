local _, addon = ...
local S = unpack(addon)

local function pack(...)
	return arg
end

S.switchClassPower =  function (profile)
	local classpower = S.unitFrames.player.ClassPower

	if profile == "PRet" then
		for i = 1, #classpower do
			local bg = classpower[i].bg:GetParent()
			local point, relativeTo, relativePoint, xOfs, yOfs = bg:GetPoint()
			
			bg.hank_placement = { point, relativeTo, relativePoint, xOfs, yOfs }
		end
		
		local indices = {3, 2, 1, 4, 5}
		for idx, i in ipairs(indices) do
			local bg = classpower[i].bg:GetParent()
			bg:ClearAllPoints()
			
			if idx == 1 then
				bg:SetPoint("TOP", UIParent, "CENTER", 0, -150)
			else
				if idx <= 3 then
					local prev = classpower[indices[idx - 1]].bg:GetParent()
					bg:SetPoint("RIGHT", prev, "LEFT", -2, 0)
				elseif idx == 4 then
					local prev = classpower[3].bg:GetParent()
					bg:SetPoint("LEFT", prev, "RIGHT", 2, 0)
				elseif idx == 5 then
					local prev = classpower[4].bg:GetParent()
					bg:SetPoint("LEFT", prev, "RIGHT", 2, 0)
				end
			end
		end
	else
		if classpower then
			for i = 1, #classpower do
				local bg = classpower[i].bg:GetParent()
				bg:ClearAllPoints()
				bg:SetPoint(unpack(bg.hank_placement))
			end
		end
	end
	
end
