return (arg[1] or 'gface'):gsub("[gface]", function(x)
  if x == 'g' then return '(' end
  if x == 'f' then return '≖' end
  if x == 'a' then return '‿' end
  if x == 'c' then return '≖' end
  if x == 'e' then return ')' end
end) or ''
