-- Usage: [-i] search string

local search = assert(arg[1], 'need search string')
local ci = false
if search:sub(1, 3) == '-i ' then
  ci = true
  search = search:sub(4):lower()
  assert(#search>1)
end

local function grep(needle, haystack, case_insensitive)
  local matches = {}

  local t = _G[haystack].find('*', true)
  
  for i, fname in ipairs(t) do
    local path = '/pub/scripts/'..haystack..'/'..fname..'.lua'
    
    local f = io.open(path, 'r')
    local code = f:read('*a')
    if case_insensitive then code = code:lower() end
    f:close()
    
    if code and code:find(search, 1, true) then
      matches[#matches + 1] = fname
    end
  end
  
  return matches
end

for k, mod in ipairs{'etc', 'plugin', 'tests'} do
  local matches = grep(search, mod, ci)
  if #matches > 0 then
    table.sort(matches)
    print('in '..mod..': '..table.concat(matches, ', '))
  end
end
