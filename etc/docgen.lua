-- Usage: 'docgen <code> - generates documentation from the code by finding --- in the code.

local isbot = bot and etc
-- local wanthtml = not isbot or arg[2] == '-html'
local wanthtml = arg[2] ~= '-text'

local f
if isbot then
  f = assert(etc.userfileopen(arg[1]))
else
  f = assert(io.open(arg[1]))
end

local docprint = print
if wanthtml then
  print("<html><head><meta http-equiv=\"content-type\" content=\"text/html; charset=UTF-8\"><title>" .. arg[1] .. "</title></head><body>")
  local incodes = {}
  local htmlcodes = { ["\031"]="u", ["\002"]="strong" }
  docprint = function(s)
    if s then
      s = s:gsub("[\031\002\r\n]", function(x)
        if x == "\r" then
          return ""
        end
        if x == "\n" then
          return "<br>\n"
        end
        local isin = incodes[x]
        incodes[x] = not isin
        if isin then
          return "</" .. htmlcodes[x] .. ">"
        else
          return "<" .. htmlcodes[x] .. ">"
        end
      end)
      return print(s .. "<br>")
    end
    return print("<br>")
  end
end
-- local isweb = Output and (Output.mode == 'web')
local sep = " "
local nbsp = "\194\160" -- "&nbsp;"
local specialprefix = "\194\160\226\128\162 " -- "&nbsp;&bull; "
docprint("\002Documentation for " .. arg[1] .. "\002")
docprint(sep)
local h
if isbot then
  local h = { etc.help(arg[1]) }
  if h[1] then
    docprint(unpack(h))
    docprint(sep)
  end
end
local indoc
local inspecial
local function doc(s)
  if #s > 0 then
    indoc[#indoc + 1] = s
  end
end
for line in f:lines() do
  if not line:find("^%s*$") then
    local cc, dc = line:match("^%s*(%-%-+)%s*(.*)$")
    if cc then
      if not indoc then
        if #cc >= 3 then
          indoc = {}
        end
      end
      if indoc and #cc > 0 then
        local special, specialdc = dc:match("^%s*@(%w+)%s+(.+)")
        if special then
          dc = specialdc
          if inspecial ~= special then
            inspecial = special
            doc("\031" .. special:sub(1, 1):upper() .. special:sub(2) .. "\031:")
          end
          doc(specialprefix .. dc)
        else
          doc(dc)
        end
      end
    else
      if indoc then
        local header = line
        local icc = header:find("--", 1, true)
        if icc then
          header = header:sub(1, icc - 1)
        end
        header = header:match("([^ ].-) *$") or ''
        -- docprint("----------")
        docprint("\002" .. header .. "\002")
        docprint(sep)
        if #indoc > 0 then
          for i = 1, #indoc do
            docprint(nbsp .. " " .. indoc[i])
          end
          docprint(sep)
        end
        indoc = nil
        level = 0
      end
    end
  end
end
f:close()

if wanthtml then
  print("</body></html>")
end
