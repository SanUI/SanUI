local _, addon = ...
local S = unpack(addon)

S.switchGCD =  function (profile)
	local player = S.unitFrames.player

	if profile == "Hidden" then
		player.GCD:SetAlpha(0)
	elseif profile == "SanChicken" then
		local castbar = player.Castbar
		player.GCD:ClearAllPoints()
		player.GCD:SetPoint('BOTTOMLEFT',castbar, 'TOPLEFT', 0, S.scale4)
		player.GCD:SetPoint('BOTTOMRIGHT',castbar, 'TOPRIGHT', 0, S.scale4)
		player.GCD:SetAlpha(1)
	elseif profile == "ToviAug" then
		player.GCD:ClearAllPoints()
		player.GCD:SetPoint('TOPLEFT',_G["DominosActionButton1"], 'BOTTOMLEFT', 0, -S.scale4)
		player.GCD:SetPoint('TOPRIGHT',_G["DominosActionButton8"], 'BOTTOMRIGHT', 0, -S.scale4)
		player.GCD:SetAlpha(1)
	else
		local castbar = player.Castbar
		player.GCD:ClearAllPoints()
		player.GCD:SetPoint('TOPLEFT',castbar, 'BOTTOMLEFT', 0, -S.scale4)
		player.GCD:SetPoint('TOPRIGHT',castbar, 'BOTTOMRIGHT', 0, -S.scale4)
		player.GCD:SetAlpha(1)
	end
	
end
