#' Create inputs for the shiny application
#' 
#' @description Create chosen shiny inputs for the different variables contained in a data set.
#'
#' @param input The variable chosen for the input as a character vector. Can be `"measure"`, `"state"`, or `"date"`.
#' @param data The data set for the input to be drawn from. Can be `aus_covid_data`.
#'
#' @return A shiny control widget used to specify inputs for the visualizations in the application
#' 
#' @export
#'
#' 
select_input <- function(input, data){
  if(input == "measure"){
    shiny::radioButtons("measure",
                        "Select Measure",
                        choices = c("Total Cases", "Total Deaths"),
                        selected = "Total Cases")
  } else if(input == "state"){
    shiny::selectizeInput("state",
                          "Select State",
                          choices = unique(data$province),
                          selected = c(states_random(data)),
                          multiple = TRUE)
  } else if(input == "date"){
    shiny::sliderInput("date",
                       "Select Date",
                       min = min(data$date),
                       max = max(data$date),
                       value = c(min(data$date),max(data$date)))
  }
}