-- Usage: arg, stdin = etc.stdio_nofile(arg) - splits up the arg into separate arguments and standard input.
-- Unlike etc.stdio this does not create a string file. It also doesn't splitArgs
local argstr = assert(arg[1], "arg expected")[1]
local cmdline = argstr
local input = ""
if Input.piped then
  cmdline = argstr:sub(Input.piped + 1)
  input = argstr:sub(1, Input.piped)
end
return cmdline, input
