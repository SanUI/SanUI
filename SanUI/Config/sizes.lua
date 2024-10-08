local _, addon = ...
local S, C = unpack(addon)

local Scale = S.Scale

local function scale_entries(t, fac)
	for k, v in pairs(t) do
		if type(v) == "number" then
			t[k] = S.Scale(fac * v)
		elseif type(v) == "table" then
			scale_entries(v, fac)
		end
	end
end


local sizes = {
	actionbuttons = 32,
	actionbuttonspacing = 4,
	actionbuttonhotkey = 12,
	minimap = 160,
	minimappanelsheight = 19,
	datatextfontsize = 12,
	minimapbuttons = 15,
	scales = {
	},
	raidframes = {
		width = 75,
		height = 32,
		smallheight = 28,
		raidicon =16,
		readycheck = 12,
		resurrecticon = 12,
		summonindicator = 28,
		turtleicon = 15,
		raiddebuffs = 16,
		raiddebuffsicon = 14,
		notauratrackicon = 7,
		name = 12,
	},
	namedframes = {
		width = 75,
		height = 32,
		smallheight = 28,
		raidicon = 16,
		readycheck = 12,
		resurrecticon = 12,
		summonindicator = 28,
		turtleicon = 15,
		raiddebuffs = 16,
		raiddebuffsicon = 14,
		notauratrackicon = 9,
		name = 12,
		
	},
}

scale_entries(sizes, 1)

for i = -10, 12 do
	sizes.scales[i] = Scale(i)
end

C.sizes = sizes
