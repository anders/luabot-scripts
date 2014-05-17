local t = etc.find("*", true)
local fname = "etc." .. t[math.random(#t)]
return etc.code(fname)
