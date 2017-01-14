API "1.2"
-- Usage: 'cmd|'each <code> runs code on each line from cmd.

local LOG = plugin.log(_funcname)
arg, io.stdin = etc.stdio(arg)

local code = arg[1]
LOG.trace("code =", tostring(code))
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
    if line:sub(1, #etc.cmdprefix) == etc.cmdprefix or line:find("|" .. etc.cmdprefix) then
      -- HACK, BUG or FEATURE: you pick.
      LOG.trace("Line", tostring(ln), "skipped, not processing commands")
    else
      local ok, x, y = pcall(etc.getOutput2, true, fn, line)
      if ok then
        if type(x) == "string" and x:sub(1, 7) == "Error: " then
          -- HACK
          y = x:sub(8)
          x = nil
        end
        if x and x ~= "" then
          print(x)
        end
        if y and y ~= "" then
          LOG.trace("Line", ln, "error:", tostring(y))
        end
        if (not x or x == "") and (not y or y == "") then
          LOG.trace("Line", ln, "no output")
        end
      else
         LOG.trace("Line", ln, "error:", tostring(x))
      end
    end
  end
  LOG.trace(tostring(ln), "lines")
else
  LOG.trace("Nothing to do")
  return nil, "Nothing to do"
end
