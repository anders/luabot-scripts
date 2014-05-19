local who = arg[1] or nick
-- local url = boturl .. "u/" .. urlEncode(getname(owner())) .. "/worthstats.html"
local url = etc.graph("cbcworth")
return who .. " is worth $" .. worth(who), url
