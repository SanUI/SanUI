local _, addon = ...
local S,C = unpack(addon)

local font = C.medias.fonts.Font
local fontsize = C.sizes.datatextfontsize

S.createGuildDT = function(frame)
	frame:RegisterEvent("GUILD_ROSTER_UPDATE")
	frame:RegisterEvent("PLAYER_GUILD_UPDATE")
	
	local text = frame:CreateFontString(nil, "OVERLAY")
	text:SetPoint("CENTER", frame, "CENTER", 0, -S.scale1)
	text:SetJustifyH("CENTER")
	text:SetJustifyV("MIDDLE")
	text:SetFont(font, fontsize)
	
	frame.Text = text
		
	text:SetScript("OnMouseDown", function()
		if InCombatLockdown() then
			print("In combat - not opening character frame")
			return
		end

		ToggleGuildFrame()
	end)
	
	local update = function(event)
		local guildmembers = select(3, GetNumGuildMembers())
		
		text:SetText("Guild: "..guildmembers) 
	end
	
	frame:SetScript("OnEvent", update)
	update()
end
