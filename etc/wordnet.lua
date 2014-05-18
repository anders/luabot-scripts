-- alias: wn

-- Partially implemented! nouns only...

local w = arg[1]
assert(type(w) == "string", "Need word")

if w == "-random" then
  return etc.randomDefinition(nil, 3)
end

local function getdef(wtype, pos)
  local f = assert(io.open("/shared/data." .. wtype));
    assert(f:seek("set", pos));
    local line = f:read()
    local wd, def = line:match("^[^ ]+ [^ ]+ [^ ]+ [^ ]+ ([^ ]+) .-| (.*)")
    if wd and def then
      return wd:gsub("_", " "), "-", def, "(" .. wtype .. ")"
    else
      return nil, "Problem parsing entry", line
    end
end

local xw = w:lower():gsub(" +", "_")

--[=[ -- This file doesn't exist in WN anymore?
-- sense.index:
-- http://wordnet.princeton.edu/man/senseidx.5WN.html
-- http://wordnet.princeton.edu/man/lexnames.5WN.html
local sinfo = etc.binarySearchFileLines("/shared/index.sense",
  function(line)
    return etc.strcmp(xw, line:match("[^ %%]+"))
  end)
if sinfo then
  local typeindex = tonumber(sinfo:match("[^%%]+%%(%d)"))
  if typeindex then
    local typeindexes = { [1]="noun", [2]="verb", [3]="adj", [4]="adv" }
    local swtype = typeindexes[typeindex]
    if swtype then
      local xspos = sinfo:match(" (%d%d%d%d%d%d%d%d)")
      local xpos = tonumber(xspos)
      if xpos then
        return getdef(swtype, xpos)
      end
    end
  end
end
--]=]

local r1, r2, r3, r4
local rank = -1

for iwx, wtype in ipairs({
  "noun",
  "verb",
  "adj",
  "adv",
}) do
  -- http://wordnet.princeton.edu/man/wndb.5WN.html#sect2
  -- synset_cnt is at position 3 in the index file,
  -- this indicates the ordering; the higher the better (most to least frequently used)
  local info = etc.binarySearchFileLines("/shared/index." .. wtype,
  function(line)
    return etc.strcmp(xw, line:match("[^ ]+"))
  end)
  
  if info then
    -- http://wordnet.princeton.edu/man/wndb.5WN.html#sect2
    local xrank = tonumber(info:match("[^ ]+ [^ ]+ (%d+)")) or 0
    if xrank > rank then
      local spos = info:match(" (%d%d%d%d%d%d%d%d)")
      local pos = tonumber(spos)
      if pos then
        r1, r2, r3, r4 = getdef(wtype, pos)
        rank = xrank
      else
        -- return nil, "Error", tostring(spos)
        if not r1 and not r2 then
          r2, r3 = "Error", tostring(spos)
        end
      end
    end
  else
    -- return nil, w, "not found"
    if not r1 and not r2 then
      r2, r3 = w, "not found"
    end
  end

end

return r1, r2 or "Error", r3 or "unknown"
