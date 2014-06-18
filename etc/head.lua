-- Usage: 'head <filename> or pipe in via |'head
local maxlines = 10
if Output.maxLines < maxlines then
  maxlines = Output.maxLines
end
if type(arg[1]) ~= "string" then
  error("No input to head")
end
if Input and Input.piped then
  for line in arg[1]:gmatch("[^\r\n]+") do
    maxlines = maxlines - 1
    if maxlines < 0 then
      break
    end
    print(line)
  end
else
  Input = Input or {}
  local _omaxlines = Output.maxLines
  Output.maxLines = maxlines
  local result = etc.cat(...)
  Output.maxLines = _omaxlines
  return result
end
