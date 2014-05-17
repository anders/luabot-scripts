local today = os.date('!*t')

if today.month == 4 and today.day == 1 then
  local _print = print
  
  local function dolan(...)
    local tmp = {}
    for i=1, select('#', ...) do
      tmp[#tmp + 1] = tostring(select(i, ...))
    end
    return table.concat(tmp, ' ')
  end
  
  function print(...)
    local s = dolan(...)
    
    --[[if math.random(1, 2) == 1 then
      _print((s:gsub('[AOUEIYaoueiy]', function (c)
        if c:upper() == c then return 'O' else return 'o' end
      end)))
    else
      _print(etc.er(s))
    end]]
    _print(etc.us(etc.funny(s)))
  end
end
return {}