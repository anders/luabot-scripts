-- It's fun.

local s = arg[1]
if not s then return end

local result = ""
local allx, allxU = {}, {}
local all  = { 'a', 'o', 'u', 'å', 'e', 'i', 'ä', 'ö' }
for k, v in ipairs(all) do allx[v] = true end
local allU = { 'A', 'O', 'U', 'Å', 'E', 'I', 'Ä', 'Ö' }
for k, v in ipairs(allU) do allxU[v] = true end

for i = 1, s:len() do
  local ch = s:sub(i, i)
  if allx[ch] then
    result = result .. pickone(all)
  elseif allxU[ch] then
    result = result .. pickone(allU)
  else
    result = result .. ch
  end
end
return result
