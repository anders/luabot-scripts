t={'%N% reeks',
   'gface',
   'g f a c e',
   function()
     return 'I promise not to shitpost for '..math.random(2, 4)..' months'
   end}
m=t[math.random(1,#t)]
if type(m) == "function" then
  m = m()
end
m=m:gsub('%%(%w+)%%', function(s)
  if s == 'N' then return rnick() end
  return '<unknown>'
end)
return '<q66> '..m
