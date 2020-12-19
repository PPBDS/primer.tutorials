# Purpose of this file is to define function(s) which will override their
# equivalents from the learnr package. Then, we do the actual overriding.

# Each tutorial sources this file when it starts.

# There must be a more elegant way of handling this issue, but I could find it.
# Presumably, this code could go in .onLoad or some similar file that is run
# automatically, when ever the package is loaded. But, if we did that, would it
# work? This certainly does . . .

# An earlier version overrided question_is_correct.learnr_text() because I
# wanted the tutorial to accept any text submitted as an answer. Any text is
# good text! The problem arises, especially with items like email, when a
# student makes a mistake and wants to correct it. There seems to be no way to
# "try again," on an answer which has been marked as correct.

# We want to allow for 5 blank lines in text questions. This is too many for
# things like e-mail address, but good for many other questions.

# Need to figure out how to pass an argumeny for number of rows from the top.

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

