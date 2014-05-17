local io = assert(guestloadstring("return io"))()

local clue = require "clue.crt"

function _open(sp, stack, fnpo, fnpd, flags)
  -- NOTE: skipping flags for now, assuming read.
  local fn = clue.crt.ptrtostring(fnpo, fnpd)
  local f = assert(io.open(fn))
  return f
end

function _lseek(sp, stack, fd, offset, whence)
  local strwhence
  if whence == 0 then
    strwhence = "set"
  elseif whence == 1 then
    strwhence = "cur"
  elseif whence == 2 then
    strwhence = "end"
  end
  return fd:seek(strwhence, offset)
end

function _read(sp, stack, fd, bufpo, bufpd, count)
  local strbyte = string.byte
  local data = fd:read(tonumber(count))
  if not data then
    return 0
  end
  count = #data
  for i = 1, count do
    bufpd[bufpo + i - 1] = strbyte(data:sub(i, i))
  end
  return count
end

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
local _mem
local _io_ports
local _opcode_stream
local _regs8
local _i_rm
local _i_w
local _i_reg
local _i_mod
local _i_mod_size
local _i_d
local _i_reg4bit
local _raw_opcode_id
local _xlat_opcode_id
local _extra
local _rep_mode
local _seg_override_en
local _rep_override_en
local _trap_flag
local _int8_asap
local _scratch_uchar
local _io_hi_lo
local _vid_mem_base
local _spkr_en
local _bios_table_lookup
local _regs16
local _reg_ip
local _seg_override
local _file_index
local _wave_counter
local _op_source
local _op_dest
local _rm_addr
local _op_to_addr
local _op_from_addr
local _i_data0
local _i_data1
local _i_data2
local _scratch_uint
local _scratch2_uint
local _inst_counter
local _set_flags_type
local _GRAPHICS_X
local _GRAPHICS_Y
local _pixel_colors
local _vmem_ctr
local _op_result
local _disk
local _scratch_int
local _clock_buf
local _ms_clock
local _set_CF
local _set_AF
local _set_OF
local _set_AF_OF_arith
local _make_flags
local _set_flags
local _set_opcode
local _pc_interrupt
local _AAA_AAS
local _main
--[[
local _open
local _lseek
local _read
local _write
local _time
local _ftime
--]]

_set_CF = function(fp, stack, H0)
local sp
local H1
local H2
local H3
local H4
local H5
local state = 0;
while true do
repeat
if state == 0 then
sp = 0
sp = fp + sp
H1 = 0
H2 = H0 == H1 and 1 or 0
H1 = 0
H3 = H2 == H1 and 1 or 0
H1 = H3
H3 = _regs8
H2 = 1
H4 = H3[H2 + 0]
H5 = H3[H2 + 1]
H5[H4 + 40] = H1
H2 = H1
do return H2 end
end
until true
end
end

_set_AF = function(fp, stack, H0)
local sp
local H1
local H2
local H3
local H4
local H5
local state = 0;
while true do
repeat
if state == 0 then
sp = 0
sp = fp + sp
H1 = 0
H2 = H0 == H1 and 1 or 0
H1 = 0
H3 = H2 == H1 and 1 or 0
H1 = H3
H3 = _regs8
H2 = 1
H4 = H3[H2 + 0]
H5 = H3[H2 + 1]
H5[H4 + 42] = H1
H2 = H1
do return H2 end
end
until true
end
end

_set_OF = function(fp, stack, H0)
local sp
local H1
local H2
local H3
local H4
local H5
local state = 0;
while true do
repeat
if state == 0 then
sp = 0
sp = fp + sp
H1 = 0
H2 = H0 == H1 and 1 or 0
H1 = 0
H3 = H2 == H1 and 1 or 0
H1 = H3
H3 = _regs8
H2 = 1
H4 = H3[H2 + 0]
H5 = H3[H2 + 1]
H5[H4 + 48] = H1
H2 = H1
do return H2 end
end
until true
end
end

