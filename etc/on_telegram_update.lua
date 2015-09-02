API "1.1"

local T = Telegram
Telegram = nil

-- _clown()
-- print("telegram: ", response)

if not T.update or T.update == "" then
  return
end

local json = require("json")

local rsp = json.decode(T.update)

if rsp.ok and type(rsp.result) == "table" then
  local LOG = plugin.log(_funcname)
  for i = 1, #rsp.result do
    local r = rsp.result[i]
    if r.message then
      if r.message.chat then
        local chat = r.message.chat -- id, first_name, last_name, username
        local from = r.message.from -- id, first_name, last_name, username
        local msg = r.message.text
        local cmdline
        if msg:sub(1, #etc.cmdprefix) == etc.cmdprefix then
          cmdline = msg:sub(#etc.cmdprefix + 1)
        elseif msg:sub(1, 1) == '/' then
          cmdline = msg:sub(1 + 1)
        end
        if cmdline then
          local cmd, params = cmdline:match("([^ ]+) ?(.*)")
          if etc then
              etc.altcmdprefix = etc.cmdprefix -- Keep the old one.
              etc.cmdchar = '/' -- For telegram bot commands.
              etc.cmdprefix = '/'
          end
          local printbuf = ""
          T.onPrint = function(...)
            if #printbuf > 0 then
              printbuf = printbuf .. "\n"
            end
            for i = 1, select('#', ...) do
              if i > 0 then
                printbuf = printbuf .. " "
              end
              local x = select(i, ...)
              printbuf = printbuf .. tostring(x)
            end
          end
          _guest()
          local f, err = guestloadstring("singleprint(etc.on_cmd(...) or '')")
          local a, b = pcall(f, cmd, params)
          if not a then
            print("Error:", b)
          end
          if #printbuf > 0 then
            T.sendMessage(chat.id, printbuf)
          end
        else
          -- _clown()
          -- print("Telegram from " .. from.first_name .. ": " .. msg)
          local sender = from.first_name .. "!" .. from.username .. '@' .. from.id .. ".telegram."
          LOG.debug("doChatbot call:", msg, chat.id, from.first_name, sender)
          local cbr = T.doChatbot(msg, chat.id, from.first_name, sender)
          LOG.debug("doChatbot return:", type(cbr), tostring(cbr))
        end
      else
        -- got non-chat message
      end
    else
      -- got non-message
    end
  end
end
