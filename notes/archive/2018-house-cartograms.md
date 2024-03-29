---
title: "Cartograms of the 2018 U.S. House Vote"
date: 2018-11-16
draft: false
aliases:
  - "/notes/2018-house-cartograms/"
---

The divide between urban and rural voters has become an [increasingly
observable](https://www.washingtonpost.com/graphics/politics/2016-election/urban-rural-vote-swing/) pattern in U.S. elections.  Many Democratic voters pack
into areas with higher population densities. Choropleth maps—where
regions are shaded by a variable—often hide this reality because
geographic area has little to do with the vote count.

Area cartograms can address this issue by distorting the geography
to match the population. Furthermore, cartograms on different
variables can present some insights. Below are three different
maps of the 2018 midterm U.S. House election results by populations:
total population, population of Democratic voters, and population of
GOP voters.

<script src="//cdnjs.cloudflare.com/ajax/libs/d3/4.11.0/d3.min.js"></script>

<script src="https://unpkg.com/cartogram-chart@1.0.6/dist/cartogram-chart.min.js"></script>

<!-- htmlmin:ignore -->
<div id="world">
  <!-- This will contain the map.-->
</div>
<!-- htmlmin:ignore -->

<select name="pop">
  <option value="HC01_EST_VC01" selected="selected">Population</option>
  <option value="Dem.Votes">Democrats</option>
  <option value="GOP.Votes">Republicans</option>
</select>

<script>
var cart;
d3.json('/images/test.json', function (error, world) {
    if (error) throw error;
    const colorScale = d3.scaleOrdinal(["#F8766D", "#619CFF", "#CCCCCC"]);
    cart = Cartogram()
      .topoJson(world)
      .topoObjectName('states')
      .projection(d3.geoAlbers())
      .iterations(12)
      .value(function (obj) {
        return obj.properties["HC01_EST_VC01"] + 1000;
      })
      .color(({ properties: { Party } }) => colorScale(Party))
      .label(({ properties: p }) => `${p.STUSAB}${p.CD115FP} (${p.Party})`)
      .valFormatter(d3.format(".3s"))
      .width("100%")
      .height(500)
      (document.getElementById('world'));
});
document.addEventListener('DOMContentLoaded',function() {
  document.querySelector('select[name="pop"]').onchange=changeEventHandler;
},false);
function changeEventHandler(event) {
  if(event.target.value) {
    cart.value(function (obj) { return obj.properties[event.target.value] + 1000;});
  }
}
</script>


## How I Made This {#how-i-made-this}

I processed the data in R. The House results came from a spreadsheet
maintained by [David Wasserman & Ally Flinn of Cook Political Report.](https://docs.google.com/spreadsheets/d/1WxDaxD5az6kdOjJncmGph37z0BPNhV1fNAH%5Fg7IkpC0/htmlview?sle=true) I
also used a table from the [U.S. Census](https://www2.census.gov/geo/docs/reference/state.txt) to map the [Congressional
District shapefiles](https://www.census.gov/geo/maps-data/data/cbf/cbf%5Fcds.html) to the results.

```R
library(maps)

all_content = readLines("https://docs.google.com/spreadsheets/d/1WxDaxD5az6kdOjJncmGph37z0BPNhV1fNAH_g7IkpC0/gviz/tq?tqx=out:csv&sheet=Sheet1")
all_content = all_content[-2]
all_content = all_content[-2]
results <- read.csv(textConnection(all_content), header = TRUE, stringsAsFactors = FALSE)
results$CD.[is.na(results$CD.)]<-0
fips <- read.csv("https://www2.census.gov/geo/docs/reference/state.txt", sep="|")
results_fips <- merge(results, fips, by.x="State", by.y="STATE_NAME")
results_fips$GEOID <- sprintf("%02d%02d", results_fips$STATE, results_fips$CD.)
tail(results_fips[,c("State", "CD.", "Party", "GEOID")])
```

| State   | CD. | Party | GEOID |
|-----------|-----|-------|-------|
| Wisconsin | 4   | D   | 5504  |
| Wisconsin | 5   | R   | 5505  |
| Wisconsin | 6   | R   | 5506  |
| Wisconsin | 7   | R   | 5507  |
| Wisconsin | 8   | R   | 5508  |
| Wyoming   | 0   | R   | 5600  |

To visualize this data, I need to use my trusty [congressional shape
files](https://www.census.gov/geo/maps-data/data/cbf/cbf%5Fcds.html) from the U.S. Census Bureau.

```R
library(cartogram)
library(maptools)

shape <- sf::st_read(shapefile)
shape$STATEFP =  as.numeric(shape$STATEFP)
shape_data <- merge(shape, results_fips, by="GEOID")
shape_data <- shape_data[!is.na(shape_data$State) & shape_data$State != "Alaska" & shape_data$State != "Hawaii",]
shape_data$GOP.Votes <- as.numeric(gsub(",", "", shape_data$GOP.Votes))
shape_data$Dem.Votes <- as.numeric(gsub(",", "", shape_data$Dem.Votes))
```

Sorry, Alaska and Hawaii. Some things are easier without you.

Creating the cartogram ended up being the tricky part. I tried a few
different libraries, but ended up finding the most success with
[topogRam](https://github.com/dreamRs/topogRam). The only issue I had was getting it to work with my website.
To do this, I ended up writing the JavaScript myself and loading it
from a pre-saved JSON file.

```R
library(topogram)
top <- topogram(shape=shape_data, value="Dem.Votes")
hpop <- read.csv(popfile)
hpop$GEOID <- sprintf("%04d", hpop$GEO.id2)
data <- merge(shape_data, hpop, by="GEOID")
d <- data[,c("STUSAB", "CD115FP", "Party", "HC01_EST_VC01", "Dem.Votes", "GOP.Votes")]
top2 <- topogram(shape=d, value="HC01_EST_VC01")
write(top2$x$shape, "images/test.json")
```

That is all there is to it. The end results look a bit strange
(and a bit like Russia according to some observers), but I think
they do a good job at showing where each respective party's voters
are located.