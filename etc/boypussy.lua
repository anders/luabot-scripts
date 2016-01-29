API "1.1"

if nick:find('gmcabrita') then
  return '<'..pickone{'graphitemastercabrita', 'gaymancabrita'}..'> meme'
end

return pickone({
function()
  return '<supergauntlet> dude '..pickone{rnick(), 'weed'}..' lmao'
end,
function()
  return '<supergauntlet> classic '..rnick()
end,
})()
