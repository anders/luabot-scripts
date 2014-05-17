io = assert(godloadstring("return io"))()
local pagename, content
if arg[2] then
  pagename = arg[1]
  content = arg[2]
else
  pagename, content = (arg[1] or ''):match("([^ ]+) (.*)")
end
assert(pagename, "Page name expected")
assert(content, "Page content expected")

local f1 = io.open("/pub/web/" .. pagename, 'r')
if f1 then
  print("The page exists. Overwrite? yes/no")
  local who, answer = input("yes", "no")
  if who == nick and answer == "yes" then
    -- ok
  elseif answer == "no" then
    return
  else
    error('The page already exists');
  end
end

local f = assert(io.open("/pub/web/" .. pagename, 'w'));
f:write(content);
f:close();
print("Done: " .. boturl .. "u/" .. urlEncode(nick) .. "/" .. urlEncode(pagename));
