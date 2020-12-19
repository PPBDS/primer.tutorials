# Gets rid of annoying note about "unable to verify current time".

Sys.setenv('_R_CHECK_SYSTEM_CLOCK_' = 0)

.onLoad <- function(libname, pkgname){

  # Purpose of this code is to define functions which will override their
  # equivalents from the learnr package. Then, we do the actual overriding.

  # We want to allow for 5 blank lines in text questions. This is too many for
  # things like e-mail address, but good for many other questions.

  # Got this magic from a Dan Kaplan issues filing to rstudio/learnr.

  # I don't like the rlang::`%||%` gibberish, but it made a warning about %||%
  # not being a global variable go away.

  question_ui_initialize.learnr_text <- function(question, value, ...) {
    shiny::textAreaInput(
      question$ids$answer,
      label = question$question,
      placeholder = question$options$placeholder,
      value = value,
      rows = rlang::`%||%`(question$options$nrows, 1))
  }

  # How does this next code work? I don't know! I got it from:

  # https://stackoverflow.com/questions/24331690/modify-package-function

  environment(question_ui_initialize.learnr_text) <- asNamespace('learnr')
  utils::assignInNamespace("question_ui_initialize.learnr_text",
                    question_ui_initialize.learnr_text,
                    ns = "learnr")

  # Because learnr will not export these three functions, we have no choice but
  # to use ::: in order to access them. Doing do produces a NOTE when we run R
  # command check. I find that annoying. So, I just provide my own copies here.
  # This is absurd hack, but it is not clear what else one can do.

  read_request <- function(session, name, default = NULL) {
    if (!is.null(name)) {
      if (exists(name, envir = session$request))
        get(name, envir = session$request)
      else
        default
    } else {
      default
    }
  }

  submissions_from_state_objects <- function(state_objects) {
    filtered_submissions <- filter_state_objects(state_objects, c("question_submission", "exercise_submission"))
    Filter(x = filtered_submissions, function(object) {
      # only return answered question, not reset questions
      if (object$type == "question_submission") {
        !isTRUE(object$data$reset)
      } else {
        TRUE
      }
    })
  }

  get_all_state_objects <- function(session, exercise_output = TRUE) {

    # get all of the objects
    objects <- get_objects(session)

    # strip output (the client doesn't need it and it's expensive to transmit)
    objects <- lapply(objects, function(object) {
      if (object$type == "exercise_submission") {
        if (!exercise_output) {
          object$data["output"] <- list(NULL)
        }
      }
      object
    })

    # return objects
    objects
  }

  # Listing these makes the annoying NOTES go away, but it is also an absurd
  # hack. I am not even sure how it works . . .

  utils::globalVariables(c("read_request",
                           "submissions_from_state_objects",
                           "get_all_state_objects",
                           "filter_state_objects",
                           "get_objects"))
}
