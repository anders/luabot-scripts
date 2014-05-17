local s = arg[1]
local modules = {'etc', 'plugin', 'tests'}

if not s or #s == 0 then
  print("Usage: 'edit [module.]func")
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

modname = modname or modules[1]

if not _G[modname][funcname] then
  print(('%s.%s doesn\'t exist, use \'create instead'):format(modname, funcname))
  return
end

if getuid() ~= owner(_G[modname][funcname]) then
  action = 'view'
else
  action = 'edit'
end

local url = boturl .. 't/' .. action .. '?module='..urlEncode(modname)..'&name='..urlEncode(funcname)
if action == 'view' then
  url = '(read only) '..url
end
sendNotice(nick, url)