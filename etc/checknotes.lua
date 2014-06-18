etc.more(function() -- anders' fault

-- Check your own (or a user's) notes.
-- Arguments: [<user>]

local ALWAYS_DELETE = false

local user = plugin.stringx().trim(arg[1] or "")

if #user == 0 then
    user = nick
end

local normal_user = plugin.ircnick().normalize(user)

local found_notes = false

local notesdir = "/home/notes/" .. chan:lower()

local notes = os.glob(notesdir .. "/*#" .. etc.globEscape(normal_user)) or {}
table.sort(notes)
for _, note in ipairs(notes) do
  local f = io.open(note)
  local line = f:read()
  local sender, date, msg = line:match("([^:]*):([^:]*):(.*)")
  local time = etc.duration(os.difftime(os.time(), tonumber(date)))
  print("Note for " .. user .. ": " .. msg .. " (by " .. sender .. " " .. time .. " ago)")
  found_notes = true
  f:close()
  if ALWAYS_DELETE or user == nick then
    os.remove(note)
  end
end

if not found_notes and not Event then
  print("No notes for user " .. user .. ".")
end

end)
