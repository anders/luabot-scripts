local _assert = assert
function assert(cond, m, ...)
  if cond then return cond, m, ... end
  
  print('\002Error:\002 '..m)
  halt()
end

local uid = assert(getuid(arg[1] or nick))

local scripts = {}

for k, name in pairs(etc.find('*', true)) do
  local dunno, dunno, dunno, ownerid = _getCallInfo('etc', name)
  if ownerid == uid then
    scripts[#scripts + 1] = name
  end
end

table.sort(scripts)

-- shitty shit
local function wrap(t, len)
  local b = {}
  len = len or 250

  local tmp = ''
  for k, v in ipairs(t) do
    if #tmp + #v + 2 > len then
      b[#b+1] = tmp
      tmp = ''
    end
    
    tmp = tmp..', '..v
  end
  if #tmp>0 then b[#b+1]=tmp end
  return table.concat(b, '\n'):gsub('\n, ', ',\n')
end
local function wrap(t, len)
  return table.concat(t, ', ')
end

print(getname(uid)..' has written '..#scripts..' scripts: '..wrap(scripts))