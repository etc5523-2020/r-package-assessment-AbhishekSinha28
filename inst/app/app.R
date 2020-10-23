library(Covid19US)
library(shiny)
library(dplyr)
library(tidyr)
library(ggplot2)
library(maps)
library(readxl)
library(lubridate)
library(scales)
library(plotly)
library(kableExtra)
library(mapproj)

# data import --------------------------------------------------
# us_covid <- read_csv("data/United_States_COVID-19_Cases_and_Deaths_by_State_over_Time.csv")
# us_names <- read_csv("data/csvData.csv")

# data wrangling -----------------------------------------------
us_covid_clean <- covid19usa::usa_covid_data 

mapdata <- covid19usa::usa_state_map

us_cases <- us_covid_clean %>%
    select(date,
           state,
           tot_cases) %>%
    filter(date >= min(date) & date <=max(date))

avg_cases <-
    us_cases %>%
    group_by(date) %>%
    summarise(tot_cases = mean(tot_cases)) %>%
    mutate(state = "average")

us_deaths <- us_covid_clean %>%
    select(date,
           state,
           tot_death) %>%
    filter(date >= min(date) & date <=max(date))

avg_deaths <-
    us_deaths %>%
    group_by(date) %>%
    summarise(tot_death = mean(tot_death)) %>%
    mutate(state = "average")



# ui -----------------------------------------------------------
ui <- fluidPage(
    
    
    titlePanel(h1("USA COVID19 Data")),
    sidebarLayout(
        sidebarPanel(
            h3("About"),
            helpText("This application was created as part of the Shiny Assessment for ETC5523, Semester 2 by Lachlan Thomas Moody. The purpose of this application is to allow users to explore COVID-19 related data in the continental United States of America to compare the volume of cases and deaths recorded by each of the states in the country. This is done to gain a better understanding of the virus and where it is localised within the country."),
            h3("Control Panel"),
            br(),
            create_input("measure"),
            helpText("The above control can be used to adjust the output of all of the visualisations in the  application. Selecting the option 'Total Cases' will display data relating to the total amount of COID19 cases in the USA on a state-by-state basis. Whereas 'Total Deaths' will display the same data relating to the number of total deaths."),
            br(),
            create_input("state", usa_state_map),
            helpText("The control above can be used to bring up temporal changes for each state using the currently selected measure, both in a time series plot and an accompanying table. This input can be changed by either clicking the box above and selecting states from the dropdown menu that appears, or by double-clicking on the desired state in the adjacent map. To remove a state, simply click on the name in the box above and press backspace or delete. Note that more than one state may be selected for comparison."),
            br(),
            create_input("date", usa_covid_data),
            helpText("The final control filters the time period displayed in the time series plot and table output should a specific time frame be of interest. This can be done by dragging either end of the slider to set a minimum and maximum date. Any dates included in the orignal data set may be selected."),
            width = 2
            
        ),
        mainPanel(
            h2("Impact of COVID19 by state in the USA"),
            helpText("The map below displays the geographic distribution of COVID19 in the USA, measuring both the 'Total Cases' and 'Total Deaths', depending on which is selected from the Control Panel to the left. The darker shades of red indicate a higher count of that measure in each state. Users can also hover over each state for additional information. This is useful for comparing data across states and regional areas in the USA. For example, Texas in the South and California in the West are faring a lot worse than their neighbouring states for 'Total Cases', while there seems to be a steady concentration and dispersion of cases in the North-West. Note that the data presented comes from the latest available date from the time of download, the 28th of September 2020"),
            br(),
            plotlyOutput("testplot", height = "600px", width = "1200px"),
            h2("Impact of COVID19 over time in the USA"),
            helpText("The plot and accompanying data table add a temporal element to the spread of COVID19 in the country. Any number of states can be selected in the Control Panel or by double-clicking on the map to compare the change in COVID19 overtime between states and to the average. For example, if Texas and California are selected, it can be seen that the two states have shared a similar progression in 'Total Cases' with a increase in the rate of infection beginning in late June, both far surpassing the national average. Additionally, the time frame displayed can also be altered in the Control Panel."),
            splitLayout(plotlyOutput("myplot", height = "500px", width = "800px"),
                        tableOutput("mykable"),
                        cellArgs = list(style = "padding: 5px"),
                        cellWidths = c("60%", "40%"))
        )
    ),
    includeCSS("styles.css")
)

