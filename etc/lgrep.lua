-- Usage: 'lgrep string - similar to grep but using lua patterns.

local oldarg2 = arg[2]
arg, io.stdin = etc.stdio(arg)
local flags, needle, filepath = etc.getArgs(arg)

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

return etc.grepcore(file, needle, flags)
