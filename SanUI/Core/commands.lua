local _, addon = ...
local S, C, L = unpack(addon)

S.SanSlashHandler = function(arg)
	if arg == "addweakauras" then
		S.weakAurasDialog()
	elseif arg == "buffs" or arg == "auras" then
		Settings.OpenToCategory(addon.optionspanel.categoryID)
		Settings.OpenToCategory(addon.saf.optionspanel.categoryID)
	elseif arg == "config" then
		Settings.OpenToCategory(addon.optionspanel.categoryID)
	end
end

SLASH_SANUISLASHHANDLER1 = "/sanui"
SlashCmdList["SANUISLASHHANDLER"] = S.SanSlashHandler
