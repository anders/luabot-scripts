-- Usage: 'findstr string just find a string like the stupid windos command. Allows -I for case-insensitive and -R for patterns.

if arg[1] and Input and Input.piped then

  local haystack = arg[1]:sub(1, Input.piped)
  local argstr = arg[1]:sub(Input.piped + 1)
  -- local needle = argstr
  local flags, needle = etc.getArgs(etc.splitArgs(argstr))
  
  local plain = true
  if flags.r or flags.R then
    plain = false
  end
  
  local ci = false
  if flags.i or flags.I then
    ci = true
    needle = needle:lower()
  end
  
  -- print("THIS IS DEBUG haystack", haystack)
  -- print("THIS IS DEBUG needle", needle)
  
  for line in haystack:gmatch("[^\r\n]+") do
    local checkline = line
    if ci then
      checkline = checkline:lower()
    end
    if checkline:find(needle, 1, plain) then
      print(line)
    end
  end

end
