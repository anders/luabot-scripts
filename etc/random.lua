-- Usage: tries to get random stuff for you. Acts like math.random, returns random elements from tables or strings, or tries to call a function to get random output using: -random switch if found in the code, calling same name function with _random suffix, or just passing a random string into the function. Example: 'rand'def

if not arg[1] then
  return math.random()
end
if type(arg[1]) == "number" then
  if type(arg[2]) == "number" then
    return math.random(arg[1], arg[2])
  end
  return math.random(arg[1])
end
if tonumber(arg[1]) then
  return math.random(tonumber(arg[1]))
end
if type(arg[1]) == "table" then
  return arg[1][math.random(#arg[1])]
end
if type(arg[1]) == "string" then
  local sn, sm = arg[1]:match("^%s*(%d+)[, \t]*(%d+)%s*$")
  if sn and sm then
    return math.random(tonumber(sn), tonumber(sm))
  end
end
do
  local func, funcname = etc.parseFunc(arg[1] or '')
  if func then
    while true do
      local xf = etc.isalias(func)
      if not xf then
        break
      end
      func = etc.parseFunc(xf)
    end
    local code = getCode(func)
    if code:find("-random", 1, true) then
      return func("-random")
    else
      if type(funcname) == "string" then
        local rfunc = etc.parseFunc(funcname .. "_random")
        if type(rfunc) == "function" then
          return rfunc()
        end
      end
      return func(etc.rdef())
    end
  end
end
return nil, "Random error"
