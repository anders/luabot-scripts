API "1.1"

local test = [[
            <tr class="table-body__row">
                <th scope="row" class="table-body__header table-body__header--party table-body__header--party-no">NO</th>
                <td class="table-body__cell"><span class="label">Votes </span>19,036</td>
                <td class="table-body__cell">53.80<span class="label label-percent">%</span></td>
            </tr>
            <tr class="table-body__row">
                <th scope="row" class="table-body__header table-body__header--party table-body__header--party-yes">YES</th>
                <td class="table-body__cell"><span class="label">Votes </span>16,350</td>
                <td class="table-body__cell">46.20<span class="label label-percent">%</span></td>
            </tr>
            <tr class="table-foot__row">
        <td class="table-foot__cell" colspan="3">After 1 of 32 counts</td>
      </tr>
]]

test = assert(httpGet("http://www.bbc.com/news/events/scotland-decides/results"))

local _, _, no, yes = test:find("<span class=\"label\">Votes </span>([%d,]+)</td>.*<span class=\"label\">Votes </span>([%d,]+)</td>")
no = tonumber((no:gsub(",", "")))
yes = tonumber((yes:gsub(",", "")))

local _, _, rejected = test:find("Rejected ballots .*</span> ([%d,]+)</p>")
rejected = tonumber((rejected:gsub(",","")))

local total = yes + no + rejected

local _, _, counts, counts_tot = test:find("After (%d+) of (%d+) counts")
counts = tonumber(counts)
counts_tot = tonumber(counts_tot)

print(("Scotland Referendum 2014: Yes: %d (%0.1f%%) No: %d (%0.1f%%) (%d/%d counts)"):format(
  yes, yes / total * 100,
  no, no / total * 100,
  counts, counts_tot))
