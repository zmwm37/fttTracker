library(shiny)
library(tidyverse)
library(lubridate)
library(ggplot2)

# Define server logic required to draw a histogram
shinyServer(function(input, output) {
        md_cities <- data.frame(name = c("Baltimore", "Frederick", "Rockville", "Gaithersburg", 
                                         "Bowie", "Hagerstown", "Annapolis", "College Park", "Salisbury", "Laurel"),
                                num.rate = c(619493, 66169, 62334, 61045, 55232,
                                        39890, 38880, 30587, 30484, 25346),
                                lat = c(39.2920592, 39.4143921, 39.0840, 39.1434, 39.0068, 39.6418, 38.9784, 38.9897, 38.3607, 39.0993),
                                lng = c(-76.6077852, -77.4204875, -77.1528, -77.2014, -76.7791, -77.7200, -76.4922, -76.9378, -75.5994, -76.8483))
        
        
        output$numRes <- renderValueBox({
                numRes<- 10
                
                valueBox(
                        value = formatC(numRes, digits = 1, format = "f"),
                        subtitle = "Number of Restaurants",
                        icon = icon("area-chart")
                )
        })
        
        output$avgRate <- renderValueBox({
                avgRate<- 7.3
                
                valueBox(
                        value = formatC(avgRate, digits = 1, format = "f"),
                        subtitle = "Number of Restaurants",
                        icon = icon("area-chart")
                )
        })
        
        output$numRate <- renderValueBox({
                numRate<- 25
                
                valueBox(
                        value = formatC(numRate, digits = 1, format = "f"),
                        subtitle = "Number of Ratings",
                        icon = icon("area-chart")
                )
                })
        
        output$restaurantMap <- renderLeaflet({
                md_cities %>%
                        leaflet() %>%
                        addTiles() %>%
                        addCircles(weight = 1, radius = sqrt(md_cities$num.rate) * 30)
        })

        
})
