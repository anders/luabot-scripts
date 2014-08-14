API "1.1"
-- Usage: util.idAllocator(serialized) - definitions is nil for a new allocator, or a string returned by the serialized allocator.

local idalloc = { ids = {}, lastID = 0 }

if type(arg[1]) == "string" then
  for k, v in arg[1]:gmatch("([^&=]+)=([^&]*)") do
    local x = tonumber(urlDecode(v))
    idalloc.ids[urlDecode(k)] = x
    if x and x > idalloc.lastID then
      idalloc.lastID = x
    end
  end
end

--- Get the ID for the specified item. demand is true by default.
function idalloc:get(item, demand)
  local x = self.ids[item]
  if not x then
    if demand ~= false then
      assert(type(item) == "string", "Item must be a string")
      x = self.lastID + 1
      self.lastID = x
      self.ids[item] = x
      self:onChange()
    end
  end
  return x
end

---
function idalloc:serialize()
  local ts = {}
  for k, v in pairs(self.ids) do
    if #ts > 0 then
      ts[#ts + 1] = "&"
    end
    ts[#ts + 1] = urlEncode(k)
    ts[#ts + 1] = "="
    ts[#ts + 1] = urlEncode(tostring(v))
  end
  return table.concat(ts, "")
end

--- Called when a new ID found or one is removed. Override to extend behavior.
function idalloc:onChange()
end

return idalloc
