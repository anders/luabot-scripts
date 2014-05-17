local s = arg[1]
local to = arg[2]
local from

if not s then
  return
end
if to == 'F' then
  from = 'C'
elseif to == 'C' then
  from = 'F'
else
  assert(false, 'arg[2] expected')
end


local result, nmatches
if arg[1] then
  arg[1] = arg[1]:gsub("\226\132\131", "\194\176C")
  result, nmatches = arg[1]:gsub("(%-?%d[%d%.]*)( *\194?\176? *)" .. from, function(x, y)
    local t = tonumber(x)
    if not t then
      return x .. y
    end
    local orig = x .. y .. from
    local conv
    if to == 'C' then
      conv = "" .. ((5.0 / 9.0) * (t - 32)) .. y .. to
    elseif to == 'F' then
      conv = "" .. (((9.0 / 5.0) * t) + 32) .. y .. to
    end
    -- return conv -- douche baggery
    return orig .. " (" .. conv .. ")"
  end)
end


return result
