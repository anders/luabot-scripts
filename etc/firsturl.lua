local urlpats = {
  "http://[^ ]*",
  "www.[^ ]*",
  -- "[^ ]+://[^ ]*",
}

local url
for i, k in ipairs(urlpats) do
  url = (arg[1] or ''):match(k)
  if url then
    return url
  end
end
return nil, "URL not found"
