-- Can be used with etc.pushPrint and etc.popPrint

if not _printstack or #_printstack == 0 then
  return print(...)
end

return _printstack[#_printstack](...)
