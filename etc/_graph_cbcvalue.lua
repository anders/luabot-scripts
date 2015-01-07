-- on_munin error in plugin cbcvalue: [string "etc.cbcvalue"]:39: attempt to perform arithmetic on local 'basevalue' (a nil value)
if Editor then return end
local ok, val = pcall(etc.cbcvalue, '-cache')
local OneUSD
if ok then
  OneUSD = 1 / val
else
  Cache.graph_cbcfail = tostring(val) .. " " .. os.time()
end
local t = {}
t.title = "Value of CBC"
t.vlabel = "CBC"
t.lowerLimit = 0
t.scale = false
t.data = { OneUSD = OneUSD }
return t
