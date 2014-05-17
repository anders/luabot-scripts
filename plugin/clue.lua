-- clue/crt.lua
--
-- Clue C runtime library
--
-- © 2008 David Given.
-- Clue is licensed under the Revised BSD open source license. To get the
-- full license text, see the README file.
--
-- $Id: crt.lua 54 2008-12-07 23:43:30Z dtrg $

local crt = {}
local libc = {}
local clue = {crt = crt, libc = libc}

-- require "bit"

local print = print
local unpack = unpack
local ipairs = ipairs
local string_char = string.char
local string_byte = string.byte
local string_sub = string.sub
local string_find = string.find
local string_len = string.len
local math_floor = math.floor
local bit_bnot = bit.bnot
local bit_band = bit.band
local bit_bor = bit.bor
local bit_bxor = bit.bxor
local bit_lshift = bit.lshift
local bit_rshift = bit.rshift
local bit_arshift = bit.arshift

local ZERO = string_char(0)
 

local initializer_list = {}
function crt.add_initializer(i)
	initializer_list[#initializer_list + 1] = i
end

function crt.run_initializers()
	-- Foul, foul hack. Run all initializers twice to resolve mutually
	-- dependent function references.
	 
	for _, i in ipairs(initializer_list) do
		i()
	end
	for _, i in ipairs(initializer_list) do
		i()
	end

	initializer_list = {}
end

local READ_FN = 1
local WRITE_FN = 2
local OFFSET_FN = 3
local TOSTRING_FN = 4

local DATA_I = 1
local OFFSET_I = 2

function crt.ptrtostring(po, pd)
	local s = {}
	while true do
		local c = pd[po]
		if (c == 0) then
			break;
		else
			s[#s+1] = c
		end
		po = po + 1
	end
	
	return string_char(unpack(s))
end
	
-- Construct a string array.

function crt.newstring(s)
	local len = string_len(s)
	local s = {string_byte(s, 1, len)}
	s[#s+1] = 0
	return s
end

-- Number operations.

function crt.int(v)
	return math_floor(v)
end

-- Bit operations.

function crt.shl(v, shift)
	return bit_lshift(v, shift)
end

function crt.shr(v, shift)
	return bit_rshift(v, shift)
end

function crt.logor(v1, v2)
	return bit_bor(v1, v2)
end

function crt.logand(v1, v2)
	return bit_band(v1, v2)
end

function crt.logxor(v1, v2)
	return bit_bxor(v1, v2)
end

-- Boolean operations.

function crt.booland(v1, v2)
	v1 = (v1 ~= nil) and (v1 ~= 0)
	v2 = (v2 ~= nil) and (v2 ~= 0) 
	return (v1 and v2) and 1 or 0
end

function crt.boolor(v1, v2)
	v1 = (v1 ~= nil) and (v1 ~= 0)
	v2 = (v2 ~= nil) and (v2 ~= 0) 
	return (v1 or v2) and 1 or 0
end

-- clue.crt
--
-- Clue C libc
--
-- © 2008 David Given.
-- Clue is licensed under the Revised BSD open source license. To get the
-- full license text, see the README file.
--
-- $Id: libc.lua 60 2008-12-08 22:30:47Z dtrg $

-- require clue.crt
-- require "socket"

local unpack = unpack
local type = type
local print = print

local ptrread = clue.crt.ptrread
local ptrwrite = clue.crt.ptrwrite
local ptroffset = clue.crt.ptroffset
local ptrtostring = clue.crt.ptrtostring
local newptr = clue.crt.newptr
local math_floor = math.floor
local tonumber = tonumber
--local io_write = io.write
--local io_stdin = io.stdin
--local io_stdout = io.stdout
--local io_stderr = io.stderr
local string_format = string.format
local string_gsub = string.gsub
local math_sin = math.sin
local math_cos = math.cos
local math_sqrt = math.sqrt
local math_pow = math.pow
local math_log = math.log
local math_atan = math.atan
local math_exp = math.exp
--local socket_gettime = socket.gettime
local socket_gettime = os.time

--module "clue.libc"

function libc._malloc(sp, stack, size)
	return 1, {}
end

function libc._calloc(sp, stack, size1, size2)
	local d = {}
	for i = 1, (size1*size2) do
		d[i] = 0
	end
	return 1, d
end
	
function libc._free(sp, stack, po, pd)
end

function libc._realloc(sp, stack, po, pd)
	return po, pd
end

function libc._memcpy(sp, stack, destpo, destpd, srcpo, srcpd, count)
	for offset = 0, count-1 do
		destpd[destpo+offset] = srcpd[srcpo+offset]
	end
	return destpo, destpd
end

function libc._memset(sp, stack, destpo, destpd, c, n)
	for offset = 0, n-1 do
		destpd[destpo+offset] = c
	end
	return destpo, destpd
end
	
function libc._atoi(sp, stack, po, pd)
	local s = ptrtostring(po, pd)
	return math_floor(tonumber(s))
end

_atol = _atoi

function libc._printf(sp, stack, formatpo, formatpd, ...)
	format = ptrtostring(formatpo, formatpd)
	local inargs = {...}
	local outargs = {}
	
	local inargcount = #inargs
	local i = 1
	while (i <= inargcount) do
		local thisarg = inargs[i]
		i = i + 1
		if (i <= inargcount) then
			local nextarg = inargs[i]
			if (nextarg == nil) or (type(nextarg) == "table") then
				-- If the next argument is nil or a table, then we must
				-- be looking at a register pair representing a pointer.
				thisarg = ptrtostring(thisarg, nextarg)
				i = i + 1
			end
		end
		
		outargs[#outargs+1] = thisarg
	end	

	-- Massage the format string to be Lua-compatible.
	
	format = string_gsub(format, "[^%%]%%l", "%%")
	format = string_gsub(format, "^%%l", "%%")
	
	-- Use Lua's string.format to actually do the rendering.
	
    
	--[[io_write]]print(string_format(format, unpack(outargs)))
	return 1
end

__stdin = io_stdin
__stdout = io_stdout
__stderr = io_stderr
 
function libc._putc(sp, stack, c, fppo, fppd)
	fppd:write(string_format("%c", c))
end

-----------------------------------------------------------------------------
--                                STRINGS                                  --
-----------------------------------------------------------------------------

function libc._strcpy(sp, stack, destpo, destpd, srcpo, srcpd)
	local origdestpo = destpo
	
	while true do
		local c = srcpd[srcpo]
		destpd[destpo] = c
		
		srcpo = srcpo + 1
		destpo = destpo + 1
		
		if (c == 0) then
			break
		end
	end
	
	return origdestpo, destpd
end

-----------------------------------------------------------------------------
--                                 MATHS                                   --
-----------------------------------------------------------------------------

function libc._sin(sp, stack, x)
	return math_sin(x)
end

function libc._cos(sp, stack, x)
	return math_cos(x)
end

function _sqrt(sp, stack, x)
	return math_sqrt(x)
end

function libc._pow(sp, stack, x, y)
	return math_pow(x, y)
end

function libc._log(sp, stack, x)
	return math_log(x)
end

function libc._atan(sp, stack, x)
	return math_atan(x)
end

function libc._exp(sp, stack, x)
	return math_exp(x)
end

-----------------------------------------------------------------------------
--                                 TIME                                    --
-----------------------------------------------------------------------------

function libc._gettimeofday(sp, stack, tvpo, tvpd, tzpo, tzpd)
	local t = socket_gettime()
	local secs = math_floor(t)
	local usecs = math_floor((t - secs) * 1000000)
	tvpd[tvpo+0] = secs
	tvpd[tvpo+1] = usecs
	return 0
end

return clue
