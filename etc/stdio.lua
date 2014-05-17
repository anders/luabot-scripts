-- Usage: arg, io.stdin = etc.stdio(arg) - splits up the arg into separate arguments and standard input.

local argstr = assert(arg[1], "arg expected")[1]
local cmdline = argstr
local input = ""
if Input.piped then
  cmdline = argstr:sub(Input.piped + 1)
  input = argstr:sub(1, Input.piped)
end
return etc.splitArgs(cmdline or ''), _createStringFile(input)
