local start = os.clock()

local types = {}
for k, v in pairs{
  'A', 'AAAA', 'CNAME', 'MX', 'NS', 'PTR', 'SOA', 'SRV', 'TXT', 'ANY'
} do
  types[v] = true
end

local API_URL = 'http://dig.jsondns.org/'

function buildURL(t)
  -- name, type, class
  t.class = t.class or 'IN'
  t.type = t.type or 'A'
  t.name = t.name or '.'

  return ('%s%s/%s/%s'):format(API_URL, t.class, t.name, t.type)
end

local stringx = plugin.stringx()
local args = stringx.split(arg[1] or '')

local t = {}
for k, v in pairs(args) do
  local lv = v:lower()

  if types[lv:upper()] then
    t.type = lv:upper()
  else
    t.name = lv
  end
end

function fields(t)
  local r = {}
  for v, k in pairs(t) do
    if type(v) == 'string' then
      if v ~= 'name' and v ~= 'ttl' and v ~= 'class' and v ~= 'type' then
        r[#r+1] = v
      end
    end
  end
  return table.concat(r, ', ')
end

-- print(buildURL(t))

local json = plugin.json()
local data = [[{
  "additional": [

  ],
  "question": [
    {
      "qname": "google.com",
      "qtype": "ANY",
      "qclass": "IN"
    }
  ],
  "authority": [

  ],
  "header": {
    "arcount": 0,
    "rcode": "NOERROR",
    "cd": false,
    "opcode": "Query",
    "tc": false,
    "qdcount": 1,
    "nscount": 0,
    "ad": false,
    "ancount": 21,
    "aa": false,
    "ra": true,
    "id": 33124,
    "qr": true,
    "rd": true
  },
  "answer": [
    {
      "type": "MX",
      "ttl": 136,
      "class": "IN",
      "name": "google.com",
      "rdata": [
        "40",
        "alt3.aspmx.l.google.com"
      ]
    },
    {
      "type": "MX",
      "ttl": 136,
      "class": "IN",
      "name": "google.com",
      "rdata": [
        "50",
        "alt4.aspmx.l.google.com"
      ]
    },
    {
      "type": "MX",
      "ttl": 136,
      "class": "IN",
      "name": "google.com",
      "rdata": [
        "10",
        "aspmx.l.google.com"
      ]
    },
    {
      "type": "MX",
      "ttl": 136,
      "class": "IN",
      "name": "google.com",
      "rdata": [
        "20",
        "alt1.aspmx.l.google.com"
      ]
    },
    {
      "type": "MX",
      "ttl": 136,
      "class": "IN",
      "name": "google.com",
      "rdata": [
        "30",
        "alt2.aspmx.l.google.com"
      ]
    },
    {
      "type": "TXT",
      "ttl": 3330,
      "class": "IN",
      "name": "google.com",
      "rdata": [
        "v=spf1 include:_netblocks.google.com ip4:216.73.93.70/31 ip4:216.73.93.72/31 ~all"
      ]
    },
    {
      "type": "A",
      "ttl": 131,
      "class": "IN",
      "name": "google.com",
      "rdata": "74.125.228.9"
    },
    {
      "type": "A",
      "ttl": 131,
      "class": "IN",
      "name": "google.com",
      "rdata": "74.125.228.14"
    },
    {
      "type": "A",
      "ttl": 131,
      "class": "IN",
      "name": "google.com",
      "rdata": "74.125.228.0"
    },
    {
      "type": "A",
      "ttl": 131,
      "class": "IN",
      "name": "google.com",
      "rdata": "74.125.228.1"
    },
    {
      "type": "A",
      "ttl": 131,
      "class": "IN",
      "name": "google.com",
      "rdata": "74.125.228.2"
    },
    {
      "type": "A",
      "ttl": 131,
      "class": "IN",
      "name": "google.com",
      "rdata": "74.125.228.3"
    },
    {
      "type": "A",
      "ttl": 131,
      "class": "IN",
      "name": "google.com",
      "rdata": "74.125.228.4"
    },
    {
      "type": "A",
      "ttl": 131,
      "class": "IN",
      "name": "google.com",
      "rdata": "74.125.228.5"
    },
    {
      "type": "A",
      "ttl": 131,
      "class": "IN",
      "name": "google.com",
      "rdata": "74.125.228.6"
    },
    {
      "type": "A",
      "ttl": 131,
      "class": "IN",
      "name": "google.com",
      "rdata": "74.125.228.7"
    },
    {
      "type": "A",
      "ttl": 131,
      "class": "IN",
      "name": "google.com",
      "rdata": "74.125.228.8"
    },
    {
      "type": "NS",
      "ttl": 9008,
      "class": "IN",
      "name": "google.com",
      "rdata": "ns3.google.com"
    },
    {
      "type": "NS",
      "ttl": 9008,
      "class": "IN",
      "name": "google.com",
      "rdata": "ns4.google.com"
    },
    {
      "type": "NS",
      "ttl": 9008,
      "class": "IN",
      "name": "google.com",
      "rdata": "ns2.google.com"
    },
    {
      "type": "NS",
      "ttl": 9008,
      "class": "IN",
      "name": "google.com",
      "rdata": "ns1.google.com"
    }
  ]
}]]

function printrecord(v)
  if v.type == 'A' or v.type == 'NS' or v.type == 'AAAA' then
    print(('%s. %d %s %s %s'):format(v.name, v.ttl, v.class, v.type, v.rdata))
  elseif v.type == 'MX' then
    print(('%s. %d %s %s %s %s'):format(v.name, v.ttl, v.class, v.type, v.rdata[1], v.rdata[2]))
  elseif v.type == 'TXT' then
    print(('%s. %d %s %s "%s"'):format(v.name, v.ttl, v.class, v.type, v.rdata[1]))
  else
    print(('%s. %d %s %s --unhandled: %s--'):format(v.name, v.ttl, v.class, v.type, fields(v)))
  end
end

local parsed = json.decode(data)

local flags = {}
if parsed.header.cd then flags[#flags+1] = 'cd' end
if parsed.header.tc then flags[#flags+1] = 'tc' end
if parsed.header.ad then flags[#flags+1] = 'cd' end
if parsed.header.aa then flags[#flags+1] = 'aa' end
if parsed.header.ra then flags[#flags+1] = 'ra' end
if parsed.header.rd then flags[#flags+1] = 'rd' end
if parsed.header.qr then flags[#flags+1] = 'qr' end

print((';; ->>HEADER<<- opcode: %s, status: %s, id: %d'):format(parsed.header.opcode:upper(), parsed.header.rcode, parsed.header.id))
print((';; flags: %s; QUERY: %d, ANSWER: %d, AUTHORITY: %d, ADDITIONAL: %d'):format(table.concat(flags, ' '), parsed.header.qdcount, parsed.header.ancount, parsed.header.arcount, parsed.header.nscount))
print('')
print(';; QUESTION SECTION:')
print((';%s. %s %s'):format(parsed.question[1].qname, parsed.question[1].qclass, parsed.question[1].qtype))
print('')

print(';; ANSWER SECTION:')
for k, v in ipairs(parsed.answer) do
  printrecord(v)
end

print('')
print(';; AUTHORITY SECTION:')
for k, v in pairs(parsed.authority) do
  printrecord(v)
end

print('')
print(';; ADDITIONAL SECTION:')
for k, v in pairs(parsed.additional) do
  printrecord(v)
end
print('')
print((';; Query time: %d msec'):format((os.clock() - start) * 1000))
print(';; SERVER: http://dig.jsondns.org')
print(';; WHEN: '..os.date())
print(';; MSG SIZE  rcvd: '..#data)
print('')

--[[
local data, err = httpGet(API_URL..'IN/'..urlEncode(domain)..'/'..urlEncode(qrtype))
local json = plugin.json()
local parsed = json.decode(data)

for k, v in pairs(parsed.answer) do
  etc.printf('%s. %d %s %s %s', v.name, v.ttl, v.class, v.type, v.rdata)
end
]]