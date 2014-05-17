local clue = plugin.clue()
local int = clue.crt.int
local booland = clue.crt.booland
local boolor = clue.crt.boolor
local logand = clue.crt.logand
local logor = clue.crt.logor
local logxor = clue.crt.logxor
local lognot = clue.crt.lognot
local shl = clue.crt.shl
local shr = clue.crt.shr
local _memcpy = _memcpy
local _main
local static_1724_0_anon
local _printf
local static_1724_1_anon

_main = function(fp, stack, H0, H1, H2)
local sp
local H3
local H4
local H5
local H6
local H7
local H8
local H9
local state = 0;
while true do
repeat
if state == 0 then
sp = 0
sp = fp + sp
H4 = H2[H1 + 0]
H5 = H2[H1 + 1]
H7 = static_1724_0_anon
H6 = 1
H8 = _printf
H9 = H8(sp, stack, H6, H7, H0, H4, H5)
H3 = 0
state = 1 break end
if state == 1 then
H4 = H3 < H0 and 1 or 0
if H4 ~= 0 then state = 2 else state = 3 end break end
if state == 2 then
H4 = 2
H5 = H3 * H4
H4 = H1 + H5
H5 = H2[H4 + 0]
H6 = H2[H4 + 1]
H7 = static_1724_1_anon
H4 = 1
H8 = _printf
H9 = H8(sp, stack, H4, H7, H3, H5, H6)
H4 = 1
H5 = H3 + H4
H3 = H5
state = 1 break end
if state == 3 then
H0 = 0
do return H0 end
end
until true
end
end


local function initializer()
local H0
local H1
local state = 0;
while true do
repeat
if state == 0 then
_G._main = _main
static_1724_0_anon = {}
H0 = static_1724_0_anon
H1 = 72
H0[1] = H1
H1 = 101
H0[2] = H1
H1 = 108
H0[3] = H1
H1 = 108
H0[4] = H1
H1 = 111
H0[5] = H1
H1 = 44
H0[6] = H1
H1 = 32
H0[7] = H1
H1 = 119
H0[8] = H1
H1 = 111
H0[9] = H1
H1 = 114
H0[10] = H1
H1 = 108
H0[11] = H1
H1 = 100
H0[12] = H1
H1 = 33
H0[13] = H1
H1 = 32
H0[14] = H1
H1 = 97
H0[15] = H1
H1 = 114
H0[16] = H1
H1 = 103
H0[17] = H1
H1 = 99
H0[18] = H1
H1 = 32
H0[19] = H1
H1 = 61
H0[20] = H1
H1 = 32
H0[21] = H1
H1 = 37
H0[22] = H1
H1 = 100
H0[23] = H1
H1 = 59
H0[24] = H1
H1 = 32
H0[25] = H1
H1 = 97
H0[26] = H1
H1 = 114
H0[27] = H1
H1 = 103
H0[28] = H1
H1 = 118
H0[29] = H1
H1 = 91
H0[30] = H1
H1 = 48
H0[31] = H1
H1 = 93
H0[32] = H1
H1 = 32
H0[33] = H1
H1 = 61
H0[34] = H1
H1 = 32
H0[35] = H1
H1 = 37
H0[36] = H1
H1 = 115
H0[37] = H1
H1 = 59
H0[38] = H1
H1 = 0
H0[39] = H1
_printf = _G._printf
static_1724_1_anon = {}
H0 = static_1724_1_anon
H1 = 97
H0[1] = H1
H1 = 114
H0[2] = H1
H1 = 103
H0[3] = H1
H1 = 118
H0[4] = H1
H1 = 91
H0[5] = H1
H1 = 37
H0[6] = H1
H1 = 100
H0[7] = H1
H1 = 93
H0[8] = H1
H1 = 32
H0[9] = H1
H1 = 61
H0[10] = H1
H1 = 32
H0[11] = H1
H1 = 37
H0[12] = H1
H1 = 115
H0[13] = H1
H1 = 0
H0[14] = H1
do return end
end
until true
end
end
clue.crt.add_initializer(initializer)
for k, v in pairs(clue.libc) do
	_G[k] = v
end


local argv = {"foo", "bar", "baz"}
local argc = 1

do
  -- (Construct argv list first.)
	
  local cargs = {}

  for i = argc, #argv do	
    local v = clue.crt.newstring(argv[i])
    cargs[#cargs+1] = 1
    cargs[#cargs+1] = v
  end
      
  clue.crt.run_initializers()

  return _main(1, {}, #argv - argc + 1, 1, cargs)
end
