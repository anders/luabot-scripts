-- a port of https://github.com/LizardGamer/tumblr-argument-generator/blob/develop/app/assets/js/main.js
-- original by Lokaltog
-- github pls no delete

local intro = {
  "burn in hell", "check your privilege", "fuck you", "fuck off",
  "please die", "rot in hell", "screw you", "shut the fuck up", "shut up",
  "kill yourself", "drop dead"
}

local description = {
  "deluded", "fucking", "god damn", "judgemental", "worthless"
}

local marginalized = {
  {
    "activist", "agender", "appearance", "asian", "attractive", "bi",
    "bigender", "black", "celestial", "chubby", "closet", "color", "curvy",
    "dandy", "deathfat", "demi", "differently abled", "disabled",
    "diversity", "dysphoria", "ethnic", "ethnicity", "fat love", "fat",
    "fatist", "fatty", "female", "feminist", "genderfuck", "genderless",
    "hair", "height", "indigenous", "intersectionality", "invisible", "kin",
    "lesbianism", "little person", "marginalized", "minority", "multigender",
    "non-gender", "non-white", "obesity", "otherkin", "pansexual",
    "polygender", "privilege", "prosthetic", "queer", "radfem", "skinny",
    "smallfat", "stretchmark", "thin", "third-gender", "trans*", "transfat",
    "transgender", "transman", "transwoman", "trigger", "two-spirit", "womyn",
    "poc", "woc"
  },
  {
    "chauvinistic", "misogynistic", "nphobic", "oppressive", "phobic",
    "shaming", "denying", "discriminating", "hypersexualizing", "intolerant",
    "racist", "sexualizing"
  }
}

local privileged = {
  {
    "able-bodied", "appearance", "attractive", "binary", "bi", "cis",
    "cisgender", "cishet", "hetero", "male", "smallfat", "thin", "white"
  },
  {
    "ableist", "classist", "normative", "overprivileged", "patriarch",
    "sexist", "privileged"
  }
}

local finisher = {
  "asshole", "bigot", "oppressor", "piece of shit", "rapist", "scum",
  "shitlord", "subhuman", "misogynist", "nazi"
}

local generateTerm = function()
  return
    pickone { "a", "bi", "dandy", "demi", "gender", "multi", "pan", "poly" } ..
    pickone { "amorous", "femme", "fluid", "queer", "romantic", "sexual", }
end

local generateArgument = function()
  local buf = {
    pickone(intro),
  ", you ",
    pickone(description),
  " ",
    pickone {
      generateTerm(),
      pickone(marginalized[1])
    },
  "-",
    pickone(marginalized[2]),
  ", ",
    pickone(privileged[1]),
  "-",
    pickone(privileged[2]),
  " ",
    pickone(finisher),
  ".",
  }
  return table.concat(buf)
end

if arg[1] then
  return arg[1]..": "..generateArgument()
else
  return generateArgument()
end
