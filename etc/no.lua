local s = pickone{"no", "nope", "hells no", "omg no", "absolutely not", "nix", "never"}
if arg[1] then
  s = s .. " " .. arg[1]
end
return s
