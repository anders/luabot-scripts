local function f(number)
    if number == 0 then
        return "zero"
    end
    if number >= math.huge then
        return "infinity"
    end
    if etc.isnan(number) then
        return "not a number"
    end
    if number < 0 then
        return "negative " .. f(math.abs(number))
    end
    local words = ""
    if math.floor(number / 1000000000000000) > 0 then
        if words:len() > 0 then
            words = words .. ' '
        end
        words = words .. f(math.floor(number / 1000000000000000)) .. " quadrillion"
        number = math.floor(number % 1000000000000000)
    end
    if math.floor(number / 1000000000000) > 0 then
        if words:len() > 0 then
            words = words .. ' '
        end
        words = words .. f(math.floor(number / 1000000000000)) .. " trillion"
        number = math.floor(number % 1000000000000)
    end
    if math.floor(number / 1000000000) > 0 then
        if words:len() > 0 then
            words = words .. ' '
        end
        words = words .. f(math.floor(number / 1000000000)) .. " billion"
        number = math.floor(number % 1000000000)
    end
    if math.floor(number / 1000000) > 0 then
        if words:len() > 0 then
            words = words .. ' '
        end
        words = words .. f(math.floor(number / 1000000)) .. " million"
        number = math.floor(number % 1000000)
    end
    if math.floor(number / 1000) > 0 then
        if words:len() > 0 then
            words = words .. ' '
        end
        words = words .. f(math.floor(number / 1000)) .. " thousand"
        number = math.floor(number % 1000)
    end
    if math.floor(number / 100) > 0 then
        if words:len() > 0 then
            words = words .. ' '
        end
        words = words .. f(math.floor(number / 100)) .. " hundred"
        number = math.floor(number % 100)
    end
    if number > 0 then
        if words:len() > 0 then
            words = words .. ' '
        end
        local unitsMap = {"zero", "one", "two", "three", "four", "five", 
            "six", "seven", "eight", "nine", "ten", "eleven", 
            "twelve", "thirteen", "fourteen", "fifteen", "sixteen", "seventeen", 
            "eighteen", "nineteen"}
        local tensMap = {"zero", "ten", "twenty", "thirty", "forty", "fifty", 
            "sixty", "seventy", "eighty", "ninety"}
        if number < 20 then
            words = words .. unitsMap[1 + number]
        else
            words = words .. tensMap[1 + math.floor(number / 10)]
            if math.floor(number % 10) > 0 then
                words = words .. "-" .. unitsMap[1 + math.floor(number % 10)]
            end
        end
    end
    return words
end

local n = assert(tonumber(arg[1]), "Number expected")
local floorn = math.floor(n)
local suff = ""
if n ~= floorn then
  suff = suff .. " point"
  for ds in tostring(n-floorn):match("%d+$"):gmatch("%d") do
    suff = suff .. " " .. f(tonumber(ds))
  end
end
return f(floorn) .. suff
