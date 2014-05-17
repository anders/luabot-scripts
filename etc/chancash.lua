return string.join(nicklist(), function(n) return n .. " has $" .. cash(n) end, ", ")
