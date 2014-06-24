API "1.1"

-- Usage: require'game'; require'game.web'; If using from Web to generate the page, call game.init and write game.web.generatePlayerWeb.

local LOG = plugin.log(_funcname);

local M = {}
local game = require 'game';
game.web = M


---
function Private.game_control.getPlayerWebTicket(who)
  local p = assert(Private.game_control.getPlayerData(who), 'No such player ' .. who)
  if not p.tik then
    LOG.debug("Generating game web ticket for", who)
    p.tik = who .. "!" .. math.random(1000000000)
  end
  return p.tik
end


---
function M.isValidPlayerWebTicket(who, gameTicket)
  local p = Private.game_control.getPlayerData(who)
  if p then
    local isvalid = p.tik == gameTicket
    if not isvalid then
      LOG.warn("Game web ticket not validated for", who)
    end
    return isvalid
  end
  return false
end


--- who is nick, gameTicket is their ticket or false if already validated, and optional writefunc.
--- Calls game_web_gen(game_control, who, writefunc)
--- This function should only generate a HTML fragment, to be used within a HTML document.
function M.generatePlayerWeb(who, gameTicket, writefunc)
  assert(gameTicket == false or Private.game_control.isValidPlayerWebTicket(who, gameTicket), "Game web ticket invalid")
  local t
  if not writefunc then
    t = {}
    writefunc = function(s)
      t[#t + 1] = assert(s, "Bad write")
    end
  end
  
  local G = Private.game_G
  
  writefunc("<div class='game_result'>")
  local game_web_gen = G.Private.game_web_gen or G.game_web_gen
  if game_web_gen then
    game_web_gen(Private.game_control, who, writefunc)
  else
    writefunc("<p>Function game_web_gen not found</p>")
  end
  writefunc("</div>")
  
  if t then
    return table.concat(t, "")
  end
end


--- Similar to generatePlayerWeb but generates a whole page.
function M.generateWebPage(who, gameTicket, writefunc)
  -- Relies on generatePlayerWeb to validate ticket!
  local t
  if not writefunc then
    t = {}
    writefunc = function(s)
      t[#t + 1] = assert(s, "Bad write")
    end
  end
  
  writefunc([[<html><head><title>Game of ]] .. M.name .. [[</title>
      <style>.game_result { display: none; border: dotted 1px silver; border: 5px; margin: 5px; }</style>
    </head><body>
    ]])
  writefunc("<h3>Game of " .. M.name .. "</h3>")
  writefunc("<noscript><p>If you don't script then how can you play</p></noscript>")
  writefunc("<script>if(!document.querySelectorAll) { document.write('<p>Your browser does not support stuff!</p>'); alert('Invalid browser'); }</script>")
  writefunc([[<div id='all_results'>]])
  M.generatePlayerWeb(who, gameTicket, writefunc)
  writefunc([[</div>
    <script>
      var qoldresults = document.querySelectorAll('.game_results_old')
      var qresult = document.querySelector('.game_result')
      var txt = qresult.innerText;
      if(qoldresults.length)
      {
        var lasttxt = qoldresults[qoldresults.length - 1].innerText;
        if(txt == lasttxt)
        {
          qresult.parentElement.removeChild(qresult);
          return;
        }
      }
      qresult.className = 'game_results_old';
    </script>
  ]])
  writefunc("</body></html>")
  
  if t then
    return table.concat(t, "")
  end
end

