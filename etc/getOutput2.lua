-- arg[1] = true if wanting standard error to be the 2nd return value.
-- arg[2] = function
-- arg[3+] = arguments for function
assert(type(arg[1]) ~= "function", "Broken API")
assert(type(arg[2]) == "function", "Function expected")

Output = Output or {}
local _opiped1 = Output.piped
Output.piped = 1
local _omode1 = Output.mode
Output.mode = 'pipe'
local _otty1 = Output.tty
Output.tty = false
local _omaxLines = Output.maxLines
Output.maxLinesLast = Output.maxLinesLast or Output.maxLines -- Not always present, and might get removed!
Output.maxLines = 500
if Input and Input.maxLines then
  Output.maxLines = Input.maxLines
end
local _oprintType = Output.printType
Output.printType = 'plain'

local _go_print1 = print
local ssss
local function _go_print(...)
  local s = ""
  for i = 1, select('#', ...) do
    if i > 1 then
      s = s .. " "
    end
    s = s .. tostring(select(i, ...))
  end
  --[[
  -- This causes annoying problems.
  if not ssss then
    ssss = ""
  end
  ssss = ssss .. s .. "\n" -- More like the unix way.
  --]]
  if s:len() > 0 then
    if ssss then
      ssss = ssss .. "\n" .. s
    else
      ssss = s
    end
  end
end
print = _go_print
-- etc.pushPrint(_go_print)

local function go(wanterr, func, ...)
  -- return func(...)
  -- Revert the print function if error:
  local t1 = { pcall(func, ...) }
  if not t1[1] then
    print = _go_print1
    error(t1[2], 0)
  end
  return unpack(t1, 2)
end

local gosssst = { go(...) }
print = _go_print1
-- assert(etc.popPrint(_go_print))
-- etc.popPrint(_go_print)
local result = ssss
local result2
if arg[1] == true then
  -- Want stderr arg.
  if not gosssst[1] and gosssst[2] then
    result2 = tostring(gosssst[2])
  end
end
if not result and not result2 then
  if not gosssst[1] and gosssst[2] then
    _go_print("Error:", unpack(gosssst, 2))
    result = ssss
  else
    if arg[1] ~= 1.2 then
      _go_print(unpack(gosssst))
      result = ssss
    end
  end
end
Output.piped = _opiped1
Output.mode = _omode1
Output.tty = _otty1
Output.maxLines = _omaxLines
Output.printType = _oprintType
if result2 ~= nil then
  return result, result2
end
if arg[1] == 1.2 and #gosssst > 0 then
  if result ~= nil then
    return unpack(gosssst), result
  else
    return unpack(gosssst)
  end
end
if result ~= nil then
  return result
end
