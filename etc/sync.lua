if not Web then
  error 'this is a Wob page'
end

local json = require 'json'

Web.header 'Content-Type: application/json'

local modules = {'etc', 'plugin', 'tests'}

if Web.GET['module'] and Web.GET['function'] then
  local found = false
  for _, modname in ipairs(modules) do
    if modname == Web.GET['module'] then
      found = true
      break
    end
  end
  
  if not found then
    Web.write(json.encode{success = false, error = 'no such module'})
    return
  end
  
  local f = _G[Web.GET['module']][Web.GET['function']]
  if not f then
    Web.write(json.encode{success = false, error = 'no such function'})
    return
  end
  
  Web.write(assert(json.encode{
    success = true,
    owner = getname(owner(f)),
    code = getCode(f)
  }))
else
  local t = {}
  -- list all available scripts
  for _, modname in ipairs(modules) do
    local mod = _G[modname]
    t[modname] = t[modname] or {}
    for _, funcname in ipairs(mod.find('*', true)) do
      local tt = t[modname]
      tt[#tt + 1] = funcname
    end
  end
  Web.write(assert(json.encode{
    success = true,
    scripts = t
  }))
end
