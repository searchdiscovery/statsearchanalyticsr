#' Get Bulk Rankings Report
#'
#' Retrieve a bulk report of all the rankings or for specific sites.
#'
#' @param date The date being requested (required) in 'YYYY-MM-DD' format. Default is set to yesterday.
#' @param siteid The site id. If not provided then all sites will be returned. Comma separated list of specific site IDs, default is all sites.
#' @param ranktype This argument changes the call between getting the highest ranks for the keywords for the date with the value highest, or getting all the ranks for each engine for a keyword for a date with the value all. Defaults to highest if not provided.
#' @param engines This argument lets you choose which search engines to include in the export, defaulting to Google and Bing. Engines can be passed in comma separated to get multiple.
#' @param currentlytracked This argument will cause the API to ouptput only keywords which currently have tracking on at the time the API request is generated.
#' @param crawledkeywords This argument causes the API to only include output for keywords that were crawled on the date argument provided.
#' @param subdomain The account subdomain
#' @param apikey The api key from the account
#'
#' @return The dataframe with all keywords ranking information for the requested date
#'
#' @import httr tidyr jsonlite
#' @importFrom glue glue
#' @importFrom purrr map_df
#' @importFrom stringr str_c
#'
#' @export
#'
ssar_bulk_rankings <- function( date = Sys.Date()-1,
                                siteid = NULL,
                                ranktype = 'highest',
                                engines = c('google', 'bing'),
                                currentlytracked = TRUE,
                                crawledkeywords = TRUE,
                                subdomain = Sys.getenv('SSAR_SUBDOMAIN'),
                                apikey = Sys.getenv('SSAR_APIKEY')) {
  if(is.null(date)){
    stop("date argument cannot be empty")
  }
  if(length(date) > 1){
    stop("date argument cannot include more than one day")
  }
  #clean engines argument
  if(length(engines) > 1) {
    engines <- stringr::str_c(engines, collapse = ',')
  }
  #clean sites
  if(length(siteid) > 1) {
    siteid <- stringr::str_c(siteid, collapse = ',')
  }
  #add valid params
  params <- list(site_id = siteid, rank_type = ranktype, engines = engines, currently_tracked_only=currentlytracked, crawled_keywords_only = crawledkeywords, format = 'json')
  
  #collec non NULL params into a list
  valid_params <- Filter(Negate(is.null), params)
  #make that list into a parameter string
  urlparams <- paste0(names(valid_params),'=',valid_params, collapse = '&')
  # build request url
  baseurl <- glue::glue('https://{subdomain}.getstat.com/api/v2/{apikey}/')
  
  endpoint <- 'bulk/ranks'
  
  requrl <- glue::glue('{baseurl}{endpoint}?date={as.Date(date)}&{urlparams}&format=json')
  
  bulk_ranks <- httr::GET(requrl)
  
  #check the status for the call and return errors or don't
  httr::stop_for_status(bulk_ranks, glue::glue('get the bulk rankings. \n   {httr::content(bulk_ranks)$Result}'))
  #if 200 but no results due to an error
  if(is.null(httr::content(bulk_ranks)$Response)) {
    stop(httr::content(bulk_ranks)$Result)
  }
  
  #return the results
  report_id <- httr::content(bulk_ranks)$Response$Result$Id
  
  message(glue::glue('Your report id is {report_id} \n Checking to see if it is complete...'))
  
  requrl <- glue::glue('{baseurl}bulk/status?id={report_id}&format=json')
  
  statusgot <- httr::GET(requrl)
  
  
  try = 1
  ##Check if the report is ready
  checkit <- function(statusgot, try){
    keepgoingstatus <- list('NotStarted','InProgress')
    stopstatus <- list('Deleted','Failed')
    completestatus <- list('Completed')
    res <- httr::content(statusgot)
    status <- httr::content(statusgot)$Response$Result$Status
    
    if(status %in% keepgoingstatus) {
      message(glue::glue('Attempt #{try}'))
      message(glue::glue('The current status is {status}.'))
      
      #pause for 2 seconds for the report to run
      Sys.sleep(2)
      
      #get the status for the report
      status_res <- httr::GET(requrl) 
      try <- try + 1
      checkit(status_res, try)
    } else if(status %in% stopstatus) {
      #report back the status and ask to retry
      message(glue::glue('The current status of the report is \'{status}\'. You will need to retry your request.'))
    } else if(status %in% completestatus) {
      
      message(glue::glue('Good news! Your report is complete'))
      report <- httr::GET(res$Response$Result$StreamUrl)
      
      reportinfo <- httr::content(report)
      
      resultkeywords <- purrr::map_df(reportinfo$Response$Project$Site$Keyword, unlist)
      #message the number of keywords that were returned.
      message(glue::glue('{length(unique(resultkeywords$Id))} Total keywords have been returned for {date}'))
      
      #return the final keyword report for the date requested
      return(resultkeywords)
    }
  }
  report_response <- checkit(statusgot, try)
  
}
