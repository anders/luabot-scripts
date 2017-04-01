if Editor then
  return
end

local which = arg[2] or "todo"
assert(which == "todo" or which == "remember")

local itemsPerPage = 25
local curPage = 1
local curList = "open"
if Web then
  local qa, qb = (Web.qs or ""):sub(2):match("([^&]*)&?p?=?([%d]*)")
  arg[1] = "list " .. qa
  if qa and qa:len() > 0 then
    curList = qa
  end
  curPage = tonumber(qb) or 1
  arg[2] = nil
  Web.write('<!DOCTYPE html><html><head><meta charset="UTF-8"><title>' .. which:upper() .. ' LIST</title></head><body><tt>')
end

if not (arg[1] or ""):find("^[Ll][Ii][Ss][Tt]") then
  require("spam")
  if spam.detect(Cache, "todo", 4, 10) then
    print(nick .. " * to-don't")
    return
  end
end

io.fs._fast = true

require "storage"
local todo = storage.load(io, which)
function todolength() return storage.length(todo) end

function fixitem(item)
  if not item.creator then
    item.creator = item.nick
  end
  if not item.created then
    item.created = item.time
  end
  return item
end

function getitempriority(item)
  local t = item.time or item.created
  local daysago = (os.time() - t) / 60 / 60 / 24
  local mp = item.mp or 3
  local p = math.max(mp - daysago / 20, 0)
  return math.ceil(p)
end

function printitem(i, item)
  item = fixitem(item)
  local newstateinfo = ""
  if item.state ~= "OPEN" or item.creator ~= item.nick then
    newstateinfo = "; set to " .. item.state .. " by " .. item.nick
      .. " " .. etc.duration(os.time() - item.time, 1) .. " ago"
  end
  local pristr = ""
  if item.state == "OPEN" then
    local p = getitempriority(item)
    -- pristr = " [priority=" .. p .. "]"
    if p == 5 then
      pristr = " \0031,9[urgent]\003"
    elseif p == 4 then
      pristr = " \0031,3[high]\003"
    elseif p == 3 then
      pristr = " \0031,8[normal]\003"
    elseif p == 2 then
      pristr = " \0031,7[below_normal]\003"
    elseif p == 1 then
      pristr = " \0031,4[low]\003"
    elseif p == 0 then
      pristr = " \0034,1[abandoned]\003"
    end
  end
  local itemline = (i .. ": " .. item.msg:gsub("[\r\n]+", " - ")
    .. " (added by " .. item.creator
    .. " " .. etc.duration(os.time() - item.created, 1) .. " ago"
    .. newstateinfo
    .. ")" .. pristr)
  if Web then
    etc.wrap(itemline)
    Web.write("<div style='height: 0.25em; margin-top 0.25em; border-top: solid 1px #D7D7D7;'></div>")
  else
    print(itemline)
  end
end

function printitembrief(i, item)
  item = fixitem(item)
  print(item.state .. ": " .. item.msg:gsub("[\r\n]+", " - "))
end

local act, msg = (arg[1] or ''):match("^([^ ]+) *(.*)")
if act then
  act = act:lower()
end

atTimeout("Could not find a result in a reasonable time")

if act == "add" then
  if msg == "" then
    print("Usage: '" .. which .. " add <item...>")
  else
    assert(allCodeTrusted(), "I don't trust that")
    item = { id=todolength() + 1, creator=nick, created=os.time(),
      nick=nick, time=os.time(), msg=msg, state='OPEN' }
    -- table.insert(todo, item) -- Won't trigger __newindex
    todo[item.id] = item
    storage.save(todo)
    print("Done, added " .. which .. " id " .. item.id)
  end
