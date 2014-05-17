local hist = {}
for i = 1, 20 do
  local h = { _getHistory(i) }
  if not h[1] then
    break
  end
  hist[i] = h
end

local t = {}

local max = 5
for i = 1, max do
  local h = hist[math.random(#hist)]
  local msg = h[1]
  local want = math.random(2, 4)
  local getting = false
  for w in msg:gmatch("[%w_%-'\194-\244\128-\191]+") do
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

local outline = table.concat(t, " ")
print(etc.nonickalert(outline))

if t[1] and t[1]:sub(1, #etc.cmdprefix) == etc.cmdprefix then
  etc.untrust()
  print(etc.nonickalert(guestloadstring("return etc.cmd(...)")(outline) or ''))
end
