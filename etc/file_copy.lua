local io = arg[1]
local path = arg[2] -- Path and name of file.
local dest = arg[3] -- Must be a file name, not a directory!
assert(type(io) == "table" and io.fs, "Need io")

local input = assert(io.open(path, "rb"))
local output = assert(io.open(dest, "wb"))
while true do
  local data, err = input:read(1024 * 4)
  if not data then
    if data == nil then
      -- EOF
      break
    end
    input:close()
    output:close()
    return data, err
  end
  local o, oerr = output:write(data)
  if not o then
    input:close()
    output:close()
    return false, oerr
  end
end
input:close()
output:close()
return true
