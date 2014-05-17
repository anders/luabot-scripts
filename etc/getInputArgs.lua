-- Returns standard input followed by 0 or more command arguments.
-- Standard input will always be a string but will be empty if none.

if Input.piped then
  if Input.piped > 1 then
    -- print("piped>1, '" .. arg[1]:sub(Input.piped) .. "', " .. arg[1]:sub(1, Input.piped - 1))
    return arg[1]:sub(Input.piped), arg[1]:sub(1, Input.piped - 1)
  else
    -- print("piped=1, '" .. arg[1] .. "'")
    return arg[1]
  end
end

-- print("piped=nil, '', ", ...)
return "", ...
