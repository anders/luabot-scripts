local a, b = httpGet(...)
if a then
  return a
end
return a, b
