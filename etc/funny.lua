-- Usage: 'funny words - or 'command|'funny - pass text to it and it will come out funny! (or not)

local funnyfuncs = arg[2] or {
  etc.tr,
  etc.o,
  etc.ermahgerd,
  etc.benis2 or etc.benis,
  etc.xxx,
  etc.mess,
  etc.y, -- WHY!
  etc.funword,
  etc.swag,
  function(x) return etc.stutter(x, true) end,
}

LocalCache.funny = (arg[1] or ''):sub(1, 200)

return etc.translateWords(arg[1] or '', function(w)
  return funnyfuncs[math.random(#funnyfuncs)](w)
end)
