-- local cb = plugin.cachebloom(Cache, "mybloom")
-- cb:add("hello")
-- if cb:test("hello") then ...

local _Cache = assert(arg[1], "Expected arg[1] = Cache")
local _name = assert(arg[2], "Expected arg[2] = name for Cache entry")
local _sig = arg[3] or 2
assert(_sig > 0, "Invalid sig")


local t = {}
t.Cache = _Cache
t.name = _name
t.sig = _sig


-- If test returns true, the key might exist.
-- If test returns false, the key does not exist.
function t:test(key)
  key = key:sub(1, self.sig)
  local x = self.Cache[self.name]
  if x then
    local i = 1
    while true do
      local a, b = x:find(key, i, true)
      if not b then
        -- break
        return false
      end
      --[[
      b = b + 1
      if x:sub(b, b) == '|' then
        return true
      end
      i = b
      --]]
      return true
    end
  end
  return false
end


function t:add(key)
  key = key:sub(1, self.sig)
  if not self:test(key) then
    local x = self.Cache[self.name]
    if not x then
      self.Cache[self.name] = key .. "|"
    else
      self.Cache[self.name] = x .. key .. "|"
    end
  end
end


function t:addKeys(object)
  for k, v in pairs(object) do
    self:add(k)
  end
end


function t:addTable(table)
  for i, v in ipairs(table) do
    self:add(v)
  end
end


return t
