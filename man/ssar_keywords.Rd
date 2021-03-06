% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/get_keywords.R
\name{ssar_keywords}
\alias{ssar_keywords}
\title{Get Keywords}
\usage{
ssar_keywords(
  siteid = NULL,
  start = 0,
  results = 100,
  subdomain = Sys.getenv("SSAR_SUBDOMAIN"),
  apikey = Sys.getenv("SSAR_APIKEY")
)
}
\arguments{
\item{siteid}{The site id (required)}

\item{start}{The default is 0 (zero indexed)}

\item{results}{The default is 100}

\item{subdomain}{The account subdomain}

\item{apikey}{The api key from the account}
}
\value{
A dataframe of keywords along with 29 other columns of data
}
\description{
Retrieve a table of all the keywords in a particular site and the corresponding metadata
}
\examples{
 
\dontrun{
ssar_keywords(siteid = {site_id} ) #replace is your site id
}

}
