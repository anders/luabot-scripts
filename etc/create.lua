local s = arg[1]

if not s or #s == 0 then
  print("Usage: 'create [module.]func")
  return
end

local modname, funcname

local pos = s:find('%.')
if pos then
  modname = s:sub(1, pos - 1)
  funcname = s:sub(pos + 1)
else
  modname = 'etc'
  funcname = s
end

if modname ~= 'etc' and modname ~= 'plugin' and modname ~= 'tests' then
  sendNotice(nick, 'invalid module')
  return
end

if _G[modname][funcname] then
  sendNotice(nick, ('%s.%s already exists, use \'edit instead'):format(modname, funcname))
  return
end

sendNotice(nick, boturl .. 'create?module='..urlEncode(modname)..'&name='..urlEncode(funcname))
