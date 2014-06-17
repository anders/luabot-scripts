-- Usage: 💩

local UNICODE_DATA_PATH = '/shared/unicode_data.txt'

local M = {}

--- Lua 5.3 utf8.charpatt
-- Lua 5.1 no likey the nilly %z
M.charpatt = "[\1-\127\194-\244][\128-\191]*"
-- M.charpatt = "[%z-\127\194-\244][\128-\191]*"

--- Searches for a Unicode codepoint by name, returns code and some other info you probably shouldn't rely on (use getUnicodeInfo instead)
--- @param plain Plaintext search instead of Lua pattern
M.findByDescription = function(q, plain)
  -- 0025;PERCENT SIGN;Po;0;ET;;;;;N;;;;;
  for line in io.lines(UNICODE_DATA_PATH) do
    local code, name = line:match('([^;]+);([^;]+)')
    if name:find(q, nil, plain) then
      code = tonumber(code, 16)
      return code, line
    end
  end
end

--- Like findByDescription but returns all matches
M.findManyByDescription = function(q, plain)
  -- 0025;PERCENT SIGN;Po;0;ET;;;;;N;;;;;
  local t = {}
  for line in io.lines(UNICODE_DATA_PATH) do
    local code, name = line:match('([^;]+);([^;]+)')
    if name:find(q, nil, plain) then
      code = tonumber(code, 16)
      t[#t + 1] = {code, line}
    end
  end
  return t
end

-- based on https://gist.github.com/pygy/7154512
-- turns out it was broken and didn't work at all, but this one does ;)
--- Decodes a UTF-8 encoded codepoint at i (default 1)
M.decode = function(stream, i)
  i = i or 1

  local msB = stream:byte(i)
  local b2, b1, b0
  local n

  if msB < 0x80 then
    return msB, i + 1
  elseif msB < 0xc0 then
    return false, 'byte values between 0x80 to 0xbf cannot start a multibyte sequence'
  elseif msB < 0xe0 then
    b0 = stream:byte(i + 1)
    if not (b0 > 0x7f and b0 < 0xbf) then
      return false, 'expected 1 continuation byte'
    end
    local res = (msB - 0xc0) * 0x40 + b0 % 0x40
    if res < 0x80 or res > 0x7ff then
      return false, "overlong encoding"
    end
    return res, i + 2
  elseif msB < 0xf0 then
    b1, b0 = stream:byte(i + 1, i + 2)
    if not (b0 > 0x7f and b0 < 0xbf) and (b1 > 0x7f and b1 < 0xbf) then
      return false, 'expected 2 continuation bytes'
    end
    local res = (msB - 0xe0) * 0x1000 + b1 % 0x40 * 0x40 + b0 % 0x40
    if 0xd800 <= res and res <= 0xdfff then 
      return false, 'UTF-16 surrogate lead are not valid codepoints'
    end
    if res < 0x800 or res > 0xffff then
      return false, "overlong encoding"
    end
    return res, i + 3
  elseif msB < 0xf8 then
    b2, b1, b0 = stream:byte(i + 1, i + 3)
    if not (b0 > 0x7f and b0 < 0xbf) and (b1 > 0x7f and b1 < 0xbf) and (b2 > 0x7f and b2 < 0xbf) then
      return false, 'expected 3 continuation bytes'
    end
    local res = (msB - 0xf0) * 0x40000 + b2 % 0x40 * 0x1000 + b1 % 0x40 * 0x40 + b0 % 0x40
    if res < 0x10000 or res > 0x1fffff then
      return false, "overlong encoding"
    end
    return res, i + 4
  end
  return false, 'invalid UTF-8 character'
end

M.encode = function(n)
  if (n >= 0xd800 and n <= 0xdfff) or n > 0x1fffff then
    return false, 'Bad code point '..n
  end
  
  if n < 0x80 then
    return string.char(n)
  elseif n < 0x800 then
    return string.char(0xc0 + n / 0x40,
                       0x80 + n % 0x40)
  elseif n < 0xd800 or 0xdfff < n and n < 0x10000 then
    return string.char(0xe0 + n / 0x1000,
                       0x80 + n / 0x40 % 0x40,
                       0x80 + n % 0x40)
  elseif n < 0x110000 then
    return string.char(0xf0 + n / 0x40000,
                       0x80 + n / 0x1000 % 0x40,
                       0x80 + n / 0x40 % 0x40,
                       0x80 + n % 0x40)
  end
end

--- Get Ernercerd database info for a codepoint
M.getUnicodeInfo = etc.getUnicodeInfo or function(n)
  -- http://ftp.unicode.org/Public/3.0-Update/UnicodeData-3.0.0.html
  local a = tonumber(n)
  if a then
    local b = etc.binarySearchFileLines("/shared/unicode_data.txt", function(line)
      local c = tonumber(line:match("[^;]+"), 16)
      -- print("returning " .. (a - c) .. " for: " .. line)
      return a - c
    end)
    if b then
      local t = {}
      local toggle = true
      -- Lua will match with every other valid entry with this pattern.
      local i = 0
      for a in b:gmatch("([^;]*)") do
        i = i + 1
        if i >= 3 and i % 2 == 1 then
          table.insert(t, a)
        end
        first = not toggle
      end
      if #t> 0 then
        return unpack(t)
      end
    end
  end
  return false, "Character not found"
end

--- Truncates a UTF-8 string to a length (in bytes). Assumes valid UTF-8.
M.truncate = function(str, to_len)
  local len = 0
  for cp, pos in str:gmatch("("..M.charpatt..")()") do
    if pos - 1 <= to_len then
      len = pos - 1
    else
      break
    end
  end
  return str:sub(1, len)
end

if Editor then
  assert(M.truncate("Test", 2) == "Te", "assert 1")
  assert(M.truncate("\231\179\158", 2) == "", "assert 2")
  assert(M.truncate("\231\179\158:", 3) == "\231\179\158", "assert 3")
end

return M
