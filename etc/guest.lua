-- Usage: run the code from a guest security context. Note that things might look the same, but won't have permissions.

return etc.output(assert(guestloadstring("return " .. assert(arg[1], "Guest code expected")))())
