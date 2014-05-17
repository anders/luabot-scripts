-- Usage: 'cryptocoin <name>

if not arg[1] or arg[1] == '' then
  return nil, "Which coin? e.g. 'cryptocoin doge"
end

local name = arg[1]:lower()

local data = assert(etc.cryptocoincharts())
for i = 1, #data do
  if name == data[i].id:lower() or name == data[i].name:lower() then
    return data[i].name .. " (" .. data[i].id:upper() .. ") = " .. data[i].price_btc .. " Bitcoin (BTC)"
  end
end
return nil, "Crypto coin not found: " .. arg[1]
