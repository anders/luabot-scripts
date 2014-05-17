-- Usage: etc.splitArgs('all "your base"') returns { 'all', 'your base' } Also: arg = etc.splitArgs(arg[1])
-- Single quotes not handled yet.

local t = {}

local s = arg[1]
if type(s) == "string" then
  s = s:gsub('%b""', function(x)
    return x:sub(2, #x - 1):gsub(" ", "\1")
  end)
  for x in s:gmatch("[^ ]+") do
    t[#t + 1] = x:gsub("\1", " ")
  end
end

return t
