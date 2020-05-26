
# stock_view_app() - Shiny ------------------------------------------------

#' Stock Analysis Application
#'
#' @description
#' An user-friendly interactive application for historical stock price analysis.
#' @return Shiny Application
#' @author Rijin Baby
#' @details Default screen shows AAPL data for 10 years. User can change the values on the side panel.
#' @importFrom shiny runApp
#' @export

stock_view_app <- function()
{
  shiny::runApp(system.file("stock_view_application_2",package = "nasdaq"))
}


# stock_view() function -----------------------------------------------------------

#' View Stock Plot
#'
#' @description
#' Function that plot the stock data based on user input. By default the function gives 10 years data for the stock if the start and end dates are not specified
#' @param stock_name a sting that represent the symbol of the Company listed in NASDAQ
#' @param start_date a sting that represent the date; By default 10 years from current date is considered
#' @param end_date a sting that represent the date; Current date is taken as default if no value is provided
#' @return Plot
#' @author Rijin Baby
#' @details
#' The function initially cleans the entered argumets and check their validity. Then update the data file and finally
#' dispalys the data for the analysis
#' @export
#' @importFrom plotly plot_ly layout
#' @importFrom utils View read.csv
#' @importFrom dplyr mutate %>%
#' @importFrom lubridate years

stock_view <- function(stock_name, start_date=Sys.Date()-lubridate::years(10),end_date=Sys.Date())
{
  # basic data cleaning steps
  Date <- Close_Price <- NULL
  stock_name <- toupper(stock_name)
  stock_name <- trimws(gsub("[^A-Z]","",stock_name))

  # Calling the function to check the arguments
  argument_validation(stock_name,start_date,end_date)

  # Calling get_data() function for the file path
  file_location <- get_data(stock_name)

  # reading the data
  Stock_Info <- utils::read.csv(file_location, stringsAsFactors=FALSE)

  column_index <- which(colnames(Stock_Info)=="Close.Last")
  colnames(Stock_Info)[column_index] <- "Close_Price"

  # Removing the $ sign from the data columns
  Stock_Info[,c("Close_Price","Open","High","Low")] <- as.data.frame(apply
                                                                     (Stock_Info[,c("Close_Price","Open","High","Low")],2,
                                                                       FUN = function(y) as.numeric(gsub("\\$","",y))))

  # converting the charater date argument to date
  Stock_Info$Date <- as.Date(Stock_Info$Date,format="%m/%d/%Y")
  #filtering data based on date range
  if(!start_date==Sys.Date()-lubridate::years(10)&!end_date==Sys.Date())
  {
    Stock_Info <- Stock_Info[-which(Stock_Info$Date<start_date|Stock_Info$Date>end_date),]
  }

  # Assigning the line colour based on the trend
  if(Stock_Info$Close_Price[nrow(Stock_Info)]<=Stock_Info$Close_Price[1])trend_color <- "blue"
  else trend_color <- "red"

  # plotting the data
  plotly::plot_ly(Stock_Info, x = ~Date, y = ~Close_Price, type = 'scatter', mode = 'lines',color = I(trend_color)) %>%
    plotly::layout(title =paste0(nasdaq::nasdaq_listed$Security_Name[which(stock_name==nasdaq::nasdaq_listed$Symbol)]," (",stock_name,")"))
}


# stock_details() function -----------------------------------------------------------

#' Return Stock Data
#'
#' @description
#' Function that return stock data based on the user inputs. The shiny app uses this function to get the data.
#' By default the function gives 10 years data for the stock if the start and end dates are not specified
#' @param stock_name a sting that represent the symbol of the Company listed in NASDAQ
#' @param start_date a sting that represent the date; By default 10 years from current date is considered
#' @param end_date a sting that represent the date; Current date is taken as default if no value is provided
#' @return Stock Data Table
#' @author Rijin Baby
#' @details
#' The function initially cleans the entered argumets and check their validity. Then update the data file and finally
#' return the data table
#' @export
#' @seealso \code{read.csv} \code{View}
#' @importFrom utils View read.csv
#' @importFrom dplyr mutate %>%
#' @importFrom lubridate years

