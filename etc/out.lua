-- Usage: 'out ... evaluates the argument and passes it to etc.output to be output.
assert(godloadstring("etc.output(" .. (arg[1] or '') .. ")"))()
