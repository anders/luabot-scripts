API "1.1"
-- Usage: <FROM>, <TO>, [io] - Move a file

if not arg[2] then
  arg = etc.stdio(arg)
end

local from = assert(arg[1], "FROM needed")
local to = assert(arg[2], "TO needed")
local io = arg[3] or assert(godloadstring("return io"))()

local toattr = io.fs.attributes(to)
if toattr then
  if toattr.mode == 'directory' then
    local fromfile = from:match("([^/]+)/*$")
    if fromfile then
      to = to .. "/" .. fromfile
    end
  end
end

return io.fs.rename(from, to)
