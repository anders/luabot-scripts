-- on_munin error in plugin cbcvalue: [string "etc.cbcvalue"]:39: attempt to perform arithmetic on local 'basevalue' (a nil value)
if Editor then return end
local t = {}
t.title = "Value of CBC"
t.vlabel = "CBC"
t.lowerLimit = 0
t.data = { OneUSD = etc.cbcvalue('-cache') }
return t
