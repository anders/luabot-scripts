local from, to = arg[1]:match("(.+)%->(.+)")

local xml = require 'xml'

local QueryPage = function(from, to)
  local url = 'http://www.labs.skanetrafiken.se/v2.2/querypage.asp?inpPointFr='..urlEncode(from)..'&inpPointTo='..urlEncode(to)
  local data = assert(httpGet(url))
  local x = assert(xml.parse(data))
  local a = x['soap:Envelope']['soap:Body'].GetStartEndPointResponse.GetStartEndPointResult.StartPoints.Point[1]
  local b = x['soap:Envelope']['soap:Body'].GetStartEndPointResponse.GetStartEndPointResult.EndPoints.Point[1]
  assert(a, 'start point missing')
  assert(b, 'end point missing')

  a, b = {Type = a.Type['#text'], Id = tonumber(a.Id['#text']), Name = a.Name['#text']},
         {Type = b.Type['#text'], Id = tonumber(b.Id['#text']), Name = b.Name['#text']}
  return a, b
end

local from, to = QueryPage(from, to)

-- http://www.labs.skanetrafiken.se/v2.2/resultspage.asp
local cmdaction = 'next'
local selPointFr = from.Name..'|'..from.Id..'|0'
local selPointTo = to.Name..'|'..to.Id..'|0'

local ResultsPage = function(cmdaction, from, to, params)
  params = params or {}
  params.cmdaction = cmdaction
  params.selPointFr = from
  params.selPointTo = to
  local url = 'http://www.labs.skanetrafiken.se/v2.2/resultspage.asp?'
  local buf = {}
  for k, v in pairs(params) do
    buf[#buf + 1] = urlEncode(k)..'='..urlEncode(v)
  end
  url = url..table.concat(buf, '&')
  local req = assert(httpGet(url))
  local x = assert(xml.parse(req))

  for _, journey in ipairs(x['soap:Envelope']['soap:Body'].GetJourneyResponse.GetJourneyResult.Journeys.Journey) do
    local dep_time = journey.DepDateTime['#text']:match("%d%d:%d%d")
    local arr_time = journey.ArrDateTime['#text']:match("%d%d:%d%d")
    local changes = journey.NoOfChanges['#text']
    local zones = journey.NoOfZones['#text']

    -- Prices->PriceInfo[4]->Price / VAT / PriceType

    -- RouteLinks->RouteLink[1]->DepDateTime, ArrDateTime, From->{Id, Name}, To->{Id, Name}, Line->{Name}

    -- might be a list...
    local route = journey.RouteLinks.RouteLink[1] or journey.RouteLinks.RouteLink
    local from = route.From.Name['#text']
    local to = route.To.Name['#text']
    local route_line = route.Line.Name['#text']
    local dist = tonumber(journey.Distance['#text']) / 1000
    
    print(dep_time.."-"..arr_time..": "..from.." → "..to.." ("..route_line..") "..('%.1f km, %d changes, %d zones'):format(dist, changes, zones))
  end
end

ResultsPage(cmdaction, selPointTo, selPointFr)

-- http://www.labs.skanetrafiken.se/v2.2/resultspage.asp?cmdaction=next&selPointFr=malm%F6%20C|80000|0&selPointTo=landskrona|82000|0&LastStart=2014-05-19%2016:38