stock_details <- function(stock_name, start_date=Sys.Date()-lubridate::years(10),end_date=Sys.Date())
{
  # Value initialization
  Date <- Close_Price <- NULL
  stock_name <- toupper(stock_name)
  stock_name <- trimws(gsub("[^A-Z]","",stock_name))

  # Calling the function to check the arguments
  argument_validation(stock_name,start_date,end_date)

  # Calling get_data() function for the file path
  file_location <- get_data(stock_name)

  # reading the data
  Stock_Info <- utils::read.csv(file_location, stringsAsFactors=FALSE)

  column_index <- which(colnames(Stock_Info)=="Close.Last")
  colnames(Stock_Info)[column_index] <- "Close_Price"

  # Removing the $ sign from the data columns
  Stock_Info[,c("Close_Price","Open","High","Low")] <- as.data.frame(apply
                                                                     (Stock_Info[,c("Close_Price","Open","High","Low")],2,
                                                                       FUN = function(y) as.numeric(gsub("\\$","",y))))

  # converting the charater date argument to date
  Stock_Info$Date <- as.Date(Stock_Info$Date,format="%m/%d/%Y")
  #filtering data based on date range
  if(!start_date==Sys.Date()-lubridate::years(10)&!end_date==Sys.Date())
  {
    Stock_Info <- Stock_Info[-which(Stock_Info$Date<start_date|Stock_Info$Date>end_date),]
  }
  return(Stock_Info)
}

# get_data() function --------------------------------------------------------------

#' Download Data from NASDAQ website
#'
#' @description
#' Check if the data already exist in the directory else download and return the file path
#' Function that search and download the data file
#' @param stock_name a string that represent the symbol of the Company listed in NASDAQ
#' @return temporary file path of the csv file
#' @author Rijin Baby
#' @details
#' This function download the stock data fro the NASDAQ website to a temporary directory in the system
#' and return the file path for better memory management.
#' @export
#' @seealso \code{download.file}
#' @importFrom utils download.file
#' @importFrom lubridate years

get_data <- function(stock_name)
{
  # Construct web URL
  src_website <- paste0("https://www.nasdaq.com/api/v1/historical/",stock_name,"/stocks/",Sys.Date()-years(10),"/",Sys.Date())

  # Construct path for storing local file temporarily
  file_location <- tempfile(stock_name,fileext = ".csv")

  # Don't download if the file is already there!
  if(!file.exists(file_location))
    utils::download.file(src_website, file_location, quiet = TRUE)

  # Checking if the file has data or not
  file_check<-readLines(file_location)
  ifelse(file_check==""&length(file_check)==1,stop("NO DATA FOUND ON THE WEBSITE, KINDLY MODIFY THE INPUT DATE"),
         return(file_location))
}

# argument_validation() function -----------------------------------------------------

#' Check Arguments
#'
#' @description
#' Function that checks the format of stock name and date to get data from NASDAQ website
#' @param stock_name a sting that represent the symbol of the Company listed in NASDAQ
#' @param start_date a sting that represent the date
#' @param end_date a sting that represent the date
#' @return TRUE if all the arguments are perfect else terminates the process
#' @author Rijin Baby
#' @details
#' This function checks validity of stock name and if the date value entered is in the YYYY-MM-DD format
#' @export

argument_validation <- function(stock_name, start_date,end_date)
{
  if(!(stock_name %in% nasdaq::nasdaq_listed$Symbol))    #Checks stock Name
  {
    stop("Check Stock Name; Refer nasdaq_listed dataset")
  }

  if(!IsDate(start_date)|!IsDate(end_date))   #Checks date fornat
  {
    stop("Check Date Format")
  }

  if((start_date)>=(end_date)|(start_date)<(Sys.Date()-lubridate::years(10))|
     (end_date)>Sys.Date())   #Checks date fornat
  {
    stop("Check Dates")
  }
}

# IsDate() function -----------------------------------------------------------------

#' Check Date
#'
#' @description
#' Function that checks the date format
#' @param mydate a sting that represent the date
#' @param date.format explicitly specifying the date format
#' @return boolean value depending on the mydate value passed as argument
#' @details
#' This function checks if the date value entered is in the YYYY-MM-DD format
#' @export

IsDate <- function(mydate, date.format = "%Y-%m-%d")
{
  tryCatch(!is.na(as.Date(mydate, date.format)), error = function(err) {FALSE})
}
