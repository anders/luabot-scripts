if not Web then return end

local nickqs = Web.qs:match('^%?js=([^/]+)')
if nickqs then
  nickqs = urlDecode(nickqs)
  local f = io.open(nickqs..'.js', 'r')
  if f then
    local d =f:read('*a')
    f:close()
    Web.write(d)
  else
    Web.write('nothing')
  end
  return
end

local resnick = Web.qs:match('^%?res=([^/]+)')
if resnick then
  resnick = urlDecode(resnick)
  local res = Web.data
  _clown()
  Output.printType = 'plain'
  Output.printTypeConvert = 'plain'
  if res and #res>0 then
    print(resnick..': '..res)
  end
  os.remove(resnick..'.js')
  return
end

Web.write[[
<!DOCTYPE html>
<html>
  <head>
    <script>
      var nick;
      
      // to fetch JS
      function cronjerb() {
        var loc = (""+window.location).split('?')[0] + '?js=' + nick;
        var xhr = new XMLHttpRequest();
        xhr.onreadystatechange = function() {
          if (xhr.readyState == 4){
            if (xhr.responseText.length > 0)
              postres(eval(xhr.responseText).toString());
          }
        };
        xhr.open('GET', loc, true);
        xhr.send(null);
        setTimeout(cronjerb, 1500);
      }
      
      // post result
      function postres(s) {
        var loc = (""+window.location).split('?')[0] + '?res=' + nick;
        
        var xhr = new XMLHttpRequest();
        xhr.open('POST', loc, true);
        xhr.send(s);
      }
    
      function init(){
        nick = (""+window.location).split('?')[1].split('=');
        if (nick[0] == "u") { nick = nick[1]; }
        else return;
      
        cronjerb();
      }
      
      init();
    </script>
  </head>
  <body>
    <pre id="debug"></pre>
  </body>
</html>
]]
