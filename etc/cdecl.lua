local query = arg[1] or 'char * const (*(* const bar)[10])(int )'
local U = 'cdecl.org/?q='..urlEncode(query)

local data = httpGet(U)
local _, pos = data:find('text_result">')
if not pos then
  print('No result div found')
else
  local resultend = data:find('</div', pos + 1)
  if resultend then
    local result = data:sub(pos + 1, resultend - 1):match('^%s*(.-)%s*$')
    print(result)
  else
    print('No </div> found')
  end
end