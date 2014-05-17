if not Input or not Input.piped or not arg[1] then
  assert(not arg[1], "tee: argument not supported")
  return
end
assert(Input.piped >= #arg[1], "tee: argument not supported")
directprint(...) -- assuming stdout
return ...
