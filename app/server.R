library(shiny)
library(tidyverse)
library(lubridate)
library(ggplot2)
library(readr)

# load data
urlfile="https://raw.githubusercontent.com/zmwm37/fttTracker/master/data/fttData.csv"

fttFull<-read_csv(url(urlfile))

# Define server logic required to draw a histogram
shinyServer(function(input, output) {

        
        # filter dataset based on 'Filters'
        ftt <- reactive({
                if(input$cat == 'All'){
                        fttFull %>% filter(rating >= input$ratingFilter[1] &
                                                   rating <= input$ratingFilter[2]
                                           )
                } else {
                        fttFull %>% filter(category == input$cat,
                                           rating >= input$ratingFilter[1] &
                                                   rating <= input$ratingFilter[2]
                                           )
                }
        })
        
        # Create summary cards
        output$numRes <- renderValueBox({
                numRes<- length(unique(ftt()$restaurant))
                
                valueBox(
                        value = formatC(numRes, digits = 1, format = "f"),
                        subtitle = "Number of Restaurants",
                        icon = icon('utensils')
                )
        })
        
        output$avgRate <- renderValueBox({
                avgRate<- mean(ftt()$rating)
                
                valueBox(
                        value = formatC(avgRate, digits = 1, format = "f"),
                        subtitle = "Average Rating",
                        icon = icon("star-half-alt")
                )
        })
        
        output$numRate <- renderValueBox({
                numRate<- length(ftt()$rating)
                
                valueBox(
                        value = formatC(numRate, digits = 1, format = "f"),
                        subtitle = "Number of Ratings",
                        icon = icon("user-friends")
                )
                })
        
        # create map
        output$restaurantMap <- renderLeaflet({
                # manipulate data
                fttSum<- ftt() %>% 
                        group_by(restaurant,category, lat, long) %>%
                        summarize(rating.count = n(),
                                  mean.rating = mean(rating))
                
                # map
                fttSum %>%
                        leaflet() %>%
                        addTiles() %>%
                        addCircles(weight = 1,radius = ~rating.count *100, 
                                   popup =  paste(fttSum$restaurant,
                                                 fttSum$category,
                                                 paste("# Ratings:",fttSum$rating.count),
                                                 paste("Avg. Rating:",fttSum$mean.rating),
                                                 sep = "<br/>")
                                   )
        })

        
})
