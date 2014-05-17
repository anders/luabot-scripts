local unichr = function(n)
  if html2text then return html2text(('&#x%x;'):format(n)) end
end

etc.codepoints = function(str) return str:gmatch("[%z\1-\127\194-\244][\128-\191]*") end

local _insert_randoms = function(text)
  local random_extras = {}
  for i=0x1d023, 0x1d045 do
    random_extras[i-0x1d022] = unichr(i)
  end
  local newtext = {}
  for ch in etc.codepoints(text) do
    newtext[#newtext + 1] = ch
    if math.random(1, 5) == 1 then
      newtext[#newtext + 1] = random_extras[math.random(1, #random_extras)]
    end
  end
  return table.concat(newtext)
end

local zalgo = function(text, intensity)
  intensity = intensity or 50
  local zalgo_threshold = intensity
  local zalgo_chars = {}
  for i=0x0300, 0x036f do
    zalgo_chars[i-0x2ff] = unichr(i)
  end
  zalgo_chars[#zalgo_chars + 1] = unichr(0x0488)
  zalgo_chars[#zalgo_chars + 1] = unichr(0x0489)

  local source = text:upper()
  --source = _insert_randoms(source)
  
  local zalgoized = {}
  for letter in etc.codepoints(source) do
    zalgoized[#zalgoized + 1] = letter
    local zalgo_num = math.random(1, zalgo_threshold)
    for i=1, zalgo_num do
      zalgoized[#zalgoized + 1] = zalgo_chars[math.random(1, #zalgo_chars)]
    end
  end
  local response = table.concat(zalgoized)
  return response
end

return zalgo(arg[1] or 'ZALGO COMES', arg[2] or 10)