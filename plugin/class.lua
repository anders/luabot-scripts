--- Usage: Can use this or use etc.class() directly.

local t = {
  __call = function(x, ...)
    return etc['class'](...)
  end,
}
setmetatable(t, t)
return t
