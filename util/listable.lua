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

--- Find and remove a object.
function lobj:remove(object)
    local i = self:find(object)
    if i then
      local c = h[i]
      table.remove(h, i)
      return c
    end
    return nil
end

--- testfunc called for each object, object removed if function returns true.
function lobj:removeif(testfunc)
    local i = 1
    while h[i] do
      repeat
        if testfunc(h[i]) then
          self:remove(i)
        else
            i = i + 1
        end
      until true
    end
end

return lobj
