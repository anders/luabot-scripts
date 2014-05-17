local code = arg[1]

local dispatch = {
  [">"] = "ptr=ptr+1;",
  ["<"] = "ptr=ptr-1;",
  ["+"] = "mem[ptr]=(mem[ptr] or 0)+1;",
  ["-"] = "mem[ptr]=(mem[ptr] or 0)-1;",
  ["."] = "buf=buf..string.char(mem[ptr]);",
  [","] = "error(\", not implemented\");",
  ["["] = "while mem[ptr]~=0 do ",
  ["]"] = "end;"
}

local preamble = "local buf=\"\";local ptr=1;local mem={};"
local gen = {}
local postamble = "return buf;"

for c in code:gmatch"." do
  local op = dispatch[c]
  if op ~= nil then
    gen[#gen + 1] = op
  end
end

local gen2 = preamble .. table.concat(gen, "") .. postamble
print(loadstring(gen2)())
