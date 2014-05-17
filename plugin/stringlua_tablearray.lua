--[[
 tablearray.lua - table with array-like interface.

 Example:
   local TA = require 'stringlua.tablearray'
   local s = TA {'t', 'e', 's', 't'}
   assert(s[3] == 's') -- access third element
   local s = TA 'test' -- equivalent to above
   assert(s[3] == 's') -- access third element
 
  LICENSE
  
  (c) 2008-2011 David Manura.  Licensed under the same terms as Lua (MIT).
  This is based directly on lstrlib.c in Lua 5.1.4.
  Copyright (C) 1994-2008 Lua.org, PUC-Rio.

  Permission is hereby granted, free of charge, to any person obtaining a copy
  of this software and associated documentation files (the "Software"), to deal
  in the Software without restriction, including without limitation the rights
  to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
  copies of the Software, and to permit persons to whom the Software is
  furnished to do so, subject to the following conditions:

  The above copyright notice and this permission notice shall be included in
  all copies or substantial portions of the Software.

  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
  IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
  FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT.  IN NO EVENT SHALL THE
  AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
  LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
  OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
  THE SOFTWARE.
  (end license)
 
--]]


local string_sub = string.sub
local table_concat = table.concat

local mt = {}
function mt:__tostring()
  local ts = {}
  for i=1,self.n do ts[#ts+1] = tostring(self[i]) end
  return table_concat(ts)
end
function mt.__eq(a,b)
  if a.n ~= b.n then return false end
  for i=1,a.n do
    if a[i] ~= b[i] then return false end
  end
  return true
end
function mt:__len()
  return self.n
end
function mt.__substring(bs,sb,se)
  local str = setmetatable({}, mt)
  local l = se-sb+1
  for p=1,l do str[p] = bs[sb+p-1] end
  str.n = l
  return str
end

local function new(s)
  local self
  if type(s) == 'string' then  -- convenience
    self = setmetatable({}, mt)
    for i=1,#s do self[i] = string_sub(s, i, i) end
    self.n = #s
  elseif type(s) == 'table' then
    s.n = #s  -- rawlen before setting metatable
    self = setmetatable(s, mt)
  else
    assert(false)
  end
  return self
end

return new