local s = (arg[1] or ""):gsub("(%a)([%w_']*)", function(first, rest)
    return first:upper() .. rest:lower()
end)
return s
