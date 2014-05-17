local cmd = arg[1]
local target = 'balance_'..arg[2]
local change = arg[3]

if not Cache[target] then Cache[target] = 0 end

if cmd == 'set' and nick == 'anders' then
  Cache[target] = change
elseif cmd == 'get' then
  return Cache[target]
elseif cmd == 'add' and nick == 'anders' then
  Cache[target] = Cache[target] + change
elseif cmd == 'subtract' then
  Cache[target] = Cache[target] - change
end