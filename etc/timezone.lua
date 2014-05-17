--[[
local fmt_time, offset, tzname = etc.timezone(code | nick, [format], [epoch])

'timezone [nick/code] (defaults to yourself)
]]

local timezones = {
  ACDT = {name = 'Australian Central Daylight Time', offset = 10.5},
  ACST = {name = 'Australian Central Standard Time', offset = 9.5},
  ACT = {name = 'ASEAN Common Time', offset = 8},
  ADT = {name = 'Atlantic Daylight Time', offset = -3},
  AEDT = {name = 'Australian Eastern Daylight Time', offset = 11},
  AEST = {name = 'Australian Eastern Standard Time', offset = 10},
  AFT = {name = 'Afghanistan Time', offset = 4.5},
  AKDT = {name = 'Alaska Daylight Time', offset = -8},
  AKST = {name = 'Alaska Standard Time', offset = -9},
  AMST = {name = 'Armenia Summer Time', offset = 5},
  AMT = {name = 'Armenia Time', offset = 4},
  ART = {name = 'Argentina Time', offset = -3},
  AST = {name = 'Arab Standard Time (Kuwait, Riyadh)', offset = 3},
  AST = {name = 'Arabian Standard Time (Abu Dhabi, Muscat)', offset = 4},
  AST = {name = 'Arabic Standard Time (Baghdad)', offset = 3},
  AST = {name = 'Atlantic Standard Time', offset = -4},
  AWDT = {name = 'Australian Western Daylight Time', offset = 9},
  AWST = {name = 'Australian Western Standard Time', offset = 8},
  AZOST = {name = 'Azores Standard Time', offset = -1},
  AZT = {name = 'Azerbaijan Time', offset = 4},
  BDT = {name = 'Brunei Time', offset = 8},
  BIOT = {name = 'British Indian Ocean Time', offset = 6},
  BIT = {name = 'Baker Island Time', offset = -12},
  BOT = {name = 'Bolivia Time', offset = -4},
  BRT = {name = 'Brasilia Time', offset = -3},
  --BST = {name = 'Bangladesh Standard Time', offset = 6},
  BST = {name = 'British Summer Time)', offset = 1},
  BTT = {name = 'Bhutan Time', offset = 6},
  CAT = {name = 'Central Africa Time', offset = 2},
  CCT = {name = 'Cocos Islands Time', offset = 6.5},
  CDT = {name = 'Central Daylight Time (North America)', offset = -5},
  CEDT = {name = 'Central European Daylight Time', offset = 2},
  CEST = {name = 'Central European Summer Time', offset = 2},
  CET = {name = 'Central European Time', offset = 1},
  CHADT = {name = 'Chatham Daylight Time', offset = 13.75},
  CHAST = {name = 'Chatham Standard Time', offset = 12.75},
  CIST = {name = 'Clipperton Island Standard Time', offset = -8},
  CKT = {name = 'Cook Island Time', offset = -10},
  CLST = {name = 'Chile Summer Time', offset = -3},
  CLT = {name = 'Chile Standard Time', offset = -4},
  COST = {name = 'Colombia Summer Time', offset = -4},
  COT = {name = 'Colombia Time', offset = -5},
  CST = {name = 'Central Standard Time (North America)', offset = -6},
  --CST = {name = 'China Standard Time', offset = 8},
  --CST = {name = 'Central Standard Time (Australia)', offset = 9.5},
  CT = {name = 'China Time', offset = 8},
  CVT = {name = 'Cape Verde Time', offset = -1},
  CXT = {name = 'Christmas Island Time', offset = 7},
  CHST = {name = 'Chamorro Standard Time', offset = 10},
  DFT = {name = 'AIX specific equivalent of Central European Time', offset = 1},
  EAST = {name = 'Easter Island Standard Time', offset = -6},
  EAT = {name = 'East Africa Time', offset = 3},
  ECT = {name = 'Eastern Caribbean Time', offset = -4},
  ECT = {name = 'Ecuador Time', offset = -5},
  EDT = {name = 'Eastern Daylight Time', offset = -4},
  EEDT = {name = 'Eastern European Daylight Time', offset = 3},
  EEST = {name = 'Eastern European Summer Time', offset = 3},
  EET = {name = 'Eastern European Time', offset = 2},
  EST = {name = 'Eastern Standard Time', offset = -5},
  FJT = {name = 'Fiji Time', offset = 12},
  FKST = {name = 'Falkland Islands Summer Time', offset = -3},
  FKT = {name = 'Falkland Islands Time', offset = -4},
  GALT = {name = 'Galapagos Time', offset = -6},
  GET = {name = 'Georgia Standard Time', offset = 4},
  GFT = {name = 'French Guiana Time', offset = -3},
  GILT = {name = 'Gilbert Island Time', offset = 12},
  GIT = {name = 'Gambier Island Time', offset = -9},
  GMT = {name = 'Greenwich Mean Time', offset = 0},
  GST = {name = 'South Georgia and the South Sandwich Islands', offset = -2},
  GST = {name = 'Gulf Standard Time', offset = 4},
  GYT = {name = 'Guyana Time', offset = -4},
  HADT = {name = 'Hawaii-Aleutian Daylight Time', offset = -9},
  HAEC = {name = 'Heure Avancée d\'Europe Centrale francised name for CEST', offset = 2},
  HAST = {name = 'Hawaii-Aleutian Standard Time', offset = -10},
  HKT = {name = 'Hong Kong Time', offset = 8},
  HMT = {name = 'Heard and McDonald Islands Time', offset = 5},
  HST = {name = 'Hawaii Standard Time', offset = -10},
  ICT = {name = 'Indochina Time', offset = 7},
  IDT = {name = 'Israeli Daylight Time', offset = 3},
  IRKT = {name = 'Irkutsk Time', offset = 8},
  IRST = {name = 'Iran Standard Time', offset = 3.5},
  IST = {name = 'Indian Standard Time', offset = 5.5},
  IST = {name = 'Irish Summer Time', offset = 1},
  IST = {name = 'Israel Standard Time', offset = 2},
  JST = {name = 'Japan Standard Time', offset = 9},
  KRAT = {name = 'Krasnoyarsk Time', offset = 7},
  KST = {name = 'Korea Standard Time', offset = 9},
  LHST = {name = 'Lord Howe Standard Time', offset = 10.5},
  LINT = {name = 'Line Islands Time', offset = 14},
  MAGT = {name = 'Magadan Time', offset = 11},
  MDT = {name = 'Mountain Daylight Time', offset = -6},
  MET = {name = 'Middle European Time Same zone as CET', offset = 2},
  MEST = {name = 'Middle European Saving Time Same zone as CEST', offset = 2},
  MIT = {name = 'Marquesas Islands Time', offset = -9.5},
  MSD = {name = 'Moscow Summer Time', offset = 4},
  MSK = {name = 'Moscow Standard Time', offset = 3},
  --MST = {name = 'Malaysian Standard Time', offset = 8},
  MST = {name = 'Mountain Standard Time (North America)', offset = -7},
  --MST = {name = 'Myanmar Standard Time', offset = 6.5},
  MUT = {name = 'Mauritius Time', offset = 4},
  MYT = {name = 'Malaysia Time', offset = 8},
  NDT = {name = 'Newfoundland Daylight Time', offset = -2.5},
  NFT = {name = 'Norfolk Time[1]', offset = 11.5},
  NPT = {name = 'Nepal Time', offset = 5.45},
  NST = {name = 'Newfoundland Standard Time', offset = -3.5},
  NT = {name = 'Newfoundland Time', offset = -3.5},
  NZDT = {name = 'New Zealand Daylight Time', offset = 13},
  NZST = {name = 'New Zealand Standard Time', offset = 12},
  OMST = {name = 'Omsk Time', offset = 6},
  PDT = {name = 'Pacific Daylight Time', offset = -7},
  PETT = {name = 'Kamchatka Time', offset = 12},
  PHOT = {name = 'Phoenix Island Time', offset = 13},
  PKT = {name = 'Pakistan Standard Time', offset = 5},
  PST = {name = 'Pacific Standard Time', offset = -8},
  --PST = {name = 'Philippine Standard Time', offset = 8},
  RET = {name = 'Réunion Time', offset = 4},
  SAMT = {name = 'Samara Time', offset = 4},
  SAST = {name = 'South African Standard Time', offset = 2},
  SBT = {name = 'Solomon Islands Time', offset = 11},
  SCT = {name = 'Seychelles Time', offset = 4},
  SGT = {name = 'Singapore Time', offset = 8},
  SLT = {name = 'Sri Lanka Time', offset = 5.5},
  SST = {name = 'Samoa Standard Time', offset = -11},
  SST = {name = 'Singapore Standard Time', offset = 8},
  TAHT = {name = 'Tahiti Time', offset = -10},
  THA = {name = 'Thailand Standard Time', offset = 7},
  UTC = {name = 'Coordinated Universal Time', offset = 0},
  UYST = {name = 'Uruguay Summer Time', offset = -2},
  UYT = {name = 'Uruguay Standard Time', offset = -3},
  VET = {name = 'Venezuelan Standard Time', offset = -4.5},
  VLAT = {name = 'Vladivostok Time', offset = 10},
  WAT = {name = 'West Africa Time', offset = 1},
  WEDT = {name = 'Western European Daylight Time', offset = 1},
  WEST = {name = 'Western European Summer Time', offset = 1},
  WET = {name = 'Western European Time', offset = 0},
  WST = {name = 'Western Standard Time', offset = 8},
  YAKT = {name = 'Yakutsk Time', offset = 9},
  YEKT = {name = 'Yekaterinburg Time', offset = 5}
}

