local email = (arg[1] or 'test@test.com'):lower()

local i = 0
local s1, s2 = 0, 0
local license = email

while i <= 608 do
  s1 = (s1 + (bit.band(license:sub(i+1, i+1):byte(), 255))) % 65535
  s2 = (s1 + s2) % 65535
  license = license..bit.tohex(bit.bor(bit.lshift(s2, 16), s1), 8):gsub('^0*', '')
  i = i + 1
end

print(email..': '..license:sub(-30)..'ab')
