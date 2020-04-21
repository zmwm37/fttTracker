library(shinythemes)
library(leaflet)

library(shinydashboard)
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
                    title = 'Filters', height = 300
                    )

            )
        )
    )
)
