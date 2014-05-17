-- Missing results:
-- http://forum.faroo.com/viewtopic.php?f=5&t=68

local q = arg[1]
assert(type(q) == "string" and q:len() > 0, "Search term expected")

local text, info = httpGet("http://www.faroo.com/api?start=1&length=1&l=en&src=web&i=true&f=json&q=" .. urlEncode(q))
if not text then
  return nil, info or "Result not found"
end

if info ~= "application/json" then
  return nil, "Unexpected content type", text
end

require "json"

local obj = json.parse(text)

if not obj or not obj.results or 0 == #obj.results then
  return nil, "Result not found"
end

local result = obj.results[1]

if arg[2] then
  return result.url, result.title
end
print(result.url .. " - " .. result.title)
