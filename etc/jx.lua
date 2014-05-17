assert(arg[1], "Code expected")
local mylua = assert(etc.getOutput(_jxparse, ...))
local deplua = assert(etc.getOutput(_jxparse))
return assert(godloadstring("function _runjx()\t"
  .. mylua .. "\tend\n" .. deplua .. "\n_runjx()"))()
