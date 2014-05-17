return (etc.getOutput(etc.weather, ...):gsub('[AOUEIYaoueiy]', function (c)
  if c:upper() == c then return 'O' else return 'o' end
end))