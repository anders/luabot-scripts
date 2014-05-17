assert(type(arg[1]) == "string" and #arg[1] > 0, "gimme a word 2 worx with")

require "spam"
spam.detect(Cache, "acro", 5, 2)

require "storage"
local lookups = storage.load(io, "acro")

for rm, word, letter in arg[1]:gmatch("(%-?)((%w)[^ ]*)") do
  if not letter then
    error("Doesn't look right to me")
  end
  letter = letter:lower()
  
  local pool = lookups[letter .. "__"]
  if not pool then
    pool = {}
    lookups[letter .. "__"] = pool
  end
  local npool = storage.length(pool)
  local found = false
  for i = 1, npool do
    if pool[i] == word then
      found = true
      if rm == "-" then
        found = rm
        pool[i] = pool[npool]
        pool[npool] = nil
        assert(pool[npool] == nil)
        print("Removed " .. word)
        -- print(etc.t(pool))
        break -- ONLY ONE RM AT A TIME!
      end
    end
  end
  if found == "-" then
    break
  end
  if not found and #word <= 20 then
    assert(rm ~= "-", "Word not found!!!")
    pool[npool + 1] = word
  else
    print("Word skipped for various reasons", word)
  end
  
  if LocalCache.debug then
    print(etc.t(pool))
  end
end
storage.save(lookups)

print("Done")
