if arg[1] then
  local input
  local a, b = arg[1]:match("^'([^ ]+) ?(.*)")
  if a then
    assert(etc[a], "No such function: etc" .. a)
    
    local input
    if b:len() > 0 then
      input = etc.getOutput(etc[a], b)
    else
      input = etc.getOutput(etc[a])
    end
  else
    input = arg[1]
  end
  assert(type(input) == "string", "Expected a string")
  
  print(etc.pm(etc.F(input)))
  
else
  assert(false, "Nothing to do, use 'us'something")
end
