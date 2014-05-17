-- Send a note to someone else.
-- It's sent as soon as the user joins.
-- Arguments: <user> <text>

local MAX_NOTES = 9 -- notes per target user (pretty arbitrary)
local MAX_GLOBAL_NOTES = 100
local MAX_USER_SIZE = 20
local MAX_MESSAGE_SIZE = 400

require("spam")
if spam.detect(Cache, "note", 4, 10) then
  print("Stop spamming!")
  return
end

local stringx = plugin.stringx()
local ircnick = plugin.ircnick()

local function sanitize_nick(n)
    if #n < 1 or #n > MAX_USER_SIZE then
        print("Invalid user name.")
        return false
    end
    return true
end

local args = arg[1] or ""
local idx = args:find(" ", 1, true)
if not idx then
    print("Usage: <user> <text>")
    return
end
local user, text = args:sub(1, idx - 1), args:sub(idx + #" ")
text = stringx.trim(text)
user = stringx.trim(user)
local sender = ircnick.normalize(nick)
local normal_user = ircnick.normalize(user)

if not (sanitize_nick(user) and sanitize_nick(sender)) then
    return
end

if sender == normal_user then
    print("always u u u u")
    return
end

--[[
for _, n in ipairs(nicklist()) do
    if ircnick.compare(normal_user, n) then
        out.print("User ", user, " is on the channel! Not saving your note.")
        return
    end
end
]]

if #text > MAX_MESSAGE_SIZE then
    print("Message too long (" .. (#text - MAX_MESSAGE_SIZE) .. " bytes too many).")
    return
end
if text == "" then
    print("u")
    return
end

local notesdir = "/home/notes/" .. chan:lower()
os.mkdir(notesdir)

local notes = os.glob(notesdir .. "/*#" .. etc.globEscape(normal_user)) or {}
if #notes >= MAX_NOTES then
  print("User " .. user .. " already received the maximum number of notes (" .. MAX_NOTES .. ").")
  return
end

local f = io.open(notesdir .. "/" .. os.time() .. "." .. #notes .. "#" .. normal_user, "w")
f:write(sender .. ":" .. os.time() .. ":" .. text)
f:close()

print("Note for " .. user .. " saved.")

-- purge old notes, start with the oldest

local files = os.list(notesdir)
local delete_count = #files - MAX_GLOBAL_NOTES
if delete_count > 0 then
  table.sort(files)
  for n = 1, delete_count do
    local f = files[n]
    os.remove(f)
  end
  print("I had to delete other notes to make space :(")
end
