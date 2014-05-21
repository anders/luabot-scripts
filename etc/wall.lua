if arg[1] then
  local x = "[wall] " .. tostring(arg[1])
  if Event then
    print(x)
  else
    sendNotice(dest, x)
  end
  _clown()
  if dest:lower() ~= "#clowngames" then
    sendNotice("#clowngames", x)
  end
  halt() -- Temporary: stop other things due to _clown.
else
  return nil, "?"
end
