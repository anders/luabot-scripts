t={'%N% reeks',
   'gface',
   'g f a c e'}
m=t[math.random(1,#t)]
m=m:gsub('%%(%w+)%%', function(s)
  if s == 'N' then return rnick() end
  return '<unknown>'
end)
return '<q66> '..m
