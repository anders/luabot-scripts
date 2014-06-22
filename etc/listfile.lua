API "1.1"
-- Usage: etc.listfile(list) - Turn any list into a file! list is either an array or a function called back for each index starting at 1 until it returns nil/false. Returns a file object which can read through the list.

if type(arg[1]) == "string" then
  return _createStringFile(arg[1])
end

local getItem = arg[1]
if type(getItem) == "table" then
  local array = arg[1]
  local function _arrayfunc(i)
    return array[i]
  end
  getItem = _arrayfunc
end

return {
  _i = 0,
  read = function(self, fmt)
    if not self._i then
      return nil, "file is closed"
    end
    if not fmt or fmt == "*l" or fmt == "*L" then
      self._i = self._i + 1
      local line = getItem(self._i)
      if not line then
        return false
      end
      if fmt == "*L" then
        return line .. "\n"
      else
        return line
      end
    elseif fmt == "*a" then
      local t = {}
      while true do
        local ln = self:read("*L")
        if not ln then
          break
        end
        t[#t + 1] = ln
      end
      return table.concat(t)
    end
    return nil, "read format not supported on list file"
  end,
  write = function(self)
    return nil, "write on list file not allowed"
  end,
  close = function(self)
    self._i = nil
  end,
  seek = function(self)
    return nil, "not implemented"
  end,
}

