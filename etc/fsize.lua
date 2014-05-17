assert(arg[1], "File name expected")
-- local f = assert((arg[2] or io).open(arg[1]));
local f = assert((arg[2] or godloadstring("return io")()).open(arg[1]));
local x = f:seek("end");
f:close()
local y
if x >= 1024 * 1024 then
  y = "(" .. (math.floor(x / 1024 / 1024 * 100) / 100) .. " MB)"
elseif x >= 1024 then
  y = "(" .. (math.floor(x / 1024 * 100) / 100) .. " KB)"
else
  y = "(" .. x .. " B)"
end
return x, y
