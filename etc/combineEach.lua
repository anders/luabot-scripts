local src = arg[1] or ""
local combine = arg[2] or ""
local skipPat = arg[3] or "%s"

local t = {}
for ch in etc.codepoints(src) do
  table.insert(t, ch)
  if not ch:find(skipPat) then
    table.insert(t, combine)
  end
end
return table.concat(t)
