local x = assert(arg[1], "Function expected")
if type(x) == "function" then
elseif type(x) == "string" then
    local etccmd, etcargs = x:match(etc.cmdchar .. "([a-zA-Z0-9_]+) ?(.*)")
    if etccmd then
      x = assert(godloadstring(string.format("etc.%s(%q)", etccmd, etcargs)))
    else
      x = assert(godloadstring(x))
    end
else
    assert(nil, "Function expected, not " .. type(x))
end
local oldprint = print
print = function(...)
    -- Do some work similar to the real print.
    local printbuf = ""
    for i = 1, select('#', ...) do
        printbuf = printbuf .. ' ' .. tostring(select(i, ...))
    end
end
local sw = stopwatch()
sw:start()
x()
sw:stop()
print = oldprint
return "time\t" .. sw:elapsed() .. "s"
