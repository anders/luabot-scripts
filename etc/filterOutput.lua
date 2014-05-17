-- Combines 'x and 'getOutput
-- local foo = etc.filterOutput(...) -- now filter foo.

if type(arg[1]) == "function" then
  return etc.getOutput(...) or ""
elseif type(arg[1]) == "string" then
  if not arg[1]:find("'", 1, true) then
    return arg[1]
  else
    return etc.getOutput(etc.x, ...) or ""
  end
end
