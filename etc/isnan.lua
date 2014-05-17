local x = tonumber(arg[1])
if x then
    return not (x >= 0 or x < 0)
end
return nil
