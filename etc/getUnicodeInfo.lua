-- http://unicode.org/Public/UNIDATA/UnicodeData.txt
-- Was: http://ftp.unicode.org/Public/3.0-Update/UnicodeData-3.0.0.html
local a = tonumber(arg[1])
if a then
  local b = etc.binarySearchFileLines("/shared/unicode_data.txt", function(line)
    local c = tonumber(line:match("[^;]+"), 16)
    -- print("returning " .. (a - c) .. " for: " .. line)
    return a - c
  end)
  if b then
    local t = {}
    local toggle = true
    -- Lua will match with every other valid entry with this pattern.
    local i = 0
    for a in b:gmatch("([^;]*)") do
        i = i + 1
        if i >= 3 and i % 2 == 1 then
            table.insert(t, a)
        end
        first = not toggle
    end
    if #t> 0 then
      return unpack(t)
    end
  end
end
return false, "Character not found"
