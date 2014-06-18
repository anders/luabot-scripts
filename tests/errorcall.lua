if LocalCache.tail then
  return tests.error()
else
  return select(1, tests.error())
end
