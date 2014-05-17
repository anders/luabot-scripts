local who = arg[1] or nick
return who .. " is worth $" .. worth(who), boturl .. "u/" .. urlEncode(getname(owner())) .. "/worthstats.html"
