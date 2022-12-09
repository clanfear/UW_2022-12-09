library(tidyverse)
library(sf)
library(leaflet)
load("./data/derived/phdcn_long_imputed.RData")
load("../phdcn_neighborhoods/individuals/data/derived/phdcn_w5_buffer_incidents.RData")

load("../../Kirk Projects/phdcn_neighborhoods/boundaries/data/derived/nc_boundaries.RData")
load("../../Kirk Projects/phdcn_neighborhoods/boundaries/data/derived/nc_boundaries_nowater.RData")
load("../../Kirk Projects/phdcn_neighborhoods/crime/data/derived/incidents_sf.RData")

nc_boundaries_nowater %>%
  st_union() %>%
  st_combine() %>%
  st_transform(4326) 

chicago_limit <- nc_boundaries %>%
  st_union() %>%
  st_combine() %>%
  st_transform(4326) %>%
  st_make_valid()

incidents_sf |>
  st_filter(chicago_limit) |>
  filter(lubridate::year(date) == 2021 & city == "Chicago" & death_or_injury) |>
  leaflet() %>%
  addTiles() %>%
  addCircles()

nc_boundaries_nowater %>%
  ggplot() + geom_sf()

nc_boundaries_nowater %>%
  st_transform(4326) %>%
  leaflet() %>%
  addTiles() %>%
  addPolygons(label = ~nc_num) 
  
phdcn_w5_gva_long <- phdcn_long_imputed |> 
  filter(w5_sample & wave == "5") |>
  inner_join(phdcn_w5_buffer_incidents)
