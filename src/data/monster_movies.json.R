

movies <- read.csv("https://raw.githubusercontent.com/rfordatascience/tidytuesday/refs/heads/master/data/2024/2024-10-29/monster_movies.csv")

movies$genres[is.na(movies$genres)] <- "Unknown"
 
movies$genres <- strsplit(movies$genres, ",")
 
cat(jsonlite::toJSON(movies))
