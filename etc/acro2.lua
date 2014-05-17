-- Usage: 'acro2 words - generates an awesome acronym from the letters provided. Use 'acro2add to add some words used by acronyms!

require "storage"


local lookups = storage.load(io, "acro")


local letters = arg[1]
assert(type(letters) == "string" and letters:len() > 0, "Need some letters!")

if letters == "-random" then
  letters = etc.randomDefinition()
end

letters = letters:lower():gsub("[^a-z]+", "")

local result
for i = 1, letters:len() do
  local ch = letters:sub(i, i)
  local word
  local pool = lookups[ch .. "__"]
  -- print("lookups", ch, etc.t(pool or {}))
  local npool = 0
  if pool then
    npool = storage.length(pool)
  end
  if not pool or npool == 0 then
    word = "?"
  else
    word = pool[math.random(npool)]
  end
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
