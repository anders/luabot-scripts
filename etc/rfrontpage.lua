-- Usage: 'rf - our 'r frontpage - use 'rf +name and 'rf -name to subscribe and unsubscribe from 'r

require "serializer"
local obj = serializer.load(io, "rfrontpage.dat")

local isrand
local function getlist()
  local slist = nil
  for name, v in pairs(obj) do
    if not isrand or math.random(1, 4) == 1 then
      if not slist then
        slist = name
      else
        slist = slist .. "+" .. name
      end
    end
  end
  return slist
end

if arg[1] == "list" then
  return (getlist() or "(frontpage)")
elseif arg[1] == "link" then
  return "http://reddit.com/r/" .. (getlist() or "")
elseif arg[1] == "rand" or arg[1] == "-random" then
  isrand = true
  arg[1] = nil
end

if arg[1] and arg[1] ~= "" then
  local msg = ""
  for addrem, name in arg[1]:gmatch("([%+%-]*)([^ ,;]+)") do
    if addrem == '+' then
      obj[name] = true
      msg = msg .. "Subscribed to " .. name .. ". "
    elseif addrem == '-' then
      obj[name] = nil
      msg = msg .. "Unsubscribed from " .. name .. ". "
    else
      error("Don't understand " .. addrem .. name)
    end
  end
  assert(msg ~= "", "Nothing to do")
  serializer.save(io, "rfrontpage.dat", obj)
  return msg
end

print(etc.reddit(getlist()) or "")
