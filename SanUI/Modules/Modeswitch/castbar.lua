local _, addon = ...
local S, C = unpack(addon)

local Scale = S.Scale

S.switchCastbar = function(profile)
	local player = S.unitFrames.player

	local cb = player.Castbar
	cb.place = function(args)
		local disp_y = 0

		if args and args.cpoints and args.cpoints > 0 then
			disp_y = -20
		end

		if profile == "SanChicken" then
			cb:ClearAllPoints()
			cb:SetWidth(288)
			cb.button:ClearAllPoints()
			cb.button:SetSize(Scale(40), Scale(40))
			cb:SetPoint("CENTER",UIParent,"CENTER",0,-265)
			cb.button:SetPoint("TOP",cb,"BOTTOM",0,-10)
		elseif profile == "ToviDam" then
			cb:ClearAllPoints()
			cb:SetWidth(288)
			cb.button:ClearAllPoints()
			cb.button:SetSize(Scale(40), Scale(40))
			cb:SetPoint("CENTER",UIParent,"CENTER",0,-300)
			cb.button:SetPoint("TOP",cb,"BOTTOM",0,-12)
			cb.time:ClearAllPoints()
			cb.time:SetPoint("BOTTOM", player.GCD, "TOP", 0, 12)
			local name, height, flags = cb.time:GetFont()
			name = name or C.UnitFrames.Font
			cb.time:SetFont(name, 16, flags)
		elseif profile == "ToviAug" then
			cb:ClearAllPoints()
			cb:SetWidth(288)
			cb.button:ClearAllPoints()
			cb.button:SetSize(Scale(40), Scale(40))
			cb:SetPoint("CENTER",UIParent,"CENTER",0,-250)
			cb.button:SetPoint("TOP",cb,"BOTTOM",0,-12)
			cb.time:ClearAllPoints()
			cb.time:SetPoint("CENTER", cb.button, "CENTER", 0, 0)
			local name, _, flags = cb.time:GetFont()
			name = name or C.UnitFrames.Font
			cb.time:SetFont(name, 22, flags)
		else
			local name, _, flags = cb.time:GetFont()
			name = name or C.UnitFrames.Font
			cb.time:SetFont(name, 16, flags)

			cb:ClearAllPoints()
			cb.button:ClearAllPoints()
			cb:SetWidth(Scale(150))
			if player.ClassPower then
				local nr_classicons = #player.ClassPower
				cb:SetPoint("TOPRIGHT", player.ClassPower[nr_classicons]:GetParent(), "BOTTOMRIGHT", 0, -S.scale2)
			else
				cb:SetPoint("TOPRIGHT", player, "BOTTOMRIGHT", -5, Scale(disp_y))
			end

			cb.button:SetPoint("TOPRIGHT",cb.bg,"TOPLEFT",-S.scale2,0)
			cb.button:SetSize(Scale(28), Scale(28))
		end
		cb.Text:SetWidth(cb:GetWidth()*0.68)
		cb.Text:SetHeight(cb:GetHeight()*0.9)
	end

	cb.place()
end
