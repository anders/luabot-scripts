local PI = 3.1415926535897932384

local __daylen__
local __sunriset__
local sunpos
local sun_RA_dec
local revolution
local rev180
local GMST0
local main
local printf

local sin, cos, tan, atan, asin, acos, atan2, sqrt, floor, abs =
  math.sin, math.cos, math.tan, math.atan, math.asin, math.acos,
  math.atan2, math.sqrt, math.floor, math.abs

printf = function(s, ...)
  print(s:format(...))
end

main = function(lat, lon, year, month, day)
  local rise, set, civ_start, civ_end, naut_start, naut_end, astr_start,
      astr_end
  local rs, civ, naut, astr

  lat = assert(lat, 'need latitude')
  lon = assert(lon, 'need longitude')

  local d = os.date('!*t')
  year = year or d.year
  month = month or d.month
  day = day or d.day

  local result = {
    daylen = __daylen__(year, month, day, lon, lat, -35.0 / 60.0, 1),
    civlen = __daylen__(year, month, day, lon, lat, -6.0, 0),
    nautlen = __daylen__(year, month, day, lon, lat, -12.0, 0),
    astrlen = __daylen__(year, month, day, lon, lat, -18.0, 0)
  }

  local to_epoch = function(t)
    return os.time{year=year, month=month, day=day, hour=0, min=0, sec=0} + t * 3600
  end

  rs, rise, set = __sunriset__(year, month, day, lon, lat, -35.0 / 60.0, 1)
  result.rs = rs
  result.rise = to_epoch(rise)
  result.set = to_epoch(set)

  civ, civ_start, civ_end = __sunriset__(year, month, day, lon, lat, -6.0, 0)
  result.civ = civ
  result.civ_start = to_epoch(civ_start)
  result.civ_end = to_epoch(civ_end)

  naut, naut_start, naut_end = __sunriset__(year, month, day, lon, lat, -12.0, 0)
  result.naut = naut
  result.naut_start = to_epoch(naut_start)
  result.naut_end = to_epoch(naut_end)

  astr, astr_start, astr_end = __sunriset__(year, month, day, lon, lat, -18.0, 0)
  result.astr = astr
  result.astr_start = to_epoch(astr_start)
  result.astr_end = to_epoch(astr_end)

  return result
end

__sunriset__ = function(year, month, day, lon, lat, altit, upper_limb)
  local trise, tset
  local d, sr, sRA, sdec, sradius, t, tsouth, sidtime

  local rc = 0

  d = (367 * (year) - ((7 * ((year) + (((month) + 9) / 12))) / 4) +
       ((275 * (month)) / 9) + (day) - 730530) +
      0.5 - lon / 360.0

  sidtime = revolution(GMST0(d) + 180.0 + lon)

  sRA, sdec, sr = sun_RA_dec(d)

  tsouth = 12.0 - rev180(sidtime - sRA) / 15.0

  sradius = 0.2666 / sr

  if upper_limb ~= 0 then altit = altit - sradius end

  do
    local cost
    cost = (sin((altit) * (PI / 180.0)) -
            sin((lat) * (PI / 180.0)) *
                sin((sdec) * (PI / 180.0))) /
           (cos((lat) * (PI / 180.0)) *
            cos((sdec) * (PI / 180.0)))
    if cost >= 1.0 then
      rc = -1 t = 0.0
    elseif cost <= -1.0 then
      rc = 1 t = 12.0
    else
      t = ((180.0 / PI) * acos(cost)) / 15.0
    end
  end

  trise = tsouth - t
  tset = tsouth + t
  return rc, trise, tset
end

__daylen__ = function(year, month, day, lon, lat, altit, upper_limb)
  local d, obl_ecl, sr, slon, sin_sdecl, cos_sdecl, sradius, t

  d = (367 * (year) - ((7 * ((year) + (((month) + 9) / 12))) / 4) +
       ((275 * (month)) / 9) + (day) - 730530) +
      0.5 - lon / 360.0

  obl_ecl = 23.4393 - 3.563E-7 * d

  slon, sr = sunpos(d)

  sin_sdecl = sin((obl_ecl) * (PI / 180.0)) *
              sin((slon) * (PI / 180.0))
  cos_sdecl = sqrt(1.0 - sin_sdecl * sin_sdecl)

  sradius = 0.2666 / sr

  if upper_limb ~= 0 then altit = altit - sradius end

  do
    local cost
    cost = (sin((altit) * (PI / 180.0)) -
            sin((lat) * (PI / 180.0)) * sin_sdecl) /
           (cos((lat) * (PI / 180.0)) * cos_sdecl)
    if cost >= 1.0 then
      t = 0.0
    elseif cost <= -1.0 then
      t = 24.0
    else
      t = (2.0 / 15.0) * ((180.0 / PI) * acos(cost))
    end
  end

  return t
end

sunpos = function(d)
  local lon, r
  local M, w, e, E, x, y, v

  M = revolution(356.0470 + 0.9856002585 * d)
  w = 282.9404 + 4.70935E-5 * d
  e = 0.016709 - 1.151E-9 * d

  E = M + e * (180.0 / PI) *
              sin((M) * (PI / 180.0)) *
              (1.0 + e * cos((M) * (PI / 180.0)))
  x = cos((E) * (PI / 180.0)) - e
  y = sqrt(1.0 - e * e) * sin((E) * (PI / 180.0))
  r = sqrt(x * x + y * y)
  v = ((180.0 / PI) * atan2(y, x))
  lon = v + w
  if (lon >= 360.0) then lon = lon - 360.0 end
  return lon, r
end

sun_RA_dec = function(d)
  local RA, dec, r
  local lon, obl_ecl, x, y, z

  lon, r = sunpos(d)

  x = r * cos((lon) * (PI / 180.0))
  y = r * sin((lon) * (PI / 180.0))

  obl_ecl = 23.4393 - 3.563E-7 * d

  z = y * sin((obl_ecl) * (PI / 180.0))
  y = y * cos((obl_ecl) * (PI / 180.0))

  RA = ((180.0 / PI) * atan2(y, x))
  dec = ((180.0 / PI) * atan2(z, sqrt(x * x + y * y)))
  return RA, dec, r
end

revolution = function(x) return (x - 360.0 * floor(x * (1.0 / 360.0))); end

rev180 = function(x) return (x - 360.0 * floor(x * (1.0 / 360.0) + 0.5)); end

GMST0 = function(d)
  local sidtim0

  sidtim0 = revolution((180.0 + 356.0470 + 282.9404) +
                       (0.9856002585 + 4.70935E-5) * d)
  return sidtim0
end

return {calc = main}
