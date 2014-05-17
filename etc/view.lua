local s = arg[1]
local modules = {'etc', 'plugin', 'tests'}

if not s or #s == 0 then
  print("Usage: 'view [module.]func")
  return
end

local modname, funcname

local pos = s:find('%.')
if pos then
  modname = s:sub(1, pos - 1)
  funcname = s:sub(pos + 1)
else
  for _, v in ipairs(modules) do
    if _G[v][s] then
      modname = v
      break
    end
  end
  funcname = s
end

modname = modname or 'etc'
if not _G[modname] or not _G[modname][funcname] then
  print(('%s.%s doesn\'t exist'):format(modname, funcname))
  return
end

local today = os.date('!*t')

if today.month == 4 and today.day == 1 then
  print("Sorry, luabot is now closed source. No open source hippies here bls.")
  return
end

local function orlOncodo(orl)
  orl = urlEncode(orl)
  return (orl:gsub('%%5F', '_'))
end

local fn = _G[modname][funcname]
local codo = getCode(fn)
local ownor = getname(owner(fn))

local lonecnt = 1
for m in codo:gmatch('\n') do lonecnt = lonecnt + 1 end

print(boturl .. 't/view?module='..orlOncodo(modname)..'&name='..orlOncodo(funcname) .. ' (owned by ' .. ownor .. ', '..lonecnt..' lines)')