-- Usage: 'alias from to

-- return etc.todo("54")

if etc.alias_impl then
  return etc.alias_impl(...)
end

if not arg[1] then
  return nil, etc.getReturn(etc.help("'alias"))
end

local a, b = (arg[1] or ''):match("^([^ ]+) ([^ ]+)")
if not a or not b then
  return nil, "Unable to figure out the alias stuff... " .. etc.getReturn(etc.help("'alias"))
end

local existf
local newn
local modname = "etc"

if etc[a] then
  if etc[b] then
    return nil, "Both " .. modname .. "." .. a .. " and " .. modname .. "." .. b .. " exist"
  end
  existf = a
  newf = b
else
  if not etc[b] then
    return nil,  "Neither " .. modname .. "." .. a .. " nor " .. modname .. "." .. b .. " exist"
  end
  existf = b
  newf = a
end

local action = 'alias'
local url = boturl .. 't/' .. action .. '?module='..urlEncode(modname)..'&name='..urlEncode(newf)
  .. '&of=' .. existf
sendNotice(nick, url)
