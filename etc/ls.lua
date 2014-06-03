API "1.1"

local path = arg[1] or '.'

local files
if type(path) == "table" then
  files = path
else
  if _apiver == 1.0 then
    local fs
    local u, p = path:match("^/user/([^/]+)(/?.*)")
    if u then
      fs = assert(getUserFS(u))
      if p == "" then
        p = "/"
      end
      path = p
      -- print("DEBUG:", "looking for", path)
      files = assert(fs.glob(path))
      if files and #files > 0 then
        for i, v in ipairs(files) do
          files[i] = "/user/" .. u .. v
        end
      end
    else
      fs = assert(getUserFS(nick))
      files = assert(fs.glob(path))
    end
  else
    local fs = guestloadstring("return io.fs")()
    if path:sub(1, 1) ~= '/' then
      -- If relative, relative to this user's home.
      path = "/user/" .. nick .. "/home/" .. path
    end
    files = assert(fs.glob(path))
  end
end
table.sort(files)

local colsize = 0
local colspace = 2
local prefwidth = 100

for i, v in ipairs(files) do
  if v:len() > colsize then
    colsize = v:len()
  end
end

local ncols = math.floor(prefwidth / (colsize + colspace))
if ncols < 1 then
  ncols = 1
end

if not Output or not Output.tty then
  ncols = 1
end

local line = nil
local oncol = 1
for i, v in ipairs(files) do
  local x = v
  if oncol < ncols then
    x = x .. (' '):rep((colsize - v:len()) + colspace)
  end
  if line then
    line = line .. x
  else
    line = x
  end
  if oncol >= ncols then
    oncol = 0
    print(line)
    line = nil
  end
  oncol = oncol + 1
end
if line then
  print(line)
  line = nil
end
