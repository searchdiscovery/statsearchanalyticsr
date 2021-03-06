% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/get_rankings.R
\name{ssar_rankings}
\alias{ssar_rankings}
\title{Get Rankings}
\usage{
ssar_rankings(
  keywordid = NULL,
  fromdate = NULL,
  todate = NULL,
  start = 0,
  results = 100,
  subdomain = Sys.getenv("SSAR_SUBDOMAIN"),
  apikey = Sys.getenv("SSAR_APIKEY")
)
}
\arguments{
\item{keywordid}{The keyword id (required)}

\item{fromdate}{Default is 100 most recent results (optional) Format is a string YYYY-MM-DD}

\item{todate}{Default is most recent ranking day (optional) Format is a string YYYY-MM-DD}

\item{start}{The default is 0 (zero indexed). The starting result for paginated requests}

\item{results}{The default is 100}

\item{subdomain}{The account subdomain}

\item{apikey}{The api key from the account}
}
\value{
A dataframe of all rankings within a defined date range for a specific keyword
}
\description{
Retrieve a table including metadata for all the sites in a particular project
}
\examples{
\dontrun{
ssar_rankings(keywordid = {keyword_id}, #replace with your keyword_id 
              fromdate = '2021-01-01', 
              todate = '2021-04-01')
}

}
