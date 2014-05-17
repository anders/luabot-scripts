--[[
changes:

- lol semicolons
- . now adds to buf[], then at the end uses table.concat
- string.char is localized as ch
]]

local code = arg[1] or "++++++++[>++++[>++>+++>+++>+<<<<-]>+>+>->>+[<]<-]>>.>---.+++++++..+++.>>.<-.<.+++.------.--------.>>+.>++."

local dispatch = {
  [">"] = "ptr=ptr+1 ",
  ["<"] = "ptr=ptr-1 ",
  ["+"] = "mem[ptr]=(mem[ptr] or 0)+1 ",
  ["-"] = "mem[ptr]=(mem[ptr] or 0)-1 ",
  ["."] = "buf[i]=ch(mem[ptr]) i=i+1 ",
  [","] = "error(\", not implemented\") ",
  ["["] = "while mem[ptr]~=0 do ",
  ["]"] = "end "
}

local preamble = "local buf,ptr,mem,ch,i={},1,{},string.char,1 "
local gen = {}
local postamble = "return table.concat(buf)"

for c in code:gmatch"." do
  local op = dispatch[c]
  if op ~= nil then
    gen[#gen + 1] = op
  end
end

local gen2 = preamble .. table.concat(gen) .. postamble
print(loadstring(gen2)())
