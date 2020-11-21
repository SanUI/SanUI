local addonName, addon = ...
local S = unpack(addon)

local Scale = S.Toolkit.Functions.Scale

S.switchCastbar = function(profile)

	local cb = oUF_player.Castbar
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
		elseif profile == "Manyak" then
			cb:ClearAllPoints()
			cb.button:ClearAllPoints()
			cb:SetPoint("CENTER",UIParent,"CENTER",0,-188)
			cb:SetWidth(300)
			cb.button:SetHeight(16)
			cb.button:SetWidth(16)
			cb.button:SetPoint("RIGHT",cb,"LEFT",-3,0)
			-- GCD
			oUF_player.GCD:SetPoint("TOPLEFT", oUF_player, "BOTTOMLEFT", S.Scale(2), S.Scale(-2))
		elseif profile == "DK" then
			cb:ClearAllPoints()
			cb.button:ClearAllPoints()
			cb:SetPoint("TOPLEFT", oUF_player, "BOTTOMLEFT", Scale(20), -Scale(20))
			cb.button:SetPoint("RIGHT",cb,"LEFT",-Scale(4),0)
		elseif profile == "PRet" then
			cb:ClearAllPoints()
			cb.button:ClearAllPoints()
			cb:SetWidth(Scale(150))
			cb:SetPoint("TOPLEFT", oUF_player, "BOTTOMLEFT", Scale(2), disp_y)
			cb.button:SetPoint("TOPRIGHT",cb.bg,"TOPLEFT",-Scale(2),0)
			cb.button:SetSize(Scale(28), Scale(28))
		else
			cb:ClearAllPoints()
			cb.button:ClearAllPoints()
			cb:SetWidth(Scale(150))
			if oUF_player.ClassPower then
				local nr_classicons = #oUF_player.ClassPower
				cb:SetPoint("TOPRIGHT", oUF_player.ClassPower[nr_classicons]:GetParent(), "BOTTOMRIGHT", 0, -Scale(2))
			else
				cb:SetPoint("TOPLEFT", oUF_player, "BOTTOMLEFT", Scale(2), Scale(disp_y))
			end
			
			cb.button:SetPoint("TOPRIGHT",cb.bg,"TOPLEFT",-Scale(2),0)
			cb.button:SetSize(Scale(28), Scale(28))
		end
		cb.Text:SetWidth(cb:GetWidth()*0.68)
		cb.Text:SetHeight(cb:GetHeight()*0.9)
	end
	
	cb.place()
end
