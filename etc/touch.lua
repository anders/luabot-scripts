-- Usage: <path>, [io] - Touch a file, creates and updates timestamp
local path = assert(arg[1], "path needed")
local io = arg[2] or assert(godloadstring("return io"))()

local a, b = io.open(path, "w")
if not a then
  return a, b
end
a:close()
return true
