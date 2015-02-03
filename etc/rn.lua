API "1.1"
-- Usage: 'rn <num> can convert to and from roman numerals.

--mapping of possible addition values
local addition_map = {
    I=1,
    X=10,
    C=100,
    M=1000
    }
 
--mapping of substraction offsets (what can be substracted from each number)
local substraction_map = {
    V = 1,
    X = 1,
    L = 10,
    C = 10,
    D = 100,
    M = 100
    }
 
--mapping of roman numerals to arabic values
local numerals_map = {
    I = 1,
    V = 5,
    X = 10,
    L = 50,
    C = 100,
    D = 500,
    M = 1000
    }
 
function roman2arabic(str)
    local result = {}
    if str and type(str) == 'string' then
        local strLen = string.len(str)
        local resultPos = 1
 
        for i=1,strLen do
            local letter = string.sub(str, i, i)
            if not result[resultPos] then
                table.insert( result, numerals_map[letter] )
                --no need to increment since it's first number
            else
                if result[resultPos] == substraction_map[letter] then --can substract prev value
                    result[resultPos] = numerals_map[letter] - result[resultPos]
                    resultPos = resultPos + 1 --go to next one
                elseif result[resultPos] == addition_map[letter] then --can add prev value
                    result[resultPos] = result[resultPos] + numerals_map[letter]
                    --no increment -> can still add
                else
                    --no addition/substraction -> add a new number
                    resultPos = resultPos + 1
                    table.insert( result, numerals_map[letter] )
                end
            end
        end
    else
        print("roman2arabic: invalid input")
    end
    local arabicNum = 0
    for i, v in ipairs(result) do
        arabicNum = arabicNum + v
    end
 
    return arabicNum
end
 
--roman numerals possible based on order (placement in number - units, tens, hundreds, thousands)
local roman_nums_order = { {"I", "V", "X"}, {"X", "L", "C"}, {"C", "D", "M"}, {"M", "M", "M"} }
 
function arabic2roman(str)
    result = ""
    if str and type(str) == 'string' and (string.len(str) <= 4) then
        local strLen = string.len(str)
        local revStr = string.reverse(str)
 
        for i=1,strLen do
            local letter = string.sub(revStr, i, i)
            --probably there's a better way to transform a letter to a digit, but i don't know now
            local digit = string.byte(letter,1) - string.byte('0',1)
            local orderRes = ""
 
            local symbolReps = 0 --num of times symbol has repeated (must not be > 3)
            local substSymbol = 1 --symbol to substitute with (from roman_nums_order table)
            local substSymbolIncrement = 1 --can be 1 or 2, depending if we are before 5 or after 5 (e.g. if we need to use V or X)
            local j=1
            while j <= digit do
            	orderRes = orderRes .. roman_nums_order[i][substSymbol]
            	symbolReps = symbolReps + 1
            	if symbolReps > 3 then
            	    if i >= 4 then --max number of order thousands supported is 3
            	        orderRes = "MMM"
            	        break
            	    end
            	    orderRes = roman_nums_order[i][substSymbol]
            	    substSymbol = substSymbol + substSymbolIncrement
                 	orderRes = orderRes .. roman_nums_order[i][substSymbol]
                 	symbolReps = 0
			--check if next digit exists in advance  -> to remove substraction possibility
			if j+1 <= digit then
			    orderRes = roman_nums_order[i][substSymbol]
                            j = j+1 --go to next numeral ( e.g. IV -> V )
			    substSymbol = substSymbol - substSymbolIncrement --go back to small units
			    substSymbolIncrement = substSymbolIncrement + 1
			end
            	end
            	j=j+1
            end
            substSymbolIncrement = 1 -- reset increment for next order digit
	    result = string.format("%s%s", orderRes, result)
        end
    end
    return result
end

if tonumber(arg[1]) then
  return arabic2roman(arg[1])
elseif arg[1] and #arg[1] then
  return roman2arabic(arg[1]:upper())
end
return nil, "Invalid input"
