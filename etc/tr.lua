-- Usage: shortcut for 'translate and 'trfunny

assert(arg[1], "Arg expected, see 'translate and/or 'trfunny")

LocalCache.tr = arg[1]:sub(1, 200)

if not Input.piped and not arg[1]:find("->", 1, true) and arg[1]:find("^.. .. .+") then
  return etc.translate(...)
else
  return etc.trfunny(...)
end
