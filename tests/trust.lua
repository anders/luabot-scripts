if math.random() < 0.5 then
  -- BUG: why isn't trust=false in web editor?
  -- oh... see todo id #215
  print(tests.hacked())
end
print(
  "allCodeSecure:", allCodeSecure(),
  "|", "allCodeTrusted:", allCodeTrusted(),
  "|", "whyNotCodeTrusted:", whyNotCodeTrusted()
  )
