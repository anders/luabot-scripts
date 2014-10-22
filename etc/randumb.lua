API "1.1"

return (arg[1] or 'dumb'):gsub("%w+", function(w)
  if math.random(3) == 1 then
    return "dumb"
  end
  return w
end) or ''
