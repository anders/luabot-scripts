-- XML parser based on https://github.com/krstns/Lua-Simple-XML-Parser, heavily modified by Anders Bergh
-- based on Corona-XML-Module by Jonathan Beebe
-- based on Alexander Makeev's Lua-only XML parser at http://lua-users.org/wiki/LuaXml

-- 2012-04-06: removed some old code
-- 2013-05-27: handle entities

--[====[
xml.parse[[
<?xml version="1.0" encoding="utf-8"?>
<lfm status="ok">
  <results for="disco" xmlns:opensearch="http://a9.com/-/spec/opensearch/1.1/">
    <opensearch:Query role="request" searchTerms="disco" startPage="1" />
    <opensearch:totalResults>2641</opensearch:totalResults>
    <opensearch:startIndex>0</opensearch:startIndex>
    <opensearch:itemsPerPage>20</opensearch:itemsPerPage>
    <tagmatches>
      <tag>
        <name>disco</name>
        <count>55483</count>
        <url>www.last.fm/tag/disco</url>
      </tag>
      <tag>
        <name>disco pop</name>
        <count>160</count>
        <url>www.last.fm/tag/disco%20pop</url>
      </tag>
    </tagmatches>
  </results>
</lfm>
]]

should result in something like this:
{
  version = '1.0',
  encoding = 'utf-8',
  lfm = {
    status = 'ok',
    results = {
      xmlns:opensearch = 'http://a9.com/-/spec/opensearch/1.1/',
      for = 'disco',
      opensearch:Query = {
        role = 'request',
        searchTerms = 'disco',
        startPage = '1'
      },
      opensearch:totalResults = {#text=2641},
      opensearch:startIndex = {#text=0},
      opensearch:itemsPerPage = {#text=20},
      tagmatches = {
        tag = {
          {name = {#text = disco}, count = {#text = 1234}, url = {#text = 'bla'}},
          {name = {#text = disco+pop}, count = {#text = 1234}, url = {#text = 'bla'}}
        }
      }
    }
  }
}
]====]

local _M = {}

function _M.parse(xmlInput)
  -- hack
  local function fixCDATA(s)
    -- <![CDATA[ ... ]]>
    local tmp = s:match('<!%[CDATA%[(.-)%]%]>')
    if not tmp then
      return s
    end
    return tmp
  end  

  local function parseAttrs(element, s)
    string.gsub(s, '([%w:]+)=(["\'])(.-)%2', function(w, _, a)
      element[w] = a
    end)
  end

  local top = {}
  local stack = {top}
  local ni, c, tag, xarg, empty
  local i, j = 1, 1

  while true do
    ni, j, c, tag, xarg, empty = xmlInput:find('<(%/?)(%??[%w_:]+)(.-)(%/?)>', i)
    if not ni then break end

    local text = xmlInput:sub(i, ni - 1)
    if not text:find('^%s*$') then
      local textValue = fixCDATA(text)
      stack[#stack]['#text'] = html2text(textValue)
    end

    if empty == '/' then
      -- empty element tag
      local element = {['#tag'] = tag}
      parseAttrs(element, xarg)
      stack[#stack][element['#tag']] = element
      element['#tag'] = nil
    elseif c == '' then
      -- start tag

      -- add the attributes for <?xml to the root table
      if tag == '?xml' then
        parseAttrs(top, xarg)
      else
        local element = {['#tag'] = tag}
        parseAttrs(element, xarg)
        table.insert(stack, element)
      end
    else
      -- end tag
      local toclose = table.remove(stack)
      top = stack[#stack]
      if #stack < 1 then
        error('nothing to close with '..tag)
      end
      
      if top[toclose['#tag']] then
        -- tagitems.tag already exists and isn't an array (1..n)
        -- store it in a tmp variable, create an array, and insert it there
        if #top[toclose['#tag']] < 1 then
          local tmp = top[toclose['#tag']]
          top[toclose['#tag']] = {}
          table.insert(top[toclose['#tag']], tmp)
        end
        
        table.insert(top[toclose['#tag']], toclose)
      else
        top[toclose['#tag']] = toclose
        toclose['#tag'] = nil
      end
    end
    i = j + 1
  end

  return top
end

return _M