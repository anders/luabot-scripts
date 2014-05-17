-- calc is a generic interface to evaluate calculations, uses whichever method appropriate.

local input = assert(arg[1], "Input expected")

if input:find("^ *[pP][iI] *$") then
   print("pi = 3.141592653589793238462643383279502884197169399375105820974944592307816406286208998628034825342117")
elseif input:find("^ *e *$") then
  print("e = 2.718281828459045235360287471352662497757247093699959574966967627724076630353547594571382178525166427")
elseif input:find("^ *[%d%-][ %d%.%+%-/%*^%%]+$") then
  local f, err = loadstring("return " .. input)
  if not f then
    error("Unable to evaluate: " .. tostring(err))
  end
  print(input .. " = " .. tostring(f() or nil))
else
  etc.wolframalpha(...)
end
