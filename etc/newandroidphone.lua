local pitch = {
  "Get it now - the new",
  "Wow,",
  "Amazing new",
  "Best phone yet? The",
  "iPhone's new competitor:",
  "There's a new kid on the block, the",
}

local phone = etc.newphone()
local os = etc.newandroid()

return ("%s %s running %s"):format(pickone(pitch), phone, os)
