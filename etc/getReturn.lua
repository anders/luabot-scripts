local a, b = ...
if not a then
  if b then
    return "Error: " .. tostring(b)
  end
end
-- return ...
-- Prevent tail call so we can read traceback.
return select(1, ...)
