how_much_swag = 0.4
swagger = {"yolo", "nigga", "swag", "bitchin", "holla", "gangsta", "gangz", "bling",
           "chainz", "hustla", "hustlin", "trippin", "stackin", "homie", "dawg",
           "ridin dirty", "poppin"}

return (arg[1]:gsub(" ", function (x)
  swag = swagger[math.floor(math.random() * #swagger) + 1]
  return math.random() < how_much_swag and (" " .. swag .. " ") or " "
end)) or ""