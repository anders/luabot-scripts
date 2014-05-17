-- Usage: <n> <unit1> = <m> <unit2>   Adds a conversion from unit1 to unit2. Or simply add a different spelling or abbreviation via: <unit1> = <unit2> (any order)

local nstr, unit1, mstr, unit2 = (arg[1] or ''):match("^([-+]?[%d%.]*) *(%w+) *= *([-+]?[%d%.]*) *(%w+)$")
local misfunc = false
if not unit2 then
  nstr, unit1, mstr, unit2 = (arg[1] or ''):match("^([-+]?[%d%.]*) *(%w+) *= *(%b()) *(%w+)$")
  misfunc = true
  -- print("Function parse:", nstr, unit1, mstr, unit2)
end
assert(unit2, "Syntax error, " .. etc.getOutput(etc.help, "etc.convadd"))
local n = tonumber(nstr)
local m = tonumber(mstr)
if nstr == "" then
  n = 1
end
if mstr == "" then
  m = 1
end
assert(unit1 ~= unit2, "The units are the same...")

local settings = plugin.settings(io);

local convfile = "settings/conv.json"
io.fs.mkdir("settings");

local conv = settings.load(convfile)
local dirty = false

if unit2 < unit1 then
  -- Ensure we only need to store one direction.
  unit1, unit2 = unit2, unit1
  n, m = m, n
end

if n and n == m then
  -- Abbreviation.
  if conv[unit1] then
    if conv[unit2] then
      return false, "Both units are set"
    end
    conv[unit2] = unit1
  else
    conv[unit1] = unit2
  end
  dirty = true
  print("Done. " .. unit1 .. " = " .. unit2)
else
  if conv[unit1 .. "|" .. unit2] then
    directprint("etc.convadd: overwriting 1 " .. unit1 .. " = " .. conv[unit1 .. "|" .. unit2] .. " " .. unit2)
  end
  assert((n and m) or (n and misfunc), "Number of units missing (n or m)")
  assert(n == n and m == m, "NaN not allowed")
  assert(n ~= 0 and m ~= 0, "Conversion to/from 0 not allowed")
  assert(n ~= math.huge and n ~= -math.huge and m ~= math.huge and m ~= -math.huge, "Infinity not allowed")
  assert(not misfunc or n == 1, "If specifying a function, n for first unit must be 1")
  if misfunc then
    conv[unit1 .. "|" .. unit2] = mstr
    dirty = true
    print("Done. " .. n .. " " .. unit1 .. " = " .. mstr .. " " .. unit2)
  else
    -- Reduce n to 1.
    m = m / n
    n = 1
    conv[unit1 .. "|" .. unit2] = m
    dirty = true
    print("Done. " .. n .. " " .. unit1 .. " = " .. m .. " " .. unit2)
  end
end

if dirty then
  settings.save(convfile, conv)
end
