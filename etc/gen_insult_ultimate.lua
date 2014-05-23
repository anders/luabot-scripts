local s = ""

local firstwordfunc = etc.capitalize
local nocapfunc = function(x) return x end
local moar = false
if math.random() < 0.15 then
  moar = true
  firstwordfunc = nocapfunc
  s = "You know what? "
end
if moar or math.random() < 0.30 then
  firstwordfunc = nocapfunc
  s = s .. "You're nothing but a "
end

local list1 = {
"lazy", "stupid", "insecure", "idiotic", "slimy", "slutty", "smelly", "pompous", "communist", "dicknose", "pie-eating", "racist", "elitist", "white trash", "drug-loving", "butterface", "tone deaf", "ugly", "creepy"
}

local list2 = {
"douche", "ass", "turd", "rectum", "butt", "cock", "shit", "crotch", "bitch", "turd", "prick", "slut", "taint", "fuck", "dick", "boner", "shart", "nut", "sphincter"
}

local list3 = {
"pilot", "canoe", "captain", "pirate", "hammer", "knob", "box", "jockey", "nazi", "waffle", "goblin", "blossum", "biscuit", "clown", "socket", "monster", "hound", "dragon", "balloon"
}

return s .. firstwordfunc(pickone(list1)) .. " " .. pickone(list2) .. " " .. pickone(list3)
