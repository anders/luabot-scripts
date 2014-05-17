-- Usage: <dir>, [io] - Create directory
local dir = assert(arg[1], "dir needed")
local io = arg[2] or assert(godloadstring("return io"))()

return io.fs.mkdir(dir)
