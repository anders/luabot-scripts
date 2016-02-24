API "1.1"
-- stolen from xt / torhve

local unicode = require 'unicode'

local an = [[ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789,.?!"'`()[]{}<>&_]]
local charmaps = {
  ci = 'ⒶⒷⒸⒹⒺⒻⒼⒽⒾⒿⓀⓁⓂⓃⓄⓅⓆⓇⓈⓉⓊⓋⓌⓍⓎⓏⓐⓑⓒⓓⓔⓕⓖⓗⓘⓙⓚⓛⓜⓝⓞⓟⓠⓡⓢⓣⓤⓥⓦⓧⓨⓩ⓪①②③④⑤⑥⑦⑧⑨',
  bl = '𝔄𝔅ℭ𝔇𝔈𝔉𝔊ℌℑ𝔍𝔎𝔏𝔐𝔑𝔒𝔓𝔔ℜ𝔖𝔗𝔘𝔙𝔚𝔛𝔜ℨ𝔞𝔟𝔠𝔡𝔢𝔣𝔤𝔥𝔦𝔧𝔨𝔩𝔪𝔫𝔬𝔭𝔮𝔯𝔰𝔱𝔲𝔳𝔴𝔵𝔶𝔷',
  ud = [[∀BƆDƎℲפHIſK˥WNOԀQRS┴∩ΛMX⅄Zɐqɔpǝɟƃɥᴉɾʞlɯuodbɹsʇnʌʍxʎz0ƖᄅƐㄣϛ9ㄥ86'˙¿¡,,,)(][}{><⅋‾]],
  nc = [[🅐🅑🅒🅓🅔🅕🅖🅗🅘🅙🅚🅛🅜🅝🅞🅟🅠🅡🅢🅣🅤🅥🅦🅧🅨🅩🅐🅑🅒🅓🅔🅕🅖🅗🅘🅙🅚🅛🅜🅝🅞🅟🅠🅡🅢🅣🅤🅥🅦🅧🅨🅩⓿]],
  sq = [[🄰🄱🄲🄳🄴🄵🄶🄷🄸🄹🄺🄻🄼🄽🄾🄿🅀🅁🅂🅃🅄🅅🅆🅇🅈🅉🄰🄱🄲🄳🄴🄵🄶🄷🄸🄹🄺🄻🄼🄽🄾🄿🅀🅁🅂🅃🅄🅅🅆🅇🅈🅉0123456789,⊡]],
  ns = [[🅰🅱🅲🅳🅴🅵🅶🅷🅸🅹🅺🅻🅼🅽🅾🅿🆀🆁🆂🆃🆄🆅🆆🆇🆈🆉🅰🅱🅲🅳🅴🅵🅶🅷🅸🅹🅺🅻🅼🅽🅾🅿🆀🆁🆂🆃🆄🆅🆆🆇🆈🆉]],
  ds = [[𝔸𝔹ℂ𝔻𝔼𝔽𝔾ℍ𝕀𝕁𝕂𝕃𝕄ℕ𝕆ℙℚℝ𝕊𝕋𝕌𝕍𝕎𝕏𝕐ℤ𝕒𝕓𝕔𝕕𝕖𝕗𝕘𝕙𝕚𝕛𝕜𝕝𝕞𝕟𝕠𝕡𝕢𝕣𝕤𝕥𝕦𝕧𝕨𝕩𝕪𝕫𝟘𝟙𝟚𝟛𝟜𝟝𝟞𝟟𝟠𝟡]],
  bo = [[𝐀𝐁𝐂𝐃𝐄𝐅𝐆𝐇𝐈𝐉𝐊𝐋𝐌𝐍𝐎𝐏𝐐𝐑𝐒𝐓𝐔𝐕𝐖𝐗𝐘𝐙𝐚𝐛𝐜𝐝𝐞𝐟𝐠𝐡𝐢𝐣𝐤𝐥𝐦𝐧𝐨𝐩𝐪𝐫𝐬𝐭𝐮𝐯𝐰𝐱𝐲𝐳𝟎𝟏𝟐𝟑𝟒𝟓𝟔𝟕𝟖𝟗]],
  bi = [[𝑨𝑩𝑪𝑫𝑬𝑭𝑮𝑯𝑰𝑱𝑲𝑳𝑴𝑵𝑶𝑷𝑸𝑹𝑺𝑻𝑼𝑽𝑾𝑿𝒀𝒁𝒂𝒃𝒄𝒅𝒆𝒇𝒈𝒉𝒊𝒋𝒌𝒍𝒎𝒏𝒐𝒑𝒒𝒓𝒔𝒕𝒖𝒗𝒘𝒙𝒚𝒛0123456789]],
  bs = [[𝓐𝓑𝓒𝓓𝓔𝓕𝓖𝓗𝓘𝓙𝓚𝓛𝓜𝓝𝓞𝓟𝓠𝓡𝓢𝓣𝓤𝓥𝓦𝓧𝓨𝓩𝓪𝓫𝓬𝓭𝓮𝓯𝓰𝓱𝓲𝓳𝓴𝓵𝓶𝓷𝓸𝓹𝓺𝓻𝓼𝓽𝓾𝓿𝔀𝔁𝔂𝔃]],
  pt = [[⒜⒝⒞⒟⒠⒡⒢⒣⒤⒥⒦⒧⒨⒩⒪⒫⒬⒭⒮⒯⒰⒱⒲⒳⒴⒵⒜⒝⒞⒟⒠⒡⒢⒣⒤⒥⒦⒧⒨⒩⒪⒫⒬⒭⒮⒯⒰⒱⒲⒳⒴⒵0⑴⑵⑶⑷⑸⑹⑺⑻⑼]],
  tl = [[ค๒ς๔єŦﻮђเןкl๓ภ๏קợгรtยשฬץאzค๒ς๔єŦﻮђเןкl๓ภ๏קợгรtยשฬץאz0123456789,.؟!"'`()[]{}«»&_]],
  ru = [[ДЬCDЗFGHIJКLMИФPQЯSTЦVШЖУZдьcdзfghijкlmифpqяstцvшжуz0123456789,.?!"'`()[]{}<>&_]]
}
local codepoints
codepoints = function(str)
  return str:gmatch("[%z\1-\127\194-\244][\128-\191]*")
end
local mimic = {
  [" "] = {
    " ",
    " ",
    " ",
    " ",
    " ",
    " ",
    " ",
    " ",
    " ",
    " ",
    " ",
    " ",
    " ",
    " "
  },
  ["!"] = {
    "！",
    "ǃ",
    "ⵑ",
    "︕",
    "﹗"
  },
  ["\""] = {
    "＂"
  },
  ["#"] = {
    "＃",
    "﹟"
  },
  ["$"] = {
    "＄",
    "﹩"
  },
  ["%"] = {
    "％",
    "٪",
    "⁒",
    "﹪"
  },
  ["&"] = {
    "＆",
    "﹠"
  },
  ["'"] = {
    "＇",
    "ʹ"
  },
  ["("] = {
    "（",
    "⟮",
    "﹙"
  },
  [")"] = {
    "）",
    "⟯",
    "﹚"
  },
  ["*"] = {
    "＊",
    "⋆",
    "﹡"
  },
  ["+"] = {
    "＋",
    "᛭",
    "﹢"
  },
  [","] = {
    "，",
    "ˏ",
    "ᛧ",
    "‚"
  },
  ["-"] = {
    "－",
    "˗",
    " ",
    "ᝍ",
    "᠆",
    "ᱼ",
    "−",
    "⎯",
    "⎼",
    "╴",
    "ⲻ",
    "ⲻ",
    "ー",
    "ㄧ",
    "﹣"
  },
  ["."] = {
    "．",
    "․"
  },
  ["/"] = {
    "／",
    "᜵",
    "⁄",
    "∕",
    "⧸",
    "Ⳇ",
    "〳"
  },
  ["0"] = {
    "᱐"
  },
  ["2"] = {
    "ᒿ"
  },
  ["3"] = {
    "Ʒ",
    "ᢃ",
    "ℨ",
    "Ⳅ",
    "Ⳍ",
    "ⳍ"
  },
  ["4"] = {
    "Ꮞ"
  },
  ["6"] = {
    "Ꮾ"
  },
  ["9"] = {
    "Ꮽ"
  },
  [":"] = {
    "：",
    "ː",
    "˸",
    "։",
    "፡",
    "᛬",
    "᠄",
    "ᱺ",
    "⁚",
    "∶",
    "⠆",
    "︓",
    "︰",
    "﹕"
  },
  [";"] = {
    "；",
    ";",
    "︔",
    "﹔"
  },
  ["<"] = {
    "＜",
    "˂",
    "‹",
    "≺",
    "❮",
    "ⵦ",
    "〱",
    "ㄑ",
    "﹤"
  },
  ["="] = {
    "＝",
    "═",
    "⚌",
    "゠",
    "﹦"
  },
  [">"] = {
    "＞",
    "˃",
    "›",
    "≻",
    "❯",
    "﹥"
  },
  ["?"] = {
    "？",
    "︖",
    "﹖"
  },
  ["@"] = {
    "＠",
    "﹫"
  },
  ["A"] = {
    "Α",
    "А",
    "Ꭺ"
  },
  ["B"] = {
    "Β",
    "В",
    "Ᏼ",
    "ᗷ",
    "Ⲃ"
  },
  ["C"] = {
    "Ϲ",
    "С",
    "Ꮯ",
    "Ⅽ",
    "Ⲥ"
  },
  ["D"] = {
    "Ꭰ",
    "ᗪ",
    "Ⅾ"
  },
  ["E"] = {
    "Ε",
    "Е",
    "Ꭼ"
  },
  ["F"] = {
    "ᖴ"
  },
  ["G"] = {
    "Ԍ",
    "Ꮐ"
  },
  ["H"] = {
    "Η",
    "Н",
    "ዘ",
    "Ꮋ",
    "ᕼ",
    "Ⲏ"
  },
  ["I"] = {
    "Ι",
    "І",
    "Ⅰ"
  },
  ["J"] = {
    "Ј",
    "Ꭻ",
    "ᒍ"
  },
  ["K"] = {
    "Κ",
    "Κ",
    "Ꮶ",
    "ᛕ",
    "K",
    "Ⲕ"
  },
  ["L"] = {
    "Ꮮ",
    "ᒪ",
    "Ⅼ",
    "Ⳑ"
  },
  ["M"] = {
    "Μ",
    "Ϻ",
    "М",
    "Ꮇ",
    "Ⅿ"
  },
  ["N"] = {
    "Ν",
    "Ⲛ"
  },
  ["O"] = {
    "Ο",
    "О",
    "ᱛ",
    "Ⲟ"
  },
  ["P"] = {
    "Ρ",
    "Р",
    "Ꮲ",
    "Ⲣ"
  },
  ["Q"] = {
    "Ԛ",
    "Ⴓ",
    "ⵕ"
  },
  ["R"] = {
    "Ꭱ",
    "Ꮢ",
    "ᖇ"
  },
  ["S"] = {
    "Ѕ",
    "Ⴝ",
    "Ꮪ"
  },
  ["T"] = {
    "Τ",
    "Т",
    "Ꭲ"
  },
  ["V"] = {
    "Ꮩ",
    "Ⅴ"
  },
  ["W"] = {
    "Ꮃ",
    "Ꮤ"
  },
  ["X"] = {
    "Χ",
    "Х",
    "Ⅹ",
    "Ⲭ"
  },
  ["Y"] = {
    "Υ",
    "Ⲩ"
  },
  ["Z"] = {
    "Ζ",
    "Ꮓ"
  },
  ["["] = {
    "［"
  },
  ["\\"] = {
    "＼",
    "∖",
    "⧵",
    "⧹",
    "〵",
    "﹨"
  },
  ["]"] = {
    "］"
  },
  ["^"] = {
    "＾",
    "˄",
    "ˆ",
    "ᶺ",
    "⌃"
  },
  ["_"] = {
    "＿",
    "ˍ",
    "⚊",
    "﹘"
  },
  ["`"] = {
    "｀",
    "ˋ",
    "`",
    "‵"
  },
  ["a"] = {
    "ɑ",
    "а"
  },
  ["c"] = {
    "ϲ",
    "с",
    "ⅽ"
  },
  ["d"] = {
    "ԁ",
    "ⅾ"
  },
  ["e"] = {
    "е",
    "ᥱ"
  },
  ["g"] = {
    "ɡ"
  },
  ["h"] = {
    "һ"
  },
  ["i"] = {
    "і",
    "ⅰ"
  },
  ["j"] = {
    "ϳ",
    "ј"
  },
  ["l"] = {
    "ⅼ"
  },
  ["m"] = {
    "ⅿ"
  },
  ["n"] = {
    "ᥒ"
  },
  ["o"] = {
    "ο",
    "о",
    "೦",
    "ഠ",
    "൦",
    "ᦞ",
    "᧐",
    "ⲟ"
  },
  ["p"] = {
    "р",
    "ⲣ"
  },
  ["s"] = {
    "ѕ"
  },
  ["u"] = {
    "ᥙ",
    "∪"
  },
  ["v"] = {
    "ᴠ",
    "ⅴ",
    "∨",
    "⋁"
  },
  ["w"] = {
    "ᴡ"
  },
  ["x"] = {
    "х",
    "ⅹ",
    "ⲭ"
  },
  ["y"] = {
    "у",
    "ỿ"
  },
  ["z"] = {
    "ᤁ",
    "ᴢ"
  },
  ["{"] = {
    "｛",
    "﹛"
  },
  ["|"] = {
    "｜",
    "ǀ",
    "ᛁ",
    "⎜",
    "⎟",
    "⎢",
    "⎥",
    "⎪",
    "⎮",
    "⼁",
    "〡",
    "丨",
    "︱",
    "︳",
    "￨"
  },
  ["}"] = {
    "｝",
    "﹜"
  },
  ["~"] = {
    "～",
    "˜",
    "⁓",
    "∼",
    "〜"
  }
}
local maps = { }
for charmap, chars in pairs(charmaps) do
  local i = 1
  maps[charmap] = { }
  for uchar in chars:gmatch(unicode.charpatt) do
    maps[charmap][an:sub(i, i)] = uchar
    i = i + 1
  end
end
local wireplace
wireplace = function(offset, arg)
  local s = arg or ''
  local t = { }
  for i = 1, #s do
    local bc = string.byte(s, i, i)
    if bc == 32 and offset == 0xFEE0 then
      t[#t + 1] = '\227\128\128'
    elseif bc == 32 then
      t[#t + 1] = ' '
    elseif bc < 0x80 then
      t[#t + 1] = unicode.encode(offset + bc)
    else
      t[#t + 1] = s:sub(i, i)
    end
  end
  return table.concat(t, "")
end
local remap
remap = function(map, s)
  return table.concat((function()
    local _accum_0 = { }
    local _len_0 = 1
    for i = 1, #s do
      _accum_0[_len_0] = map[s:sub(i, i)] or s:sub(i, i)
      _len_0 = _len_0 + 1
    end
    return _accum_0
  end)(), '')
end
local zalgo
zalgo = function(text, intensity)
  if intensity == nil then
    intensity = 50
  end
  text = text:sub(1, 512)
  local zalgo_chars = { }
  for i = 0x0300, 0x036f do
    zalgo_chars[i - 0x2ff] = unicode.encode(i)
  end
  zalgo_chars[#zalgo_chars + 1] = unicode.encode(0x0488)
  zalgo_chars[#zalgo_chars + 0] = unicode.encode(0x0489)
  local zalgoized = { }
  for letter in codepoints(text) do
    zalgoized[#zalgoized + 1] = letter
    local zalgo_num = math.random(1, intensity)
    for i = 1, zalgo_num do
      zalgoized[#zalgoized + 1] = zalgo_chars[math.random(1, #zalgo_chars)]
    end
  end
  return table.concat(zalgoized)
end

return remap(maps.ru, arg)

--[======[
return {
  PRIVMSG = {
    ['^%pwide (.+)$'] = function(self, source, destination, arg)
      return say(wireplace(0xFEE0, arg))
    end,
    ['^%pblackletter (.+)$'] = function(self, source, destination, arg)
      return say(remap(maps.bl, arg))
    end,
    ['^%pcircled (.+)$'] = function(self, source, destination, arg)
      return say(remap(maps.ci, arg))
    end,
    ['^%pzalgo (.+)$'] = function(self, source, destination, arg)
      return say(zalgo(arg, 7))
    end,
    ['^%pupsidedown (.+)$'] = function(self, source, destination, arg)
      return say(remap(maps.ud, util.utf8.reverse(arg)))
    end,
    ['^%pflip (.+)$'] = function(self, source, destination, arg)
      return say(remap(maps.ud, arg))
    end,
    ['^%pthrow (.+)$'] = function(self, source, destination, arg)
      return say("（╯°□°）╯︵ " .. tostring(remap(maps.ud, util.utf8.reverse(arg))))
    end,
    ['^%pparanthesized (.+)$'] = function(self, source, destination, arg)
      return say(remap(maps.pt, arg))
    end,
    ['^%pnegcircle (.+)$'] = function(self, source, destination, arg)
      return say(remap(maps['nc'], arg))
    end,
    ['^%psquare (.+)$'] = function(self, source, destination, arg)
      return say(remap(maps.sq, arg))
    end,
    ['^%pnegsquare (.+)$'] = function(self, source, destination, arg)
      return say(remap(maps.ns, arg))
    end,
    ['^%pdoublestruck (.+)$'] = function(self, source, destination, arg)
      return say(remap(maps.ds, arg))
    end,
    ['^%pubold (.+)$'] = function(self, source, destination, arg)
      return say(remap(maps.bo, arg))
    end,
    ['^%pbolditalic (.+)$'] = function(self, source, destination, arg)
      return say(remap(maps.bi, arg))
    end,
    ['^%pboldscript (.+)$'] = function(self, source, destination, arg)
      return say(remap(maps.bs, arg))
    end,
    ['^%pthai (.+)$'] = function(self, source, destination, arg)
      return say(remap(maps.tl, arg))
    end,
    ['^%prussian (.+)$'] = function(self, source, destination, arg)
      return say(remap(maps.ru, arg))
    end,
    ['^%putfuk (.+)$'] = function(self, source, destination, arg)
      local keys
      do
        local _accum_0 = { }
        local _len_0 = 1
        for x, _ in pairs(maps) do
          _accum_0[_len_0] = x
          _len_0 = _len_0 + 1
        end
        keys = _accum_0
      end
      return say(table.concat((function()
        local _accum_0 = { }
        local _len_0 = 1
        for letter in codepoints(arg) do
          _accum_0[_len_0] = remap(maps[keys[math.random(#keys)]], letter)
          _len_0 = _len_0 + 1
        end
        return _accum_0
      end)()))
    end,
    ['^%pmimic (.+)$'] = function(self, source, destination, arg)
      local out = { }
      for uchar in util.utf8.chars(arg) do
        local mimictbl = mimic[uchar]
        if mimictbl then
          out[#out + 1] = mimictbl[math.random(#mimictbl)]
        else
          out[#out + 1] = uchar
        end
      end
      return say(table.concat(out))
    end,
    ['^%pul (.+)$'] = function(self, source, destination, arg)
      return say(table.concat((function()
        local _accum_0 = { }
        local _len_0 = 1
        for letter in codepoints(arg) do
          _accum_0[_len_0] = letter .. util.utf8.char(0x0332)
          _len_0 = _len_0 + 1
        end
        return _accum_0
      end)()))
    end
  }
}
]======]
