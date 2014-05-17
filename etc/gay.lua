local FABULOUS_COLORS = {4, 7, 9, 10, 12, 13, 6}
local DEFAULT = "wm4 is a faggot"

local i = 0

return (arg[1] or DEFAULT):gsub("[%z\1-\127\194-\244][\128-\191]*", function (c)
  local ret = string.format("\03%02d%s", FABULOUS_COLORS[i + 1], c)
  i = (i + 1) % #FABULOUS_COLORS
  return ret
end) or ""