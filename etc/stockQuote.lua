local API_URL = 'http://www.google.com/ig/api' -- ?stock=GOOG
--[[
<xml_api_reply version="1">
  <script/>
  <finance module_id="0" tab_id="0" mobile_row="0" mobile_zipped="1" row="0" section="0">
    <symbol data="GOOG"/>
    <pretty_symbol data="GOOG"/>
    <symbol_lookup_url data="/finance?client=ig&q=GOOG"/>
    <company data="Google Inc"/>
    <exchange data="Nasdaq"/>
    <exchange_timezone data="ET"/>
    <exchange_utc_offset data="+05:00"/>
    <exchange_closing data="960"/>
    <divisor data="2"/>
    <currency data="USD"/>
    <last data="605.91"/>
    <high data="608.13"/>
    <low data="604.00"/>
    <volume data="2325443"/>
    <avg_volume data="3230"/>
    <market_cap data="197003.34"/>
    <open data="607.88"/>
    <y_close data="611.46"/>
    <change data="-5.55"/>
    <perc_change data="-0.91"/>
    <delay data="0"/>
    <trade_timestamp data="13 hours ago"/>
    <trade_date_utc data="20120210"/>
    <trade_time_utc data="210006"/>
    <current_date_utc data="20120211"/>
    <current_time_utc data="102944"/>
    <symbol_url data="/finance?client=ig&q=GOOG"/>
    <chart_url data="/finance/chart?q=NASDAQ:GOOG&tlf=12"/>
    <disclaimer_url data="/help/stock_disclaimer.html"/>
    <ecn_url data=""/>
    <isld_last data=""/>
    <isld_trade_date_utc data=""/>
    <isld_trade_time_utc data=""/>
    <brut_last data=""/>
    <brut_trade_date_utc data=""/>
    <brut_trade_time_utc data=""/>
    <daylight_savings data="false"/>
  </finance>
</xml_api_reply>
]]

local cache = plugin.cache(Cache)
local xml = plugin.xml()
local stringx = plugin.stringx()

local stock = arg[1] and stringx.trim(arg[1])
if not stock then
  etc.printf('$BUsage:$B %ssq stock (e.g.: %ssq GOOG, BUTT.BOT)', etc.cmdchar, etc.cmdchar)
  return
end

-- current price, symbol, description, 1-day change in points, 1-day change percent
local value, symbol, desc, onedaypts, onedaypcnt = botstock(stock)
if value then
--  etc.printf('\002'..symbol..' Last trade: \002$'..value..' \002Change:\002 $'..onedaypts..' ()
  etc.printf('$B%s$B (%s) $BLast trade:$B $%.02f $BChange:$B $%.02f (%0.2f%%)', desc, symbol, value, onedaypts, onedaypcnt)
  return
end

cache.auto(stock, 10 * 60, function()
  local data, err = httpGet(API_URL..'?stock='..urlEncode(stock))
  assert(data, err)
  local parsed = xml.parse(data)
  local finance = parsed.xml_api_reply.finance
  
  if finance.company.data == '' then
    etc.printf('$BError:$B 404 Company Not Found')
  else
    local change = finance.change.data
    local sign = change:sub(1, 1)
    change = change:sub(2)
    etc.printf('$B%s$B (%s) $BLast trade:$B $%s $BChange:$B %s$%s (%s%%)', finance.company.data, finance.symbol.data, finance.last.data, sign, change, finance.perc_change.data)
  end
end)