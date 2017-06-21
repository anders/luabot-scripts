API "1.1"

local C = {}

function C.abv(foo)
  local og = foo:match("[Oo][Gg]%s*(%d%.%d+)")
  local fg = foo:match("[Ff][Gg]%s*(%d%.%d+)")
  if not og or not fg then
    return false, "usage: "..etc.cmdchar.."brewcalc abv OG 1.xxx FG 1.xxx"
  end

  og = assert(tonumber(og))
  fg = assert(tonumber(fg))

  local abv1 = (og - fg) * 131.25
  local abv2 = (76.08 * (og - fg) / (1.775 - og)) * (fg / 0.794)
  etc.printf("OG %.3f, FG %.3f = %.1f%% or %1.f%% ABV", og, fg, abv1, abv2)

  -- ABV = (og – fg) * 131.25
  -- ABV =(76.08 * (og-fg) / (1.775-og)) * (fg / 0.794)
end

local arg1 = ... or ""

local cmd = arg1:match("%w+")
if C[cmd] then
  return C[cmd](...)
else
  local cmds = {}
  for k, v in pairs(C) do cmds[#cmds + 1] = k end
  return false, "unknown command, try one of: "..table.concat(cmds, ", ")
end
