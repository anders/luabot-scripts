MEIJI =  "明治"
TAISHO = "大正"
SHOWA = "昭和"
HEISEI = "平成"

year = tonumber(arg[1])

if year < 1868 then
  return "cba to implement"
elseif year < 1912 then
  return MEIJI .. (year - 1867)
elseif year == 1912 then
  return MEIJI .. (year - 1867) .. "/" .. TAISHO .. (year - 1911)
elseif year < 1926 then
  return TAISHO .. (year - 1911)
elseif year == 1926 then
  return TAISHO .. (year - 1911) .. "/" .. SHOWA .. (year - 1925)
elseif year < 1989 then
  return SHOWA .. (year - 1925)
elseif year == 1989 then
  return SHOWA .. (year - 1925) .. "/" .. HEISEI .. (year - 1988)
else
  return HEISEI .. (year - 1988)
end
