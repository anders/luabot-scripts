-- on_munin error in plugin cbcvalue: [string "etc.cbcvalue"]:39: attempt to perform arithmetic on local 'basevalue' (a nil value)
if Editor then return end
local val, err = etc.cbcvalue('-cache')
local OneUSD
if val then
  OneUSD = 1 / val
else
  Cache.graph_cbcfail = (err or "nil") .. " " .. os.time()
end
local t = {}
t.title = "Value of CBC"
t.vlabel = "CBC"
t.lowerLimit = 0
t.scale = false
t.data = { OneUSD = OneUSD }
return t
