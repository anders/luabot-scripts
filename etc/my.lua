-- alias:  'my

if arg[1] then
  local input
  if Input and Input.piped then
    input = arg[1]
  else
    local a, b = arg[1]:match("^'([^ ]+) ?(.*)")
    if not a then
      assert(false, "What just happened")
    end
    assert(etc[a], "No such function")
    
    if b:len() > 0 then
      input = etc.getOutput(etc[a], b)
    else
      input = etc.getOutput(etc[a])
    end
  end
  
  local fixer = arg[2] or etc.get("my") or etc.get("fix")
  if not fixer then
    print("You have no my code, outputting normally:")
    print(input)
    return
  end
  
  --[[
  local c = "return etc.getOutput(function(...)return " .. fixer .. " ;end, ...)"
  local d = "return (function(etc, plugin, ...) " .. c .. " ;end)(...)"
  -- print("DEBUG", "loadstring:", d)
  -- print("DEBUG", "input:", input)
  local f = assert(loadstring(d))
  print(f(etc, plugin, input))
  --]]
  
  local f = assert(godloadstring("return " .. fixer))
  -- print(f(input))
  return f(input)
  
else
  assert(false, "Nothing to fix, use 'set my code(...)")
end
