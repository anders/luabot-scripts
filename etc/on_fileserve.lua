API "1.1"

if Web then
  Web.header["Content-Type"] = "text/plain; charset=utf-8"
end

local LOG = plugin.log(_funcname);

local user, fs, method, action, path, mode, data = ...
path = path or "/home/" .. user

local ok = true
LOG.trace('request:', user, method, action, path, mode)
if method == 'GET' then
  if action == 'list' then
    fs.list(path, function(path, t)
      print(t, path)
    end)
  else
    ok = false
  end
elseif method == 'POST' then
  if action == 'write' then
    
  else
    ok = false
  end
else
  ok = false
end

if not ok then
  error("Invalid action=" .. (action or '<nil>') .. " for method=" .. (method or '<nil>'))
end
