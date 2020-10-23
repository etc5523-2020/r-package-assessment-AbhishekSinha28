#' Create a summary COVID19 data set for entire Australia
#' 
#' @description Create new data set comprising average daily counts for each different `measure` of COVID19 in Australia.
#'
#' @param data A data set to be summarized
#' @param measure The variable to summarize the data on, can be as a character vector. Can be `"total_cases"` or `"total_death`.
#'
#' @return A summarised data set comprising 273 observations (one for each day) and 3 variables dependent on what `measure` is chosen.
#' 
#' @export
#'
#' @examples
#' average_measure(aus_covid_data, "tot_cases")
#' average_measure(aus_covid_data, "tot_death")
#' 
average_measure <- function(data, measure){
  if(measure == "tot_cases"){
    data %>%
      dplyr::group_by(date,type) %>%
      dplyr::summarise(tot_cases = mean(tot_cases)) %>%
      dplyr::mutate(state = "average",
                    tot_cases = round(tot_cases, digits = 0))
  } else if(measure == "tot_death"){
    data %>%
      dplyr::group_by(date,type) %>%
      dplyr::summarise(tot_death = mean(tot_death)) %>%
      dplyr::mutate(state = "average",
                    tot_death = round(tot_death, digits = 0))
  }
}