local Time = require 'time'

local iscmd = #arg < 2
local person, format, now, butt = (arg[1] or nick):match('([^%s]+)'),
                             arg[2] or '%Y-%m-%d %H:%M:%S',
                             arg[3] or os.time(), arg[4]

local function file_exists(path)
  local f = io.open(path, 'r')
  if not f then return false end
  f:close()
  return true
end

local zoneinfo_path = '/shared/zoneinfo/'
local tz

local pref_tz = etc.get('timezone', person) or person or 'No/Such/Timezone'

if file_exists(zoneinfo_path..pref_tz) then
  tz = assert(Time.zoneinfo(pref_tz, now))
end

-- hacklicious
local oldtzdata = timezones[person:upper()]
if oldtzdata then
  tz = {ts = os.time(),
        dst = false,
        zone = oldtzdata.name,
        offset = oldtzdata.offset * 3600,
        code = person:upper()}
end

local localtime
if tz then
  localtime = os.date('!'..format, now + tz.offset)
end

if not butt then
  if not tz then
    if person:lower() == nick:lower() then
      print(nick, '* Set your timezone with \'set location <location>, example "Malmö, Sweden."')
    else
      return false, 'unknown timezone'
    end
    
    return
  end

  local name = tz.zone

  print(name..': '..localtime..(tz.dst and ' (DST)' or ''))
else
  if not tz then
    return false, 'No such timezone/user.'
  end

  return localtime, tz.offset, tz.code, os.date('!*t', now + tz.offset)
end