# server -------------------------------------------------------
server <- function(input, output, session) {
    
    
    
    output$myplot <-
        renderPlotly({
            if(input$measure == "Total Cases") {
                us_cases <- us_covid_clean %>%
                    select(date,
                           state,
                           tot_cases) %>%
                    filter(date >= input$date[1] & date <= input$date[2])
                
                avg_cases <- average_measure(us_cases, "tot_cases")
                
                timeseries <- bind_rows(us_cases, avg_cases)
                
                plot <- timeseries %>%
                    filter(state == paste(tolower(input$state)) | state == "average") %>%
                    ggplot(aes(x = date,
                               y = tot_cases,
                               colour = toupper(state))) +
                    geom_line(size = 1) +
                    scale_color_brewer(palette = "Pastel1") +
                    scale_y_continuous(labels = comma) +
                    labs(title = "Change in Cases Over Time",
                         x = "",
                         y = "Cases",
                         colour = "") +
                    theme(text = element_text(size = 16, color = "white"),
                          panel.background = element_rect(fill = "black"),
                          rect = element_rect(fill = "black"),
                          panel.grid.major = element_blank(), panel.grid.minor = element_blank(),
                          legend.key = element_rect(fill = "black"),
                          axis.line = element_line(color = "white"),
                          axis.text = element_text(color = "white"),
                          axis.ticks = element_line(color = "white"))
                
                ggplotly(plot,
                         tooltip = c("date", "tot_cases")) %>%
                    config(displayModeBar = FALSE) }
            
            else if(input$measure == "Total Deaths"){
                us_deaths <- us_covid_clean %>%
                    select(date,
                           state,
                           tot_death) %>%
                    filter(date >= input$date[1] & date <= input$date[2])
                
                avg_deaths <- average_measure(us_deaths, "tot_death")
                
                timeseries <- bind_rows(us_deaths, avg_deaths)
                
                plot <- timeseries %>%
                    filter(state == paste(tolower(input$state)) | state == "average") %>%
                    ggplot(aes(x = date,
                               y = tot_death,
                               colour = toupper(state))) +
                    geom_line(size = 1) +
                    scale_color_brewer(palette = "Pastel1") +
                    scale_y_continuous(labels = comma) +
                    labs(title = "Change in Deaths Over Time",
                         x = "",
                         y = "Deaths",
                         colour = "") +
                    theme(text = element_text(size = 16, color = "white"),
                          panel.background = element_rect(fill = "black"),
                          rect = element_rect(fill = "black"),
                          panel.grid.major = element_blank(), panel.grid.minor = element_blank(),
                          legend.key = element_rect(fill = "black"),
                          axis.line = element_line(color = "white"),
                          axis.text = element_text(color = "white"),
                          axis.ticks = element_line(color = "white"))
                
                ggplotly(plot,
                         tooltip = c("date", "tot_death")) %>%
                    config(displayModeBar = FALSE)
            }
        })
    
    output$mykable <- function() {
        if(input$measure == "Total Cases") {
            state_cases <- us_cases %>%
                filter(state %in% paste(tolower(input$state))) %>%
                mutate(state = toupper(state)) %>%
                tidyr::pivot_wider(names_from = state, values_from = tot_cases)
            
            national_cases <- avg_cases %>%
                tidyr::pivot_wider(names_from = state, values_from = tot_cases)
            
            combined <- left_join(state_cases, national_cases) %>%
                rename(DATE = date,
                       AVERAGE = average) %>%
                filter(DATE >= input$date[1] & DATE <= input$date[2])
            
            present_table(combined, "cases", paste("State cases compared to national average"))}
        
        else if(input$measure == "Total Deaths"){
            state_deaths <- us_deaths %>%
                filter(state %in% paste(tolower(input$state))) %>%
                mutate(state = toupper(state)) %>%
                tidyr::pivot_wider(names_from = state, values_from = tot_death)
            
            national_deaths <- avg_deaths %>%
                tidyr::pivot_wider(names_from = state, values_from = tot_death)
            
            combined <- left_join(state_deaths, national_deaths) %>%
                rename(DATE = date,
                       AVERAGE = average) %>%
                filter(DATE >= input$date[1] & DATE <= input$date[2])
            
            present_table(combined, "deaths", paste("State deaths compared to national average"))
        }
    }
    
    output$testplot <-
        renderPlotly({
            options(scipen = 9999)
            if(input$measure == "Total Cases") {
                case_data <- us_covid_clean %>%
                    group_by(state) %>%
                    filter(tot_cases == max(tot_cases))
                
                case_map_data <- left_join(mapdata, case_data, by = c("region" = "state"))
                
                case_map <- ggplot() +
                    geom_polygon(data = case_map_data,
                                 aes(fill = tot_cases,
                                     x = long,
                                     y = lat,
                                     group = group,
                                     text = paste(toupper(region), "<br>",
                                                  "Total Cases:", format(tot_cases, big.mark = ",")))) +
                    theme_void() +
                    coord_map() +
                    labs(fill = "Total Cases") +
                    scale_fill_distiller(palette = "Reds", direction = 1, label = comma) +
                    theme(panel.background = element_rect(fill = "black"),
                          plot.background = element_rect(fill = "black"),
                          text = element_text(color = "white", size = 16),
                          axis.line = element_line(color = "black"),
                          panel.grid.major = element_blank(), panel.grid.minor = element_blank()) +
                    ggtitle("Total COVID19 Cases by State")
                
                ggplotly(case_map,
                         tooltip = "text")%>%
                    config(displayModeBar = FALSE)}
            
            else if(input$measure == "Total Deaths") {
                death_data <- us_covid_clean %>%
                    group_by(state) %>%
                    filter(tot_death == max(tot_death))
                
                death_map_data <- left_join(mapdata, death_data, by = c("region" = "state"))
                
                death_map <- ggplot() +
                    geom_polygon(data = death_map_data,
                                 aes(fill = tot_death,
                                     x = long,
                                     y = lat,
                                     group = group,
                                     text = paste(toupper(region), "<br>",
                                                  "Total Deaths:", format(tot_death, big.mark = ",")))) +
                    theme_void() +
                    coord_map() +
                    labs(fill = "Total Deaths") +
                    scale_fill_distiller(palette = "Reds", direction = 1, label = comma)+
                    theme(panel.background = element_rect(fill = "black"),
                          plot.background = element_rect(fill = "black"),
                          text = element_text(color = "white", size = 16),
                          axis.line = element_line(color = "black"),
                          panel.grid.major = element_blank(), panel.grid.minor = element_blank()) +
                    ggtitle("Total COVID19 Deaths by State")
                
                ggplotly(death_map,
                         tooltip = "text")%>%
                    config(displayModeBar = FALSE)}
        })
    
}

# run ----------------------------------------------------------
shinyApp(ui = ui, server = server)
