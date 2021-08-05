library(primer.tutorials)
library(tidyverse)
library(rvest)



# This script tests the components of the downloading functions
# for submission_server()

# Load session saved in rds

saved_session <- readRDS(session_path)

message(paste0("Saved Session Path:\n", session_path))

message(paste0("Session App Dir:\n", saved_session$options$appDir))

# Test get_label_list()

label_list_test <- get_label_list(saved_session, is_test = TRUE)

label_list_output <- readRDS(system.file("www/submission_test_outputs/label_list_output.rds", package = "primer.tutorials"))

if (!identical(label_list_test, label_list_output)){
  stop("From test-submission.R. function get_label_list() did not return the desired output")
}



# Test get_submissions_from_learnr_session()

learnr_submissions_test <- get_submissions_from_learnr_session(saved_session)

learnr_submissions_output <- readRDS(system.file("www/submission_test_outputs/learnr_submissions_output.rds", package = "primer.tutorials"))

if (!identical(learnr_submissions_test, learnr_submissions_output)){
  stop("From test-submission.R. function get_submissions_from_learnr_session() did not return the desired output\nTest output:\n",
       learnr_submissions_test,
       "\n\nDesired output:\n",
       learnr_submissions_output,
       "\n\nDifference in lists:\n",
       setdiff(learnr_submissions_test, learnr_submissions_output))
}



# Test build_html()

report_test_loc <- build_html(file.path(tempdir(), "submission_report_test.html"), saved_session)

submission_report_test <- rvest::read_html(report_test_loc)

submission_report_output <- rvest::read_html(system.file("www/submission_test_outputs/submission_report_output.html", package = "primer.tutorials"))

if (!identical(rvest::html_table(submission_report_test), rvest::html_table(submission_report_output))){
  stop("From test-submission.R. function build_html() did not return the desired output")
}

