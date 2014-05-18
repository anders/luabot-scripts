local t = {}
t.title = "Number of users in #dbot"
t.vlabel = "Users"
t.lowerLimit = 0
t.data = {users = #nicklist("#dbot")}
return t
