-- arg[1] is the file name.
-- arg[2] is a callback function that returns:
        -- 0 for match
        -- >0 to search ahead
        -- <0 to search behind
-- arg[3] and arg[4] are optional file offsets to search within.

local LOG = plugin.log(_funcname);

local fn = arg[1]
local callback = arg[2]

assert(type(fn) == "string", "File name expected")

if not callback then
  fn, callback = fn:match("^([^ ]+) (.+)$")
end

if type(callback) == "string" then
  if not callback:find("%f[%w_]return[\t %(]") then
    callback = "return " .. callback
  end
  callback = assert(godloadstring("local line = ...; " .. callback))
else
  assert(type(callback) == "function", "Callback function expected")
end

--[[
-- io = godloadstring("return io")() -- Shouldn't access the current nick's files!
if not fn or not fn:find("^/shared/") or fn:find("..", 1, true) then
  error("binarySearchFileLines only works with /shared files for now")
end
io._fast = true
local f = assert(io.open(fn))
--]]
local f = assert(etc.userfileopen(fn, 'r', '-fast'))

local start = arg[3] or 0
local stop = arg[4] or assert(f:seek("end"))

local bsc = 0
Cache.bsc = bsd

local function myrand(m, n)
  if type(m) ~= "number" or type(n) ~= "number" then
    error("random didn't get numbers, got: " .. tostring(m) .. " " .. tostring(n))
  end
  if m > n then
    error("random got m > n: " .. tostring(m) .. " " .. tostring(n))
  end
  return math.random(m, n)
end

LOG.trace("Starting at", start, stop)
while true do
  local line
  -- local offset = math.floor((stop - start) / 2)
  local m = (stop - start) / 4
  local n = (stop - start) / 4 * 3
  local offset = myrand(m, n)
  if offset < 1 then
    LOG.trace("No offset, bailing out")
    break
  end
  local mid = start + offset
  local b4line
  if offset < 50 then
    -- If the offset is small, look directly from the start.
    LOG.trace("Looking directly from the start", start)
    mid = start
    b4line = start
    f:seek("set", mid)
    line = f:read()
  else
    LOG.trace("Skipping ahead by", offset)
    f:seek("set", mid)
    f:read() -- Skip partial line.
    b4line = f:seek()
    line = f:read()
  end
    LOG.trace("On line at position", b4line)
  -- print("seeked to ", mid, " got line: ", line)
  if line then
    bsc = bsc + 1
    Cache.bsc = bsc
    local dir = callback(line)
    if dir == 0 then
      f:close()
      LOG.trace("Found match")
      return line
    end
    --[[
    if bsc % 100 == 0 then
      _yield()
    end
    --]]
    if b4line >= stop then
      LOG.trace("The line passed the stop, bailing out")
      break
    end
    if dir < 0 then
      if start == b4line then
        LOG.trace("Stuck on the same line, bailing out")
        break
      end
      stop = b4line
      LOG.trace("Need to go back to to", start, stop)
    else --if dir > 0 then
      start = f:seek()
      LOG.trace("Need to go ahead to", start, stop)
    end
  else
    -- Can hit EOF when skipping lines, so treat it as "less than".
    stop = b4line
    LOG.trace("Hit EOF, need to go back to", start, stop)
  end
end

f:close()
LOG.trace("Did not find match")
return nil, "Not found"
