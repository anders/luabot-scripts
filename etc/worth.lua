local who = arg[1] or nick
-- local url = boturl .. "u/" .. urlEncode(getname(owner())) .. "/worthstats.html"
local url = etc.graph("cbcworth")
if Output.brief then
  return 'worth $' .. worth(who)
end
return who .. " is worth $" .. worth(who), url
