-- Usage: 'hsize 7129393 gets the human-readable size

local div = arg[2] or 1000

-- local mags = { "K", "M", "G", "T", "P", "E", "Z", "Y" }
local mags = div == 1024 and { "Ki", "Mi", "Gi", "Ti", "Pi", "Ei", "Zi", "Yi" } or { "k", "M", "G", "T", "P", "E", "Z", "Y" }

local n = tonumber(arg[1]) or 0

if n < div then
  return math.floor(n * 100 + 0.5) / 100, ''
end

local i = 0
while n >= div do
  i = i + 1
  n = n / div
end
return math.floor(n * 100 + 0.5) / 100, (mags[i] or ('' .. div .. '^' .. i))
