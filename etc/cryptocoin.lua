-- Usage: 'cryptocoin <name>

if not arg[1] or arg[1] == '' then
  return nil, "Which coin? e.g. 'cryptocoin doge"
end

local name = arg[1]:lower()

local data = assert(etc.cryptocoincharts(name))
--[[ OLD when all crypto coins were returned:
for i = 1, #data do
  if name == data[i].id:lower() or name == data[i].name:lower() then
    return data[i].name .. " (" .. data[i].id:upper() .. ") = " .. data[i].price_btc .. " Bitcoin (BTC)"
  end
end
--]]
if data and data.id then
  local from, to = data.id:match("^([^/]+)/(.*)$")
  return from:upper() .. " (" .. from:upper() .. ") = " .. data.price .. " Bitcoin (BTC)"
end
return nil, "Crypto coin not found: " .. arg[1]
