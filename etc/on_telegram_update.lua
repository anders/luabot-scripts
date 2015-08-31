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
  for i = 1, #rsp.result do
    local r = rsp.result[i]
    if r.message then
      if r.message.chat then
        local chat = r.message.chat -- id, first_name, last_name, username
        local from = r.message.from -- id, first_name, last_name, username
        local msg = r.message.text
        _clown()
        print("Telegram from " .. from.first_name .. ": " .. msg)
      else
        -- got non-chat message
      end
    else
      -- got non-message
    end
  end
end
