API "1.1"

local x, y = etc.getRandomRedditTitle(
  pickone{ 'joke', 'jokes', 'dadjokes', 'meanjokes', 'cleanjokes', }
  )
if not x then
  return x, y
end
return x
