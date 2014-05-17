local xml = plugin.xml()

local testData1 = [===[
<?xml version="1.0" encoding="utf-8"?>
<weatherdata>
  <location>
    <name>London</name>
    <type/>
    <country>GB</country>
    <timezone/>
    <location altitude="0" latitude="51.50853" longitude="-0.12574" geobase="geonames" geobaseid="0"/>
  </location>
  <credit/>
  <meta>
    <lastupdate>2013-10-23T16:53:24</lastupdate>
    <calctime>0.0184</calctime>
    <nextupdate>2013-10-23T19:53:24</nextupdate>
  </meta>
  <sun rise="2013-10-23T06:39:31" set="2013-10-23T16:49:57"/>
  <forecast>
    <time day="2013-10-23">
      <symbol number="802" name="scattered clouds" var="03d"/>
      <precipitation/>
      <windDirection deg="249" code="WSW" name="West-southwest"/>
      <windSpeed mps="6.71" name="Moderate breeze"/>
      <temperature day="11.09" min="6.25" max="11.09" night="6.25" eve="9.23" morn="11.09"/>
      <pressure unit="hPa" value="1005.09"/>
      <humidity value="95" unit="%"/>
      <clouds value="scattered clouds" all="44" unit="%"/>
    </time>
    <time day="2013-10-24">
      <symbol number="800" name="sky is clear" var="01d"/>
      <precipitation/>
      <windDirection deg="142" code="SE" name="SouthEast"/>
      <windSpeed mps="2.18" name="Light breeze"/>
      <temperature day="12.49" min="4.72" max="12.95" night="12.08" eve="11.46" morn="4.72"/>
      <pressure unit="hPa" value="1017.47"/>
      <humidity value="100" unit="%"/>
      <clouds value="sky is clear" all="0" unit="%"/>
    </time>
    <time day="2013-10-25">
      <symbol number="500" name="light rain" var="10d"/>
      <precipitation value="2" type="rain"/>
      <windDirection deg="194" code="SSW" name="South-southwest"/>
      <windSpeed mps="7.17" name="Moderate breeze"/>
      <temperature day="16.32" min="13.35" max="16.32" night="15.88" eve="15.18" morn="13.35"/>
      <pressure unit="hPa" value="1002.55"/>
      <humidity value="98" unit="%"/>
      <clouds value="overcast clouds" all="92" unit="%"/>
    </time>
    <time day="2013-10-26">
      <symbol number="500" name="light rain" var="10d"/>
      <precipitation value="1" type="rain"/>
      <windDirection deg="221" code="SW" name="Southwest"/>
      <windSpeed mps="7.37" name="Moderate breeze"/>
      <temperature day="15.7" min="10.86" max="15.7" night="10.86" eve="12.03" morn="14.96"/>
      <pressure unit="hPa" value="1001.56"/>
      <humidity value="95" unit="%"/>
      <clouds value="overcast clouds" all="92" unit="%"/>
    </time>
    <time day="2013-10-27">
      <symbol number="501" name="moderate rain" var="10d"/>
      <precipitation value="11" type="rain"/>
      <windDirection deg="217" code="SW" name="Southwest"/>
      <windSpeed mps="7.17" name="Moderate breeze"/>
      <temperature day="13.16" min="9.78" max="13.16" night="11.7" eve="11.93" morn="9.78"/>
      <pressure unit="hPa" value="1006.69"/>
      <humidity value="96" unit="%"/>
      <clouds value="broken clouds" all="80" unit="%"/>
    </time>
    <time day="2013-10-28">
      <symbol number="502" name="heavy intensity rain" var="10d"/>
      <precipitation value="15.6" type="rain"/>
      <windDirection deg="261" code="W" name="West"/>
      <windSpeed mps="11.84" name="Strong breeze"/>
      <temperature day="15.64" min="12.54" max="15.64" night="12.91" eve="12.54" morn="14.07"/>
      <pressure unit="hPa" value="989.8"/>
      <humidity value="0" unit="%"/>
      <clouds value="scattered clouds" all="30" unit="%"/>
    </time>
    <time day="2013-10-29">
      <symbol number="501" name="moderate rain" var="10d"/>
      <precipitation value="7.49" type="rain"/>
      <windDirection deg="249" code="WSW" name="West-southwest"/>
      <windSpeed mps="12.14" name="Strong breeze"/>
      <temperature day="12.3" min="11.86" max="12.55" night="11.86" eve="12.02" morn="12.55"/>
      <pressure unit="hPa" value="984.89"/>
      <humidity value="0" unit="%"/>
      <clouds value="scattered clouds" all="39" unit="%"/>
    </time>
  </forecast>
</weatherdata>
]===]

local testData2 =
[[
     <methodCall kind="xuxu">
      <methodName>examples.getStateName</methodName>
      <params>
         <param>
            <value><i4>41</i4></value>
            </param>
         </params>
      </methodCall>
]]

etc.print_table(xml.parse(testData1))