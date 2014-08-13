-- Usage: util.listable(list, create, decompose, type) - list is an array of objects or a string of decomposed IDs, create is a function used to create an object, decompose will turn an object back into its ID, and type is an optional type name for type checking.

-- Note: this is not finished or tested yet.

assert(type(list) == "string" or type(lits) == "table", "Invalid list")

local lobj = { type = type or "unknown", create = create, decompose = decompose }

if type(list) == "string" then
    local i = 0
    for sid in list:match("[^,]+") do
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
    for i = 1, #list do
        tstr[#tstr + 1] = tostring(decompose(list[i]))
    end
    return table.concat(tstr, ",")
end

--- Find a object in this list by object or index. Returns the index.
--- Equality is determined by decomposed ID, or the provided comparer returning 0.
function lobj:find(object, comparer)
    if type(object) == "number" then
      return object -- Index.
    end
    local id = assert(decompose(object), "Unable to decompose object")
    if comparer then
      for i = 1, #list do
          if 0 == comparer(list[i], object) then
              return i
          end
      end
    else
      for i = 1, #list do
          if decompose(list[i]) == id then
              return i
          end
      end
    end
    return false
end

function lobj:_rawRemove(object, wantChange)
  local i = self:find(object)
  if i then
    local c = h[i]
    table.remove(h, i)
    if wantChange then
      self:onChange()
    end
    return c
  end
  return nil
end

--- Find and remove a object.
function lobj:remove(object)
    return self:_rawRemove(object, true)
end

--- testfunc called for each object, object removed if function returns true.
function lobj:removeif(testfunc)
    local i = 1
    local changed = false
    while h[i] do
      repeat
        if testfunc(h[i]) then
          self:_rawRemove(i, false)
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
