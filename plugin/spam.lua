-- Usage: assert(not require("spam").detect(Cache, "reason_name", times, in_seconds))

-- max per seconds.
local function detect(Cache, name, max, seconds)
  local last = Cache['spam.' .. name]
  if not last or last < os.time() - (max * seconds) then
    Cache['spam.' .. name] = os.time() - ((max - 1) * seconds)
    return false
  end
  if last > os.time() then
    return true
  end
  Cache['spam.' .. name] = last + seconds
  return false
end

return { detect = detect }
