API "1.1"
-- This is called before any UDF call from an API 1.2+ function.

-- print("on_udf_call", ...)

return (function(apiver, modname, k, v, ...)
  return etc.getOutput2(1.2, v, ...)
end)(...)
