local input = assert(arg[1], "wut?")

local hex = { '0', '1', '2', '3', '4', '5', '6', '7',
  '8', '9', 'a', 'b', 'c', 'd', 'e', 'f' }
local function dumbhash(s)
  local x = {}
  for i = 1, 32 do
    x[i] = (i % 16) + 1
  end
  local g = s:len()
  for rep = 1, math.min(math.max(5, g), 10) do
    for i = 1, s:len() do
      local v = string.byte(s, i, i)
      local a, b = v % 32 + 1, g % 32 + 1
      x[a], x[b] = x[b], x[a]
      x[i % 32 + 1] = (a + b + i) % 16 + 1
      g = g + v
    end
  end
  for i = 1, 32 do
    x[i] = hex[x[i]]
  end
  return table.concat(x)
end

local n = 0
for orig in input:gmatch("[^|]+") do --------
n = n + 1

local first = dumbhash(orig)
local second = dumbhash(first)

local function matchlen(a, apos, b, bpos)
  local alen = a:len()
  local blen = b:len()
  local len = 0
  while apos <= alen and bpos <= blen do
    local ca = a:sub(apos, apos)
    local cb = b:sub(bpos, bpos)
    if ca ~= cb then
      break
    end
    len = len + 1
    apos = apos + 1
    bpos = bpos + 1
  end
  return len
end

local longlen = 0
local longlenPosA = 0
local longlenPosB = 0
for i = 1, 32 do
  for j = 1, 32 do
    local len = matchlen(first, i, second, j)
    if len > longlen then
      longlen = len
      longlenPosA = i
      longlenPosB = j
    end
  end
end

local function hilite(s, pos, len)
  return s:sub(1, pos - 1)
    .. "\022" .. s:sub(pos, pos + len - 1) .. "\022"
    .. s:sub(pos + len)
end

if longlen == 0 or n <= 1 or longlen >= 3 or (n == 2 and longlen == 2) then
  if longlen > 0 then
    local after = " (" .. orig .. ")"
    if n <= 1 then
      after = ""
    end
    print(nick .. " * your match is " .. longlen .. " long: "
      .. hilite(first, longlenPosA, longlen)
      .. " ~ " .. hilite(second, longlenPosB, longlen)
      .. after)
  else
    print(nick .. " * no match, that's strange: " .. first .. " ~ " .. second)
  end
end

end --------
