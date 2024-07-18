local addonName, addon = ...
local S = unpack(addon)

local Scale = S.Scale

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
		local castbar = player.Castbar
		player.GCD:ClearAllPoints()
		player.GCD:SetPoint('TOPLEFT',ActionButton1, 'BOTTOMLEFT', 0, -S.scale4)
		player.GCD:SetPoint('TOPRIGHT',ActionButton8, 'BOTTOMRIGHT', 0, -S.scale4)
		player.GCD:SetAlpha(1)
	else
		local castbar = player.Castbar
		player.GCD:ClearAllPoints()
		player.GCD:SetPoint('TOPLEFT',castbar, 'BOTTOMLEFT', 0, -S.scale4)
		player.GCD:SetPoint('TOPRIGHT',castbar, 'BOTTOMRIGHT', 0, -S.scale4)
		player.GCD:SetAlpha(1)
	end
	
end
