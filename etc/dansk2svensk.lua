API "1.1"

return arg[1]
  :gsub('ø', 'ö')
  :gsub('aa', 'å')
  :gsub('æ', 'ä')
  :gsub('Ø', 'Ö')
  :gsub('AA', 'Å')
  :gsub('Aa', 'Å')
  :gsub('Æ', 'Ä')or ''
