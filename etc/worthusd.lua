API "1.1"

local cbcvalue
if Cache._cbcvalue then
  cbcvalue = Cache._cbcvalue 
else
  cbcvalue = etc.cbcvalue()
  Cache._cbcvalue = cbcvalue
end

local who = arg[1] or nick
local wusd = string.format("%.2f", worth(who) * cbcvalue)
if Output.brief then
  return 'worth $' .. wusd .. ' USD*' -- * unrealized!
end
return who .. " is worth $" .. wusd .. " in USD (unrealized)"
