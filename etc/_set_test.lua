local val = ...

if math.random(1,2)==1 then
  return false, 'random failure'
else
  return val:upper(), {test2=os.time()}
end
