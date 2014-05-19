local a, b = ...
if not a then
  if b then
    b = tostring(b)
    setLastError("Function returned " .. tostring(a) .. ": " .. b) -- THIS MAY GET MOVED to getOutput or on_cmd!
    return "Error: " .. b
  end
end
-- return ...
-- Prevent tail call so we can read traceback.
return select(1, ...)
