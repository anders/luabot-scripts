assert(getuid() == 1, "you're not byte[]")
local a, b, c = pcall(loadstring, "return _G")
assert(a, b)
assert(b, c)
return b()
