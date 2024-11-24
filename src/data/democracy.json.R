
democracy <- read.csv("https://raw.githubusercontent.com/rfordatascience/tidytuesday/refs/heads/master/data/2024/2024-11-05/democracy_data.csv")

democracy <- democracy[c("country_name", "country_code", "year", "is_democracy")]

countries <- rnaturalearth::ne_countries() |>
  dplyr::mutate(adm0_iso = ifelse(adm0_iso == "COD", "ZAR", adm0_iso))

countries_sf <- dplyr::select(countries, country_name = name_en, country_code = adm0_iso)

democracy_sf <- dplyr::left_join(
  democracy,
  dplyr::select(countries_sf, country_code),
  by = "country_code",
  suffix = c("", "_joined")
)

democracy_sf <-
  democracy_sf[sf::st_is_empty(democracy_sf$geometry), ] |>
  dplyr::tibble() |>
  dplyr::select(-geometry) |>
  dplyr::left_join(
    dplyr::select(countries_sf, country_name),
    by = "country_name",
    suffix = c("", "_joined")
  ) |>
  dplyr::bind_rows(democracy_sf[!sf::st_is_empty(democracy_sf$geometry), ])

democracy_sf |>
  tidyr::nest(data = c(year, is_democracy)) |>
  jsonlite::toJSON()
