local code = etc.getOutput(etc.code, ...)
local nlines = 0
local icode = 1
code = ("\n" .. code):gsub("\n--[^\n]*", "")
code = code:gsub("\n\n+", "\n")
code = code:gsub("[\t ]+", " ")
code = code:match("\n*(.*)")
while true do
  local ilf = code:find("\n", icode, true)
  if not ilf then
    break
  end
  nlines = nlines + 1
  icode = ilf + 1
end
local wrapflags = { maxLines = arg[2] or Output.maxLines or 4 }
if nlines > wrapflags.maxLines then
  wrapflags.m = true
end
return etc.wrap(code, wrapflags)
