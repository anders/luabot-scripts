API "1.1"

return arg[1]:gsub("s+([^h])", "sh%1"):gsub("S+([^Habcdefghijklmnopqrstuvwxyz])", "SH%1"):gsub("Ss*([^hABCDEFGHIJKLMONPQRSTUVWXYZ])", "Sh%1") or ""
