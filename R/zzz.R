.onLoad <- function(libname, pkgname){

  # Purpose of this code is to define function(s) which will override their
  # equivalents from the learnr package. Then, we do the actual overriding.

  # We want to allow for 5 blank lines in text questions. This is too many for
  # things like e-mail address, but good for many other questions.

  question_ui_initialize.learnr_text <- function(question, value, ...) {
    textAreaInput(
      question$ids$answer,
      label = question$question,
      placeholder = question$options$placeholder,
      value = value,
      rows = question$options$nrows %||% 1
    )
  }

  # How does this work? I don't know!

  environment(question_ui_initialize.learnr_text) <- asNamespace('learnr')
  assignInNamespace("question_ui_initialize.learnr_text",
                    question_ui_initialize.learnr_text,
                    ns = "learnr")

}
