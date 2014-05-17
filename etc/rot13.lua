local byte_a, byte_A = string.byte('a'), string.byte('A')
return (string.gsub((arg[1] or ''), "[%a]",
    function (char)
      local offset = (char < 'a') and byte_A or byte_a
      local b = string.byte(char) - offset -- 0 to 25
      b = ((b + 13) % 26) + offset -- Rotate
      return string.char(b)
    end
  ))