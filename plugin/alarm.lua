local KEY = 'DbotIsMyGod'

local M = {}

function M.web_callback()
  local qs = Web.qs:sub(2)
  local kv = {}
  for k, v in qs:gmatch('([^=]+)=([^&]+)') do
    kv[k] = v
  end

  if kv.key ~= KEY then
    Web.print('error: key incorrect')
    return
  end

  if not kv.callback then
    Web.print('error: no callback')
    return
  end

  --[[ do something ]]
end

return M