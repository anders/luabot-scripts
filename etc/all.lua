local foo = arg[1] -- function or name of function
local all = arg[2] -- table or assumes current nicks
local delim = arg[3] or "; " -- delimiter
local fmt = arg[4] or "\002%n\002: %s" -- format of each entry
local plain = arg[5]

Output.brief = true -- Please check for this and make your output brief :D

if not foo or Help then
  print("'all <function> runs the function on all nicks")
  if Help then Help.handled = true end
  return
end

if not all then
  if chan then
    all = nicklist()
  else
    all = { nick }
  end
end

local func
local extra
if type(foo) == "function" then
  func = foo
elseif type(foo) == "string" then
  local a, b = foo:match("^([^ ]+) (.+)$")
  if b then
    foo = a
    extra = b
  end
  if foo:sub(1, 1) ~= "'" then
    func = _G[foo]
    assert(func, "Function not found: _G." .. foo:gsub("%.", "-"))
  else
    foo = foo:sub(2)
    func = etc[foo]
    assert(func, "Function not found: '" .. foo)
  end
end
local result = ""
for i, n in ipairs(all) do
  if type(n) ~= "string" then
    n = tostring(n)
  end
  local r, s, serr
  if extra then
    r, s = pcall(etc.getOutput, true, func, extra, n)
  else
    r, s = pcall(etc.getOutput, true, func, n)
  end
  if s then
    s = tostring(s):gsub("[\r\n]", "")
    local x = fmt
    -- assert(type(x) == "string", "x is not a string, it's a " .. type(x))
    -- assert(type(s) == "string", "s is not a string, it's a " .. type(s))
    x = x:gsub("%%n", n:gsub("%%", "%%%%") or '')
    x = x:gsub("%%s", s:gsub("%%", "%%%%") or '')
    
    if result ~= "" then
      result = result .. delim
    end
    result = result .. x
  end
end
-- if not plain and print ~= directprint then
if not plain then
  return etc.nonickalert(result)
end
return result
