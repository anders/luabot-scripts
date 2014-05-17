if Editor then
  return
end

etc.sm(Cache, '~goat', arg,
function(...)
  print("Give me an A!")
end,
function(x)
  if x ~= 'A' then
    print("huh? no.")
    return false
  end
  print("Yay, now give me a B!")
end,
function(x)
  if x ~= 'B' then
    print("now you're just messing with me. go back to A now.")
    return 1
  end
  print("Hooray!")
end
)
