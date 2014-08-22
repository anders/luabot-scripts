local age = arg[1]
if not age or not tonumber(age) then
  age = tostring(etc.getOutput(etc.age, ...)):match("(%d+) years")
end
return tonumber(age)/2+7
