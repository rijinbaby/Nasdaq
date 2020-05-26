

# Dataset -----------------------------------------------------------------

#' Dataset with detailes of the NASDAQ listed companies
#' @usage nasdaq_listed
#' @format
#'  \describe{
#' \item{Symbol}{The one to four or five character identifier for each NASDAQ-listed security}
#' \item{Security_Name}{Company issuing the security}
#' \item{Market_Category}{The category assigned to the issue by NASDAQ based on Listing Requirements\cr
#' Values:\cr
#' Q = NASDAQ Global Select MarketSM\cr
#' G = NASDAQ Global MarketSM\cr
#' S = NASDAQ Capital Market}
#' \item{Test_Issue}{Indicates whether or not the security is a test security\cr
#' Values:\cr
#' Y = yes, it is a test issue\cr
#' N = no, it is not a test issue.}
#' \item{Financial_Status}{Indicates when an issuer has failed to submit its regulatory filings on a timely basis, has failed to meet NASDAQ's continuing listing standards, and/or has filed for bankruptcy.\cr
#' Values include:\cr
#' D = Deficient: Issuer Failed to Meet NASDAQ Continued Listing Requirements\cr
#' E = Delinquent: Issuer Missed Regulatory Filing Deadline\cr
#' Q = Bankrupt: Issuer Has Filed for Bankruptcy\cr
#' N = Normal (Default): Issuer Is NOT Deficient, Delinquent, or Bankrupt.\cr
#' G = Deficient and Bankrupt\cr
#' H = Deficient and Delinquent\cr
#' J = Delinquent and Bankrupt\cr
#' K = Deficient, Delinquent, and Bankrupt}
#' \item{ETF}{Identifies whether the security is an exchange traded fund (ETF).\cr
#' Possible values:\cr
#' Y = Yes, security is an ETF\cr
#' N = No, security is not an ETF\cr
#' For new ETFs added to the file, the ETF field for the record will be updated to a value of "Y".}
#' }
#' @note Data as of 30 January 2020
#' @source http://www.nasdaqtrader.com/trader.aspx?id=symboldirdefs
"nasdaq_listed"

