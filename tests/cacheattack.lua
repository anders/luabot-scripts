Cache = arg[1]
for i = 1, 2000 do
  Cache[("u"):rep(math.random(1, 100))] = ("U"):rep(math.random(1, 1000))
end
print("done")
