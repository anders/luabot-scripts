local who, where
if arg[2] then
  who = arg[1]
  where = arg[2]
else
  who, where = (arg[1] or ""):match("^([^ ]+)[ ]?([^ ]*)$")
end
assert(who and who ~= '', "Seen who?")
if not where or where == "" then
  where = chan or ""
end

local u = ircUser(who)
if u then
  who = u.nick
end

local myprint = directprint
if where:lower() == chan:lower() then
  myprint = print
end

local x, y = seen(who, where)
if x then
  myprint(nick .. " * I have last seen " .. who .. " on " .. where
    .. " (" .. etc.duration(os.time() - x) .. " ago) " .. y)
else
  local r = ""
  if '#' ~= where:sub(1, 1) then
    r = " (did you mean #" .. where .. "?)"
  end
  myprint(nick .. " * I have not seen " .. who .. " on " .. where .. r)
end
