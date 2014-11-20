local maxlines = math.huge
if Output and Output.maxLines then
  maxlines = Output.maxLines
end
local wantSwitches = true
arg, io.stdin = etc.stdio(arg)

local function getFS(path)
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
  return fs
end

local function xfile(path)
  local f
  if type(path) == "string" then
    if path == "--" then
      wantSwitches = false
      return
    elseif path == "-" then
      f = io.stdin
    else
      if wantSwitches and path:sub(1, 1) == "-" then
        error("Unknown switch " .. path)
      end
      local fs = getFS(path);
      f = assert(etc.userfileopen(path, 'r', true, fs))
    end
  end
  for line in f:lines() do
    maxlines = maxlines - 1
    if maxlines < 0 then
      break
    end
    print(line)
  end
  if f ~= io.stdin then
    f:close()
  end
end

if #arg == 0 then
  xfile("-")
else
  for ipath, path in ipairs(arg) do
    xfile(path)
  end
end
