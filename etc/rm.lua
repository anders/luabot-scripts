-- Usage: <path>, [io] - Delete file
local path = assert(arg[1], "path needed")
local io = arg[2] or assert(godloadstring("return io"))()

return io.fs.remove(path)
