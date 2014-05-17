local t = arg[1]
if not t or tonumber(t) then
  if tonumber(t) then
    t = etc.randomDefinition(nil, nil, nil, tonumber(t))
  else
    t = etc.randomDefinition(nil, nil, nil, 4)
  end
elseif type(t) == "string" then
  t = { { t } }
elseif type(t) ~= "table" then
  error("Not expecting " .. tostring(t))
end

local firstwords = {}
local lookup = {}

local index = 0
for itt, tt in ipairs(t) do
  local s
  for j = 1, #tt do
    if type(tt[j]) == "string" then
      if not s or tt[j]:len() > s:len() then
        s = tt[j]
      end
    end
  end
  assert(s, "Cannot find a string in table")
  local first = true
  for before, w in s:gmatch("()([a-zA-Z0-9%-']+)") do
    index = index + 1
    local lw = w:lower()
    local yt = lookup[lw]
    local entry = { s, before, index }
    if yt then
      table.insert(yt, entry)
    else
      lookup[lw] = { entry }
    end
    if first then
      first = false
      table.insert(firstwords, lw)
    end
  end
end

-- print(etc.t(firstwords))
-- print(etc.t(lookup))

local result = {}
-- local third = math.floor(index / #t / 3)
local lw = firstwords[math.random(#firstwords)]
while true do
  local yt = lookup[lw]
  if not yt or #yt == 0 then
    -- error("Cant find " .. lw)
    break
  end
  local entryindex = math.random(#yt)
  local entry = yt[entryindex]
  yt[entryindex] = yt[#yt - 1]
  table.remove(yt, #yt - 1)
  local w, tafter, wnext = entry[1]:match("([a-zA-Z0-9%-']+)([^a-zA-Z0-9]*)([a-zA-Z0-9%-']*)", entry[2])
  if not w or not tafter then
    error("Couldn't find info? " .. entry[1] .. " (" .. entry[2] .. ")")
  end
  table.insert(result, w)
  table.insert(result, tafter)
  if not wnext or wnext:len() == 0 then
    break
  end
  lw = wnext:lower()
end

-- print(table.concat(result))
return table.concat(result)
