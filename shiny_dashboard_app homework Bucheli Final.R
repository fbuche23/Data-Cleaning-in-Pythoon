# Load required libraries
#install.packages("DT")
library(shiny)
library(shinydashboard)
library(leaflet)
library(DBI)
library(odbc)
library(DT)

#install.packages('rsconnect')
#rsconnect::setAccountInfo(name='fbucheli', token='32E4CB5C3AE6AC15057F96E763B41270', secret='5OXpYaw6Z+LrXaSX6JOZq/UrJo9RapJWa/4MJD9n')
#library(rsconnect)
#rsconnect::deployApp('path/to/your/app')

# Read database credentials
# source("./03_shiny_HW1/credentials_v3.R")
source("./credentials_v4.R")

r_colors <- rgb(t(col2rgb(colors()) / 255))
names(r_colors) <- colors()

ui <- dashboardPage(
  dashboardHeader(title = "ITOM6265-HW1"),
  #Sidebar content
  dashboardSidebar(
    #Add sidebar menus here
    sidebarMenu(
      menuItem("HW Summary", tabName = "HWSummary", icon = icon("dashboard")),
      menuItem("Q1-DB Query", tabName = "dbquery", icon = icon("dashboard")),
      menuItem("Q2-Maps", tabName = "leaflet", icon = icon("th"))
    )
  ),
  dashboardBody(
    tabItems(
      # Add contents for first tab
      tabItem(tabName = "HWSummary",
              h3("This HW was submitted by Felipe Bucheli of ITOM6265"),
              p("This is my first shiny app using R studio. By using the DBquery tab, you will be able to search for a name of a restaurant based on the range and name! Click the button below it to find the results then on the second tab you can display the map with the location")
      ),
      # Add contents for second tab
      tabItem(tabName = "dbquery",
              textInput("text", label = h3("Pattern of Name"), value = ""),
              sliderInput("slider2", label = h3("Slider Range"), min = 0, 
                          max = 1500, value = c(450, 850)),
              h3("Range of votes to search for:"),
              actionButton("action", label = "Get Results"),
              DT::dataTableOutput("mytable")
              ),
      #  Add contents for third tab
      tabItem(tabName = "leaflet", 
              fluidPage(
              actionButton("recalc", "Display Map"),
              h3("Map of restaurants in London. Click on teardrop to check names."),
              leafletOutput("mymap"),
              p()
    ))
  )
),
skin = "red")

server <- function(input, output) {
  
  #Develop your server side code (Model) here
  observeEvent(input$action, {
    # open DB connection
    db <- dbConnector(
      server   = getOption("database_server"),
      database = getOption("database_name"),
      uid      = getOption("database_userid"),
      pwd      = getOption("database_password"),
      port     = getOption("database_port")
    )
    on.exit(dbDisconnect(db), add = TRUE)
    
    #browser()
    
    query <- paste0("SELECT name, city, Votes FROM zomato_rest WHERE Votes >=", input$slider2[1], " AND votes <=", input$slider2[2], " and name LIKE '%",input$text,"%';")
    print(query)
    data <- dbGetQuery(db, query)
    output$mytable <- DT::renderDataTable({
      data
    })
  })
   #Develop your server side code (Model) here
  observeEvent(input$recalc, {
    # open DB connection
    db <- dbConnector(
      server   = getOption("database_server"),
      database = getOption("database_name"),
      uid      = getOption("database_userid"),
      pwd      = getOption("database_password"),
      port     = getOption("database_port")
    )
    on.exit(dbDisconnect(db), add = TRUE)
    
    #browser()
    
    query2 <- paste("select Longitude, name, latitude from zomato_rest where Longitude is not NULL and Latitude is not NULL")
    print(query2)
    
    data2 <- dbGetQuery(db, query2)
    #View(data2)
    
    output$mymap <- renderLeaflet({
      leaflet() %>%
        addProviderTiles(providers$Stamen.TonerLite,
                         options = providerTileOptions(noWrap = TRUE)
        ) %>%
        addAwesomeMarkers(data =data2, lat=~latitude, lng=~Longitude, popup=~name)
    })
  
  })
} 


 

shinyApp(ui, server)

