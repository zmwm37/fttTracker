library(shiny)
library(tidyverse)
library(lubridate)
library(ggplot2)

fftFull <- read.csv('../data/fftData.csv', stringsAsFactors = F)

# Define server logic required to draw a histogram
shinyServer(function(input, output) {
        
        fft <- reactive({
                if(input$cat == 'All'){
                        fftFull %>% filter(rating >= input$ratingFilter[1] &
                                                   rating <= input$ratingFilter[2]
                                           )
                } else {
                        fftFull %>% filter(category == input$cat,
                                           rating >= input$ratingFilter[1] &
                                                   rating <= input$ratingFilter[2]
                                           )
                }
        })
        
        output$numRes <- renderValueBox({
                numRes<- length(unique(fft()$restaurant))
                
                valueBox(
                        value = formatC(numRes, digits = 1, format = "f"),
                        subtitle = "Number of Restaurants",
                        icon = icon('utensils')
                )
        })
        
        output$avgRate <- renderValueBox({
                avgRate<- mean(fft()$rating)
                
                valueBox(
                        value = formatC(avgRate, digits = 1, format = "f"),
                        subtitle = "Average Rating",
                        icon = icon("star-half-alt")
                )
        })
        
        output$numRate <- renderValueBox({
                numRate<- length(fft()$rating)
                
                valueBox(
                        value = formatC(numRate, digits = 1, format = "f"),
                        subtitle = "Number of Ratings",
                        icon = icon("user-friends")
                )
                })
        
        output$restaurantMap <- renderLeaflet({
                fftSum<- fft() %>% 
                        group_by(restaurant,category, lat, long) %>%
                        summarize(rating.count = n(),
                                  mean.rating = mean(rating))
                
                fftSum %>%
                        leaflet() %>%
                        addTiles() %>%
                        addCircles(weight = 1,radius = ~rating.count *100, 
                                   popup =  paste(fftSum$restaurant,
                                                 fftSum$category,
                                                 paste("# Ratings:",fftSum$rating.count),
                                                 paste("Avg. Rating:",fftSum$mean.rating),
                                                 sep = "<br/>")
                                   )
        })

        
})
