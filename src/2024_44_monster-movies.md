---
toc: false
theme: dashboard
---

# [2024/44] 🧟 Monster Movies 

This week we're exploring "monster" movies: movies with "monster" in their title! The data this week comes from the [Internet Movie Database](https://developer.imdb.com/non-commercial-datasets/). This dashboard explores monster movie *genres* - more than just horror!

```js
const monsterMovies = FileAttachment("data/monster_movies.json").json({typed: true});
```

```js
const genres = monsterMovies.map((d) => d.genres).flat();

const uniqueGenres = [... new Set(genres)].sort();
```

```js
const monsterMoviesSelected = monsterMovies.filter((d) => d.genres.includes(inputGenre))

const highestRatedMovie = monsterMoviesSelected.reduce((highest, film) => {
  return film.average_rating > highest.average_rating ? film : highest;
})
```

```js
const inputGenre = view(Inputs.select(uniqueGenres, {label: "Highlight Genre"}))
```

<div class="grid grid-cols-3" style="grid-auto-rows: auto;">

<div class="card grid-colspan-2 grid-rowspan-2">
${resize((width) => Plot.plot({
  title: "Weighted average of all the individual user ratings on IMDb",
  width: width,
  y: {type: "linear", domain: [0, 10], grid: true, label: null},
  x: {tickFormat: d => d.toString(), label: inputXaxis === "Runtime" ? "Runtime (minutes)" : "Release Year"},
  marks: [
    Plot.ruleY([0]),
    Plot.dot(
      monsterMovies, 
      {x: inputXaxis === "Runtime" ? "runtime_minutes" : "year", y: "average_rating", stroke: "#464646"}
    ),
    Plot.dot(
      monsterMoviesSelected, 
      {
        x: inputXaxis === "Runtime" ? "runtime_minutes" : "year", 
        y: "average_rating", 
        stroke: "#62c8cd", 
        tip: {
          format: {
            year: true,
            x: false,
            y: false
          }
        },
        channels: {
          "": "primary_title",
          "Runtime": (d) => d.runtime_minutes + " minutes", 
          "Release Year": (d) => d.year.toString()
        }
      }
    )
  ]}))}

```js
const inputXaxis = view(Inputs.select(["Runtime", "Release Year"], {label: "X-axis"}))
```
</div>

<div class = "card">

### Number of ${inputGenre} Monster Movies
# ${monsterMoviesSelected.length}

${resize((width) => Plot.plot({
  width,
  marginLeft: 10,
  marginRight: 10,
  margin: 0,
  y: {label: null, tickSize: 0},
  marks: [
    Plot.barX(monsterMovies, {y: "", x: 1, fill: "#464646"}),
    Plot.barX(monsterMoviesSelected, {y: "", x: 1, fill: "#62c8cd"})
  ]
}))}

</div>

<div class = "card">

### Highest Rated ${inputGenre} Monster Movie

# ${highestRatedMovie.primary_title} (${highestRatedMovie.year})
## ${highestRatedMovie.genres.join(", ")}
## Rating: ${highestRatedMovie.average_rating} / 10 (${highestRatedMovie.num_votes.toLocaleString()} Votes)

</div>

</div>

<div>

<div class = "card" style="padding: 0;">

```js
Inputs.table(monsterMoviesSelected, {
  select: false,
  layout: "auto",
  columns: [
    "primary_title",
    "genres",
    "year",
    "runtime_minutes",
    "average_rating",
    "num_votes"
  ],
  header: {
    primary_title: "Movie Title",
    year: "Release Year",
    runtime_minutes: "Runtime (minutes)",
    genres: "Genre(s)",
    average_rating: "Avg. IMDb Rating",
    num_votes: "Number IMDb Votes"
  },
  format: {
    year: (x) => x.toString(),
    genres: (x) => x.join(", ")
  }
})
```

</div>

</div>

```js
function rRange(x) {
  return [Math.min(...x), Math.max(...x)]
}
```