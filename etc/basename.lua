if arg[2] == 2 then
  -- Python style.
  local x = (arg[1] or ''):match("([^/]*)$")
  return x
end

-- Nix style:
local x = (arg[1] or ''):match("([^/]*)/*$")
return x
