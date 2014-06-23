-- Usage: assert(not require("spam").detect(Cache, "reason_name", times, in_seconds))

--[[ -- This causes a NASTY loop of messages flooded! The send buffer is exceeded!
if not allCodeTrusted() then
  local errmsg = "spam module used from untrusted context is deprecated (not trusted: " .. whyNotCodeTrusted() .. ")"
  if os.time() > 1403519288 + (60 * 60 * 60 * 24 * 30) then
    return error(errmsg)
  else
    _clown() -- TESTING
    directprint("TESTING: " .. errmsg)
  end
end
--]]

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
