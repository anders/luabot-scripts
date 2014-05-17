local data =
[[
<soap:Envelope xmlns:soap="http://schemas.xmlsoap.org/soap/envelope/" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xmlns:xsd="http://www.w3.org/2001/XMLSchema">
<script/>
<soap:Body>
<GetJourneyResponse xmlns="http://www.etis.fskab.se/v1.0/ETISws">
<GetJourneyResult>
<Code>0</Code>
<Message/>
<JourneyResultKey>019416222107125166643014</JourneyResultKey>
<Journeys>
<Journey>
<SequenceNo>0</SequenceNo>
<DepDateTime>2012-02-11T16:46:00</DepDateTime>
<ArrDateTime>2012-02-11T17:22:00</ArrDateTime>
<DepWalkDist>0</DepWalkDist>
<ArrWalkDist>0</ArrWalkDist>
<NoOfChanges>0</NoOfChanges>
<Guaranteed>true</Guaranteed>
<CO2factor>10</CO2factor>
<NoOfZones>11</NoOfZones>
<PriceZoneList>
12000250,12000243,12000242,12000241,12000240,12000237,12000236,12000132,12000130,12000119,12000120
</PriceZoneList>
<FareType>Normaltaxa</FareType>
<Prices>
<PriceInfo>
<PriceType>Kontant Vuxen</PriceType>
<Price>81</Price>
<VAT>4.58490562</VAT>
</PriceInfo>
<PriceInfo>
<PriceType>Kontant Barn</PriceType>
<Price>49</Price>
<VAT>2.77358484</VAT>
</PriceInfo>
<PriceInfo>
<PriceType>Kontant Duo/Familj</PriceType>
<Price>146</Price>
<VAT>8.264151</VAT>
</PriceInfo>
<PriceInfo>
<PriceType>Jojo Reskassa Vuxen</PriceType>
<Price>64.8</Price>
<VAT>3.66792464</VAT>
</PriceInfo>
<PriceInfo>
<PriceType>Jojo Reskassa Barn</PriceType>
<Price>39.2</Price>
<VAT>2.218868</VAT>
</PriceInfo>
<PriceInfo>
<PriceType>Jojo Reskassa Duo/Familj</PriceType>
<Price>116.8</Price>
<VAT>6.611321</VAT>
</PriceInfo>
<PriceInfo>
<PriceType>Skånekortet Vuxen</PriceType>
<Price>1150</Price>
<VAT>65.09434</VAT>
</PriceInfo>
<PriceInfo>
<PriceType>Skånekortet Barn</PriceType>
<Price>1150</Price>
<VAT>65.09434</VAT>
</PriceInfo>
<PriceInfo>
<PriceType>Skånekortet Duo/Familj</PriceType>
<Price>0</Price>
<VAT>0</VAT>
</PriceInfo>
</Prices>
<JourneyKey>13284131410035102705100279600040016</JourneyKey>
<RouteLinks>
<RouteLink>
<RouteLinkKey>13284131410035102705100279600040016</RouteLinkKey>
<DepDateTime>2012-02-11T16:46:00</DepDateTime>
<DepIsTimingPoint>true</DepIsTimingPoint>
<ArrDateTime>2012-02-11T17:22:00</ArrDateTime>
<ArrIsTimingPoint>true</ArrIsTimingPoint>
<CallTrip>false</CallTrip>
<PriceZones>
<PriceZone>
<Id>12000250</Id>
</PriceZone>
<PriceZone>
<Id>12000243</Id>
</PriceZone>
<PriceZone>
<Id>12000242</Id>
</PriceZone>
<PriceZone>
<Id>12000241</Id>
</PriceZone>
<PriceZone>
<Id>12000240</Id>
</PriceZone>
<PriceZone>
<Id>12000237</Id>
</PriceZone>
<PriceZone>
<Id>12000236</Id>
</PriceZone>
<PriceZone>
<Id>12000132</Id>
</PriceZone>
<PriceZone>
<Id>12000130</Id>
</PriceZone>
<PriceZone>
<Id>12000119</Id>
</PriceZone>
<PriceZone>
<Id>12000120</Id>
</PriceZone>
</PriceZones>
<RealTime/>
<From>
<Id>80000</Id>
<Name>Malmö C</Name>
<StopPoint>3</StopPoint>
</From>
<To>
<Id>82000</Id>
<Name>Landskrona Station</Name>
<StopPoint>3</StopPoint>
</To>
<Line>
<Name>Pågatåg</Name>
<No>817</No>
<RunNo>756</RunNo>
<LineTypeId>32</LineTypeId>
<LineTypeName>Pågatågen</LineTypeName>
<TransportModeId>4</TransportModeId>
<TransportModeName>Tåg</TransportModeName>
<TrainNo>1756</TrainNo>
<Towards>Ängelholm</Towards>
<OperatorId>44</OperatorId>
<OperatorName>Arriva Tåg AB</OperatorName>
</Line>
<Deviations/>
</RouteLink>
</RouteLinks>
<Distance>47702</Distance>
<CO2value>1E-06</CO2value>
</Journey>
<Journey>
<SequenceNo>1</SequenceNo>
<DepDateTime>2012-02-11T17:08:00</DepDateTime>
<ArrDateTime>2012-02-11T17:36:00</ArrDateTime>
<DepWalkDist>0</DepWalkDist>
<ArrWalkDist>0</ArrWalkDist>
<NoOfChanges>0</NoOfChanges>
<Guaranteed>true</Guaranteed>
<CO2factor>10</CO2factor>
<NoOfZones>11</NoOfZones>
<PriceZoneList>
12000250,12000243,12000242,12000241,12000240,12000237,12000236,12000132,12000130,12000119,12000120
</PriceZoneList>
<FareType>Normaltaxa</FareType>
<Prices>
<PriceInfo>
<PriceType>Kontant Vuxen</PriceType>
<Price>81</Price>
<VAT>4.58490562</VAT>
</PriceInfo>
<PriceInfo>
<PriceType>Kontant Barn</PriceType>
<Price>49</Price>
<VAT>2.77358484</VAT>
</PriceInfo>
<PriceInfo>
<PriceType>Kontant Duo/Familj</PriceType>
<Price>146</Price>
<VAT>8.264151</VAT>
</PriceInfo>
<PriceInfo>
<PriceType>Jojo Reskassa Vuxen</PriceType>
<Price>64.8</Price>
<VAT>3.66792464</VAT>
</PriceInfo>
<PriceInfo>
<PriceType>Jojo Reskassa Barn</PriceType>
<Price>39.2</Price>
<VAT>2.218868</VAT>
</PriceInfo>
<PriceInfo>
<PriceType>Jojo Reskassa Duo/Familj</PriceType>
<Price>116.8</Price>
<VAT>6.611321</VAT>
</PriceInfo>
<PriceInfo>
<PriceType>Skånekortet Vuxen</PriceType>
<Price>1150</Price>
<VAT>65.09434</VAT>
</PriceInfo>
<PriceInfo>
<PriceType>Skånekortet Barn</PriceType>
<Price>1150</Price>
<VAT>65.09434</VAT>
</PriceInfo>
<PriceInfo>
<PriceType>Skånekortet Duo/Familj</PriceType>
<Price>0</Price>
<VAT>0</VAT>
</PriceInfo>
</Prices>
<JourneyKey>13284131410035102666500246600180029</JourneyKey>
<RouteLinks>
<RouteLink>
<RouteLinkKey>13284131410035102666500246600180029</RouteLinkKey>
<DepDateTime>2012-02-11T17:08:00</DepDateTime>
<DepIsTimingPoint>true</DepIsTimingPoint>
<ArrDateTime>2012-02-11T17:36:00</ArrDateTime>
<ArrIsTimingPoint>true</ArrIsTimingPoint>
<CallTrip>false</CallTrip>
<PriceZones>
<PriceZone>
<Id>12000250</Id>
</PriceZone>
<PriceZone>
<Id>12000243</Id>
</PriceZone>
<PriceZone>
<Id>12000242</Id>
</PriceZone>
<PriceZone>
<Id>12000241</Id>
</PriceZone>
<PriceZone>
<Id>12000240</Id>
</PriceZone>
<PriceZone>
<Id>12000237</Id>
</PriceZone>
<PriceZone>
<Id>12000236</Id>
</PriceZone>
<PriceZone>
<Id>12000132</Id>
</PriceZone>
<PriceZone>
<Id>12000130</Id>
</PriceZone>
<PriceZone>
<Id>12000119</Id>
</PriceZone>
<PriceZone>
<Id>12000120</Id>
</PriceZone>
</PriceZones>
<RealTime/>
<From>
<Id>80000</Id>
<Name>Malmö C</Name>
<StopPoint>3</StopPoint>
</From>
<To>
<Id>82000</Id>
<Name>Landskrona Station</Name>
<StopPoint>3</StopPoint>
</To>
<Line>
<Name>Öresundståg</Name>
<No>804</No>
<RunNo>74</RunNo>
<LineTypeId>16</LineTypeId>
<LineTypeName>Öresundståg</LineTypeName>
<TransportModeId>4</TransportModeId>
<TransportModeName>Tåg</TransportModeName>
<TrainNo>1074</TrainNo>
<Towards>Göteborg C</Towards>
<OperatorId>31</OperatorId>
<OperatorName>Veolia Transport Öresundståg</OperatorName>
</Line>
<Deviations/>
</RouteLink>
</RouteLinks>
<Distance>48100</Distance>
<CO2value>1E-06</CO2value>
</Journey>
<Journey>
<SequenceNo>2</SequenceNo>
<DepDateTime>2012-02-11T17:44:00</DepDateTime>
<ArrDateTime>2012-02-11T18:20:00</ArrDateTime>
<DepWalkDist>0</DepWalkDist>
<ArrWalkDist>0</ArrWalkDist>
<NoOfChanges>0</NoOfChanges>
<Guaranteed>true</Guaranteed>
<CO2factor>10</CO2factor>
<NoOfZones>11</NoOfZones>
<PriceZoneList>
12000250,12000243,12000242,12000241,12000240,12000237,12000236,12000132,12000130,12000119,12000120
</PriceZoneList>
<FareType>Normaltaxa</FareType>
<Prices>
<PriceInfo>
<PriceType>Kontant Vuxen</PriceType>
<Price>81</Price>
<VAT>4.58490562</VAT>
</PriceInfo>
<PriceInfo>
<PriceType>Kontant Barn</PriceType>
<Price>49</Price>
<VAT>2.77358484</VAT>
</PriceInfo>
<PriceInfo>
<PriceType>Kontant Duo/Familj</PriceType>
<Price>146</Price>
<VAT>8.264151</VAT>
</PriceInfo>
<PriceInfo>
<PriceType>Jojo Reskassa Vuxen</PriceType>
<Price>64.8</Price>
<VAT>3.66792464</VAT>
</PriceInfo>
<PriceInfo>
<PriceType>Jojo Reskassa Barn</PriceType>
<Price>39.2</Price>
<VAT>2.218868</VAT>
</PriceInfo>
<PriceInfo>
<PriceType>Jojo Reskassa Duo/Familj</PriceType>
<Price>116.8</Price>
<VAT>6.611321</VAT>
</PriceInfo>
<PriceInfo>
<PriceType>Skånekortet Vuxen</PriceType>
<Price>1150</Price>
<VAT>65.09434</VAT>
</PriceInfo>
<PriceInfo>
<PriceType>Skånekortet Barn</PriceType>
<Price>1150</Price>
<VAT>65.09434</VAT>
</PriceInfo>
<PriceInfo>
<PriceType>Skånekortet Duo/Familj</PriceType>
<Price>0</Price>
<VAT>0</VAT>
</PriceInfo>
</Prices>
<JourneyKey>13284131410035102702000278300040016</JourneyKey>
<RouteLinks>
<RouteLink>
<RouteLinkKey>13284131410035102702000278300040016</RouteLinkKey>
<DepDateTime>2012-02-11T17:44:00</DepDateTime>
<DepIsTimingPoint>true</DepIsTimingPoint>
<ArrDateTime>2012-02-11T18:20:00</ArrDateTime>
<ArrIsTimingPoint>true</ArrIsTimingPoint>
<CallTrip>false</CallTrip>
<PriceZones>
<PriceZone>
<Id>12000250</Id>
</PriceZone>
<PriceZone>
<Id>12000243</Id>
</PriceZone>
<PriceZone>
<Id>12000242</Id>
</PriceZone>
<PriceZone>
<Id>12000241</Id>
</PriceZone>
<PriceZone>
<Id>12000240</Id>
</PriceZone>
<PriceZone>
<Id>12000237</Id>
</PriceZone>
<PriceZone>
<Id>12000236</Id>
</PriceZone>
<PriceZone>
<Id>12000132</Id>
</PriceZone>
<PriceZone>
<Id>12000130</Id>
</PriceZone>
<PriceZone>
<Id>12000119</Id>
</PriceZone>
<PriceZone>
<Id>12000120</Id>
</PriceZone>
</PriceZones>
<RealTime/>
<From>
<Id>80000</Id>
<Name>Malmö C</Name>
<StopPoint>3</StopPoint>
</From>
<To>
<Id>82000</Id>
<Name>Landskrona Station</Name>
<StopPoint>3</StopPoint>
</To>
<Line>
<Name>Pågatåg</Name>
<No>817</No>
<RunNo>760</RunNo>
<LineTypeId>32</LineTypeId>
<LineTypeName>Pågatågen</LineTypeName>
<TransportModeId>4</TransportModeId>
<TransportModeName>Tåg</TransportModeName>
<TrainNo>1760</TrainNo>
<Towards>Ängelholm</Towards>
<OperatorId>44</OperatorId>
<OperatorName>Arriva Tåg AB</OperatorName>
</Line>
<Deviations/>
</RouteLink>
</RouteLinks>
<Distance>47702</Distance>
<CO2value>1E-06</CO2value>
</Journey>
<Journey>
<SequenceNo>3</SequenceNo>
<DepDateTime>2012-02-11T18:08:00</DepDateTime>
<ArrDateTime>2012-02-11T18:36:00</ArrDateTime>
<DepWalkDist>0</DepWalkDist>
<ArrWalkDist>0</ArrWalkDist>
<NoOfChanges>0</NoOfChanges>
<Guaranteed>true</Guaranteed>
<CO2factor>10</CO2factor>
<NoOfZones>11</NoOfZones>
<PriceZoneList>
12000250,12000243,12000242,12000241,12000240,12000237,12000236,12000132,12000130,12000119,12000120
</PriceZoneList>
<FareType>Normaltaxa</FareType>
<Prices>
<PriceInfo>
<PriceType>Kontant Vuxen</PriceType>
<Price>81</Price>
<VAT>4.58490562</VAT>
</PriceInfo>
<PriceInfo>
<PriceType>Kontant Barn</PriceType>
<Price>49</Price>
<VAT>2.77358484</VAT>
</PriceInfo>
<PriceInfo>
<PriceType>Kontant Duo/Familj</PriceType>
<Price>146</Price>
<VAT>8.264151</VAT>
</PriceInfo>
<PriceInfo>
<PriceType>Jojo Reskassa Vuxen</PriceType>
<Price>64.8</Price>
<VAT>3.66792464</VAT>
</PriceInfo>
<PriceInfo>
<PriceType>Jojo Reskassa Barn</PriceType>
<Price>39.2</Price>
<VAT>2.218868</VAT>
</PriceInfo>
<PriceInfo>
<PriceType>Jojo Reskassa Duo/Familj</PriceType>
<Price>116.8</Price>
<VAT>6.611321</VAT>
</PriceInfo>
<PriceInfo>
<PriceType>Skånekortet Vuxen</PriceType>
<Price>1150</Price>
<VAT>65.09434</VAT>
</PriceInfo>
<PriceInfo>
<PriceType>Skånekortet Barn</PriceType>
<Price>1150</Price>
<VAT>65.09434</VAT>
</PriceInfo>
<PriceInfo>
<PriceType>Skånekortet Duo/Familj</PriceType>
<Price>0</Price>
<VAT>0</VAT>
</PriceInfo>
</Prices>
<JourneyKey>13284131410035102666900246700180029</JourneyKey>
<RouteLinks>
<RouteLink>
<RouteLinkKey>13284131410035102666900246700180029</RouteLinkKey>
<DepDateTime>2012-02-11T18:08:00</DepDateTime>
<DepIsTimingPoint>true</DepIsTimingPoint>
<ArrDateTime>2012-02-11T18:36:00</ArrDateTime>
<ArrIsTimingPoint>true</ArrIsTimingPoint>
<CallTrip>false</CallTrip>
<PriceZones>
<PriceZone>
<Id>12000250</Id>
</PriceZone>
<PriceZone>
<Id>12000243</Id>
</PriceZone>
<PriceZone>
<Id>12000242</Id>
</PriceZone>
<PriceZone>
<Id>12000241</Id>
</PriceZone>
<PriceZone>
<Id>12000240</Id>
</PriceZone>
<PriceZone>
<Id>12000237</Id>
</PriceZone>
<PriceZone>
<Id>12000236</Id>
</PriceZone>
<PriceZone>
<Id>12000132</Id>
</PriceZone>
<PriceZone>
<Id>12000130</Id>
</PriceZone>
<PriceZone>
<Id>12000119</Id>
</PriceZone>
<PriceZone>
<Id>12000120</Id>
</PriceZone>
</PriceZones>
<RealTime/>
<From>
<Id>80000</Id>
<Name>Malmö C</Name>
<StopPoint>3</StopPoint>
</From>
<To>
<Id>82000</Id>
<Name>Landskrona Station</Name>
<StopPoint>3</StopPoint>
</To>
<Line>
<Name>Öresundståg</Name>
<No>804</No>
<RunNo>180</RunNo>
<LineTypeId>16</LineTypeId>
<LineTypeName>Öresundståg</LineTypeName>
<TransportModeId>4</TransportModeId>
<TransportModeName>Tåg</TransportModeName>
<TrainNo>1080</TrainNo>
<Towards>Helsingborg C</Towards>
<OperatorId>31</OperatorId>
<OperatorName>Veolia Transport Öresundståg</OperatorName>
</Line>
<Deviations/>
</RouteLink>
</RouteLinks>
<Distance>48100</Distance>
<CO2value>1E-06</CO2value>
</Journey>
<Journey>
<SequenceNo>4</SequenceNo>
<DepDateTime>2012-02-11T18:44:00</DepDateTime>
<ArrDateTime>2012-02-11T19:20:00</ArrDateTime>
<DepWalkDist>0</DepWalkDist>
<ArrWalkDist>0</ArrWalkDist>
<NoOfChanges>0</NoOfChanges>
<Guaranteed>true</Guaranteed>
<CO2factor>10</CO2factor>
<NoOfZones>11</NoOfZones>
<PriceZoneList>
12000250,12000243,12000242,12000241,12000240,12000237,12000236,12000132,12000130,12000119,12000120
</PriceZoneList>
<FareType>Normaltaxa</FareType>
<Prices>
<PriceInfo>
<PriceType>Kontant Vuxen</PriceType>
<Price>81</Price>
<VAT>4.58490562</VAT>
</PriceInfo>
<PriceInfo>
<PriceType>Kontant Barn</PriceType>
<Price>49</Price>
<VAT>2.77358484</VAT>
</PriceInfo>
<PriceInfo>
<PriceType>Kontant Duo/Familj</PriceType>
<Price>146</Price>
<VAT>8.264151</VAT>
</PriceInfo>
<PriceInfo>
<PriceType>Jojo Reskassa Vuxen</PriceType>
<Price>64.8</Price>
<VAT>3.66792464</VAT>
</PriceInfo>
<PriceInfo>
<PriceType>Jojo Reskassa Barn</PriceType>
<Price>39.2</Price>
<VAT>2.218868</VAT>
</PriceInfo>
<PriceInfo>
<PriceType>Jojo Reskassa Duo/Familj</PriceType>
<Price>116.8</Price>
<VAT>6.611321</VAT>
</PriceInfo>
<PriceInfo>
<PriceType>Skånekortet Vuxen</PriceType>
<Price>1150</Price>
<VAT>65.09434</VAT>
</PriceInfo>
<PriceInfo>
<PriceType>Skånekortet Barn</PriceType>
<Price>1150</Price>
<VAT>65.09434</VAT>
</PriceInfo>
<PriceInfo>
<PriceType>Skånekortet Duo/Familj</PriceType>
<Price>0</Price>
<VAT>0</VAT>
</PriceInfo>
</Prices>
<JourneyKey>13284131410035102702100278300040016</JourneyKey>
<RouteLinks>
<RouteLink>
<RouteLinkKey>13284131410035102702100278300040016</RouteLinkKey>
<DepDateTime>2012-02-11T18:44:00</DepDateTime>
<DepIsTimingPoint>true</DepIsTimingPoint>
<ArrDateTime>2012-02-11T19:20:00</ArrDateTime>
<ArrIsTimingPoint>true</ArrIsTimingPoint>
<CallTrip>false</CallTrip>
<PriceZones>
<PriceZone>
<Id>12000250</Id>
</PriceZone>
<PriceZone>
<Id>12000243</Id>
</PriceZone>
<PriceZone>
<Id>12000242</Id>
</PriceZone>
<PriceZone>
<Id>12000241</Id>
</PriceZone>
<PriceZone>
<Id>12000240</Id>
</PriceZone>
<PriceZone>
<Id>12000237</Id>
</PriceZone>
<PriceZone>
<Id>12000236</Id>
</PriceZone>
<PriceZone>
<Id>12000132</Id>
</PriceZone>
<PriceZone>
<Id>12000130</Id>
</PriceZone>
<PriceZone>
<Id>12000119</Id>
</PriceZone>
<PriceZone>
<Id>12000120</Id>
</PriceZone>
</PriceZones>
<RealTime/>
<From>
<Id>80000</Id>
<Name>Malmö C</Name>
<StopPoint>3</StopPoint>
</From>
<To>
<Id>82000</Id>
<Name>Landskrona Station</Name>
<StopPoint>3</StopPoint>
</To>
<Line>
<Name>Pågatåg</Name>
<No>817</No>
<RunNo>764</RunNo>
<LineTypeId>32</LineTypeId>
<LineTypeName>Pågatågen</LineTypeName>
<TransportModeId>4</TransportModeId>
<TransportModeName>Tåg</TransportModeName>
<TrainNo>1764</TrainNo>
<Towards>Ängelholm</Towards>
<OperatorId>44</OperatorId>
<OperatorName>Arriva Tåg AB</OperatorName>
</Line>
<Deviations/>
</RouteLink>
</RouteLinks>
<Distance>47702</Distance>
<CO2value>1E-06</CO2value>
</Journey>
</Journeys>
</GetJourneyResult>
</GetJourneyResponse>
</soap:Body>
</soap:Envelope>
]]
local xml = plugin.xml()
local parsed = xml.parse(data)

local journey = parsed['soap:Envelope']['soap:Body']['GetJourneyResponse']['GetJourneyResult']['Journeys']['Journey'][1]
--[[
CO2factor
DepWalkDist
RouteLinks
FareType
ArrWalkDist
ArrDateTime
DepDateTime
Guaranteed
PriceZoneList
Distance
JourneyKey
Prices
NoOfZones
CO2value
NoOfChanges
SequenceNo
]]


-- 2012-02-11T18:36:00
local departure = journey.DepDateTime['#text']:sub(12, 16)
local arrival = journey.ArrDateTime['#text']:sub(12, 16)
local routelinks = journey.RouteLinks.RouteLink
if #routelinks == 0 then
  routelinks = {routelinks}
end
local routelink = routelinks[1]
local from = routelink.From.Name['#text']
local to = routelink.To.Name['#text']
local line = routelink.Line.Name['#text']

etc.printf('$BDeparture:$B %s $BArrival:$B %s $BFrom:$B %s $BTo:$B %s (%s)', departure, arrival, from, to, line)