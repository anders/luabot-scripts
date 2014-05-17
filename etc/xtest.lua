-- arg[1] = "'strike'weather"
if arg[1] then
  local a, b = arg[1]:match("^('[^ ]+) ?(.*)")
  if a then
    local t = {}
    for name in a:gmatch("'([^']+)") do
      table.insert(t, name)
    end
    if b and b:len() == 0 then
      b = nil
    end
    local c = [[local ssss = select(1, ...); local tttt;
local ssssprint = print;
local function x4print(...)
  if not ssss then
    local s = ""
    for i = 1, select('#', ...) do
      if i > 1 then
        s = s .. " "
      end
      s = s .. tostring(select(i, ...))
    end
    if s:len() > 0 then
      ssss = s
    end
  end
end
print = x4print
]]
    for i = #t, 1, -1 do
      local name = t[i]
      -- c = c .. "tttt=ssss;ssss=nil;tttt=etc." .. name .. "(tttt);ssss=ssss or tttt;\n"
      c = c .. "tttt=ssss;ssss=nil;x4print(etc." .. name .. "(tttt))\n"
    end
    c = c .. "print=ssssprint;print('xD '..ssss)"
    -- if arg[1] == "'strike'weather" then print("DEBUG", c) end
    -----{
    local f = assert(io.open("x.code", 'w'))
    f:write(c)
    f:close()
    -----}
    return assert(loadstring(c))(b)
  end
end