_set_AF_OF_arith = function(fp, stack)
local sp
local H0
local H1
local H2
local H3
local H4
local H5
local state = 0;
while true do
repeat
if state == 0 then
sp = 0
sp = fp + sp
H1 = _op_dest
H0 = 1
H2 = H1[H0 + 0]
H1 = _op_result
H0 = 1
H3 = H1[H0 + 0]
H0 = H3
H1 = logxor(H2, H0)
H2 = _op_source
H0 = 1
H3 = H2[H0 + 0]
H0 = H3
H2 = logxor(H0, H1)
H0 = H2
H2 = _op_source
H1 = 1
H2[H1 + 0] = H0
H1 = 16
H2 = logand(H0, H1)
H0 = _set_AF
H1 = H0(sp, stack, H2)
H2 = _op_result
H0 = 1
H3 = H2[H0 + 0]
H0 = H3
H3 = _op_dest
H2 = 1
H4 = H3[H2 + 0]
H2 = H0 == H4 and 1 or 0
if H2 ~= 0 then state = 1 else state = 3 end break end
if state == 1 then
H1 = 0
H2 = _set_OF
H3 = H2(sp, stack, H1)
H0 = H3
state = 2 break end
if state == 2 then
do return H0 end
end
if state == 3 then
H2 = _regs8
H1 = 1
H3 = H2[H1 + 0]
H4 = H2[H1 + 1]
H1 = H4[H3 + 40]
H2 = H1
H3 = _op_source
H1 = 1
H4 = H3[H1 + 0]
H3 = _i_w
H1 = 1
H5 = H3[H1 + 0]
H1 = H5
H3 = 1
H5 = H1 + H3
H1 = 8
H3 = H5 * H1
H1 = -1
H5 = H3 + H1
H1 = shr(H4, H5)
H3 = logxor(H2, H1)
H1 = 1
H2 = logand(H3, H1)
H1 = _set_OF
H3 = H1(sp, stack, H2)
H0 = H3
state = 2 break end
until true
end
end

_make_flags = function(fp, stack)
local sp
local H0
local H1
local H2
local H3
local H4
local state = 0;
while true do
repeat
if state == 0 then
sp = 0
sp = fp + sp
H1 = 61442
H3 = _scratch_uint
H2 = 1
H3[H2 + 0] = H1
H0 = 61442
state = 1 break end
if state == 1 then
H2 = _regs8
H1 = 1
H3 = H2[H1 + 0]
H4 = H2[H1 + 1]
H1 = H4[H3 + 48]
H2 = H1
H3 = _bios_table_lookup
H1 = 1
H4 = H3[H1 + 4872]
H1 = H4
H3 = shl(H2, H1)
H1 = H0
H2 = H1 + H3
H1 = H2
H3 = _scratch_uint
H2 = 1
H3[H2 + 0] = H1
H0 = H1
state = 1 break end
until true
end
end

_set_flags = function(fp, stack, H0)
local sp
local H1
local H2
local H3
local H4
local H5
local state = 0;
while true do
repeat
if state == 0 then
sp = 0
sp = fp + sp
state = 1 break end
if state == 1 then
H2 = _bios_table_lookup
H1 = 1
H3 = H2[H1 + 4872]
H1 = H3
H2 = 1
H3 = shl(H2, H1)
H1 = logand(H3, H0)
H2 = 0
H3 = H1 == H2 and 1 or 0
H1 = 0
H2 = H3 == H1 and 1 or 0
H1 = H2
H3 = _regs8
H2 = 1
H4 = H3[H2 + 0]
H5 = H3[H2 + 1]
H5[H4 + 48] = H1
state = 1 break end
until true
end
end

