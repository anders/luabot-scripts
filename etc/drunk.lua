local words = table.concat(arg, " ")

if #words == 0 then error("dongs") end

local shuffle = function(w)
    if #w <= 1 then return w end
    local buf = {}
    for c in w:gmatch(".") do buf[#buf + 1] = c end
    --local idx = #buf
    --while idx > 1 do
    --    local rnd = math.random(1, idx - 1)
    --    buf[rnd], buf[idx] = buf[idx], buf[rnd]
    --    idx = idx - 1
    --end
    for i = 1, math.random(1, 2) do
        local idx = math.random(1, #buf - 1)
        buf[idx], buf[idx + 1] = buf[idx + 1], buf[idx]
    end
    return table.concat(buf)
end

local warr  = {}
local first = true
for line in words:gmatch("([^\n]+)") do
    if not first then warr[#warr + 1] = "\n" end
    first = false
    for word in line:gmatch("([^%s]+)") do
        warr[#warr + 1] = shuffle(word)
    end
end

return table.concat(warr, " "):upper()