elseif act == "list" or act == "find" then
    local find = ".*"
    local scope
    if act == "find" then
      if msg:len() == 0 then
        print("Usage: '" .. which .. " find <wildcard>")
        return
      end
      if msg:sub(1, 1) == '"' and msg:sub(-1, -1) == '"' then
        scope = msg:sub(2, -2)
      else
        scope = "*" .. msg .. "*"
      end
      find = globToLuaPattern(scope, true)
      msg = "ALL"
    end
    if msg:len() == 0 then
      msg = "OPEN"
    else
      msg = msg:upper()
    end
    if not scope then
      scope = msg
    end
    if arg[3] ~= 'noheader' then
      print(scope .. " " .. which .. " items:")
    end
    if Web then
      print(" ")
    end
    local more
    if not Web and Output.tty and scope:find("^[A-Z]+$") then
      more = Output.maxLines - 2
    end
    local any = false
    -- for i, item in ipairs(todo) do
    -- for i = todolength(), 1, -1 do
    for i = todolength() - ((curPage - 1) * itemsPerPage), 1, -1 do
      local item = todo[i]
      if item and item.msg then
        if item.msg:find(find) and (msg == "ALL" or item.state == msg) then
          any = true
          if more then
            if more <= 0 or itemsPerPage <= 0 then
              -- Need to leave room for this last message.
              if not Web then
                print("...more: " .. boturl .. "u/byte%5B%5D/" .. which .. ".lua?" .. scope:lower())
              end
              break
            end
            more = more - 1
          end
          -- print(i .. ": " .. item.msg)
          -- print(etc.t(item))
          printitem(i, item)
        end
      end
      if Web and itemsPerPage <= 0 then
        local prevpage = "&lt; Previous page"
        if curPage > 1 then
          prevpage = "<a href='?" .. curList .. "&p=" .. (curPage - 1) .. "'>" .. prevpage .. "</a>"
        else
          prevpage = "<font color='gray'>" .. prevpage .. "</font>"
        end
        -- br
        Web.write(prevpage .. " | <a href='?" .. curList .. "&p=" .. (curPage + 1) .. "'>Next page &gt;</a>")
        break
      end
      itemsPerPage = itemsPerPage - 1
    end
    if not any then
      if act ~= "find" then
        print("Nothing there, I'll assume you meant find...")
        Output.maxLines = (Output.maxLines or 1) - 1
        if arg[3] ~= 'noheader' then
          Output.maxLines = Output.maxLines - 1
        end
        etc.todo("find " .. arg[1]:sub(#act + 1), arg[2], 'noheader')
      else
        print("*crickets*")
      end
    end
elseif act == "done" or act == "wontfix" or act == "invalid" or act == "append" then
  assert(allCodeTrusted(), "I don't trust that")
  local a, b = msg:match("^(%d+) *(.*)")
  local i = tonumber(a)
  local item = todo[i]
  if item then
    fixitem(item)
    if act ~= "append" then
      item.state = act:upper()
      item.nick = nick
    end
    item.time = os.time()
    if b and b:len() > 0 then
      item.msg = item.msg .. "\n<" .. nick .. "> " .. b
    end
    storage.save(todo)
    -- print("Done")
    printitembrief(i, item)
  else
    print("No such " .. which .. " item id " .. tostring(a))
  end
elseif act == "reopen" then
  assert(allCodeTrusted(), "I don't trust that")
  local a, b = msg:match("^(%d+) *(.*)")
  local i = tonumber(a)
  local item = todo[i]
  if item then
    fixitem(item)
    item.nick = nick
    item.state = "OPEN"
    item.time = os.time()
    item.mp = nil
    if b and b:len() > 0 then
      item.msg = item.msg .. "\n<" .. nick .. "> " .. b
    end
    storage.save(todo)
    -- print("Done")
    printitembrief(i, item)
  else
    print("No such " .. which .. " item id " .. tostring(a))
  end
elseif act == "raise" then
  assert(allCodeTrusted(), "I don't trust that")
  local a, b = msg:match("^(%d+) *(.*)")
  local i = tonumber(a)
  local item = todo[i]
  if item then
    if item.state == "OPEN" then
      fixitem(item)
      local oldp = getitempriority(item)
      if oldp == 5 then
        print("If it's that urgent, why don't you just do it right now...")
        return
      end
      item.time = os.time()
      local newp = getitempriority(item)
      if newp <= oldp then
        newp = math.min(oldp + 1, 5)
        item.mp = newp
      end
      storage.save(todo)
      -- print("Done")
      printitem(i, item)
    else
      print("Cannot raise priority of closed " .. which .. " item id " .. tostring(a))
    end
  else
    print("No such " .. which .. " item id " .. tostring(a) .. " (cannot raise priority)")
  end
elseif act == "lower" then
  assert(allCodeTrusted(), "I don't trust that")
  local a, b = msg:match("^(%d+) *(.*)")
  local i = tonumber(a)
  local item = todo[i]
  if item then
    if item.state == "OPEN" then
      fixitem(item)
      local oldp = getitempriority(item)
      item.time = os.time()
      item.mp = math.max(oldp - 1, 0)
      storage.save(todo)
      -- print("Done")
      if item.mp == 0 then
        print("You know you could just mark it as WONTFIX: '" .. which .. " wontfix " .. tostring(a))
      else
        printitem(i, item)
      end
    else
      print("Cannot lower priority of closed " .. which .. " item id " .. tostring(a))
    end
  else
    print("No such " .. which .. " item id " .. tostring(a) .. " (cannot lower priority)")
  end
elseif act == '#' then
  print("Usage: '" .. which .. " <id>")
elseif tonumber(act) then
    local i = tonumber(act)
    local item = todo[i]
    if item then
      -- print(etc.t(item))
      printitem(i, item)
    else
      print("No such " .. which .. " item id " .. act)
    end
elseif type(arg[1]) == "string" and #arg[1] > 2 then
  if #arg[1] > 15 then
    print(nick .. ": Type \2add\2 if you want to add that as a todo item, or just find to look for it...")
  else
    print(nick .. ": Type \2find\2 if you want to find that todo item, or add to add it...")
  end
  local who, action = input("add", "find")
  if who == nick then
    if action == "add" then
      return etc.todo("add " .. arg[1], arg[2])
    elseif action == "find" then
      return etc.todo("find " .. arg[1], arg[2])
    end
  else
    -- return etc.todo("", arg[2])
  end
else
  print("Usage: " .. etc.cmdprefix .. which .. " <add|list|done|wontfix|invalid|reopen|append|find|raise|lower|#> ...")
end


if Web then
  if curPage ~= 1 and itemsPerPage > 0 then
    Web.write("<br><a href='?" .. curList .. "&p=" .. (curPage - 1) .. "'>&lt; Previous page</a> | <font color='gray'>Next page &gt;</font>")
  end
  Web.write('</tt></body></html>')
end
