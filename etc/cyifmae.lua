local colemak = 'qwfpgjluy;arstdhneiozxcvbkm'
local  qwerty = 'qwertyuiooasdfghjkl;zxcvbnm'

local function cipat(s)
  local tmp = {}
  for i=1, #s do
    local c = s:sub(i, i)
    tmp[#tmp + 1] = c:lower() .. c:upper()
  end
  return table.concat(tmp)
end

local function f(x)
  return (x:gsub('['..cipat(colemak)..']', function(c)
    local p = colemak:find(c:lower(), 1, true)
    return qwerty:sub(p, p)
  end))
end

return f(arg[1])