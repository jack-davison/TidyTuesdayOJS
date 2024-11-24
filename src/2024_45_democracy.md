---
toc: false
theme: [dashboard]
---

```js
import * as L from "npm:leaflet";
```

# [2024/45] 🏛️ Democracy

<div class="grid grid-cols-2" style="grid-auto-rows: auto;">

<div class="grid-colspan-1">

This week we're exploring democracy and dictatorship! The data this week comes from the *The Review of International Organizations 15.2 (2020), pp. 531-551.* [DOI: 10.1007/s11558-019-09345-1](https://link.springer.com/article/10.1007/s11558-019-09345-1). This dashboard explores how countries go from <span style='text-decoration: underline;text-decoration-color: #5e5d5d; text-underline-offset: 4px; text-decoration-thickness: 3px;'>dictatorship</span> to <span style='text-decoration: underline;text-decoration-color: gold; text-underline-offset: 4px; text-decoration-thickness: 3px;'>democracy</span> (and, unfortunately, occasionally back again).

```js
const democracy = FileAttachment("data/democracy.json").json({typed: true})
```

```js
const democracyYear = democracy.map((d) => {
  const filtered = d.data.filter(x => x.year === selectedYear)

  return {
    ...d,
    data: filtered
  }
})
```

```js
const selectedYear = view(Inputs.range([Math.min(...uniqueYears), Math.max(...uniqueYears)], {step: 1, value: 1950}))
```

${resize((width) => Plot.plot({
  marginLeft: 10,
  marginRight: 10,
  width,
  y: {label: null, tickSize: 0},
  x: {percent: true},
  color: {domain: [true, false], range: ["gold", "#5e5d5d"]},
  marks: [
    Plot.barX(democracy_counts, {x: "Percentage of Countries", y: "", fill: "democracy"})
  ]
})
)}

</div>

<div class="card grid-colspan-1" height=250>

${resize((width) => Plot.plot({
  width,
  height: 250,
  color: {domain: [true, false], range: ["gold", "#5e5d5d"]},
  y: {label: "Number of Countries"},
  x: {label: "Year", interval: 1, tickFormat: x => x.toString()},
  marks: [
    Plot.barY(demoCounts, {y: "count", x: "year", fill: "democracy"}),
    Plot.ruleX([selectedYear])
  ]
}))}


</div>

</div>

<div class = "card"  style="padding: 0;">

```js
const div = display(document.createElement("div"));
div.style = "height: 400px;";

const map = L.map(div)
  .setView([30, 0], 1);

L.tileLayer('http://{s}.basemaps.cartocdn.com/dark_all/{z}/{x}/{y}.png', {
  attribution: '&copy; <a href="http://www.openstreetmap.org/copyright">OpenStreetMap</a> contributors, &copy; <a href="http://cartodb.com/attributions">CartoDB</a>'
})
  .addTo(map);

const geoJsonLayerGroup = L.layerGroup().addTo(map);
```
</div>

```js
updateMap(democracyYear);
```

```js
function updateMap(data) {
  geoJsonLayerGroup.clearLayers(); // Remove all current layers
  data.forEach((element) => L.geoJSON(element.geometry, {
    onEachFeature: (feature, layer) => {
      console.log(element)
      // console.log(feature)
      layer.bindPopup(element.country_name)
    },
    fillOpacity: 2/3, 
    color: "white",
    weight: 0.25, 
    fillColor: element.data[0]["is_democracy"] ? "gold" : "#5e5d5d"}).addTo(geoJsonLayerGroup)
  );
};
```

```js
const years = democracy.flatMap(country => country.data.map(entry => entry.year));

const uniqueYears = [...new Set(years)].sort();
```

```js
const democracy_counts =
aq.from(democracyYear
  .map((d) => {
    return {
      country_name: d.country_name,
      democracy: d.data[0].is_democracy
    }
  })).groupby(["democracy"]).count().orderby(aq.desc("democracy")).derive({"Percentage of Countries": d => d.count / aq.op.sum(d.count)});
```

```js
const valDemocracy = democracy.flatMap((d) => d.data.flatMap((x) => x.is_democracy))
```

```js
const valYear = democracy.flatMap((d) => d.data.flatMap((x) => x.year))
```

```js
const demoCounts = aq.table({
  year: valYear,
  democracy: valDemocracy
}).groupby(["year", "democracy"]).count().orderby(aq.desc("democracy"))
```

