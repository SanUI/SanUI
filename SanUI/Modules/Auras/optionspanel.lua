local addonName, addon = ...
local S, C = unpack(addon)

local saf = addon.saf

local panel = CreateFrame("Frame")
panel.name = "SimpleAuraFilter"
panel.parent = addonName

saf.optionspanel = panel

local font = C.medias.fonts.Font

local buffs_selected = {}

panel.create = function()
    panel.created = true

    local title = panel:CreateFontString(nil, "OVERLAY")
	title:SetFont(font, 14)
    title:SetWidth(panel:GetWidth())
    title:SetJustifyH("LEFT")
    title:SetJustifyV("TOP")
    title.type = "label"
    title:SetPoint("TOPLEFT", panel, 10, -10)
    title:SetPoint("RIGHT", panel, -10, 0)
    title:SetHeight(45)
    title:SetText("Select buffs to hide for profile "..(saf.profile or "NONE"))
	
	panel.title = title

    local scrollframe = CreateFrame("ScrollFrame", nil, panel, "FauxScrollFrameTemplate")
    scrollframe:SetPoint("TOPLEFT", panel.title, "BOTTOMLEFT", 0, -5)
    scrollframe:SetPoint("RIGHT", panel, "RIGHT", -30, 0)
    scrollframe:SetHeight(320)
    scrollframe:Show()
	
	panel.scrollframe = scrollframe

    panel.buffs = {}

    for i = 1, 10 do
	    local cb = CreateFrame("CheckButton", "SAF_checkbox_Item" .. i, panel.scrollframe, "UICheckButtonTemplate")
		cb.text = _G["SAF_checkbox_Item" .. i .. "Text"]
		cb.text:SetFont(font, 12)
		cb.type = "checkbox"
		
		cb:SetScript("OnClick", function(buff)
			buffs_selected[buff.name] = not not buff:GetChecked()
		end)
        
        if i == 1 then
            cb:SetPoint("TOPLEFT", panel.scrollframe, "TOPLEFT", 0, 0)
        else
            cb:SetPoint("TOPLEFT", panel.buffs[i-1], "BOTTOMLEFT", 0, 0)
        end
		
		panel.buffs[i] = cb
    end

    panel.rowheight = panel.buffs[1]:GetHeight()

    panel.scrollframe:SetScript("OnVerticalScroll", function(frame, offset)
        FauxScrollFrame_OnVerticalScroll(frame, offset, panel.rowheight, function()
			panel:UpdateScrollFrame()
		end)
    end)

    local selectall = CreateFrame("Button", nil, panel, "UIPanelButtonTemplate")
    selectall:SetText("Select All")
    selectall:SetPoint("BOTTOMLEFT", 10, 10)
    selectall:SetWidth(100)
    selectall:SetScript("OnClick", function(button)
        for name, _ in pairs(saf.filters) do
			buffs_selected[name] = true
        end

        panel:UpdateScrollFrame()
    end)
	panel.selectall = selectall

    local selectnone = CreateFrame("Button", nil, panel, "UIPanelButtonTemplate")
    selectnone:SetText("Select None")
    selectnone:SetPoint("BOTTOMLEFT", panel.selectall, "BOTTOMRIGHT", 5, 0)
    selectnone:SetWidth(100)
    selectnone:SetScript("OnClick", function(button)
        for name, _ in pairs(saf.filters) do
            buffs_selected[name] = false
        end

        panel:UpdateScrollFrame()
    end)
	panel.selectnone = selectnone
end

function panel:UpdateScrollFrame()
    local sort = {}
    for name, _ in pairs(saf.filters) do
        if name then
            table.insert(sort, name)
        end
    end

    table.sort(sort)

    local offset = FauxScrollFrame_GetOffset(self.scrollframe)
    FauxScrollFrame_Update(self.scrollframe, #sort, 10, self.rowheight)

    for i=1+offset, 10+offset do
        local buff = self.buffs[i-offset]
        if i <= #sort then
            buff.name = sort[i]
            buff.text:SetText(sort[i])
            buff:SetChecked(buffs_selected[sort[i]])
            buff:Show()
        else
            buff:Hide()
        end
    end
end

function panel.okay()
    for name, value in pairs(buffs_selected) do
		saf.filters[name] = not not value
    end
	
	--BuffFrame_UpdateAllBuffAnchors()
end

function panel.refresh()
    if not panel.created then
        panel.create()
    end

    for name, filtering in pairs(saf.filters) do
        buffs_selected[name] = filtering
    end
	
	panel.title:SetText("Select buffs to hide for profile "..(saf.profile or "NONE"))
	--BuffFrame_UpdateAllBuffAnchors()

    panel:UpdateScrollFrame()
end

panel:SetScript("OnShow", function(self)
    if not panel.created then
        panel.create()
    end
    panel.refresh()
end)
