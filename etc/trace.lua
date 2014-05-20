-- Usage: 'trace'command ... - traces the 'command by logging the TRACE level and tracking functions called. Use 'lastlog after using this command. See plugin.log and _getCalls

_getCalls() -- Enable.
Output.logLevel = 'TRACE'

local LOG = plugin.log(_funcname);

LOG.trace("init")
LOG.trace("allCodeTrusted", allCodeTrusted(), whyNotCodeTrusted() or "")

if type(arg[1]) == "string" and arg[1]:sub(1, 2) == "-f" then
  -- the -f switch means fail if code not trusted.
  failNotCodeTrusted()
  local i = 3
  if arg[1]:sub(i, i) == ' ' then
    i = i + 1
  end
  arg[1] = arg[1]:sub(i)
end

local x = assert(arg[1], "Function expected")
local args
if type(x) == "function" then
  args = { (function(f, ...) return ... end)(...) }
elseif type(x) == "string" then
  local etccmd, etcargs = x:match(etc.cmdchar .. "([a-zA-Z0-9_]+) ?(.*)")
  if etccmd then
    -- x = assert(godloadstring(string.format("etc.%s(%q)", etccmd, etcargs)))
    x = etc[etccmd]
    args = { etcargs }
  else
    x = assert(godloadstring(x))
    args = {}
  end
else
    assert(nil, "Function expected, not " .. type(x))
end

local results = { (function(x, ...)return ... end)(pcall(x, unpack(args))) }

LOG.trace("Calls:")
local calls = _getCalls()
for i = 1, #calls do
  LOG.trace("*", calls[i])
end

LOG.trace("allCodeTrusted", allCodeTrusted(), whyNotCodeTrusted() or "")

return unpack(results)
