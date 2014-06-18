-- lang = ISO 639-1 code
-- country = ISO 3166 alpha-2 code
--
-- locale[country]
--   ->
--       .currency     = one of "USD", "SEK", ...
--       .measurement  = one of "US", "metric"
-- locale[language] (lower case)
--   ->
--       nothing yet, probably won't have anything here

local M = {
  US = { currency = 'USD', measurement = 'US' },
  SE = { currency = 'SEK', measurement = 'metric' },
  DK = { currency = 'DKK', measurement = 'metric' },
  NO = { currency = 'NOK', measurement = 'metric' },
}

for _, cc in ipairs{'DE', 'NL', 'FI'} do
  M[cc] = { currency = 'EUR', measurement = 'metric' }
end

-- Default
setmetatable(M, {
  __index = function(t, k)
    if k:match('%u%u') then
      return {
        measurement = 'metric'
      }
    elseif k:match('%l%l') then
      return {}
    end
  end
})

M.parse = function(locale)
  local lang, country = assert(locale:match('(%l%l)_(%u%u)'))
  return M[lang], M[country]
end

return M
