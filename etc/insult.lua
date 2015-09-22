-- Usage: 'insult - Insult someone. If you want to add insults, just write a function gen_insult_x where x is a unique name.

local t = etc.findFunc("^gen_insult_.*")

if #t == 0 then
  return "idiot"
end

local func = etc[t[math.random(#t)]]
local prefix = ""
if arg[1] and not Output.brief then
  prefix = tostring(arg[1]) .. ": "
end
return prefix .. etc.getOutput(func)
