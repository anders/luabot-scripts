API "1.1"

return arg[1]
  :gsub('ö', 'ø')
  :gsub('å', 'aa')
  :gsub('ä', 'æ')
  :gsub('Ö', 'Ø')
  :gsub('Å', 'Aa')
  :gsub('Ä', 'Æ')or ''
