-- Usage: either search 'sx term, or substitute the last message 'sx/foo/bar/

if not arg[1] then
  return etc.help("etc.s")
end

local from, to, flags = arg[1]:match("^/([^/]+)/([^/]+)(.*)")
if to then
  local f_i = false
  local f_g = false
  local f_slash = false
  for i = 1, #flags do
    local f = flags:sub(i, i)
    if f == 'i' then
      f_i = true
    elseif f == 'g' then
      f_g = true
    elseif f == '/' then
      f_slash = true
    else
      error("Unexpected flag " .. f)
    end
  end
  if not f_slash then
    return false, "I think you forgot a slash, but I'll help you out anyway: " .. etc.getReturn(etc.s(arg[1] .. '/'))
  end
  local xfrom = from
  if f_i then
    xfrom = etc.cipat(xfrom)
  end
  if xfrom:sub(#xfrom) == '&' then
    xfrom = xfrom:sub(1, #xfrom - 1) .. ".*"
  end
  local irep = 0
  local str = (arg[2] or LocalCache.lastmsg or '')
  -- print("str='" .. str .. "'", "from='" .. xfrom .. "'", "to='" .. to .. "'")
  return str:gsub(xfrom, function(s)
    if f_g or irep == 0 then
      return to
    end
    irep = irep + 1
    return s
  end) or ''
else
  return etc.search(...)
end
