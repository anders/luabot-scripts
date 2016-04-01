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
  
  local print = function(...)
    _G.print = _print
    local s = dolan(...)
    
    _print(etc.funny(s))
    _G.print = print
  end
  
  _G.print = print
end
return {}
