-- Usage: 'newandroid - generate a new Android version and name

local dumb_names = {
  "Mars Bar",
  "Junior Mint",
  "Skittles",
  "M&M",
  "Jolly Rancher",
  "Dr. Pepper",
  "Reese's",
  "Hershey's Kiss",
  "Tootsie Roll",
  "Pez Dispenser",
  "Swedish Fish",
  "Milky Way",
  "Kool-Aid",
  "Butterfinger",
  "Starburst",
  "Gummy Bear",
  "Root Beer",
}

local version = ("%d.%d"):format(math.random(6, 9), math.random(0, 9))

return ('Android %s "%s"'):format(version, pickone(dumb_names))
