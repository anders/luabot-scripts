-- Usage: etc.untrust() - Call when you no longer want a trusted context.

-- Don't rely on this implementation detail, just call etc.untrust()
-- loadstring("")
_strust()

if allCodeTrusted() then
  -- Should never happen, but just to be sure.
  error(_funcname .. " failed on its promise")
  return halt()
end
