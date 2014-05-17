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
}

LocalCache.funny = arg[1]:sub(1, 200)

return etc.translateWords(arg[1] or '', function(w)
  return funnyfuncs[math.random(#funnyfuncs)](w)
end)
