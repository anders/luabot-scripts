if not chan then
  return
end

local allowChans = { ["#clowngames"] = true, ["#dbot"] = true }

if Event or not arg[1] then
  if allowChans[chan:lower()] then
    local infoline = etc.get('#infoline')
    if infoline then
      --[[
      -- TODO: Don't remove _G but also don't run in my env...
      local ilcode = infoline:match("^={(.*)}$")
      if ilcode then
        infoline = assert(loadstring(ilcode))()
      end
      --]]
      infoline = infoline:match("([^\r\n]+)")
      if infoline:len() > 150 + 3 then
        infoline = infoline:sub(1, 150) .. "..."
      end
      if Event and Event.recentUser then
        -- This doesn't seem to run, probably blocked up the chain.
        -- Might be a quick rejoin or a netsplit.
        sendNotice(nick, "Welcome back to " .. dest .. " [" .. nick .. "] " .. infoline)
        return
      end
      print("[" .. nick .. "] " .. infoline)
    end
  end
  return
end

if allowChans[chan:lower()] then
  assert(type(arg[1]) == "string", "String value expected")
  etc.set('#infoline ' .. arg[1])
else
  print(nick .. " * info not allowed on this channel")
end