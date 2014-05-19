local amount = tonumber(arg[1], 10)
assert(amount>=0 and amount<=1000)
amount = tostring(amount)


return "\2\3\48\44\51\91\204\178\204\133\36\204\178\204\133\40\204\178\204\133"..
 amount:gsub("%d", "%1\204\178\204\133") ..
 "\41\204\178\204\133\36\204\178\204\133\93\3\2"