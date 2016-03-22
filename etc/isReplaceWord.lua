API "1.1"

local wl = (arg[1] or ""):lower()

return (
  not etc.isPreposition(wl)
  and not etc.isPronoun(wl)
  and not etc.isDeterminer(wl)
  and not etc.isAdverb(wl)
  and not etc.isExtraWord(wl)
)
