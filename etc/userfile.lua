-- Usage: etc.userfile(name) returns path,err given the user-specified file name. If name starts with ' then it's considered to be user code. Also see etc.userfileopen.

local LOG = plugin.log(_funcname);

LOG.debug(tostring(arg[1]))

local name = arg[1]
if not name then
  LOG.debug("->", "nil")
  return nil, "File name expected"
end
local user = arg[2] or nick

local firstch = name:sub(1, 1)

-- Uses ' hardcoded, otherwise / conflicts with the FS!
if firstch == "'" then
  local func, funcname = etc.parseFunc(name)
  if not func then
    return func, funcname
  end
  local sx = "/pub/scripts/" .. funcname:gsub("%.", "/") .. ".lua"
  LOG.debug("->", sx)
  return sx
end

if firstch == "/" then
  LOG.debug("->", name)
  return name
end

local ux = "/user/" .. user .. "/home/" .. name
LOG.debug("->", ux)
return ux
