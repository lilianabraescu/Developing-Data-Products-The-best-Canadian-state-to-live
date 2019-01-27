library(shiny)
require(shinydashboard)
library(ggplot2); library(dplyr)

server <- function(input, output) { 
        
        # Some data manipulation to derive the values of KPI boxes 
        income <- read.csv("Income_Canada_2014.csv")
        total.income <- sum(income$Number.Tax.Fillers)
        range.income <- income %>% group_by(Income.Range) %>% summarise(value = sum(Number.Tax.Fillers)) %>% filter(value == max(value))
        prof.prod <- income %>% group_by(Source.Income) %>% summarise(value = sum(Number.Tax.Fillers)) %>% filter(value == max(value))
        
        dataInput <- reactive({
                incomeInput <- input$Insert
        })
        
        # Creating the valueBoxOutput content
        output$value1 <- renderValueBox({
                valueBox(
                        formatC(range.income$value, format = "d", big.mark = ','),
                        paste('Top Income Range:', range.income$Income.Range),
                        icon = icon("usd", lib = 'glyphicon'),
                        color = "purple")  
        })
       
         output$value2 <- renderValueBox({ 
                valueBox(
                        formatC(total.income, format = "d", big.mark = ','),
                        'Total Number of Tax Filers',
                        icon = icon("user", lib = 'glyphicon'),
                        color = "green")  
        })
        
         output$value3 <- renderValueBox({
                valueBox(
                        formatC(prof.prod$value, format = "d", big.mark =','),
                        paste('Predicted Income:', prof.prod$Source.Income),
                        icon = icon("menu-hamburger", lib = 'glyphicon'),
                        color = "yellow")   
        })
         
        # Creating the plotOutput content
        output$incomebyPrd <- renderPlot({
                ggplot(data = income, 
                       aes(x = Source.Income, y = Number.Tax.Fillers, fill = factor(State))) + 
                        geom_bar(position = "dodge", stat = "identity") + ylab("Number of Tax Filers") + 
                        xlab("Source Income") + theme(legend.position = "bottom", 
                                                plot.title = element_text(size = 15, face = "bold")) + 
                        ggtitle("Income per Source") + labs(fill = "State")
        })
        output$incomebyState <- renderPlot({
                ggplot(data = income, 
                       aes(x = Income.Range, y = Number.Tax.Fillers, fill = factor(State))) + 
                        geom_bar(position = "dodge", stat = "identity") + ylab("Number of Tax Filers") + 
                        xlab("Income Range") + theme(legend.position="bottom", 
                                                plot.title = element_text(size=15, face = "bold")) + 
                        ggtitle("Income per Range") + labs(fill = "State")
        })
        
        # Creating the plotOutput for Search State to live
        output$YourState <- renderPlot({
                incomeInput <- input$Insert
                        newdata = filter(income, Average.Income > incomeInput)
                ggplot(newdata, aes(x = State, y = Number.Tax.Fillers, fill = factor(State))) + 
                        geom_bar(position = "dodge", stat = "identity") + ylab("Number of Tax Filers") + 
                        xlab("State") + theme(legend.position="bottom", 
                                                    plot.title = element_text(size=15, face = "bold")) + 
                       ggtitle("Income average larger than your desired salary") + labs(fill = "State")
                
         })
}
