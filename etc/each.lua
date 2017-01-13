API "1.2"
-- Usage: 'stuff|'each <otherstuff> runs otherstuff on each line from stuff.

local LOG = plugin.log(_funcname)
arg, io.stdin = etc.stdio(arg)

local code = arg[1]
LOG.trace("code = " .. tostring(code))
if code and code ~= "" then
  local fn
  if code:sub(1, #etc.cmdprefix) == etc.cmdprefix then
    fn = function(...)
      return etc.on_cmd(code:sub(1 + #etc.cmdprefix), ...)
    end
  else
    fn = assert(guestloadstring(code))
  end
  
  local ln = 0
  for line in io.stdin:lines() do
    ln = ln + 1
    local x, y = etc.getOutput(fn, line)
    if x then
      print(x)
    else
      if y ~= nil then
        LOG.trace("Line " .. tostring(ln) .. " error: " .. tostring(y))
      else
        LOG.trace("Line " .. tostring(ln) .. " no output")
      end
    end
  end
  LOG.trace("" .. tostring(ln) .. " lines")
else
  LOG.trace("Nothing to do")
  return nil, "Nothing to do"
end
