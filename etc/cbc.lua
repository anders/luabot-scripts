-- return etc.toCurrency("cbc", ...)

local nn, curr = (arg[1] or ''):match("^(%d*) ?t?o? ?(.*)$")
nn = tonumber(nn) or 1
curr = curr or etc.get('currency', nick) or 'USD'

local onecbc, currency = etc.cbcvalue(curr)
return nn .. ' Clownbot Coin = ' .. (onecbc * nn) .. ' ' .. currency
