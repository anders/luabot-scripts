API "1.1"

if not Web or not Web.GET.msg then return end

Output.printType = "irc"
Output.printTypeConvert = "irc"
Output.mode = 'irc'
_clown()

-- print(Web.GET.msg)

local msg = Web.GET.msg
local prefix = msg:sub(1, 1) == "'" and "" or "'"

print(assert(guestloadstring("_guest(); return etc.cmd(...)"))(prefix .. msg))
