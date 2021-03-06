#' Request Bulk Report
#'
#' Retrieve a bulk report using a bulk report id. Intended to be used with the `get_bulk_rankings` function but can be used independently as well.
#'
#' @param id Id of the bulk job #required
#' @param subdomain The account subdomain
#' @param apikey The api key from the account
#'
#' @return list of the bulk keyword ranking report for the requested ID
#' 
#' @examples 
#' \dontrun{
#' ssar_bulk_request(id = {report_id})
#' }
#'
#' @import httr tidyr jsonlite
#' @importFrom glue glue
#' @importFrom purrr map_df
#' @importFrom stringr str_c
#' 
#' @export
#'
#'
ssar_bulk_request <- function(id = NULL,
                               subdomain = Sys.getenv('SSAR_SUBDOMAIN'),
                               apikey = Sys.getenv('SSAR_APIKEY')) {
if(is.null(id)){
  stop("id argument cannot be empty")
}
  # build request url
  baseurl <- glue::glue('https://{subdomain}.getstat.com/api/v2/{apikey}/')

  endpoint <- 'bulk/status'

  requrl <- glue::glue('{baseurl}{endpoint}?id={id}&format=json')

 bulk_status <- httr::GET(requrl)
#check the status for the call and return errors or don't
 httr::stop_for_status(bulk_status, glue::glue('get the bulk rankings. \n {httr::content(bulkranks)$Result}'))
 #if 200 but no results due to an error
 if(is.null(httr::content(bulk_status)$Response)) {
   stop(httr::content(bulk_status)$Result)
 }

 #return the results
 status <- httr::content(bulk_status)$Response$Result$Status

 if(status == 'Completed') {
 data <- httr::GET(httr::content(bulk_status)$Response$Result$StreamUrl)

 data_content <- httr::content(data)$Response$Project

 return(data_content)
 } else {
  return(status)
 }
}
