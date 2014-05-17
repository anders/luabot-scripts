local func = arg[1]
assert(type(func) == "function" or type(func) == "number")

if not _printstack or #_printstack == 0 then
  return false
end

if func == print or func == #_printstack + 1 then
  print = _printstack[#_printstack]
  _printstack[#_printstack] = nil
  return true
end

if type(func) == "function" then
  for i = #_printstack, 1, -1 do
    if _printstack[i] == func then
      -- func to stack number.
      func = i
      break
    end
  end
end

if type(func) == "number" then
  assert(func > 1) -- Can't remove the first.
  if func >= 1 and func <= #_printstack then
    for i = #_printstack, func, -1 do
      _printstack[i] = nil
    end
    print = _printstack[func - 1]
    _printstack[func - 1] = nil
    return true
  end
  return false
end

return false

