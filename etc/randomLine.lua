local f = assert(arg[1], "File expected")
local doclose = arg[2]

if type(f) == "string" then
  local io
  if type(arg[2]) == "table" then
    io = arg[2]
  else
    io = godloadstring("return io")()
  end
  f = io.open(f, 'r')
  if doclose ~= false then
    doclose = true
  end
end

local size = f:seek("end")
if not size or size <= 2 then
  if doclose == true then
    f:close()
  end
  return nil, "No data"
end

local result
--  Note: this always skips the first line.
for i = 1, 10 do
  local x, err2 = f:seek("set", math.random(0, size))
  if not x then
      if doclose == true then
        f:close()
      end
      return nil, err2
  end
  f:read() -- Skip partial line.
  result = f:read()
  if result then
    break
  end
end

if doclose == true then
  f:close()
end
if not result then
  return nil, "Unable to find a line"
end
return result
