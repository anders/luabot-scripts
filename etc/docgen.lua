-- Usage: 'docgen <file> or 'docgen '<etcfunc> - generate documentation for the file, provides web link.

local doc = require "doc"

if not Web then
  local suff = ""
  if arg[1] then
    suff = "?code=" .. arg[1]
  end
  print(boturl .. "u/" .. urlEncode(getname(owner())) .. "/docgen.lua" .. suff)
  return
end
if not Web.GET['code'] then
  print("need ?code=")
elseif Web.GET['text'] then
  doc.generate(Web.GET['code'], 'text')
else
  Web.header 'Content-Type: text/html; charset=utf-8'
  doc.print = function(...) Web.write(etc.stringprint(...)) end
  doc.generate(Web.GET['code'], 'html')
end
