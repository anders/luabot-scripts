-- Usage: check_apikey_fs(io1, io2, apikeypath) to check if apikey is granted between io1 and io2.

io = nil
local io1 = assert(arg[1], "need io1")
local io2 = assert(arg[2], "need io2")
local apikeypath = assert(arg[3], "need apikey path")

assert(type(io1) == "table" and type(io2) == "table" and type(apikeypath) == "string", "bad input types")

assert(io1 ~= io2, "Don't use the same io twice!")

local apikey1
do
  local f = io1.open(apikeypath)
  if f then
    apikey1 = f:read()
    f:close()
  end
end

local apikey2
do
  local f = io2.open(apikeypath)
  if f then
    apikey2 = f:read()
    f:close()
  end
end

return not (not apikey1 or not apikey2 or apikey1 ~= apikey2)
