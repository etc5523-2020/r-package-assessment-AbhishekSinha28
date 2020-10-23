#' Present a stylish table
#' 
#' @description Creates a formatted and styled table to display COVID19 data using the kableExtra package
#'
#' @param data The data set to be formatted
#' @param measure The measure chosen for the heading of the table as a character vector, can be `"cases"` or `"deaths"`
#' @param caption The desired caption for the table entered as a character string.
#' 
#' @return A formatted kable of the original data set entered
#' 
#' @importFrom magrittr %>%
#' 
#' @export
#'
#' 
output_table <- function(data, measure, caption){
  data %>%
    kableExtra::kable(digits = 0,
                      format.args = list(big.mark = ","),
                      caption = caption,
                      format = "html",
                      escape = FALSE) %>%
    kableExtra::kable_styling(bootstrap_options = c("border"))%>%
    kableExtra::scroll_box(height = "500px")
}