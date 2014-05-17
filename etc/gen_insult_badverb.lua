if math.random() < 0.5 then
  return etc.capitalize(etc.badword() .. " " .. dbotscript("%v%"))
else
  return etc.capitalize(dbotscript("%v%") .. " " .. etc.badword())
end
