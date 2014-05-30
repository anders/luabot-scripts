-- Usage: 'rf - our 'r frontpage - use 'rsub and 'runsub to subscribe and unsubscribe from 'r

require "serializer"
local obj = serializer.load(io, "rfrontpage.dat")

local slist = nil
for i = 1, #obj do
  if slist then
    slist = obj[i]
  else
    slist = slist .. "+" .. obj[i]
  end
end

etc.reddit(slist)
