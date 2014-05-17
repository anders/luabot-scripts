local ok = nick .. " * Keep on flappin'"
atTimeout(ok)

plugin.spam = function() return { detect=function() end } end

local last = ""
for i = 0, 100 do
  local x = etc.getOutput(etc.flappybird)
  if x and x:find("died") and not x:find("Score: 0") then
    print(x)
    return
  end
  last = x
end

print(ok, last)
