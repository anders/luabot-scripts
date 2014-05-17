local letters = arg[1]
assert(type(letters) == "string" and letters:len() > 0, "Need some letters!")

letters = letters:lower():gsub("[^a-z]+", "")

local result
for i = 1, letters:len() do
  local ch = letters:sub(i, i)
  local indexfile = "/shared/index.noun"
  if math.random(3) == 1 then
    indexfile = "/shared/index.verb"
  end
  local rupper = math.random(1, 40)
  local word
  etc.binarySearchFileLines(indexfile,
  function(line)
    local onword = line:match("[^ ]+")
    local x = onword:sub(1, 1)
    if x == ch then
      if not word or math.random(1, 3) == 1 then
        -- Just keep track of one in case we run out of words.
        word = onword
      end
      if math.random(1, rupper) == 1 then
        word = onword
        return 0
      end
      rupper = rupper - 1
      if rupper < 1 then
        rupper = 1
      end
      -- Return a random direction within the same letter.
      if math.random(2) == 1 then
        return 1
      else
        return -1
      end
    end
    return etc.strcmp(ch, onword)
  end)
  assert(word, "Wut word.....")
  word = word:gsub("_", " "):match("[^ ]+")
  local cword = word:gsub("^(.)(.*)", function(f, r)
    return f:upper() .. r
  end)
  if result then
    local rr = math.random(10)
    if rr == 1 then
      result = result .. " of"
    elseif rr == 2 then
      result = result .. " to"
    elseif rr == 3 then
      result = result .. " in"
    elseif rr == 4 then
      result = result .. ","
    end
    -- 'the' added separately and must fit after the previous
    if math.random(5) == 1 then
      result = result .. " the"
    end
    result = result .. " " .. cword
  else
    result = cword
  end
end
return result