_set_opcode = function(fp, stack, H0)
local sp
local H1
local H2
local H3
local H4
local H5
local state = 0;
while true do
repeat
if state == 0 then
sp = 0
sp = fp + sp
H1 = 2048
H3 = _bios_table_lookup
H2 = 1
H4 = H2 + H1
H2 = _raw_opcode_id
H1 = 1
H2[H1 + 0] = H0
H1 = H0
H2 = H4 + H1
H1 = H3[H2 + 0]
H3 = _xlat_opcode_id
H2 = 1
H3[H2 + 0] = H1
H1 = 2304
H3 = _bios_table_lookup
H2 = 1
H4 = H2 + H1
H1 = H0
H2 = H4 + H1
H4 = H3[H2 + 0]
H3 = _extra
H2 = 1
H3[H2 + 0] = H4
H2 = 3584
H4 = _bios_table_lookup
H3 = 1
H5 = H3 + H2
H2 = H5 + H1
H3 = H4[H2 + 0]
H4 = _i_mod_size
H2 = 1
H4[H2 + 0] = H3
H2 = 2560
H4 = _bios_table_lookup
H3 = 1
H5 = H3 + H2
H2 = H5 + H1
H1 = H4[H2 + 0]
H2 = H1
H3 = _set_flags_type
H1 = 1
H3[H1 + 0] = H2
do return end
end
until true
end
end

