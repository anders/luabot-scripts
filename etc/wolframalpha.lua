-- alias: wa

assert(arg[1] and arg[1]:find("%w"), "Input expected")

require "spam"

if spam.detect(Cache, "wolframalpha", 20, 60 * 20) then
  error("Too many requests, please try again in a few minutes")
end

local raw

if arg[1] == "-test" then
  raw = pickone({

[[
<queryresult success="true" error="false" numpods="8" datatypes="MathematicalFunctionIdentity" timedout="Numeric" timedoutpods="" timing="2.747" parsetiming="0.188" parsetimedout="false" recalculate="http://www4b.wolframalpha.com/api/v2/recalc.jsp?id=MSPa11591a43h3gff5fh0ci6000067c8eegdgh8c81dh&s=51" id="MSPa11601a43h3gff5fh0ci6000027fbehaga96b1530" auth="" host="http://www4b.wolframalpha.com" server="51" related="http://www4b.wolframalpha.com/api/v2/relatedQueries.jsp?id=MSPa11611a43h3gff5fh0ci6000061g64dd8gdiibd66&s=51" version="2.6">
<pod title="Input" scanner="Identity" id="Input" position="100" error="false" numsubpods="1">
<subpod title="">
<plaintext>pi</plaintext>
</subpod>
</pod>
<pod title="Decimal approximation" scanner="Numeric" id="DecimalApproximation" position="200" error="false" numsubpods="1" primary="true">
<subpod title="">
<plaintext>
3.1415926535897932384626433832795028841971693993751058...
</plaintext>
</subpod>
<states count="1">
<state name="More digits" input="DecimalApproximation__More digits"/>
</states>
</pod>
<pod title="Property" scanner="Numeric" id="Property" position="300" error="false" numsubpods="1">
<subpod title="">
<plaintext>pi is a transcendental number</plaintext>
</subpod>
</pod>
<pod title="Number line" scanner="NumberLine" id="NumberLine" position="400" error="false" numsubpods="1">
<subpod title="">
<plaintext/>
</subpod>
</pod>
<pod title="Continued fraction" scanner="ContinuedFraction" id="ContinuedFraction" position="500" error="false" numsubpods="1">
<subpod title="">
<plaintext>
[3; 7, 15, 1, 292, 1, 1, 1, 2, 1, 3, 1, 14, 2, 1, 1, 2, 2, 2, 2, 1, 84, 2, 1, 1, 15, ...]
</plaintext>
</subpod>
<states count="2">
<state name="Fraction form" input="ContinuedFraction__Fraction form"/>
<state name="More terms" input="ContinuedFraction__More terms"/>
</states>
</pod>
<pod title="Alternative representations" scanner="MathematicalFunctionData" id="AlternativeRepresentations:MathematicalFunctionIdentityData" position="600" error="false" numsubpods="3">
<subpod title="">
<plaintext>pi = 180 °</plaintext>
</subpod>
<subpod title="">
<plaintext>pi = -i log(-1)</plaintext>
</subpod>
<subpod title="">
<plaintext>pi = cos^(-1)(-1)</plaintext>
</subpod>
<states count="1">
<state name="More" input="AlternativeRepresentations:MathematicalFunctionIdentityData__More"/>
</states>
<infos count="4">
<info text="log(x) is the natural logarithm">
<link url="http://reference.wolfram.com/mathematica/ref/Log.html" text="Documentation" title="Mathematica"/>
<link url="http://functions.wolfram.com/ElementaryFunctions/Log" text="Properties" title="Wolfram Functions Site"/>
<link url="http://mathworld.wolfram.com/NaturalLogarithm.html" text="Definition" title="MathWorld"/>
</info>
<info text="i is the imaginary unit">
<link url="http://reference.wolfram.com/mathematica/ref/I.html" text="Documentation" title="Documentation"/>
<link url="http://mathworld.wolfram.com/i.html" text="Definition" title="MathWorld"/>
</info>
<info text="cos^(-1)(x) is the inverse cosine function">
<link url="http://reference.wolfram.com/mathematica/ref/ArcCos.html" text="Documentation" title="Mathematica"/>
<link url="http://functions.wolfram.com/ElementaryFunctions/ArcCos" text="Properties" title="Wolfram Functions Site"/>
<link url="http://mathworld.wolfram.com/InverseCosine.html" text="Definition" title="MathWorld"/>
</info>
<info>
<link url="http://functions.wolfram.com/Constants/Pi/27/ShowAll.html" text="More information"/>
</info>
</infos>
</pod>
<pod title="Series representations" scanner="MathematicalFunctionData" id="SeriesRepresentations:MathematicalFunctionIdentityData" position="700" error="false" numsubpods="3">
<subpod title="">
<plaintext>pi = 4 sum_(k=0)^infinity (-1)^k/(2 k+1)</plaintext>
</subpod>
<subpod title="">
<plaintext>
pi = -2+2 sum_(k=1)^infinity 2^k/(binomial(2 k, k))
</plaintext>
</subpod>
<subpod title="">
<plaintext>
pi = sum_(k=0)^infinity (50 k-6)/(2^k binomial(3 k, k))
</plaintext>
</subpod>
<states count="1">
<state name="More" input="SeriesRepresentations:MathematicalFunctionIdentityData__More"/>
</states>
<infos count="2">
<info text="(n m) is the binomial coefficient">
<link url="http://reference.wolfram.com/mathematica/ref/Binomial.html" text="Documentation" title="Mathematica"/>
<link url="http://functions.wolfram.com/GammaBetaErf/Binomial" text="Properties" title="Wolfram Functions Site"/>
<link url="http://mathworld.wolfram.com/BinomialCoefficient.html" text="Definition" title="MathWorld"/>
</info>
<info>
<link url="http://functions.wolfram.com/Constants/Pi/06/ShowAll.html" text="More information"/>
</info>
</infos>
</pod>
<pod title="Integral representations" scanner="MathematicalFunctionData" id="IntegralRepresentations:MathematicalFunctionIdentityData" position="800" error="false" numsubpods="3">
<subpod title="">
<plaintext>pi = 2 integral_0^infinity 1/(t^2+1) dt</plaintext>
</subpod>
<subpod title="">
<plaintext>pi = 4 integral_0^1 sqrt(1-t^2) dt</plaintext>
</subpod>
<subpod title="">
<plaintext>pi = 2 integral_0^infinity (sin(t))/t dt</plaintext>
</subpod>
<states count="1">
<state name="More" input="IntegralRepresentations:MathematicalFunctionIdentityData__More"/>
</states>
<infos count="1">
<info>
<link url="http://functions.wolfram.com/Constants/Pi/07/ShowAll.html" text="More information"/>
</info>
</infos>
</pod>
<assumptions count="1">
<assumption type="Clash" word="pi" template="Assuming "${word}" is ${desc1}. Use as ${desc2} instead" count="6">
<value name="NamedConstant" desc="a mathematical constant" input="*C.pi-_*NamedConstant-"/>
<value name="Character" desc="a character" input="*C.pi-_*Character-"/>
<value name="MathWorld" desc="referring to a mathematical definition" input="*C.pi-_*MathWorld-"/>
<value name="MathWorldClass" desc="a class of mathematical terms" input="*C.pi-_*MathWorldClass-"/>
<value name="Movie" desc="a movie" input="*C.pi-_*Movie-"/>
<value name="Word" desc="a word" input="*C.pi-_*Word-"/>
</assumption>
</assumptions>
</queryresult>
]],

[[
<queryresult success="true" error="false" numpods="8" datatypes="" timedout="" timedoutpods="" timing="1.138" parsetiming="0.281" parsetimedout="false" recalculate="" id="MSPa99011a43gadah58c37ie000016i913ce55bdh349" auth="" host="http://www3.wolframalpha.com" server="26" related="http://www3.wolframalpha.com/api/v2/relatedQueries.jsp?id=MSPa99021a43gadah58c37ie000031cfgb25ge0756hc&s=26" version="2.6">
<pod title="Input interpretation" scanner="Identity" id="Input" position="100" error="false" numsubpods="1">
<subpod title="">
<plaintext>convert 1 gallon to liters</plaintext>
</subpod>
</pod>
<pod title="Result" scanner="Identity" id="Result" position="200" error="false" numsubpods="1" primary="true">
<subpod title="" primary="true">
<plaintext>3.785 L (liters)</plaintext>
</subpod>
</pod>
<pod title="Additional conversions" scanner="Unit" id="AdditionalConversion" position="300" error="false" numsubpods="5">
<subpod title="">
<plaintext>0.003785 m^3 (cubic meters)</plaintext>
</subpod>
<subpod title="">
<plaintext>3785 cm^3 (cubic centimeters)</plaintext>
</subpod>
<subpod title="">
<plaintext>8 pints</plaintext>
</subpod>
<subpod title="">
<plaintext>4 quarts</plaintext>
</subpod>
<subpod title="">
<plaintext>0.1337 ft^3 (cubic feet)</plaintext>
</subpod>
<states count="1">
<state name="More" input="AdditionalConversion__More"/>
</states>
</pod>
<pod title="Comparisons as volume" scanner="Unit" id="ComparisonAsVolume" position="400" error="false" numsubpods="2">
<subpod title="">
<plaintext>
~~ ( 0.17 ~~ 1/6 ) × volume of one mole of ideal gas at STP ( 1 mol molar volumes of an ideal gas at STP )
</plaintext>
</subpod>
<subpod title="">
<plaintext>
~~ 0.8 × volume of blood in a typical human (~~ 5 L )
</plaintext>
</subpod>
</pod>
<pod title="Comparisons as volume of food or beverage" scanner="Unit" id="ComparisonAsVolumeOfFoodOrBeverage" position="500" error="false" numsubpods="3">
<subpod title="">
<plaintext>~~ 1.2 × volume of a US size 10 can ( 105 fl oz )</plaintext>
</subpod>
<subpod title="">
<plaintext>~~ 2.3 × volume of a US size 5 can ( 7 cups )</plaintext>
</subpod>
<subpod title="">
<plaintext>~~ 4 × volume of a US size 3 can ( 4 cups )</plaintext>
</subpod>
</pod>
<pod title="Interpretations" scanner="Unit" id="Interpretation" position="600" error="false" numsubpods="2">
<subpod title="">
<plaintext>volume</plaintext>
</subpod>
<subpod title="">
<plaintext>volume of food or beverage</plaintext>
</subpod>
<states count="1">
<state name="More" input="Interpretation__More"/>
</states>
</pod>
<pod title="Basic unit dimensions" scanner="Unit" id="BasicUnitDimensions" position="700" error="false" numsubpods="1">
<subpod title="">
<plaintext>[length]^3</plaintext>
</subpod>
</pod>
<pod title="Corresponding quantities" scanner="Unit" id="CorrespondingQuantity" position="800" error="false" numsubpods="4">
<subpod title="">
<plaintext>
Radius r of a sphere from V = 4pir^3/3: | 0.3172 feet | 3.806 inches | 9.668 cm (centimeters)
</plaintext>
</subpod>
<subpod title="">
<plaintext>
Edge length a of a cube from V = a^3: | 0.5113 feet | 6.136 inches | 15.58 cm (centimeters)
</plaintext>
</subpod>
<subpod title="">
<plaintext>
Mass m of water from m = rhoV: | 8.3 lb (pounds) | 3.8 kg (kilograms) | (assuming maximum water density ~~ 1000 kg/m^3)
</plaintext>
</subpod>
<subpod title="">
<plaintext>
Molecules N of water from N = rhoV/MW: | 1.265×10^26 molecules | (assuming maximum water density ~~ 1000 kg/m^3)
</plaintext>
</subpod>
</pod>
<assumptions count="1">
<assumption type="Unit" word="gallon" template="Assuming ${desc1} for "${word}". Use ${desc2} instead" count="4">
<value name="Gallons" desc="US liquid gallons" input="UnitClash_*gallon.*Gallons--"/>
<value name="DryGallons" desc="dry gallons" input="UnitClash_*gallon.*DryGallons--"/>
<value name="GallonsUK" desc="UK fluid gallons" input="UnitClash_*gallon.*GallonsUK--"/>
<value name="GallonsUKBeer" desc="UK gallons of beer" input="UnitClash_*gallon.*GallonsUKBeer--"/>
</assumption>
</assumptions>
</queryresult>]],

  })
