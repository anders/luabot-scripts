return (arg[1]
  :gsub("l", "r")
  :gsub("L", "R")
  :gsub("%s*%f[%a][tT][hH][eE]%f[%A]%s*", " ")
  :gsub("%s*%f[%a][aA][nN]?%f[%A]%s*", " ")
  :gsub("%s*%f[%a][mM][yY]%f[%A]%s*", " ")
)
