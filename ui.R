library(shiny)
require(shinydashboard)
library(ggplot2); library(dplyr)

# Dashboard header
header <- dashboardHeader(title = "Income in Canada")  

# Sidebar content of the dashboard
sidebar <- dashboardSidebar(
        sidebarMenu(
                menuItem("Dashboard", tabName = "dashboard", icon = icon("dashboard"))
        ),
                menuItem("Open Data", icon = icon("send",lib='glyphicon'), 
                          href = "https://open.canada.ca/en/open-data"),
        sliderInput("Insert", "Enter your desired salary", 10000, 130000, value = 50000),
        submitButton("Submit")
)
# Combine the two fluid rows (frow1, frow2) to make the body
frow1 <- fluidRow(
        valueBoxOutput("value1"),
        valueBoxOutput("value2"),
        valueBoxOutput("value3")
)
frow2 <- fluidRow( 
        box(
                title = "Income in Canada per Source - according to 2014 tax year",
                status = "primary",
                solidHeader = TRUE, 
                collapsible = TRUE, 
                plotOutput("incomebyPrd", height = "200px")
        ),
         box(
                title = "Income in Canada per Range - according to 2014 tax year",
                status = "primary",
                solidHeader = TRUE, 
                collapsible = TRUE, 
                plotOutput("incomebyState", height = "200px")
        ) 
)
frow3 <- fluidRow( 
        box(
                title = "State where you can live",
                status = "primary",
                solidHeader = TRUE, 
                collapsible = TRUE, 
                plotOutput("YourState", height = "200px")
        )
)

body <- dashboardBody(frow1, frow2, frow3)
ui <- dashboardPage(title = 'This is my Page title', header, sidebar, body, skin ='red')

# References: Open Data Government of Canada, "Individual statistics by tax filing method",
# record released at 2018-06-27 (downloaded on January 25, 2019)
# https://www150.statcan.gc.ca/t1/tbl1/en/tv.action?pid=1110004601