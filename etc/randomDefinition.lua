local wt = arg[1]
if wt then
  assert(type(wt) == "string" and wt:find("^%l+$"), "Invalid argument")
else
  wt = pickone{"noun", "verb", "adj", "adv"}
end

-- When tries > 1, tries multiple times to get a definition length nearest prefer_length
local tries = arg[2]

local prefer_length = arg[3] or 200

local multi = arg[4] or 1

local t
if multi > 1 then
  t = {}
  if not tries then
    tries = math.max(math.min(multi * 2, 10), multi)
  elseif tries < multi then
    tries = multi
  end
end
tries = tries or 2
local w, def
local f = assert(io.open("/shared/data." .. wt, 'r'))
for itry = 1, tries do
  local a, b = etc.randomLine(f)
  if a then
    local xw = a:match("^[^ ]+ [^ ]+ [^ ]+ [^ ]+ ([^ ]+)")
    if xw then
      local xdef = a:match(" %| (.*)$")
      if xdef then
        xw = xw:gsub("_", " ")
        local better
        if w then
          -- Find which one is closer to prefer_length:
          local diff = math.abs(def:len() - prefer_length)
          local xdiff = math.abs(xdef:len() - prefer_length)
          if xdiff < diff then
            -- print(xdef, "OVER", def)
            w = xw
            def = xdef
            better = true
          end
        else
          w = xw
          def = xdef
        end
        if t then
          if #t < multi then
            table.insert(t, {xw, xdef})
          elseif better then
            t[math.random(multi)] = {xw, xdef}
          end
        end
      end
    end
  else
    if itry == tries then
      f:close()
      return a, b or "Error reading file"
    end
  end
end
f:close()

if not w then
  return nil, "Unable to find a definition"
end
if t then
  return t
end
return w, def
