local cash = etc.cash
-- return string.join(nicklist(), function(n) return n .. " has $" .. cash(n) end, ", ") -- nick alerts
return etc.all(function(n) return "$" .. cash(n) end)