_pc_interrupt = function(fp, stack, H0)
local sp
local H1
local H2
local H3
local H4
local H5
local H6
local H7
local H8
local H9
local H10
local state = 0;
while true do
repeat
if state == 0 then
sp = 0
sp = fp + sp
H4 = 205
H5 = _set_opcode
H5(sp, stack, H4)
H4 = _make_flags
H4(sp, stack)
H4 = 1
H6 = _i_w
H5 = 1
H6[H5 + 0] = H4
H5 = _regs16
H4 = 1
H6 = H5[H4 + 0]
H7 = H5[H4 + 1]
H4 = H7[H6 + 10]
H5 = H4
H4 = 16
H8 = H5 * H4
H4 = H7[H6 + 4]
H5 = -1
H9 = H4 + H5
H7[H6 + 4] = H9
H4 = H9
H5 = H4
H4 = H8 + H5
H5 = H4
H6 = _mem
H4 = 1
H7 = H5 + H4
H4 = H7
H5 = H6
H6 = H5[H4 + 0]
H4 = H6
H6 = _op_dest
H5 = 1
H6[H5 + 0] = H4
H5 = _scratch_uint
H4 = 1
H6 = H4
H7 = H5
H4 = H7[H6 + 0]
H5 = H4
H6 = _op_source
H4 = 1
H6[H4 + 0] = H5
H4 = H5
H6 = _regs16
H5 = 1
H7 = H6[H5 + 0]
H8 = H6[H5 + 1]
H5 = H8[H7 + 10]
H6 = H5
H5 = 16
H9 = H6 * H5
H5 = H8[H7 + 4]
H6 = -1
H10 = H5 + H6
H8[H7 + 4] = H10
H5 = H10
H6 = H5
H5 = H9 + H6
H6 = H5
H7 = _mem
H5 = 1
H8 = H6 + H5
H5 = H8
H6 = H7
H6[H5 + 0] = H4
H5 = H4
H6 = _op_result
H4 = 1
H6[H4 + 0] = H5
H4 = 1
H6 = _i_w
H5 = 1
H6[H5 + 0] = H4
H5 = _regs16
H4 = 1
H6 = H5[H4 + 0]
H7 = H5[H4 + 1]
H4 = H7[H6 + 10]
H5 = H4
H4 = 16
H8 = H5 * H4
H4 = H7[H6 + 4]
H5 = -1
H9 = H4 + H5
H7[H6 + 4] = H9
H4 = H9
H5 = H4
H4 = H8 + H5
H5 = H4
H6 = _mem
H4 = 1
H7 = H5 + H4
H4 = H7
H5 = H6
H6 = H5[H4 + 0]
H4 = H6
H6 = _op_dest
H5 = 1
H6[H5 + 0] = H4
H5 = _regs16
H4 = 1
H6 = H5[H4 + 0]
H7 = H5[H4 + 1]
H4 = 9
H5 = H6 + H4
H4 = H5
H8 = H7
H5 = H8[H4 + 0]
H4 = H5
H8 = _op_source
H5 = 1
H8[H5 + 0] = H4
H5 = H4
H4 = H7[H6 + 10]
H8 = H4
H4 = 16
H9 = H8 * H4
H4 = H7[H6 + 4]
H8 = -1
H10 = H4 + H8
H7[H6 + 4] = H10
H4 = H10
H6 = H4
H4 = H9 + H6
H6 = H4
H7 = _mem
H4 = 1
H8 = H6 + H4
H4 = H8
H6 = H7
H6[H4 + 0] = H5
H4 = H5
H6 = _op_result
H5 = 1
H6[H5 + 0] = H4
H4 = 1
H6 = _i_w
H5 = 1
H6[H5 + 0] = H4
H5 = _regs16
H4 = 1
H6 = H5[H4 + 0]
H7 = H5[H4 + 1]
H4 = H7[H6 + 10]
H5 = H4
H4 = 16
H8 = H5 * H4
H4 = H7[H6 + 4]
H5 = -1
H9 = H4 + H5
H7[H6 + 4] = H9
H4 = H9
H5 = H4
H4 = H8 + H5
H5 = H4
H6 = _mem
H4 = 1
H7 = H5 + H4
H4 = H7
H5 = H6
H6 = H5[H4 + 0]
H4 = H6
H6 = _op_dest
H5 = 1
H6[H5 + 0] = H4
H5 = _reg_ip
H4 = 1
H6 = H4
H7 = H5
H4 = H7[H6 + 0]
H5 = H4
H6 = _op_source
H4 = 1
H6[H4 + 0] = H5
H4 = H5
H6 = _regs16
H5 = 1
H7 = H6[H5 + 0]
H8 = H6[H5 + 1]
H5 = H8[H7 + 10]
H6 = H5
H5 = 16
H9 = H6 * H5
H5 = H8[H7 + 4]
H6 = -1
H10 = H5 + H6
H8[H7 + 4] = H10
H5 = H10
H6 = H5
H5 = H9 + H6
H6 = H5
H7 = _mem
H5 = 1
H8 = H6 + H5
H5 = H8
H6 = H7
H6[H5 + 0] = H4
H5 = H4
H6 = _op_result
H4 = 1
H6[H4 + 0] = H5
H5 = _i_w
H4 = 1
H6 = H5[H4 + 0]
H4 = H0
H5 = 4
H1 = H4 * H5
H4 = 2
H5 = H1 + H4
H4 = H5
H7 = _mem
H5 = 1
H3 = H7
H2 = H4 + H5
if H6 ~= 0 then state = 1 else state = 3 end break end
if state == 1 then
H0 = 983058
H5 = _mem
H4 = 1
H6 = H4 + H0
H0 = H6
H4 = H5
H7 = H4[H0 + 0]
H0 = H7
H7 = _op_dest
H4 = 1
H7[H4 + 0] = H0
H0 = H2
H4 = H3
H2 = H4[H0 + 0]
H0 = H2
H3 = _op_source
H2 = 1
H3[H2 + 0] = H0
H2 = H0
H0 = H6
H3 = H5
H3[H0 + 0] = H2
H0 = H2
H3 = _op_result
H2 = 1
H3[H2 + 0] = H0
state = 2 break end
if state == 2 then
H2 = _i_w
H0 = 1
H3 = H2[H0 + 0]
H0 = H1
H2 = _mem
H1 = 1
H5 = H2
H4 = H0 + H1
if H3 ~= 0 then state = 4 else state = 6 end break end
if state == 3 then
H4 = _mem
H0 = 1
H5 = H4[H0 + 983058]
H0 = H5
H5 = _op_dest
H4 = 1
H5[H4 + 0] = H0
H0 = H2
H4 = H3
H2 = H4[H0 + 0]
H0 = H2
H3 = _op_source
H2 = 1
H3[H2 + 0] = H0
H2 = H0
H3 = _mem
H0 = 1
H3[H0 + 983058] = H2
H0 = H2
H3 = _op_result
H2 = 1
H3[H2 + 0] = H0
state = 2 break end
if state == 4 then
H1 = _reg_ip
H0 = 1
H2 = H0
H3 = H1
H0 = H3[H2 + 0]
H1 = H0
H2 = _op_dest
H0 = 1
H2[H0 + 0] = H1
H0 = H4
H1 = H5
H2 = H1[H0 + 0]
H0 = H2
H2 = _op_source
H1 = 1
H2[H1 + 0] = H0
H1 = H0
H2 = _reg_ip
H0 = 1
H3 = H0
H4 = H2
H4[H3 + 0] = H1
H0 = H1
H2 = _op_result
H1 = 1
H2[H1 + 0] = H0
state = 5 break end
if state == 5 then
H1 = _regs8
H0 = 1
H2 = H1[H0 + 0]
H3 = H1[H0 + 1]
H0 = 0
H3[H2 + 46] = H0
H1 = _regs8
H0 = 1
H2 = H1[H0 + 0]
H3 = H1[H0 + 1]
H0 = 0
H3[H2 + 45] = H0
H0 = 0
do return H0 end
end
if state == 6 then
H1 = _reg_ip
H0 = 1
H2 = H1[H0 + 0]
H0 = H2
H2 = _op_dest
H1 = 1
H2[H1 + 0] = H0
H0 = H4
H1 = H5
H2 = H1[H0 + 0]
H0 = H2
H2 = _op_source
H1 = 1
H2[H1 + 0] = H0
H1 = H0
H2 = _reg_ip
H0 = 1
H2[H0 + 0] = H1
H0 = H1
H2 = _op_result
H1 = 1
H2[H1 + 0] = H0
state = 5 break end
until true
end
end

