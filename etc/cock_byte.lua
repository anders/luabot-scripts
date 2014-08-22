local who = (arg[1] or nick):lower()
local x = math.floor((tonumber(etc.md5(who):sub(1, 2), 16) / 256) * 9) + 1
local len = (math.floor(os.time() / (60 * 60 * 24)) * x * 7) % 10
if len == 0 then
  return "(|)"
end
return "8"..("="):rep(len).."D"
