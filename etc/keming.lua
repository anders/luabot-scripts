local s = table.concat(arg, " ")
local r = {}
local f = s:gmatch(".")
local c = f()
local i = 1

local rep_two = function(matched, follow, result)
    c = f()
    if c == follow then
        r[i] = result
        c = f()
    else
        r[i] = matched
    end
end

while c do
    if c == "m" then
        r[i] = "rn"
        c = f()
    elseif c == "r" then
        rep_two("r", "n", "m")
    elseif c == "d" then
        r[i] = "cl"
        c = f()
    elseif c == "c" then
        rep_two("c", "l", "d")
    else
        r[i] = c
        c = f()
    end
    i = i + 1
end

return table.concat(r)
