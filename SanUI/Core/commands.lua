local _, addon = ...
local S, C, L = unpack(addon)

S.SanSlashHandler = function(arg)
	if arg == "addweakauras" then
		S.weakAurasDialog()
	elseif arg == "buffs" or arg == "auras" then
		InterfaceOptionsFrame_OpenToCategory(addon.saf.optionspanel)
		InterfaceOptionsFrame_OpenToCategory(addon.saf.optionspanel)
	elseif arg == "config" then
		InterfaceOptionsFrame_OpenToCategory(addon.optionspanel)
		InterfaceOptionsFrame_OpenToCategory(addon.optionspanel)
	end
end

SLASH_SANUISLASHHANDLER1 = "/sanui"
SlashCmdList["SANUISLASHHANDLER"] = S.SanSlashHandler
