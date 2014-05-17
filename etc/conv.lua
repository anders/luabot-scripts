-- Usage: <from> to <to> conversions in English, such as 'conv seconds in a day   See 'convadd to add more conversions.
assert(type(arg[1]) == "string" and arg[1] ~= "", "Please input a conversion")

local s = arg[1]

local i, j
-- Be careful in the order of these, the more generic should go last.
if not j then
  i, j = s:find("=>", 1, true)
end
if not j then
  i, j = s:find("->", 1, true)
end
if not j then
  i, j = s:find(" in a ", 1, true)
end
if not j then
  i, j = s:find(" in an ", 1, true)
end
if not j then
  i, j = s:find(" per ", 1, true)
end
if not j then
  i, j = s:find(" to ", 1, true)
end
if not j then
  i, j = s:find(" as ", 1, true)
end
if not j then
  i, j = s:find("=", 1, true)
end
if not j then
  i, j = s:find(" in ", 1, true)
end
if not j then
  return false, "Unable to parse input for conversion"
end

local a = s:sub(1, i - 1)
local b = s:sub(j + 1)

local acountstr, aunit = a:match("^ *([-+]?[%d%.]*) *(%w+) *$")
local bcountstr, bunit = b:match("^ *([-+]?[%d%.]*) *(%w+) *$")
if not aunit or not bunit then
  return false, "Unable to parse units"
end

local nfrom
local unitfrom, unitto
local swapped = false
if acountstr == "" and bcountstr == "" then
  nfrom = 1
  unitfrom = aunit
  unitto = bunit
  swapped = true
elseif acountstr == "" then
  nfrom = tonumber(bcountstr)
  unitfrom = bunit
  unitto = aunit
  swapped = false
elseif bcountstr == "" then
  nfrom = tostring(acountstr)
  unitfrom = aunit
  unitto = bunit
  swapped = false
end

local settings = plugin.settings(io);

local convfile = "settings/conv.json"
io.fs.mkdir("settings");

local conv = settings.load(convfile)

local unitfromsingle = unitfrom:match("(.*)s$") or unitfrom
local unitfromplural = unitfromsingle .. "s"
local allfrom = { unitfrom, unitfromsingle, unitfromplural }
local unittosingle = unitto:match("(.*)s$") or unitto
local unittoplural = unittosingle .. "s"
local allto = { unitto, unittosingle, unittoplural }


-- What keys to lookup, but find the right units direction.
local allp = allfrom
local allq = allto
if unitto < unitfrom then
  allp, allq = allq, allp
end

local key
local foundkey
for i = 1, #allp do
  for j = 1, #allq do
    key = allp[i] .. "|" .. allq[j]
    if conv[key] then
      foundkey = true
      break
    end
  end
  if foundkey then
    break
  end
end

if not foundkey then
  for i = 1, #allfrom do
    if conv[allfrom[i]] then
      return etc.conv("" .. nfrom .. " " .. conv[allfrom[i]] .. " => " .. unitto), '@ ' .. unitfrom
    end
  end
  for i = 1, #allto do
    if conv[allto[i]] then
      return etc.conv("" .. nfrom .. " " .. unitfrom .. " => " .. conv[allto[i]]), '@ ' .. unitto
    end
  end
  return false, "Did not find a conversion from " .. unitfrom .. " to " .. unitto
end

local r
local x = conv[key]
if type(x) == "string" then
  local env = { string, math, tostring, tonumber, type, }
  -- Adding both names to simplify, but it's misleading.
  local code = "local " .. unitfrom .. "," .. unitto
    .. ",env=...;string=env.string;math=env.math;tostring=env.tostring;tonumber=env.tonumber;type=env.type;return "
    .. x
  -- print(code)
  local xx = assert(safeloadstring(code,
    "Conversion function for " .. unitfrom .. "_to_" .. unitto))(nfrom, nfrom, env);
  assert(type(xx) == "number", "Conversion function did not return a number")
  r = xx
else
  r = nfrom * x
  if swapped then
    r = nfrom / x
  end
end
return "" .. nfrom .. " " .. unitfrom .. " is " .. r .. " " .. unitto
