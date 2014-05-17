local s = arg[1] or ""
local min = arg[2] or 8
if s:len() < min then
    local lf = math.floor((min - s:len()) / 2)
    local rf = math.ceil((min - s:len()) / 2)
    s = string.rep(' ', lf) .. s .. string.rep(' ', rf)
end

local tl = "┌"
local t_ = "─"
local tr = "┐"
local ml = "│"
local m_ = " "
local mr = "│"
local bl = "└"
local b_ = "─"
local br = "┘"

local result = ""

result  = result .. tl
for x = 1, s:len() do
    result  = result  .. t_
end
result  = result  .. tr .. '\n'

result  = result  .. ml
for x = 1, s:len() do
    local ch = s:sub(x, x)
    if ch == ' ' then
        result = result  .. m_
    else
        result  = result  .. ch
    end
end
result  = result  .. mr .. '\n'

result  = result  .. bl
for x = 1, s:len() do
    result  = result  .. b_
end
result  = result  .. br .. '\n'

return result 
