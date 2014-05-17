--[[
todo:

'quote
'quote search-string
'quote id

storing quotes in a better way

]]

local QUOTES_FILE = 'quotes.txt'

local serializer = require 'serializer'

local quotes = serializer.load(io, QUOTES_FILE)

local quote
if not arg[1] then
  if #quotes > 0 then
    quote = quotes[math.random(1, #quotes)]
  end
elseif arg[1]:match('%d+') then
  quote = quotes[tonumber(arg[1])]
else
  return false, 'search not implemented'
end

if not quote then
  return false, 'quote not found'
end

print(quote.text)
