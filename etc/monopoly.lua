local Type_PassGo = 1
local Type_Property = 2
local Type_CommunityChest = 3
local Type_Tax = 4
local Type_Chance = 5
local Type_Jail = 6
local Type_Services = 7 -- electric/water company
local Type_Station = 8
local Type_Parking = 9
local Type_GoToJail = 10

local Board = {
  {type = Type_PassGo},
  {type = Type_Property, group = 1},
  {type = Type_CommunityChest},
  {type = Type_Property, group = 1},
  {type = Type_Tax, amount = 200},
  {type = Type_Station, base = 200}, -- fixme: base price
  {type = Type_Property, group = 2},
  {type = Type_Chance},
  {type = Type_Property, group = 2},
  {type = Type_Property, group = 2},
  {type = Type_Jail},
  {type = Type_Property, group = 3},
  {type = Type_Services},
  {type = Type_Property, group = 3},
  {type = Type_Property, group = 3},
  {type = Type_Station, base = 200}, -- fixme: base price
  {type = Type_Property, group = 4},
  {type = Type_CommunityChest},
  {type = Type_Property, group = 4},
  {type = Type_Property, group = 4},
  {type = Type_Parking},
  {type = Type_Property, group = 5},
  {type = Type_Chance},
  {type = Type_Property, group = 5},
  {type = Type_Property, group = 5},
  {type = Type_Station, base = 200}, -- fixme: base price
  {type = Type_Property, group = 6},
  {type = Type_Property, group = 6},
  {type = Type_Services},
  {type = Type_Property, group = 6},
  {type = Type_GoToJail},
  {type = Type_Property, group = 7},
  {type = Type_Property, group = 7},
  {type = Type_CommunityChest},
  {type = Type_Property, group = 7},
  {type = Type_Station, base = 200},
  {type = Type_Chance},
  {type = Type_Property, group = 8},
  {type = Type_Tax, amount = 100}, -- fixme price
  {type = Type_Property, group = 8},
}