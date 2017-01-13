local id = (arg[1] or ""):match("\1TELEGRAM%-STICKER ([^\1]+)")
if id then
  return id
end
return nil, "Sticker not found"
