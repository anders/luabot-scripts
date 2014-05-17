local function ends(x, y)
    return x:sub(#x - #y + 1) == y
end

local function isvowel(c, includeY)
    return c == 'A' or
        c == 'E' or
        c == 'I' or
        c == 'O' or
        c == 'U' or
        (c == 'Y' and includeY)
end

local function containschar(x, y)
    for i = 1, #x do
        if x:sub(i, i) == y then
            return i
        end
    end
end

local function bestvowel(vowels)
    local best = vowels:sub(1, 1)
    if containschar(vowels, 'E') then
        best = 'E'
    elseif containschar(vowels, 'U') then
        best = 'U'
    elseif containschar(vowels, 'I') then
        best = 'I'
    end
    return best
end

local function removedupes(x)
    local cvowels = "";
    local prevc = "\255"
    local temp = "";
    local go
    for i = 1, #x do
        local c = x:sub(i, i)
        go = c ~= prevc
        if go then
            if isvowel(c) or (c == 'Y' and #cvowels > 0) then
                cvowels = cvowels .. c
                go = false
            elseif #cvowels > 0 then
                local bvc = bestvowel(cvowels)
                temp = temp .. bvc
                cvowels = ""
            end
            if go then
                temp = temp .. c
            end
            prevc = c
        end
    end
    if #cvowels > 0 then
        local bvc = bestvowel(cvowels)
        temp = temp .. bvc
        cvowels = ""
    end
    return temp
end

function doit(s)
    -- s = s:gsub("%a+", function(x)
    s = etc.translateWords(s, function(x)
        s = s:gsub("[OoAa][HhWw]", function(x)
            x = x:upper()
            if x == "OH" then return "O" end
            if x == "OW" then return "O" end
            if x == "AH" then return "A" end
            if x == "AW" then return "A" end
        end)
        x = x:upper()
        if x == "THEY" then return "DEY" end
        if x == "THE" then return "DA" end
        if x == "GOOSEBUMPS" then return "GERSBERMS" end
        if x == "FAVORITE" then return "FRAVRIT" end
        if x == "YOU" then return "U" end
        if x == "U" then return "U" end
        if x == "OMG" then return "ERMAHGERD" end
        if x == "ERMAHGERD" then return "ERMAHGERD" end
        
        local suffix = ""
        if ends(x, "ES") and not ends(x, "SES") and not ends(x, "SHES") then
            suffix = "S"
            x = x:sub(1, #x - 2)
        elseif ends(x, "ING") then
            suffix = "IN"
            x = x:sub(1, #x - 3)
        end
        
        if #x == 0 then
            return suffix
        end
        
        x = removedupes(x)
        
        if #x == 2 and #suffix == 0 then
            if x:sub(1, 2) == "M" and isvowel(x:sub(2, 2), true) then
                return "MAH"
            end
        end
        
        local lastchar = x:sub(#x)
        if isvowel(lastchar) and #x > 2 then
            if #suffix == 0 and (lastchar == 'A' or lastchar == 'I' or lastchar == 'O') then
                suffix = "ER"
            end
            x = x:sub(1, #x - 1)
        end
        
        local prevchar = "\0"
        local temp = ""
        for i = 1, #x do
            local c = x:sub(i, i)
            local next = x:sub(i + 1, i + 1)
            if (((isvowel(c) and (next ~= 'R' or c == 'A' or c == 'O')) or (c == 'Y' and idx ~= 0)) and
                    (prevChar ~= 'M' or (c == 'A' or c == 'I' or c == 'O' and prevchar == 'M'))) then
                temp = temp .. "ER"
            elseif isvowel(c, true) and prevchar == 'M' and c ~= 'E' then
                temp = temp .. "AH"
            else
                temp = temp .. c
            end
        end
        
        x = removedupes(temp .. suffix)
        suffix = ""
        
        return x:lower()
    end)
    return s
end

--[[
print(doit("all your base are belong to us"))
print(doit("oh my god!"))
print(doit("goosebumps!"))
print(doit("ermahgerd!"))
if arg[1] then
    print(doit(arg[1]))
end
--]]
return doit(assert(arg[1], "String expected"))
