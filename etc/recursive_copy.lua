-- Usage: 'out etc.recursive_copy(io, "storage/todo", "storage/todo_backup")

local io = arg[1]
local path = arg[2]
local dest = arg[3]
assert(type(io) == "table" and io.fs, "Need io")

io.fs.mkdir(dest) -- Assume copying a dir!

local failures
io.fs.list(path, function(fp, flags)
  local name = fp:match("[^/]+$")
  assert(name, "Internal FILE NAME error??? " .. fp)
  local a, b
  if flags:find("d", 1, true) then
    a, b = etc.recursive_copy(io, fp, dest .. "/" .. name)
  else
    a, b = etc.file_copy(io, fp, dest .. "/" .. name)
  end
  if not a then
    if not failures then
      failures = {}
    end
      failures[#failures + 1] = fp .. ": " .. tostring(b)
    end
end)

if failures then
  return false, table.concat(failures, "\n")
end
return true
