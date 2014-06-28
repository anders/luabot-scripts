local who = (arg[1] or nick):lower()
local len = math.floor((tonumber(etc.md5(who):sub(1, 2), 16) / 256) * 9) + 1
return "8"..("="):rep(len).."D"