else
  local typeORerr, charset, statusCode, statusDesc
  raw, typeORerr, charset, statusCode, statusDesc = httpGet("http://api.wolframalpha.com/v2/query?input=" .. urlEncode(arg[1])
    .. "&format=plaintext&appid=" .. io.open("apikeys/wolframalpha"):read()
    )
  assert(raw, typeORerr)
  if statusCode ~= "200" then
    return false, html2text(statusDesc or typeORerr or raw or "???")
  end
end

require "xml"

local dat = assert(xml.parse(raw))

-- print(etc.t(dat)) -------

if dat and dat.queryresult and dat.queryresult.pod and #dat.queryresult.pod > 1 then
  local input, result, prop
  for i, pod in ipairs(dat.queryresult.pod) do
    if pod.subpod then
      local t
      local subpod
      if pod.subpod.plaintext then
        t = pod.subpod.plaintext["#text"]
        subpod = pod.subpod
      elseif pod.subpod[1] and pod.subpod[1].plaintext then
        t = pod.subpod[1].plaintext["#text"]
        subpod = pod.subpod[1]
      end
      if t then
        t = t:gsub("[ \t\r\n]+", " ")
        if pod.title == "Input" or pod.title == "Input interpretation" then
          input = t
        elseif true and (
            pod.title == "Property"
            or pod.title == "Interpretations"
            ) then
          prop = t
        elseif not result then
          result = t
          prop = pod.scanner
        end
      end
    end
  end
  if not result then
    error("Unable to find result: " .. html2text(raw))
  end
  result = result:gsub("^[ ]+", ""):gsub("[ ]+$", "")
  if arg[2] == true then
    return input, result, prop
  end
  -- print((input or '?') .. " = " .. result .. " (" .. (prop or '?') .. ")")
  print((input or '?') .. " = " .. result)
else
  local errmsg = "Unable to evaluate: " .. html2text(raw)
  if arg[2] == true then
    return nil, errmsg or "???"
  end
  print(errmsg)
end

