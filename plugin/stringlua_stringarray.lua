--[[
 stringarray.lua - string with array-like interface.

 Example:
   local SA = require 'stringlua.stringarray'
   local s = SA 'test'
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

local mt = {}
function mt:__tostring() return self.s end
function mt.__eq(a,b) return a.s == b.s end
function mt:__len() return #self.s end
function mt:__substring(sb,se) return string_sub(self.s,sb,se) end
function mt:__index(i)
  return i <= #self.s and string_sub(self.s, i, i) or nil
end

local function new(s)
  assert(type(s) == 'string')
  return setmetatable({s=s}, mt)
end

return new