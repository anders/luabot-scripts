API "1.1"

local extras = {
  a = true,
  an = true,
  ["and"] = true,
  because = true,
  ["for"] = true,
  he = true,
  her = true,
  his = true,
  i = true,
  ["if"] = true,
  ["in"] = true,
  is = true,
  my = true,
  of = true,
  on = true,
  ["or"] = true,
  she = true,
  so = true,
  the = true,
  their = true,
  ["then"] = true,
  to = true,
  you = true,
  with = true,
  your = true,
}

return extras[(arg[1] or ''):lower()] or false
