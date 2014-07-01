local versern = 2

local LOG = plugin.log(_funcname); 

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
        LOG.trace("* NEXT WORD", x)
        s = s:gsub("[OoAa][HhWw]", function(x)
            x = x:upper()
            if x == "OH" then return "O" end
            if x == "OW" then return "O" end
            if x == "AH" then return "A" end
            if x == "AW" then return "A" end
        end)
        x = x:upper()
        LOG.trace("10", "x:", x, "suffix:", suffix)
        if x == "THEY" then return "dey" end
        if x == "THE" then return "da" end
        if x == "GOOSEBUMPS" then return ("GERSBERMS"):lower() end
        if x == "FAVORITE" then return ("FRAVRIT"):lower() end
        if x == "YOU" then return "u" end
        if x == "U" then return "u" end
        if x == "OMG" then return ("ERMAHGERD"):lower() end
        if x == "ERMAHGERD" then return ("ERMAHGERD"):lower() end
        
        local suffix = ""
        if ends(x, "ES") and not ends(x, "SES") and not ends(x, "SHES") then
            suffix = "S"
            x = x:sub(1, #x - 2)
        elseif ends(x, "ING") then
            suffix = "IN"
            x = x:sub(1, #x - 3)
        end
        LOG.trace("20", "x:", x, "suffix:", suffix)
        
        if #x == 0 then
            return suffix
        end
        
        x = removedupes(x)
        LOG.trace("25", "x:", x, "suffix:", suffix)
        
        if #x == 2 and #suffix == 0 then
            if x:sub(1, versern == 1 and 2 or 1) == "M" and isvowel(x:sub(2, 2), true) then
                return "mah"
            end
        end
        LOG.trace("30", "x:", x, "suffix:", suffix)
        
        local lastchar = x:sub(#x)
        if isvowel(lastchar) and #x > 2 then
            if #suffix == 0 and (lastchar == 'A' or lastchar == 'I' or lastchar == 'O') then
                suffix = "ER"
            end
            x = x:sub(1, #x - 1)
        end
        LOG.trace("40", "x:", x, "suffix:", suffix)
        
        local prevchar = "\0"
        local temp = ""
        for i = 1, #x do
            local c = x:sub(i, i)
            local next = x:sub(i + 1, i + 1)
            local idx
            if versern ~= 1 then
              idx = i - 1
            end
            if (((isvowel(c) and (next ~= 'R' or c == 'A' or c == 'O')) or (c == 'Y' and idx ~= 0)) and
                    (prevChar ~= 'M' or (c == 'A' or c == 'I' or c == 'O' and prevchar == 'M'))) then
                temp = temp .. "ER"
            elseif isvowel(c, true) and prevchar == 'M' and c ~= 'E' then
                temp = temp .. "AH"
            else
                temp = temp .. c
            end
            if versern ~= 1 then
              prevchar = c
            end
        end
        LOG.trace("50", "temp:", temp, "suffix:", suffix)
        
        x = removedupes(temp .. suffix)
        suffix = ""
        
        LOG.trace("90", "x:", x, "suffix:", suffix)
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
local s = assert(arg[1], "Strin erxpercterd")
if tonumber(arg[2]) then
  versern = tonumber(arg[2])
else
  local a, b = s:match("^%-v(%d+) (.*)")
  if a then
    versern = tonumber(a)
    s = b
  end
end
assert(versern == 1 or versern == 2, "Ernverlerd versern")
LOG.trace("versern", versern)
LOG.trace("input", s)
return doit(s)
