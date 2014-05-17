-- Usage etc.stripCodes(str) - strips out control codes from the string.

return (arg[1] or ''):gsub("([\002\0029\022\003])(%d?%d?,?%d?%d?)", function(code, nn)
    if code ~= "\003" then return nn end
    return ""
  end) or ''
