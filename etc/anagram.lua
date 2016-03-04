assert(require("spam").detect(Cache, "anagram", 4, 10))

assert(arg[1], "anagram of what?")
local s, err = httpGet("http://www.wordsmith.org/anagram/anagram.cgi?t=100&anagram=" .. urlEncode(arg[1]))
assert(s, err)

s = assert(s:match("(Displaying%s.-)</?[Pp][ />]"), "Did not find result")
s = s:gsub("<[Bb][Rr][ />]", arg[2] or "; ")

return html2text(s):gsub(":%s*;", ":") or ''
