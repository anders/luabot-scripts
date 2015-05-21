--[[
def generate(email):
    i = 0
    s1 = 0
    s2 = 0

    l = random.randint(16, 246)
    c = (l + 8 ^ 255) * 8

    while i <= 1848:
        s1 = (s1 + (ord(email[i]) & 255)) % 65535
        s2 = (s1 + s2) % 65535
        email += '%x' % (s2 << 16 | s1)
        i += 1
        if i == c:
            return email[-30:] + "{:02x}".format(l)
]]

local email = (arg[1] or 'test@test.com'):lower()
--[[
local i = 0
local s1, s2 = 0, 0
local license = email

while i <= 608 do
  s1 = (s1 + (bit.band(license:sub(i+1, i+1):byte(), 255))) % 65535
  s2 = (s1 + s2) % 65535
  license = license..bit.tohex(bit.bor(bit.lshift(s2, 16), s1), 8):gsub('^0*', '')
  i = i + 1
end
]]

local i, s1, s2 = 0, 0, 0

local license = email
local l = math.random(16, 246)
local c = bit.bxor(l + 8, 255) * 8

while i <= 1848 do
  s1 = (s1 + (bit.band(license:sub(i+1, i+1):byte(), 255))) % 65535
  s2 = (s1 + s2) % 65535
  license = license..bit.tohex(bit.bor(bit.lshift(s2, 16), s1), 8):gsub('^0*', '')
  i = i + 1
  if i == c then
    print(email..': '..license:sub(-30)..bit.tohex(l, 2))
    return
  end
end

assert(false, "xd")
