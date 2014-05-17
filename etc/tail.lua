-- Usage: 'tail <filename> or pipe in via |'tail

local maxlines = 10
if Output.maxLines < maxlines then
  maxlines = Output.maxLines
end
local omaxlines = Output.maxLines

if type(arg[1]) ~= "string" then
  error("No input to tail")
end
local data, err
if Input and Input.piped then
  data = arg[1]
  err = "not arg[1]"
  -- [[ -- This breaks when not supplying any explicit arg.
  assert(data, err)
  -- print("Input.piped=", Input.piped)
  data = arg[1]:sub(1, Input.piped)
  local argstr = arg[1]:sub(Input.piped + 1)
  -- print("data=",data,"argstr=",argstr)
  local ns = (argstr or ''):match("^%-(%d+)$")
  if ns then
    -- print("updated maxlines to", maxlines, "from arg", argstr)
    maxlines = tonumber(ns)
  end
  --]]
else
  Output.maxLines = math.max(500, Output.maxLines or 0)
  data, err = etc.getOutput(etc.cat, ...)
end
assert(data ~= nil, err)

-- print("maxlines=", maxlines)
-- print("data=", '`' .. tostring(data) .. '`')

local t = {}
local count = 0
for line in data:gmatch("[^\r\n]+") do
  t[count % maxlines + 1] = line
  count = count + 1
end

local result = ""
for i = count, count + maxlines - 1 do
  local x = t[i % maxlines + 1]
  if x then
    result = result .. x
    result = result .. "\n"
  end
end

Output.maxLines = omaxlines

return result
