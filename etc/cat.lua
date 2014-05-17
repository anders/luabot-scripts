local path = arg[1]

if not path or type(path) ~= "string" then
  local old_tty = Output.tty
  Output.tty = false
  if type(path) == "table" then
    -- local highest = tonumber("nan")
    for k, v in ipairs(table) do
      -- highest = k
      print(v)
    end
  elseif type(path) == "function" then
    path()
  elseif path == nil then
    local x, y = input()
    if x then
      print(y)
    end
  else
    print(tostring(path))
  end
  Output.tty = old_tty
  return nil, "Nothing to cat"
end

local fs
-- os = godloadstring("return os")()
local u, p = path:match("^/user/([^/]+)(/.*)")
if u then
  fs = getUserFS(u)
  path = p
else
  -- fs = getUserFS(nick)
  local io = assert(godloadstring("return io"))()
  fs = io
  if io.fs then
    fs = fs.fs
  end
end


local f = assert(fs.open(path, 'r'))

local maxlines = math.huge
if Output and Output.maxLines then
  maxlines = Output.maxLines
end
for line in f:lines() do
  maxlines = maxlines - 1
  if maxlines < 0 then
    break
  end
  print(line)
end

f:close()
