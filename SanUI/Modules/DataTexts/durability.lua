local addonName, addon = ...
local S,C = unpack(addon)

local floor = math.floor

local font = C.medias.fonts.Font
local fontsize = C.sizes.datatextfontsize

local slots = {
	"HeadSlot",
	"ShoulderSlot",
	"ChestSlot",
	"WristSlot",
	"HandsSlot",
	"WaistSlot",
	"LegsSlot",
	"FeetSlot",
	"MainHandSlot"
}

S.createDurabilityDT = function(frame, pos)
	frame:RegisterEvent("MERCHANT_SHOW")
	frame:RegisterEvent("PLAYER_ENTERING_WORLD")
	frame:RegisterEvent("UPDATE_INVENTORY_DURABILITY")
	
	local text = frame:CreateFontString(nil, "OVERLAY")
	text:SetPoint("LEFT", frame, "LEFT", S.Scale(4), -S.scale1)
	text:SetJustifyH("CENTER")
	text:SetJustifyV("MIDDLE")
	text:SetFont(font, fontsize)
	
	frame.Text = text
		
	text:SetScript("OnMouseDown", function()
		if InCombatLockdown() then
			print("In combat - not opening character frame")
			return
		end

		ToggleCharacter("PaperDollFrame")
	end)
	
	local update = function(Event)
		local durmin = 1
	
		for _, slot in ipairs(slots)
		do
			local current, maximum = GetInventoryItemDurability(GetInventorySlotInfo(slot))
			
			if current and current/maximum < durmin then
				durmin = current/maximum
			end
		end
		
		text:SetText(floor(durmin*100).."%")
		
		local green = durmin * 2
		local red = 1 - green
		
		if green < 0.4 then
			text:SetTextColor(red + 1, green, 0, 1)
		else
			text:SetTextColor(1, 1, 1, 1)
		end
	end
	
	frame:SetScript("OnEvent", update)
	update()
end