library(Covid19Aus)
library(shiny)
library(tidyverse)
library(plotly)
library(leaflet)
library(dplyr)
library(ggplot2)
library(lubridate)
library(kableExtra)

#data <- read.csv("data/data_raw.csv", row.names = 1)
#data$date <- as.Date(data$date)

data <- Covid19Aus::aus_covid_data 

state_pop <-tibble(
  province = c("New South Wales", "Victoria", "Queensland", "South Australia", "Western Australia", "Tasmania", "Northern Territory", "Australian Capital Territory"),
  pop = c(8089526,6594804,5095100,1751693,2621680,426709,245869,420379))

oz_covid19_state <- inner_join(data, state_pop, by = c("province"))

oz_covid19_state <- oz_covid19_state %>% 
  mutate(month = month(date, label = TRUE))


ui <- fluidPage(
  
  titlePanel("Analyzing Covid-19 in Australia"),
  
  mainPanel(
    tabsetPanel(type = "tabs",
                tabPanel("How to Begin", textOutput("text4"), textOutput("text5"), textOutput("text6"),textOutput("text7")),
                tabPanel("Covid Confirmed Cases across states", selectInput("var1", "State", 
                                                                                                          choices = data$province,
                                                                                                          selected = "Select", width = "200%"),
                         plotlyOutput("line_plot_first")), 
                tabPanel("Covid Deaths across states", selectInput("var2", "State", 
                                                                                                  choices = data$province,
                                                                                                  selected = "Select", width = "200%"),
                         plotlyOutput("line_plot")),
                tabPanel("Recovery Rate across states", selectInput("var3", "State", choices = oz_covid19_state$province,
                                                                                    selected = "Select", width = "200%"),
                         tableOutput("mytable")),
                tabPanel("About", textOutput("text1"), textOutput("text2"), textOutput("text3"))
  )
  
)
)


server <- function(input, output, session) {
  
  output$line_plot_first <-renderPlotly({
    p1 <- data %>%
      filter(province == input$var1) %>%
      group_by(type,date) %>%
      summarise(total_cases = sum(cases)) %>%
      pivot_wider(names_from = type, 
                  values_from = total_cases) %>%
      ggplot(aes(x = date, y = confirmed) ) +
      geom_line(color = "red") +
      labs(x = "Date", y = "Confirmed Cases", title = input$var1) 
    ggplotly(p1, height = 400, width = 800)
  })
  
  output$line_plot <-renderPlotly({
    p2 <- data %>%
      filter(province == input$var2) %>%
      group_by(type,date) %>%
      summarise(total_cases = sum(cases)) %>%
      pivot_wider(names_from = type, 
                  values_from = total_cases) %>%
      ggplot(aes(x = date, y = death) ) +
      geom_line(color = "red") +
      labs(x = "Date", y = "Deaths", title = input$var2) 
    ggplotly(p2, height = 400, width = 800)
  })
  
  output$mytable <-function()({
    oz_covid19_state %>%
      filter(province == input$var3) %>%
      group_by(type,month,pop) %>%
      summarise(total_cases = sum(cases)) %>%
      pivot_wider(names_from = type, 
                  values_from = total_cases) %>%
      mutate(active = confirmed - death - recovered) %>%
      mutate(active_total = cumsum(active)) %>%
      mutate(confirmed_rates = ((10000*confirmed/pop)),
             active_rates = ((10000*active_total/pop)),
             recovered_rates = ((10000*recovered/pop)),
             dead_rates = ((10000*death/pop))) %>% 
      select(-c(2:7)) %>% 
      pivot_longer(2:5, 
                   names_to = "type", 
                   values_to = "rate") %>% 
      mutate(rate = round(rate,4)) %>% 
      pivot_wider(names_from = month, 
                  values_from = rate) %>% 
      knitr::kable(caption = "Covid Cases Rate") %>% 
      kable_styling(bootstrap_options = 
                      c("striped", "condensed"), 
                    full_width = F, 
                    position = "center",
                    latex_options = c("hold_position")) 
  })
  
  output$text1 <- renderText({
    "My name is Abhishek Sinha. I am a Masters student at Monash University majoring in Business Analytics."
  })
  
  output$text2 <- renderText({
    "This app provides an updated analysis of the Coronavirus pandemic in Australia, one of the few countries that manage to bend the curve of new cases."
  })
  
  output$text3 <- renderText({
    "The app allows user to interact with the plots through user inputs to analyze and compare the factors like confirmed cases, deaths and recovery rate across the states in Australia overtime."
  })
  
  output$text4 <- renderText({
    "This tab will help you to understand the flow of the corresponding tabs and interpret the results.\n"  
  })
  
  output$text5 <- renderText({
    "First analysis tab is 'Covid Confirmed Cases across states' which analyses the number of confirmed covid cases across 
    different states in Australia. The user can choose the state of choice through the drop down menu. The successive plots
    allows the user to analyse the trend of confirmed cases of covid in different states overtime. Looking at the plots for 
    state like Victoria we can notice how the situation unfolded where a state performing so well became the epicenter of the
    new cases.\n"  
  })
  
  output$text6 <- renderText({
    "Second analysis tab is 'Covid Deaths across states' which analyses the number of deaths across 
    different states in Australia. The user can choose the state of choice through the drop down menu. The successive plots
    allows the user to analyse the trend of deaths reported in different states overtime. Looking at the plots for 
    states like New South Wales and Victoria we can notice the stark contrast in the handling of the pandemic. 
    New South Wales initially struggled to limit the deaths by the virus but with strict lock down measures managed to bring
    down the rate to near zero. Victoria on the other hand enjoyed a relatively calm initial months of the outbreak but 
    suddenly saw the new cases and deaths sky rocket beginning July.\n"  
  })
  
  output$text7 <- renderText({
    "Third analysis tab is 'Recovery Rate across states' which describes the rates of recovered cases, active cases across 
    different states in Australia. The user can choose the state of choice through the drop down menu. This table gives us an
    overview of how the situation changed in Australia from the time of the first case in January. We can notice that the rate 
    of the confirmed cases increased drastically in July in Victoria representing the second wave which also saw the highest 
    death rate anywhere in Australia. It is then when Victoria implemented strict lock down as a measure to contain the spread 
    of virus and thus we can see a decline in new cases. We can also notice that apart from Metropolitan states like Victoria
    and New South Wales, the rest of Australia has done well. We can notice that Queensland, the third most populated state
    in Australia performed exceptionally well in controlling the spread of the virus and keeping new cases almost to zero."
  })
}

shinyApp(ui, server)
