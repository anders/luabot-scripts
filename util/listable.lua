-- Usage: util.listable(list, create, decompose, listType) - list is an array of objects or a string of decomposed IDs, create is a function used to create an object, decompose will turn an object back into its ID, and listType is an optional type name for type checking.

-- Example: list=util.listable("55,66", function(x) return string.char(x) end, function(x) return string.byte(x) end); list:add("f") print(list:serialize())

local list, create, decompose, listType = ...

assert(type(list) == "string" or type(list) == "table", "Invalid list")

local lobj = { listType = listType or "unknown", create = create, decompose = decompose }

if type(list) == "string" then
    local i = 0
    for sid in list:gmatch("[^,]+") do
        local id = tonumber(sid)
        assert(id, "Unable to determine ID of " .. sid)
        i = i + 1
        lobj[i] = create(id)
    end
elseif type(list) == "table" then
    for i = 1, #list do
        lobj[i] = list[i]
    end
end

--- Return serialized string.
function lobj:serialize()
    local tstr = {}
    for i = 1, #self do
        tstr[#tstr + 1] = tostring(decompose(self[i]))
    end
    return table.concat(tstr, ",")
end

--- Find a object in this list by object. Returns the index.
--- Equality is determined by decomposed ID, or the provided comparer returning 0.
function lobj:find(object, comparer)
    local id = assert(decompose(object), "Unable to decompose object")
    if comparer then
      for i = 1, #self do
          if 0 == comparer(self[i], object) then
              return i
          end
      end
    else
      for i = 1, #self do
          if decompose(self[i]) == id then
              return i
          end
      end
    end
    return false
end

function lobj:_rawRemoveAt(i, wantChange)
  -- if i then
    local c = self[i]
    table.remove(self, i)
    if wantChange then
      self:onChange()
    end
    return c
  -- end
  -- return nil
end

--- Find and remove a object.
function lobj:remove(object)
    local i = self:find(object)
    if i then
      return self:_rawRemoveAt(i, true)
    end
    return nil
end

--- Remove object at the specified index.
function lobj:removeAt(i)
  return self:_rawRemoveAt(i, true)
end

--- testfunc called for each object, object removed if function returns true.
function lobj:removeIf(testfunc)
    local i = 1
    local changed = false
    while self[i] do
      repeat
        if testfunc(self[i]) then
          self:_rawRemoveAt(i, false)
          changed = true
        else
            i = i + 1
        end
      until true
    end
    if changed then
      self:onChange()
    end
end

-- Add. index is optional
function lobj:add(object, index)
  table.insert(self, index or (#self + 1), object)
  self:onChange()
end

--- Replace the object at the specified index. Does call onChange.
function lobj:replace(index, object)
  assert(self[index], "Cannot replace missing item")
  self[index] = object
  self:onChange()
end

--- Called when the list changes via add or remove methods. Override to extend behavior.
--- Note that the table.* functions or manually modifying the array do not trigger changes.
function lobj:onChange()
end

return lobj
