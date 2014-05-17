local s = arg[1]
assert(type(s) == "string" and s:len() > 0, "Need input")


local function _x(c)
    if c:sub(1, 2) == '\\u' then
        -- c = html2text("&#x" .. c:sub(3) .. ";")
        c = etc.U(c:sub(3), true)
    end
    return c
end
local flipTable = {}
for k, v in pairs({
a = '\\u0250',
b = 'q',
c = '\\u0254',
d = 'p',
e = '\\u01DD',
f = '\\u025F',
g = '\\u0183',
h = '\\u0265',
i = '\\u0131',
j = '\\u027E',
k = '\\u029E',
-- l = '\\u0283',
m = '\\u026F',
n = 'u',
r = '\\u0279',
t = '\\u0287',
v = '\\u028C',
w = '\\u028D',
y = '\\u028E',
['.'] = '\\u02D9',
['['] = ']',
['('] = ')',
['{'] = '}',
['?'] = '\\u00BF',
['!'] = '\\u00A1',
["\'"] = ',',
['<'] = '>',
['_'] = '\\u203E',
[';'] = '\\u061B',
['\\u203F'] = '\\u2040',
['\\u2045'] = '\\u2046',
['\\u2234'] = '\\u2235',
-- ['\r'] = '\n',
}) do
  local a = _x(k)
  local b = _x(v)
    flipTable[a] = b
    flipTable[b] = a
end


local t = {}
for ch in etc.codepoints(s:lower()) do
    table.insert(t, flipTable[ch] or ch)
end
return table.concat(etc.reverse(t))
