local _, addon = ...
local S = unpack(addon)

S.switchBossBars = function(profile)

  for i = 1,4 do
    local boss = S.unitFrames["boss"..i]
    boss:ClearAllPoints()
    boss.Castbar:ClearAllPoints()
  end

  local boss1 = S.unitFrames.boss1
  local boss2 = S.unitFrames.boss2
  local boss3 = S.unitFrames.boss3
  local boss4 = S.unitFrames.boss4

  if profile == "SanChicken" then
    boss1:SetPoint("LEFT",S.unitFrames.target,"LEFT",0,150)
    boss2:SetPoint("LEFT",boss1,"LEFT",0,50)
    boss3:SetPoint("LEFT",boss2,"LEFT",0,50)
    boss4:SetPoint("LEFT",boss3,"LEFT",0,50)

    boss1.Castbar:SetPoint("LEFT",boss1,"RIGHT",8,0)
    boss2.Castbar:SetPoint("LEFT",boss2,"RIGHT",8,0)
    boss3.Castbar:SetPoint("LEFT",boss3,"RIGHT",8,0)
    boss4.Castbar:SetPoint("LEFT",boss4,"RIGHT",8,0)

  else
    boss1:SetPoint("TOPRIGHT",UIParent,"TOP",-5,-5)
    boss2:SetPoint("LEFT", boss1, "RIGHT", 20, 0)
    boss3:SetPoint("RIGHT", boss1, "LEFT",-20,0)
    boss4:SetPoint("LEFT", boss2, "RIGHT", 20,0)

    boss1.Castbar:SetPoint("TOP",boss1.Power,"BOTTOM",0,2)
    boss2.Castbar:SetPoint("TOP",boss2.Power,"BOTTOM",0,2)
    boss3.Castbar:SetPoint("TOP",boss3.Power,"BOTTOM",0,2)
    boss4.Castbar:SetPoint("TOP",boss4.Power,"BOTTOM",0,2)
  end

end
