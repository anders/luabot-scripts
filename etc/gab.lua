local cmd, param = (arg[1] or ""):match("([^ ]+) ?(.*)")

if cmd == "help" then
  print("For example, if your hint is: \002William Harem He\002, answer: 'gab guess \002Will You Marry Me\002")
  return
end

if cmd == "hint" and Cache.gabA then
  local x = etc.rot13(Cache.gabA)
  print("Hint: " .. x:sub(1, 5) .. x:sub(6):gsub("[%a%d]", "*"))
  return
end

if not cmd or cmd == "skip" or not Cache.gabA then
  local hint
  if not cmd and Cache.gabQ and Cache.gabA then
    hint = Cache.gabQ
  else
    print("It was " .. etc.rot13(Cache.gabA or "?"))
    require "csv"
    local ent = csv.parseLine(etc.randomLine("gab13.csv", io) or "?,?")
    hint = etc.rot13(ent[1] or "?")
    Cache.gabQ = hint
    Cache.gabA = ent[2] or "?"
  end
  print("Gab hint: \002" .. hint .. "\002"
    .. " (use 'gab guess <answer> to solve, use 'gab help if confused)")
  return
end

local function fix(s)
  return s:lower():gsub("[^%a%d]+", "")
end

if cmd == "guess" or cmd == "solve" then
  if not param or param == "" then
    print("Please type in your guess, 'gab guess <answer>")
    return
  end
  local userA = fix(param)
  local realA = fix(etc.rot13(Cache.gabA or "?"))
  if userA == realA then
    print("Correct! " .. nick .. " guessed the correct answer of: " .. etc.rot13(Cache.gabA or "?"))
    Cache.gabQ = nil
    Cache.gabA = nil
  else
    local xs = ""
    if 1 == math.random(1, 4) then
      xs = ". If this one is too hard you can use 'gab skip"
    end
    print("Sorry " .. nick .. ", that's not it" .. xs)
  end
  return
end

print("What? did you mean 'gab guess " .. (arg[1] or ""))
