#' Launch the shiny application for USA COVID19 data exploration
#' 
#' @export

launch_app <- function(){
  shiny::runApp(system.file("app", "app.R", package = "Covid19US"))
}
