-- Usage: etc.extra("message") - Gives the user extra information if they are requesting it.

assert(type(arg[1]) ~= "function", "Function not expected")

if print == directprint then
  if not Private.alreadyextra then
    Private.alreadyextra = true
    directprint("\00314", ..., "\003")
  end
end
