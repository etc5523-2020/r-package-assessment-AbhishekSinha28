#' Compare two states
#' 
#' @description This function is used in the shiny application to provide two random state names each time it is loaded for the default values.
#' 
#' @param data The data set to be sampled from.
#'
#' @return A collection of two state names returned from the a data set.
#' 
#' @export
#'
#' @examples
#' states_random(aus_covid_data)
#' 
states_random <- function(data){
  states <- unique(data$province)
  sample(states, 2)
}