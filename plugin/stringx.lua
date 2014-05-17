-- Feel free to suggest more functions to anders
local _M = {}

function _M.trim(s)
  s = s or ''
  return s:match('^%s*(.-)%s*$')
end

function _M.splitLines(s)
  s = s or ''
  local lines = {}
  for line in s:gmatch('[^\r\n]+') do
    if line:sub(1, 1) ~= '#' then
      lines[#lines + 1] = line
    end
  end
  return lines
end

function _M.replace(s, find, rep)
  s = s or ''
  local findlen = #find
  local replen = #rep
  local i = 1
  while true do
    i = string.find(s, find, i, true)
    if not i then
      break
    end
    s = string.sub(s, 1, i - 1) .. rep .. string.sub(s, i + findlen)
    i = i + replen
  end
  return s
end

function _M.split(s)
  s = s or ''
  local spl = {}
  for w in s:gmatch('[^%s]+') do
    spl[#spl + 1] = w
  end
  return spl
end

function _M.fmtstr(s, ...)
  s = s or ''
  return s:gsub('$B', '\002'):gsub('$C', '\003'):format(...)
end

return _M