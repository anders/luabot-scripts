local cash = assert(godloadstring("return cash"))() -- BUG: why is this needed?
return cash(arg[1] or nick)
