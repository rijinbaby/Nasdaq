
library(shiny)
library(dplyr)
library(DT)

# Define UI for application that displays stock information
ui <- fluidPage(

    # Application title
    titlePanel(h2("Historical Stock Price Analysis")),

    # Sidebar for input options
    sidebarLayout(
        sidebarPanel(
            width = 3,

            #Setting up input values
            dateInput("start_date1", label = h3("Start Date"), value = Sys.Date()-lubridate::years(10),
                      min = Sys.Date()-lubridate::years(10),max =Sys.Date() ),
            dateInput("end_date1", label = h3("End Date"),
                      min = Sys.Date()-lubridate::years(10),max =Sys.Date() ),
            h6("Note: Change both the date values if the data is not updated"),
            selectInput("stock",label = h3("Stock Symbol"),choices = nasdaq::nasdaq_listed$Symbol,selected = "AAPL"),

            #Action button to view the symbols
            actionButton("view_symbol","View Symbol"),
            DT::dataTableOutput("symbol_table")
        ),

        # Show a plot of the generated distribution
        mainPanel(
            plotly::plotlyOutput("testplot1"),
            # h2("Data"),
            DT::dataTableOutput("mytable"),
        )
    )
)
