-- Usage: 'luajit <code> runs code™ on LuaJIT® for dbot © 2013

if type(arg[1]) == "string" and arg[1]:find("ffi", 1, true) then
  return print "Segmentation fault (core dumped)"
end
if math.random(3) >= 2 then
  etc.print(...)
end
singleprint("The code ran so fast™ on LuaJIT® it returned before we could print it")
