if not arg[1] then return "doot doot" end

local dootstr = table.concat(arg, " ")
local ndoots = 1

for c in dootstr:gmatch("[^ ]+") do ndoots = ndoots + 1 end

local doots = {}
for i = 1, ndoots * 2 do
    doots[#doots + 1] = "doot"
end
return table.concat(doots, " ")
