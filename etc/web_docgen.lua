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
  etc.docgen(Web.GET['code'], '-text')
else
  Web.header 'Content-Type: text/html; charset=utf-8'
  print = function(s) Web.write(s) end
  etc.docgen(Web.GET['code'], '-html')
end
