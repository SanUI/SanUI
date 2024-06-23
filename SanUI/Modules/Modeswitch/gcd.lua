local addonName, addon = ...
local S = unpack(addon)

local Scale = S.Scale

S.switchGCD =  function (profile)

	if profile == "Hidden" then
		oUF_player.GCD:SetAlpha(0)
	elseif profile == "SanChicken" then
		local castbar = oUF_player.Castbar
		oUF_player.GCD:ClearAllPoints()
		oUF_player.GCD:SetPoint('BOTTOMLEFT',castbar, 'TOPLEFT', 0, S.scale4)
		oUF_player.GCD:SetPoint('BOTTOMRIGHT',castbar, 'TOPRIGHT', 0, S.scale4)
		oUF_player.GCD:SetAlpha(1)
	elseif profile == "ToviAug" then
		local castbar = oUF_player.Castbar
		oUF_player.GCD:ClearAllPoints()
		oUF_player.GCD:SetPoint('TOPLEFT',ActionButton1, 'BOTTOMLEFT', 0, -S.scale4)
		oUF_player.GCD:SetPoint('TOPRIGHT',ActionButton8, 'BOTTOMRIGHT', 0, -S.scale4)
		oUF_player.GCD:SetAlpha(1)
	else
		local castbar = oUF_player.Castbar
		oUF_player.GCD:ClearAllPoints()
		oUF_player.GCD:SetPoint('TOPLEFT',castbar, 'BOTTOMLEFT', 0, -S.scale4)
		oUF_player.GCD:SetPoint('TOPRIGHT',castbar, 'BOTTOMRIGHT', 0, -S.scale4)
		oUF_player.GCD:SetAlpha(1)
	end
	
end
