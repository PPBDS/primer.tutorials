# There must be a better way of doing this . . .

# Purpose of this file is to define two functions which will override their
# equivalents from the learnr package. Then, we do the actual overriding.

# Each tutorial sources this file when it starts.

# Again, there must be a more elegant way of handling this issue, but I could
# find it. Presumably, this code could go in .onLoad or something . . .



question_is_correct.learnr_text <- function(question, value, ...) {

  if (nchar(value) == 0) {
    showNotification("Please enter some text before submitting", type = "error")
    req(value)
  }

  if (isTRUE(question$options$trim)) {
    value <- str_trim(value)
  }

  for (ans in question$answers) {
    ans_val <- ans$option
    if (isTRUE(question$options$trim)) {
      ans_val <- str_trim(ans_val)
    }
    if (TRUE) {
#    if (isTRUE(all.equal(ans_val, value))) {
      return(mark_as(
        ans$correct,
        ans$message
      ))
    }
  }

  mark_as(FALSE, NULL)
}


environment(question_is_correct.learnr_text) <- asNamespace('learnr')
assignInNamespace("question_is_correct.learnr_text",
                  question_is_correct.learnr_text,
                  ns = "learnr")

question_ui_initialize.learnr_text <- function(question, value, ...) {
  textAreaInput(
    question$ids$answer,
    label = question$question,
    placeholder = question$options$placeholder,
    value = value,
    rows = 5
  )
}

environment(question_ui_initialize.learnr_text) <- asNamespace('learnr')
assignInNamespace("question_ui_initialize.learnr_text",
                  question_ui_initialize.learnr_text,
                  ns = "learnr")

