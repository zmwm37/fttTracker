library(shinythemes)
library(leaflet)
library(shinydashboard)

# load data
urlfile="https://raw.githubusercontent.com/zmwm37/fttTracker/master/data/fttData.csv"

fttFull<-read_csv(url(urlfile))

shinyUI(
    
    dashboardPage(
        dashboardHeader(title = "Food Truck Tuesday Tracker"),
        dashboardSidebar(
            sidebarMenu(
                menuItem("Geo View", tabName = 'geoView')
            )
        ),
        dashboardBody(
            # Boxes need to be put in a row (or column)
            fluidRow(
                valueBoxOutput("numRes"),
                valueBoxOutput("avgRate"),
                valueBoxOutput('numRate')
            ),
            fluidRow(
                box(width = 8, status = 'info',solidHeader = TRUE,
                    title = "Restaurants Reviewed",
                    leafletOutput("restaurantMap", height = 300)
                    ),
                
                # filter selections
                box(width = 4, status = 'info', solidHeader = T,
                    title = 'Filters', height = 300,
                    selectInput('cat',
                                "Filter by Food Category", 
                                c('All',unique(fttFull$category))
                                ),
                    sliderInput('ratingFilter',label = 'Filter by Rating',
                                min = 0, max = 10,value = c(0,10), step = 0.5)
                    )

            )
        )
    )
)
