local mash = {'a', 's', 'd', 'f', 'g', 'h', 'j', 'k', 'e', 'r', 'w',
              't', 'y', 'e', 'b', 'c', 'v', 'b', 'ø', 'æ', 'dt'}
return (arg[1]:gsub("%w+", function(w)
  local n = #w - #w / 4
  local tmp = {w:sub(1, n)}
  for i=1, math.max(#w - n, 3) do
    tmp[#tmp + 1] = mash[math.random(1, #mash)]
  end
  return table.concat(tmp)
end))
