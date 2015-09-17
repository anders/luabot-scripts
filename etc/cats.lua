local s = arg[1] or ""

function allupper(s)
  return s:upper() == s
end

function alllower(s)
  return s:lower() ==s
end

function capitalized(s)
  return s:sub(1,1):upper() and alllower(s:sub(2))
end



function improve(s)
  local slen = #s
  local c = math.floor(math.max(slen / 19, 3))
  local slang = {
    "meow", "cat", "cats", "kitten", "cheezburger"
  }
  return (s:gsub("[a-zA-Z'%-]+", function(x)
    if x == 'http' or x == 'https' or x == 'mailto' then
      return x
    end
    if x:len() >= 4 and math.random(1, c) == 1 then
      local w = slang[math.random(#slang)]
      if allupper(x) then return w:upper() end
      if alllower(x) then return w end
      if capitalized(x) then return w:sub(1,1):upper()..w:sub(2) end
    end
    c = math.max(c - 1, 3)
    return x
  end)):gsub("se?", function(s)
    if math.random() < 0.5 then
      if allupper(s) then
        return "Z"
      else
        return "z"
      end
    end
  end)
end

local tmp = {}
for line in s:gmatch('[^\n]+') do
  tmp[#tmp+1] = improve(line)
end
return table.concat(tmp, '\n')
