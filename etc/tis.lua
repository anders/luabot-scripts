API "1.1"

local ADJS = {"totally", "really", "absolutely", "completely", "tubularly", "entirely", "wholly", "thoroughly", "utterly", "perfectly", "quite", "unconditionally", "altogether"}
local adjs = {}

for i=1,math.floor(math.random() * 10) do
  adjs[#adjs + 1] = pickone(ADJS)
end

return "'tis " .. table.concat(adjs, ", ") .. " not " .. arg[1]
