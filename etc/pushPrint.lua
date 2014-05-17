-- Returns (number, prevprint)
-- To pass print along, can either use prevprint or call etc.nextPrint

local func = arg[1]
assert(type(func) == "function")

if not _printstack then
  _printstack = {}
end

local prevprint = print

table.insert(_printstack, print)

print = func

return #_printstack + 1, prevprint
