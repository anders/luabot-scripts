local value, info = ...

-- Valid locale format is ll_CC where ll = ISO 639-1 language code and
-- CC = ISO 3166-1 alpha-2 country code.
--
-- Examples:
--
--   en_US
--   sv_FI
--   da_DK
--   ja_JP
--

local language, country = value:match('(%l%l)_(%u%u)')
if not language then
  return false, 'Valid locale format: ll_CC where ll = ISO 639-1 language code, CC = ISO 3166-1 alpha-2 country code.'
end

return value
