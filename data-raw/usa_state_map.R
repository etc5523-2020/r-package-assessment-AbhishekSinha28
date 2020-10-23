## code to prepare `usa_state_map` dataset goes here

library(maps)
library(mapproj)
library(broom)

usa_state_map <- map("state", fill = TRUE, plot = FALSE)
names <- strsplit(usa_state_map$names, ":")
names <- lapply(names, function(x) x[1])
usa_state_map <- fortify(usa_state_map)



usethis::use_data(usa_state_map, overwrite = TRUE)
