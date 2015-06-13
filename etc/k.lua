local hist = {}
for i = 1, 20 do
  local h = { _getHistory(i) }
  if not h[1] then
    break
  end
  hist[i] = h
end

local t = {}

local function k(i, max, msg)
  local want = math.random(2, 4)
  local getting = false
  msg = msg:gsub("\003%d?%d?,?%d?%d?", "")
  for w in msg:gmatch("[%w%[%]%{%}%|`%^_%-%|'\194-\244\128-\191]+") do
    if w == "http" or w == "https" then
      break
    end
    if not getting then
      -- Less odds if not starting with letter.
      if w:find("^[%a']") or math.random(2) == 1 then
        if math.random(1, max + i + 1) <= i then
          getting = true
        end
      end
    end
    if getting then
      if want > 0 then
        t[#t + 1] = w:lower()
      else
        break
      end
      want = want - 1
    end
  end
end

local max = 5
local initi = 1
if arg[1] and #arg[1] then
  k(initi, max, arg[1])
  initi = initi + 1
end
for i = initi, max do
  local h = hist[math.random(#hist)]
  local msg = h[1]
  k(i, max, msg)
end

local outline = table.concat(t, " ")
print(etc.nonickalert(outline))

if t[1] and t[1]:sub(1, #etc.cmdprefix) == etc.cmdprefix then
  etc.untrust()
  print(etc.nonickalert(guestloadstring("return etc.cmd(...)")(outline) or ''))
end
