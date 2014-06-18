--[[
 filearray.lua - file with array-like interface.

 Example:
   local FA = require 'stringlua.filearray'
   local s = FA 'manual.html'
   print(s[100]) -- print 100th byte of file
   s:close()

 Note: access is buffered.
 
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

local SZBLOCK = 1024

local string_sub = string.sub
local table_concat = table.concat
local tostring = tostring

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
function mt:__len() return self.n end
function mt:__index(i)
  i = i - 1
  local ipos = i % SZBLOCK
  local iblock = (i - ipos) / SZBLOCK
  if self.iblock ~= iblock then
    self.fh:seek('set', iblock * SZBLOCK)
    self.block = self.fh:read(SZBLOCK)
    self.iblock = iblock
  end
  return string_sub(self.block, ipos+1, ipos+1)
end
function mt.__substring(bs,sb,se)
  local str = {}
  for p=1,se-sb+1 do str[p] = bs[sb+p-1] end
  return table_concat(str, '')
end

local function new(s)
  local self = setmetatable({block=false, iblock=false}, mt)
  if type(s) == 'string' then  -- convenience
    local fh, msg = io.open(s, 'rb')
    if not fh then return nil, msg end
    self.fh = fh
    self.n = self.fh:seek("end")
    self.owned = true
  elseif io.type(s) == 'file' then
    self.fh = s
    self.n = self.fh:seek("end")
    self.owned = false
  else
    assert(false)
  end
  function self:close()
    if self.owned then self.fh:close() end
    self.fh = nil
    self.owned = false
  end
  return self
end


return new
