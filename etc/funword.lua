local words = {
"bamboozled",
"bazinga",
"bevy",
"bifurcate",
"bilirubin",
"bobolink",
"buccaneer",
"bulgur",
"bumfuzzle",
"canoodle",
"cantankerous",
"carbuncle",
"caterwaul",
"cattywampus",
"cheeky",
"conniption",
"coot",
"didgeridoo",
"dingy",
"doodle",
"doohickey",
"eschew",
"fiddledeedee",
"finagle",
"flanker",
"floozy",
"fungible",
"girdle",
"gobsmacked",
"grog",
"gumption",
"gunky",
"hitherto",
"hornswoggle",
"hullabaloo",
"indubitably",
"janky",
"kahuna",
"katydid",
"kerplunk",
"kinkajou",
"knickers",
"lackadaisical",
"loopy",
"manscape",
"monkey",
"mugwump",
"namby-pamby",
"noggin",
"pantaloons",
"passel",
"persnickety",
"popinjay",
"prestidigitation",
"proctor",
"rapscallion",
"rookery",
"rumpus",
"scootch",
"scuttlebutt",
"shebang",
"smegma",
"snarky",
"snuffle",
"spelunker",
"spork",
"sprocket",
"squeegee",
"succubus",
"tater",
"tuber",
"tuchis",
"viper",
"waddle",
"walkabout",
"wasabi",
"weasel",
"wenis",
"whatnot",
"wombat",
"wonky",
"zeitgeist",
"abibliophobia",
"absquatulate",
"allegator",
"anencephalous",
"argle-bargle",
"batrachomyomachy",
"billingsgate",
"bloviate",
"blunderbuss",
"borborygm",
"boustrophedon",
"bowyang",
"brouhaha",
"bumbershoot",
"callipygian",
"canoodle",
"cantankerous",
"catercornered",
"cockalorum",
"cockamamie",
"codswallop",
"collop",
"collywobbles",
"comeuppance",
"crapulence",
"crudivore",
"discombobulate",
"donnybrook",
"doozy",
"dudgeon",
"ecdysiast",
"eructation",
"fard",
"fartlek",
"fatuous",
"filibuster",
"firkin",
"flibbertigibbet",
"flummox",
"folderol",
"formication",
"fuddy-duddy",
"furbelow",
"furphy",
"gaberlunzie",
"gardyloo!",
"gastromancy",
"gazump",
"gobbledygook",
"gobemouche",
"godwottery",
"gongoozle",
"gonzo",
"goombah",
"hemidemisemiquaver",
"hobbledehoy",
"hocus-pocus",
"hoosegow",
"hootenanny",
"jackanapes",
"kerfuffle",
"klutz",
"la-di-da",
"lagopodous",
"lickety-split",
"lickspittle",
"logorrhea",
"lollygag",
"malarkey",
"maverick",
"mollycoddle",
"mugwump",
"mumpsimus",
"namby-pamby",
"nincompoop",
"oocephalus",
"ornery",
"pandiculation",
"panjandrum",
"pettifogger",
"pratfall",
"quean",
"rambunctious",
"ranivorous",
"rigmarole",
"shenanigan",
"sialoquent",
"skedaddle",
"skullduggery",
"slangwhanger",
"smellfungus",
"snickersnee",
"snollygoster",
"snool",
"tatterdemalion",
"troglodyte",
"turdiform",
"unremacadamized",
"vomitory",
"wabbit",
"widdershins",
"butt",
"butts",
"goat",
"willy-nilly",
"llama",
}


local len = tonumber(arg[1])

if len and len > 0 then
  local start = math.random(#words)
  for i = start, #words do
    if words[i]:len() == len then
      return words[i]
    end
  end
  for i = 1, start - 1 do
    if words[i]:len() == len then
      return words[i]
    end
  end
  return 'a' .. ('h'):rep(len - 1)
elseif type(arg[1]) == "string" and #arg[1] > 0 then
  return etc.translateWords(arg[1], function(w)
    if w:len() >= math.random(4, 10) then
      return words[math.random(#words)]
    end
  end)
else
  return words[math.random(#words)]
end


