local s = arg[1]:gsub('[uU]', '\0030,1\002\U\002\003')
return s
