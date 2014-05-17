if type(arg[1]) == "function" then
  return getCode(arg[1])
end
-- Should use etc.parseFunc but didn't get to it yet.
local mod, fn = (arg[1] or ''):match("^([^'%.]*'?)%.?(.+)$")
assert(arg[1] and mod and fn, "Invalid")
if mod == "'" then
  mod = "etc"
end
assert(_G[mod], "No such module: " .. mod)
-- return getCode(_G[mod][fn])
local f = assert(io.open("/pub/scripts/" .. mod .. "/" .. fn .. ".lua"))
local r = f:read("*a")
f:close()
return r
