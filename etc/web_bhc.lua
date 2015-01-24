API "1.1"

if not Web or not Web.GET.msg then return end

_clown()

Output = { tty=true, maxLineLength=400, printTypeConvert='auto', mode='irc', printType='irc', maxLines=4 }

-- print(Web.GET.msg)

print(assert(guestloadstring("etc.cmd(...)"))("'" .. Web.GET.msg))
