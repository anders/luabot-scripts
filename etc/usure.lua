-- Usage: 'usure <text>

return ((arg[1] or '') .. '.'):gsub("[%?%.!]+", "?") or ''