_AAA_AAS = function(fp, stack, H0)
local sp
local H1
local H2
local H3
local H4
local H5
local H6
local state = 0;
while true do
repeat
if state == 0 then
sp = 0
sp = fp + sp
H4 = H0
H5 = 262
H1 = H4 * H5
H5 = _regs8
H4 = 1
H2 = H5[H4 + 0]
H3 = H5[H4 + 1]
H4 = H3[H2 + 0]
H5 = H4
H4 = 15
H6 = logand(H5, H4)
H4 = 9
H5 = H6 > H4 and 1 or 0
if H5 ~= 0 then state = 1 else state = 3 end break end
if state == 1 then
H4 = 1
state = 2 break end
if state == 2 then
H0 = H4
H2 = _set_CF
H3 = H2(sp, stack, H0)
H0 = H3
H2 = _set_AF
H3 = H2(sp, stack, H0)
H0 = H3
H2 = H1 * H0
H0 = H2
H2 = _regs16
H1 = 1
H3 = H2[H1 + 0]
H4 = H2[H1 + 1]
H1 = H4[H3 + 0]
H2 = H1
H1 = H2 + H0
H0 = H1
H4[H3 + 0] = H0
H1 = _regs8
H0 = 1
H2 = H1[H0 + 0]
H3 = H1[H0 + 1]
H0 = H3[H2 + 0]
H1 = H0
H0 = 15
H4 = logand(H1, H0)
H3[H2 + 0] = H4
do return H4 end
end
if state == 3 then
H0 = H3[H2 + 42]
H4 = H0
state = 2 break end
until true
end
end

