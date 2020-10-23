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
#' random_states(usa_state_map)
#' 
random_states <- function(data){
  states <- unique(data$region)
  sample(states, 2)
}