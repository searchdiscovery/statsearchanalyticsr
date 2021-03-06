% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/get_projects.R
\name{ssar_projects}
\alias{ssar_projects}
\title{Get Projects}
\usage{
ssar_projects(
  subdomain = Sys.getenv("SSAR_SUBDOMAIN"),
  apikey = Sys.getenv("SSAR_APIKEY")
)
}
\arguments{
\item{subdomain}{The account subdomain}

\item{apikey}{The api key from the account}
}
\value{
A dataframe of available project data your authentication has access to
}
\description{
Receive a list of all the projects on an account accessible through the provided api key
}
\examples{
\dontrun{
projects(subdomain = Sys.getenv('SSAR_SUBDOMAIN'),
         apikey = Sys.getenv('SSAR_APIKEY'))
}

}
