## code to update `aus_covid_data` dataset 

library(tidyverse)
library(lubridate)
library(dplyr)

aus_covid_data <- read.table("https://raw.githubusercontent.com/RamiKrispin/coronavirus/master/csv/coronavirus.csv", header = TRUE, sep = ",")

aus_covid_data <- aus_covid_data %>% filter(country == "Australia")

aus_covid_data$date <- as.Date(aus_covid_data$date)

aus_covid_data <- aus_covid_data %>% filter(date <= today() - days(2))

usethis::use_data(aus_covid_data, overwrite = TRUE)
