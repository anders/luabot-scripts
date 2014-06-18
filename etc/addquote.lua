local QUOTES_FILE = 'quotes.txt'

local serializer = require 'serializer'

assert(arg[1], 'pls quote something')

local quotes = serializer.load(io, QUOTES_FILE)

quotes[#quotes + 1] = {uid = account, text = arg[1], ts = os.time()}
assert(serializer.save(io, QUOTES_FILE, quotes))
print('quote '..#quotes..' added')
