API "1.1"

local pub = pub

if not pub then
  -- all wrapped functions return their output, regardless
  -- of whether they use print or return
  local function wrapper(name)
    return function(...)
      return etc.getOutput(etc[name], ...)
    end
  end

  pub = {}
  for k, v in ipairs(etc.find('*', true)) do
    pub[v] = wrapper(v)
  end
end

-- An example of a function that would normally print
print("pub.uno(\"help\") = "..pub.uno("help"))
