## code to prepare `usa_covid_data` dataset goes here

library(tidyverse)
library(janitor)
library(lubridate)

usa_covid_data <- read_csv("data-raw/United_States_COVID-19_Cases_and_Deaths_by_State_over_Time.csv")
usa_states_abbr <- read_csv("data-raw/csvData.csv")

usa_covid_data <- usa_covid_data %>%
  left_join(usa_states_abbr, by = c("state" = "Code")) %>%
  select("date" = submission_date,
         "state" = State,
         "state_abr" = state,
         tot_cases:pnew_death) %>%
  mutate(date = mdy(date),
         state = tolower(state))

usethis::use_data(usa_covid_data, overwrite = TRUE)
