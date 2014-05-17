local arg1, arg2
if arg[1] then string.gsub(arg[1], "(%d)%s*(%d*)", function(a, b) arg1, arg2 = a, b end) end
arg1 = arg1 and tonumber(arg1) or 5
arg2 = arg2 and tonumber(arg2) or 10

if arg1 > arg2 then
    print("gimme proper numbers!")
    return nil
end
local clamp = function(val, low, high) return math.max(low, math.min(val, high)) end

arg1 = clamp(arg1, 0, 20)
arg2 = clamp(arg2, 0, 20)

local nbutts = math.random(arg1, arg2)
local butts = ""
for i = 1, nbutts do
    butts = butts .. "butts" .. (i == nbutts and "" or " ")
end
print(butts)