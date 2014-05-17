-- Usage: 'trace'command ... - traces the 'command by logging the TRACE level and tracking functions called. Use 'lastlog after using this command. See plugin.log and _getCalls

_getCalls() -- Enable.
Output.logLevel = 'TRACE'

local LOG = plugin.log(_funcname);

local x = assert(arg[1], "Function expected")
if type(x) == "function" then
elseif type(x) == "string" then
    local etccmd, etcargs = x:match(etc.cmdchar .. "([a-zA-Z0-9_]+) ?(.*)")
    if etccmd then
      x = assert(godloadstring(string.format("etc.%s(%q)", etccmd, etcargs)))
    else
      x = assert(godloadstring(x))
    end
else
    assert(nil, "Function expected, not " .. type(x))
end

local results = { x(...) }

LOG.trace("Calls:")
local calls = _getCalls()
for i = 1, #calls do
  LOG.trace("*", calls[i])
end

return unpack(results)
