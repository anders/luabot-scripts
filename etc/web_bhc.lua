API "1.1"

if not Web or not Web.GET.msg then return end

Output.mode = "irc"
Output.printType = "irc"
_clown()

-- print(Web.GET.msg)

print(assert(guestloadstring("_guest(); return etc.cmd(...)"))("'" .. Web.GET.msg))
