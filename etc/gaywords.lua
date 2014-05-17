-- Code stolen from etc.gay

local FABULOUS_COLORS = {4, 5, 7, 9, 10, 12, 13, 6}

local i = 0

return etc.translateWords(arg[1] or '', function(s)
  local ret = string.format("\03%02d%s", FABULOUS_COLORS[i + 1], s)
  i = (i + 1) % #FABULOUS_COLORS
  return ret
end)
