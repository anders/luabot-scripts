API "1.1"

-- Usage: etc.serialize(table) - uses plugin.serializer to serialize into a string.

require 'serializer'

local sf = _createStringFile()
assert(serializer.save({ open = function() return sf end }, 'filename', arg[1]))
return sf:read("*a")
