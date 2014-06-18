API "1.1"
-- Usage: 'info <new_infoline> - sets your on-join infoline. Use 'info by itself to see it (quick rejoin won't work). Can also set it as ={code} with custom code.

if not chan then
  return
end

local allowChans = { ["#clowngames"] = true, ["#dbot"] = true }

if Event or not arg[1] then
  if allowChans[chan:lower()] then
    local infoline = etc.get('#infoline')
    if infoline then
      local ilcode = infoline:match("^={(.*)}$")
      if ilcode then
        local realprint = print
        print = function() end
        infoline = etc.getReturn(assert(guestloadstring("return " .. ilcode))())
        print = realprint
      end
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
  -- etc.set('#infoline ' .. arg[1])
  print("We are having difficulties honoring your request, so please enter the following:")
  print("'set #infoline " .. arg[1])
else
  print(nick .. " * info not allowed on this channel")
end
