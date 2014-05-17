-- Usage: 'grep string - similar to posix grep but with limitations.

local origflags
if type(arg[1]) == "table" then
  origflags = arg[1]
  for i = 2, #arg do
    arg[i - 1] = arg[i]
  end
end

local oldarg2 = arg[2]
arg, io.stdin = etc.stdio(arg)
local flags, needle, filepath = etc.getArgs(arg)
if origflags then
  flags = etc.mergetables(origflags, flags)
end

local fgrep = flags.F or flags["fixed-strings"] or oldarg2 == '-F'
flags.F = fgrep -- So that arg[2] == '-F' goes to grepcore.

local egrep = flags.E or flags["extended-regexp"] or oldarg2 == '-E'
flags.E = nil
flags["extended-regexp"] = nil

if fgrep and egrep then
  return error("Conflicting fgrep/egrep")
end

if not fgrep then
  needle = needle:gsub("[%-%%]", "%%%1")
  if egrep then
    assert(not needle:find("[^\\]%{"), "Sorry { not supported")
    assert(not needle:find("[^\\]%|"), "Sorry | not supported")
    assert(not needle:find("[^\\]%("), "Sorry ( not supported")
  else
    assert(not needle:find("\\%{", 1, true), "Sorry \\{ not supported")
    needle = needle:gsub("[%+%?%(%)]", "%%%1") -- These are literal when not egrep.
  end
  needle = needle:gsub("\\(.)", function(x)
    if x == "^" or x == "$" or x == "[" or x == "]" or x == "." or x == "*" then
      return "%" .. x
    end
    -- Other than the above, backslash ignored.
    return ""
  end)
end

local file = io.stdin
local closefile = false
if type(oldarg2) == "table" and oldarg2.read then
  assert(not filepath, "Argument not expected: " .. tostring(filepath))
  file = oldarg2
else
  if filepath and filepath ~= "-" then
    file = assert(etc.userfileopen(filepath))
    closefile = true
    file.grepGetFilePath = function(self)
      return filepath
    end
  else
    file.grepGetFilePath = function(self)
      return "(standard input)"
    end
  end
end

etc.grepcore(file, needle, flags)
if closefile then
  file:close()
end
