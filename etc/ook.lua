API "1.1"

return etc.brainfuck((arg[1] or ''):gsub("[Oo]ok([%.!%?]) ?[Oo]ok([%.!%?]) ?", function(a, b)
  if a == '.' then
    if b == '?' then
      return '>'
    elseif b == '!' then
      return ','
    elseif b == '.' then
      return '+'
    end
  elseif a == '?' then
    if b == '.' then
      return '<'
    elseif b == '!' then
      return ']'
    else
      error("??")
    end
  elseif a == '!' then
    if b == '?' then
      return '['
    elseif b == '!' then
      return '-'
    elseif b == '.' then
      return '.'
    end
  end
end))
