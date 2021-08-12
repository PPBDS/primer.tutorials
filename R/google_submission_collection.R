
#' Google Submission Collection
#'
#' @param key client id obtained from oauth credentials
#' @param secret client secret obtained from oauth credentials
#' @param tutorial_id id of tutorial to save and process
#' @param after_date keep only mails after this date: use YYYY/MM/DD
#' @param before_date (Optional) keep only mails before this date: use YYYY/MM/DD
#'
#' @return succss status
#' @export
#'
google_submission_collection <- function(key, secret, tutorial_id, after_date, before_date=NULL){
  filter <- paste0("has:attachment after:", after_date)

  if (!is.null(before_date)){
    filter <- paste0(filter , " before:", before_date)
  }

  rds_paths <- gmail_access(filter, key, secret)

  parsed_date <- readr::parse_date(after_date, "%Y%.%m%.%d")

  year <- format(parsed_date, "%Y")

  month <- format(parsed_date, "%m")

  day <- format(parsed_date, "%d")

  gdrive_access(tutorial_id, year, month, day, tempdir(), rds_paths)
}
