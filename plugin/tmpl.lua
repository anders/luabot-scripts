-- Simple Lua template engine.
-- based on https://github.com/torhve/LuaWeb/blob/master/tirtemplate.lua

--[[

Usage:

local tmpl = require 'tmpl'
local code = tmpl.compile(tmplsrc)
local fun = loadstring(code)
local output = fun()

Syntax:

{{ expr }} - Evaluate expression.
{% code %} - Run code

Can use function "out()" to add more stuff to buffer.
htmlescape(s) for escaping html

Everything else is returned as is.

]]


--[===[
local test_data = [[
Here is some text, random number: {{ math.random(1, 100) }} {% for i=1, 10 do print("HEJ") end %}
]]

local source = arg[1] or test_data
--]===]

-----------------------------

local tmpname = "_TmPlOuT" -- Something "unique"

local handlers = {
  ["{%"] = function(code)
    return code
  end,
  ["{{"] = function(code)
    return ("%s[#%s+1]=tostring(%s)"):format(tmpname, tmpname, code)
  end,
  [""] = function(text)
    if #text == 0 then return "" end
    return ("%s[#%s+1]=%q"):format(tmpname, tmpname, text):gsub("\\\n", "\\n")
  end
}

local compile = function(template, loadstring)
  local gen = {
    ("local %s = {}"):format(tmpname),
    ("local out = function(s) %s[#%s+1] = s end"):format(tmpname, tmpname),
    "local htmlescape = function(s) return (s:gsub('&', '&amp;'):gsub('<', '&lt;'):gsub('>', '&gt;')) end"
  }
  template = template..'{}'

  for plain, special in template:gmatch("([^{]-)(%b{})") do
    local handler = handlers[special:sub(1, 2)]
    if handler then
      gen[#gen + 1] = handlers[""](plain)
      gen[#gen + 1] = handler(special:sub(3, -3))
    else
      gen[#gen + 1] = handlers[""](plain)
      if #special > 2 then
        gen[#gen + 1] = handlers[""](special)
      end
    end
  end

  gen[#gen + 1] = ("return table.concat(%s)"):format(tmpname)

  return table.concat(gen, "\n")
end

return {
  compile = compile
}
