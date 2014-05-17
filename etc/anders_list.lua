os = type(arg[1]) == 'table' and arg[1] or os

local list = {}

function basename(f)
  return (f:match('.*/(.+)$'))
end

function fill(t, path)
  local files = os.list(path, 'f')

  for k, v in pairs(files) do
    t[#t + 1] = basename(v)
  end

  local dirs = os.list(path, 'd')
  for k, v in pairs(dirs) do
    t[basename(v)] = fill({}, v)
  end

  return t
end

fill(list, '/')

if Web then
  function print(...)
    local tmp = {}
    for i=1, select('#', ...) do
      tmp[#tmp+1] = tostring(select(i, ...))
    end
    Web.write(table.concat(tmp, ' ')..'\n')
  end
end
etc.print_table(list)
