-- Usage: <dirs>, [io] - Make the full path of directories if they don't exist already.
local dirs = assert(arg[1], "dirs needed")
local io = arg[2] or assert(godloadstring("return io"))()

local a, b
for dir, direndpos in dirs:gmatch("([^/]+)()") do
  a, b = io.fs.mkdir(dirs:sub(1, direndpos))
end

if a then
  return a
end
return a, b
