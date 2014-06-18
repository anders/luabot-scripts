local U = 'http://bash.org/?random'

local data
local f, err
if (Cache['ts.bash.cache'] or os.time()) + 5 * 60 < os.time() then
  f, err = io.open('bash.cache', 'r')
end

if not f then
  data = assert(httpGet(U))

  f = assert(io.open('bash.cache', 'w'))
  f:write(data:sub(1, 1024 * 12))
  Cache['ts.bash.cache'] = os.time()
else
  data = f:read('*a')
end

f:close()

data = data:gsub('[\r\n]', '')
assert(#data > 0, 'loaded data is empty')

local quotes = {}

local start = 0
while true do
  local startpos, endpos = data:find('<p class="qt">', n)

  if not endpos then
    break
  end
  
  local quoteend = data:find('</p>', endpos)

  if not quoteend then
    break
  end

  local quote = data:sub(endpos + 1, quoteend - 1)
  quote = html2text(quote:gsub('<br />', '  '))
  if #quote < 350 then
    quotes[#quotes + 1] = quote
  end
  
  n = startpos + 1
end

print(quotes[math.random(1, #quotes)])
