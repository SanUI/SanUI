local _, addon = ...
local S, C = unpack(addon)

local lsg = _G["ls_Glass"]
local E = lsg[1]
local C = lsg[2]
C.db.global.colors.lanzones = E:CreateColor(1,1,1)

S.modLsgChatTab = function(E, frame)
    S.Kill(frame.Middle)
    S.Kill(frame.Right)
    S.Kill(frame.Left)
    S.Kill(frame.ActiveLeft)
    S.Kill(frame.ActiveMiddle)
    S.Kill(frame.ActiveRight)
    S.Kill(frame.HighlightLeft)
    S.Kill(frame.HighlightRight)
    S.Kill(frame.HighlightMiddle)

    frame.Text:SetTextColor(1, 1, 1)
    S.CreateAnonymousBackdrop(frame)

end

hooksecurefunc(E, "HandleChatTab", S.modLsgChatTab)

hooksecurefunc(E, "HandleMinimizedTab", S.modLsgChatTab)