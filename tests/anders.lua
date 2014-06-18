assert(Web, 'expected to be run as a Web script')

local data = [[
<script type="text/javascript">
var req = new XMLHttpRequest();
req.onreadystatechange = function() {
  if (req.readyState == 4 && req.status == 200) {
    document.write(req.responseText);
  }
};
req.open('POST', 'test.lua?hax', true);
req.send(document.cookie);
</script>
]]

if Web.qs == '?hax' then
  print('hehehehe: '..tostring(Web.data))
  return
end

Web.write(data)

--Web.write(data..'Enjoy!')
