API "1.1"

local cbcvalue
if Cache._cbcvalue then
  cbcvalue = Cache._cbcvalue 
else
  cbcvalue = etc.cbcvalue()
  Cache._cbcvalue = cbcvalue
end

local who = arg[1] or nick
local wusd = string.format("%.2f", cash(who) * cbcvalue)
if Output.brief then
  return 'has $' .. wusd .. ' USD'
end
return who .. " is has $" .. wusd .. " in USD"
