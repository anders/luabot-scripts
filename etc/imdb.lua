--[[
http://www.imdbapi.com/?t=True%20Grit&y=1969
i	 string (optional)	 a valid IMDb movie id
t	 string (optional)	 title of a movie to search for
y	 year (optional)	 year of the movie
r	 JSON, XML	 response data type (JSON default)
plot	 short, full	 short or extended plot (short default)
callback	 name (optional)	 JSONP callback name
tomatoes	 true (optional)	 adds rotten tomatoes data
]]

--[[
{
    "Title": "True Grit",
    "Year": "2010",
    "Rated": "PG-13",
    "Released": "22 Dec 2010",
    "Genre": "Adventure, Drama, Western",
    "Director": "Ethan Coen, Joel Coen",
    "Writer": "Joel Coen, Ethan Coen",
    "Actors": "Jeff Bridges, Matt Damon, Hailee Steinfeld, Josh Brolin",
    "Plot": "A tough U.S. Marshal helps a stubborn young woman track down her father's murderer.",
    "Poster": "http://ia.media-imdb.com/images/M/MV5BMjIxNjAzODQ0N15BMl5BanBnXkFtZTcwODY2MjMyNA@@._V1_SX320.jpg",
    "Runtime": "1 hr 50 mins",
    "Rating": "7.8",
    "Votes": "102615",
    "ID": "tt1403865",
    "tomatoMeter": "96",
    "tomatoImage": "certified",
    "tomatoRating": "8.4",
    "tomatoReviews": "248",
    "tomatoFresh": "238",
    "tomatoRotten": "10",
    "Response": "True"
}
]]

local json = plugin.json()

local function asshurt(exp, e)
  if not exp then
    etc.printf('$BError:$B %s', e)
    halt()
  end
  return exp
end

local title = asshurt(arg[1], 'No movie title specified!')

local data, err = httpGet('http://www.imdbapi.com/?tomatoes=true&r=json&t='..urlEncode(title))
asshurt(data, err)

local parsed = json.decode(data)
etc.printf('$B%s$B (%s, %s) - %s (http://www.imdb.com/title/%s/)', data.Title, data.Year, data.Rating, data.Plot, data.ID)