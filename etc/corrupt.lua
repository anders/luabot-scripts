return (arg[1]:gsub("[%z\1-\127\194-\244][\128-\191]*", function(c)
  if math.random() > 0.95 then
    return "�"
  else
    return c
  end
end))
