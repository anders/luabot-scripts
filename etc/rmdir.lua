-- Usage: <dir>, [io] - Delete empty directory
local dir = assert(arg[1], "dir needed")
local io = arg[2] or assert(godloadstring("return io"))()

return io.fs.remove(dir) -- For now
