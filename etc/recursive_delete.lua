-- Usage: 'out etc.recursive_delete(io, "storage/old_garbage")

local io = arg[1]
local path = arg[2]
assert(type(io) == "table" and io.fs, "Need io")

local failures
io.fs.list(path, function(fp, flags)
  local name = fp:match("[^/]+$")
  assert(name, "Internal FILE NAME error??? " .. fp)
  local a, b
  if flags:find("d", 1, true) then
    a, b = etc.recursive_delete(io, fp)
  else
    a, b = io.fs.remove(fp)
  end
  if not a then
    if not failures then
      failures = {}
    end
    failures[#failures + 1] = fp .. ": " .. tostring(b)
  end
end)

local c, d = io.fs.remove(path)
if not c then
  if not failures then
    failures = {}
  end
  failures[#failures + 1] = path .. ": " .. tostring(d)
end

if failures then
  return false, table.concat(failures, "\n")
end
return true
