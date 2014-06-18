local fn = "'" .. etc.find("*", 1):match("[^ ]+$")
LocalCache.called = fn
return guestloadstring("return etc.random(...)")(fn)
