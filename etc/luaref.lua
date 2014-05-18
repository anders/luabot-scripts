-- Usage: [lib.]function in stock Lua (only functions for now)
local baselib = require 'baselib'

baselib._G.childs = {}
for k, v in pairs(baselib) do
  baselib._G.childs[k] = v
end

local format = function(t)
  if t.type == "function" then
    return t.args.." -> "..t.returns
  else
    return ": (sorry) "..t.type.." is not yet handled"
  end
end

local lookup = arg[1]
if not lookup then
  return false, "See 'help 'luaref."
end

if not lookup:find("%.") then
  lookup = "_G."..lookup
end

local parent, child = lookup:match("([a-zA-Z0-9_]+)%.([a-zA-Z0-9_]+)")
if not parent then
  return false, "Invalid format."
end

local a = baselib[parent]
if not a then return false, parent.." not in baselib" end

local b = a.childs[child]
if not b then return false, child.." not in "..parent end

lookup = lookup:gsub("^_G%.", "")
return lookup..format(b)
