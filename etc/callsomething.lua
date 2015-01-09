local fn = "'" .. etc.find(arg[1] or "*", 1):match("[^ ]+$")
LocalCache.called = fn
return guestloadstring("return etc.random(...)")(fn)
