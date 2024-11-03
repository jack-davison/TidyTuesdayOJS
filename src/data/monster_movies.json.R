
library(dplyr)
 
monsters <- tidytuesdayR::tt_load(2024, 44)

movies <- monsters$monster_movies

movies$genres[is.na(movies$genres)] <- "Unknown"
 
movies$genres <- strsplit(movies$genres, ",")
 
cat(jsonlite::toJSON(movies))