_main = function(fp, stack, H0, H1, H2)
local sp
local H3
local H4
local H5
local H6
local H7
local H8
local H9
local H10
local H11
local H12
local state = 0;
while true do
repeat
if state == 0 then
sp = 0
sp = fp + sp
H5 = 983040
H7 = _mem
H6 = 1
H8 = H6 + H5
H6 = _regs8
H5 = 1
H6[H5 + 0] = H8
H6[H5 + 1] = H7
H5 = H8
H6 = H7
H8 = _regs16
H7 = 1
H8[H7 + 0] = H5
H8[H7 + 1] = H6
H7 = 61440
H6[H5 + 9] = H7
H6 = _regs8
H5 = 1
H7 = H6[H5 + 0]
H8 = H6[H5 + 1]
H5 = 0
H8[H7 + 45] = H5
H5 = 3
H6 = H0 > H5 and 1 or 0
H3 = H1
H4 = H2
H3 = H1
H4 = H2
if H6 ~= 0 then state = 1 else state = 4 end break end
if state == 1 then
H5 = H2[H1 + 6]
H6 = H2[H1 + 7]
H0 = H6[H5 + 0]
H7 = H0
H0 = 64
H8 = H7 == H0 and 1 or 0
if H8 ~= 0 then state = 2 else state = 4 end break end
if state == 2 then
H0 = 1
H8 = H5 + H0
H2[H1 + 6] = H8
H2[H1 + 7] = H6
H7 = 128
state = 3 break end
if state == 3 then
H0 = H7
H2 = _regs8
H1 = 1
H5 = H2[H1 + 0]
H6 = H2[H1 + 1]
H6[H5 + 4] = H0
H0 = 3
H2 = _file_index
H1 = 1
H2[H1 + 0] = H0
state = 5 break end
if state == 4 then
H7 = 0
state = 3 break end
if state == 5 then
H1 = _file_index
H0 = 1
H2 = H1[H0 + 0]
if H2 ~= 0 then state = 8 else state = 10 end break end
if state == 6 then
H1 = _file_index
H0 = 1
H2 = H1[H0 + 0]
H0 = -1
H1 = H2 + H0
H2 = _file_index
H0 = 1
H2[H0 + 0] = H1
H0 = H1
H2 = _disk
H1 = 1
H5 = H0 + H1
H2[H5 + 0] = H10
state = 5 break end
if state == 7 then
H0 = 32898
H1 = _open
H2 = H1(sp, stack, H8, H9, H0)
H10 = H2
state = 6 break end
if state == 8 then
H0 = 2
H1 = H3 + H0
H8 = H4[H3 + 2]
H9 = H4[H3 + 3]
H3 = H1
H3 = H1
if H9 then state = 7 else state = 9 end break end
if state == 9 then
H10 = 0
state = 6 break end
if state == 10 then
H1 = _disk
H0 = 1
H11 = H1[H0 + 0]
if H11 ~= 0 then state = 11 else state = 13 end break end
if state == 11 then
H0 = 2
H1 = 0
H2 = _lseek
H3 = H2(sp, stack, H11, H1, H0)
H0 = 9
H1 = shr(H3, H0)
H12 = H1
state = 12 break end
if state == 12 then
H0 = H12
H2 = _regs16
H1 = 1
H3 = H2[H1 + 0]
H4 = H2[H1 + 1]
H1 = H3
H2 = H4
H2[H1 + 0] = H0
H1 = _disk
H0 = 1
H2 = H1[H0 + 2]
H1 = _regs8
H0 = 1
H3 = H1[H0 + 0]
H4 = H1[H0 + 1]
H0 = 256
H5 = _reg_ip
H1 = 1
H5[H1 + 0] = H0
H0 = 256
H1 = H3 + H0
H0 = 65280
H3 = _read
H5 = H3(sp, stack, H2, H1, H4, H0)
state = 14 break end
if state == 13 then
H12 = 0
state = 12 break end
if state == 14 then
H1 = _regs8
H0 = 1
H2 = H1[H0 + 0]
H3 = H1[H0 + 1]
H1 = _regs16
H0 = 1
H4 = H1[H0 + 0]
H5 = H1[H0 + 1]
H0 = H5[H4 + 129]
H1 = H0
H0 = H1
H1 = H2 + H0
H0 = H3[H1 + 0]
H2 = _bios_table_lookup
H1 = 1
H2[H1 + 0] = H0
state = 14 break end
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
_mem = {}
_G._mem = _mem
_io_ports = {}
_G._io_ports = _io_ports
_opcode_stream = {}
_G._opcode_stream = _opcode_stream
_regs8 = {}
_G._regs8 = _regs8
_i_rm = {}
_G._i_rm = _i_rm
_i_w = {}
_G._i_w = _i_w
_i_reg = {}
_G._i_reg = _i_reg
_i_mod = {}
_G._i_mod = _i_mod
_i_mod_size = {}
_G._i_mod_size = _i_mod_size
_i_d = {}
_G._i_d = _i_d
_i_reg4bit = {}
_G._i_reg4bit = _i_reg4bit
_raw_opcode_id = {}
_G._raw_opcode_id = _raw_opcode_id
_xlat_opcode_id = {}
_G._xlat_opcode_id = _xlat_opcode_id
_extra = {}
_G._extra = _extra
_rep_mode = {}
_G._rep_mode = _rep_mode
_seg_override_en = {}
_G._seg_override_en = _seg_override_en
_rep_override_en = {}
_G._rep_override_en = _rep_override_en
_trap_flag = {}
_G._trap_flag = _trap_flag
_int8_asap = {}
_G._int8_asap = _int8_asap
_scratch_uchar = {}
_G._scratch_uchar = _scratch_uchar
_io_hi_lo = {}
_G._io_hi_lo = _io_hi_lo
_vid_mem_base = {}
_G._vid_mem_base = _vid_mem_base
_spkr_en = {}
_G._spkr_en = _spkr_en
_bios_table_lookup = {}
_G._bios_table_lookup = _bios_table_lookup
_regs16 = {}
_G._regs16 = _regs16
_reg_ip = {}
_G._reg_ip = _reg_ip
_seg_override = {}
_G._seg_override = _seg_override
_file_index = {}
_G._file_index = _file_index
_wave_counter = {}
_G._wave_counter = _wave_counter
_op_source = {}
_G._op_source = _op_source
_op_dest = {}
_G._op_dest = _op_dest
_rm_addr = {}
_G._rm_addr = _rm_addr
_op_to_addr = {}
_G._op_to_addr = _op_to_addr
_op_from_addr = {}
_G._op_from_addr = _op_from_addr
_i_data0 = {}
_G._i_data0 = _i_data0
_i_data1 = {}
_G._i_data1 = _i_data1
_i_data2 = {}
_G._i_data2 = _i_data2
_scratch_uint = {}
_G._scratch_uint = _scratch_uint
_scratch2_uint = {}
_G._scratch2_uint = _scratch2_uint
_inst_counter = {}
_G._inst_counter = _inst_counter
_set_flags_type = {}
_G._set_flags_type = _set_flags_type
_GRAPHICS_X = {}
_G._GRAPHICS_X = _GRAPHICS_X
_GRAPHICS_Y = {}
_G._GRAPHICS_Y = _GRAPHICS_Y
_pixel_colors = {}
_G._pixel_colors = _pixel_colors
_vmem_ctr = {}
_G._vmem_ctr = _vmem_ctr
_op_result = {}
_G._op_result = _op_result
_disk = {}
_G._disk = _disk
_scratch_int = {}
_G._scratch_int = _scratch_int
_clock_buf = {}
_G._clock_buf = _clock_buf
_ms_clock = {}
_G._ms_clock = _ms_clock
_G._set_CF = _set_CF
_G._set_AF = _set_AF
_G._set_OF = _set_OF
_G._set_AF_OF_arith = _set_AF_OF_arith
_G._make_flags = _make_flags
_G._set_flags = _set_flags
_G._set_opcode = _set_opcode
_G._pc_interrupt = _pc_interrupt
_G._AAA_AAS = _AAA_AAS
_G._main = _main
--[[ -- has more than 60 upvalues
_open = _G._open
_lseek = _G._lseek
_read = _G._read
_write = _G._write
_time = _G._time
_ftime = _G._ftime
--]]
do return end
end
until true
end
end

clue.crt.add_initializer(initializer)
