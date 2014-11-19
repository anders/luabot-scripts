-- Usage: 'newphone - generate a new bogus phone name

  local manufacturers = {
    'HTC'
    , 'Motorola'
    , 'Samsung'
    , 'LG'
    , 'Sony Ericsson'
    , 'Acer'
  };
  local names = {
    'Droid'
    , 'Nexus'
    , 'Galaxy'
    , 'Motivate'
    , 'Fascinate'
    , 'Captivate'
    , 'Bionic'
    , 'Infuse'
    , 'Sensation'
    , 'Atrix'
    , 'MyTouch'
    , 'Liquid'
    , 'Dream'
    , 'Desire'
    , 'Aria'
    , 'Hero'
    , 'Legend'
    , 'Magic'
    , 'Evo'
    , 'Wildfire'
    , 'Thunderbolt'
    , 'Mesmerize'
    , 'Devour'
    , 'Defy'
    , 'Moment'
    , 'Xperia'
    , 'Charge'
    , 'Amaze'
    , 'Rezound'
    , 'Vigor'
  };
  local adjectives = {
    'Touch'
    , 'Epic'
    , 'Plus'
    , 'Slide'
    , 'Incredible'
    , 'Black'
    , 'Neo'
    , 'Vibrant'
    , 'Optimus'
    , 'Vivid'
  };
  local suffixs = {
    {'4G','4G+'}
    , {'S'}
    , {'X','X2','XT'}
    , {'2','II'}
    , {'3D'}
    , {'One'}
    , {'Plus'}
    , {'Prime'}
    , {'E'}
    , {'Pro'}
    , {'G1'}
    , {'G2'}
    , {'V'}
    , {'Z'}
    , {'Y'}
  };
-- Thanks android phone name generator .com

local result = pickone(manufacturers)
  .. " " .. pickone(names)
  .. " " .. pickone(adjectives)

local tsuff = etc.clone(suffixs)
for ri = 1, math.random(0, 3) do
  local i = math.random(1, #tsuff)
  result = result .. " " .. pickone(tsuff[ri])
  table.remove(tsuff, i)
end

return result
