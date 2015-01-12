-- Example: 'echo something |'trparty tr
-- It will run etc.tr(something) repeatedly until the output is the same or the time limit is exceeded.

local arg, stdin = etc.stdio(arg)
local f = assert(guestloadstring("return "..arg[1])())

assert(type(f) == "function")

local last = stdin:read("*a")

local timelimit = 0.1

local start = os.clock()

while true do
  local current = etc.getOutput(f, last)
  if os.clock() - start >= timelimit or current == last then break end
  last = current
end

return last or ""
