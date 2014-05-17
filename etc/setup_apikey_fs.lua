-- Usage: setup_apikey_fs(io1, io2, apikeypath) - Setup an API key shared between 2 file systems, to be used with check_apikey_fs(io1, io2, apikeypath) to check if granted.

io = nil
local io1 = assert(arg[1], "need io1")
local io2 = arg[2]
local apikeypath = assert(arg[3], "need apikey path")

assert(type(io1) == "table" and type(apikeypath) == "string", "bad input types")

assert(io1 ~= io2, "Don't use the same io twice!")

local apikey = arg[4] or etc.make_apikey(io1, io2, io1.open, io2.open)

do
  local f = io1.open(apikeypath)
  assert(not f, "apikey file already exists in io1")
  f:close()
  f = assert(io1.open(apikeypath, 'w'))
  f:write(apikey)
  f:close()
end

if io2 then
  local f = io2.open(apikeypath)
  assert(not f, "apikey file already exists in io2")
  f:close()
  f = assert(io2.open(apikeypath, 'w'))
  f:write(apikey)
  f:close()
end

return apikeypath
