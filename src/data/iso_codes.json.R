
countries <- read.csv("https://raw.githubusercontent.com/rfordatascience/tidytuesday/refs/heads/master/data/2024/2024-11-12/countries.csv")

countries <- countries[c("alpha_3", "name")]

splits <- strsplit(countries$alpha_3, "")
 
countries$alpha_3 <- lapply(splits, \(x) paste(x, collapse = "/"))

alpha3 <- paste(countries$alpha_3, countries$name, sep ="/")
 

 
cat(jsonlite::toJSON(data.frame(
  alpha3 = alpha3,
  one = sapply(splits, \(x) x[1]),
  two = sapply(splits, \(x) x[2]),
  three = sapply(splits, \(x) x[3]),
  name = countries$name
)))


