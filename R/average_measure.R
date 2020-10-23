#' Create a summary COVID19 data set for the entire USA
#' 
#' @description Create new data set comprising average daily counts for each different `measure` of COVID19 in the USA.
#'
#' @param data A data set to be summarised
#' @param measure The variable to summarise the data on, can be as a character vector. Can be `"tot_cases"` or `"tot_death`.
#'
#' @return A summarised data set comprising 251 observations (one for each day) and 3 variables dependent on what `measure` is chosen.
#' 
#' @export
#'
#' @examples
#' average_measure(usa_covid_data, "tot_cases")
#' average_measure(usa_covid_data, "tot_death")
#' 
average_measure <- function(data, measure){
  if(measure == "tot_cases"){
    data %>%
      dplyr::group_by(date) %>%
      dplyr::summarise(tot_cases = mean(tot_cases)) %>%
      dplyr::mutate(state = "average",
                    tot_cases = round(tot_cases, digits = 0))
  } else if(measure == "tot_death"){
    data %>%
      dplyr::group_by(date) %>%
      dplyr::summarise(tot_death = mean(tot_death)) %>%
      dplyr::mutate(state = "average",
                    tot_death = round(tot_death, digits = 0))
  }
}
