-- Usage: arg, io.stdin = etc.stdio(arg) - splits up the arg into separate arguments and standard input.

local LOG = plugin.log(_funcname);

local argstr = assert(arg[1], "arg expected")[1]
local cmdline = argstr
local input = ""
if Input.piped then
  cmdline = argstr:sub(Input.piped + 1)
  input = argstr:sub(1, Input.piped)
end
local arg = etc.splitArgs(cmdline or '')
for i = 1, #arg do
  local x = arg[i]:gsub("\\.", "x")
  if x:find("[%{%*%?]") then
    LOG.warn("File globs not supported yet")
  end
end
return arg, _createStringFile(input)
