return "8"..("="):rep(math.floor((tonumber(etc.md5((arg[1] or nick):lower()):sub(1, 2), 16) / 256) * 9) + 1).."D"
