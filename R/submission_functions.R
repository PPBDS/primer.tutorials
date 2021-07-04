# Next time we revisit this, consider some changes. First, split this file into
# two. One part has the two functions we use: submission_server() and
# submission_ui. The second part has all the helper functions.

# Second, bringing in the learnr functions somehow. I hate being dependent on
# learnr given how unresponsive they are. We could just make copies of the
# functions we use. Or we could just incorporate the key code from those
# functions where we need them.

# Third, consider getting rid of all these helper functions. If we only use
# something once, I don't think we need a separate function. And, indeed, for
# some of this checking, maybe we don't need it at all. We could delete
# check_server_context() and is_server_context(). We only use a couple of lines
# from encode_obj().

# What we really want is a single function which, when called from the tutorial,
# does all the stuff we need. But, presumably, that is impossible. We need (?) a
# Shiny server and Shiny ui. This is not (?) any other way to produce this
# effect.

# Want to change the color to the OK box so that it is green when students enter
# their email or other text. This seem relevant:

# https://stackoverflow.com/questions/33620133/change-the-color-of-action-button-in-shiny/35871042

# But where, exactly, do we add this code given that we don't control the Shiny
# sessions which learnr itself starts and stops?

# Ought to understand and explain exactly what shiny::div() does.

# Add in a function (here?) for parsing the resulting RDS files.

# Add in a function (here?) for pulling out an answer key to share with
# students. Maybe we distribute a PDF in order to make copy/pasting harder?



#' @title Tutorial submission functions
#'
#' @description
#'
#' The following function was modified from Colin Rundel's learnrhash package,
#' available at https://github.com/rundel/learnrhash. Many thanks to Professor
#' Rundel, who has developed a fantastic tool for courses that teach R and use
#' the learnr package.
#'
#' This note is also modified from Professor Rundel's description: Note that
#' when including these functions in a learnr Rmd document it is necessary that
#' the server function, `submission_server()`, be included in an R chunk where
#' `context="server"`. Conversely, any of the ui functions, `*_ui()`, must *not*
#' be included in an R chunk with a `context`.
#'
#' @param input unused
#' @param output unused
#'
#' @rdname submission_functions
#' @export

submission_server <- function(input, output) {
  p = parent.frame()
  check_server_context(p)

  # We need information from the parent frame --- from the learnr code which is
  # running this tutorial. This is the environment which is calling this
  # function, submission_server. Only this parent environment has access to
  # objects (like input, output, and session) which we need to access. So,
  # local() makes everything below evaluated in the parent frame.

  local({

    output$downloadPdf <- shiny::downloadHandler(
      filename = paste0(learnr:::read_request(session, "tutorial.tutorial_id"),
                        "_answers.pdf"),
      content = function(file){

        objs <- learnr:::get_all_state_objects(session)
        objs <- learnr:::submissions_from_state_objects(objs)

        # Initialize empty dataframe outside of for-loop
        pdf_df <- data.frame(
          type_ = character(),
          id_ = character(),
          user_input = character(),
          page_num = integer(),
          stringsAsFactors=FALSE
        )

        # Threshold of number of text rows in one page
        page_threshold = 20

        # Current number of text rows
        curr_rows = 0

        # Current page number
        curr_page = 0


        for (obj in objs){

          # If we are at or past 30, we have enough data for one page
          # so we append the current df to df_list and reset the df
          if (curr_rows >= page_threshold){
            curr_page = curr_page + 1
            curr_rows = 0
          }

          # Store question type
          obj_type = obj$type[[1]]

          # Store answer based on question type
          obj_answer = ""

          if (obj_type == "exercise_submission"){
            obj_answer = obj$data$code[[1]] %>% trimws()
          } else{
            obj_answer = obj$data$answer[[1]] %>% trimws()
          }

          # Increment curr_rows by number of newlines
          curr_rows = curr_rows + stringr::str_count(obj_answer, "\n")

          # Store question id
          obj_id = obj$id[[1]]

          # Add row to dataframe
          pdf_df = rbind(pdf_df, c(type_ = obj_type, id_ = obj_id, user_input = obj_answer, page_num = curr_page))
        }

        # Add column names to dataframe
        colnames(pdf_df) = c("type_", "id_", "user_input", "page_num")

        # Create PDF
        pdf(file, height = 11, width = 20)

        # Write dataframe to corresponding page on PDF
        for (seg_df in split(pdf_df, pdf_df$page_num)){

          gridExtra::grid.table(seg_df %>% select(-page_num))

          if (curr_page != seg_df$page_num[[1]]){
            grid::grid.newpage()
          }

        }

        # Close PDF
        dev.off()
      }
    )

    output$downloadRds <- shiny::downloadHandler(

      # Next code chunk is key. downloadHandler is a function, one of the
      # arguments for which is filename. We want to have the file name be
      # different for each tutorial. But how do we know the name of the tutorial
      # in the middle of the session? It is easy to access some information from
      # the session object if we know the correct learnr function. (Note that
      # the call to session only seems to work within a reactive function like
      # this.)

      filename = paste0(learnr:::read_request(session, "tutorial.tutorial_id"),
                        "_answers.rds"),

      content = function(file){

        # We used to execute the next two lines in a separate step, requiring
        # users to generate the hash by pressing a button. But this is hardly
        # necessary. We can just do it here, whenever users press the download
        # button. Would be nice to get the learnr people to export these
        # functions so that the ::: hack is not necessary. I have submitted a
        # request: https://github.com/rstudio/learnr/issues/454. The functions
        # are small, so we might just copy them over. But given that we need
        # learnr regardless, that seems excessive.

        objs <- learnr:::get_all_state_objects(session)
        objs <- learnr:::submissions_from_state_objects(objs)

        responses <- encode_obj(objs)
        readr::write_rds(responses, file)
      }
    )

  }, envir = p)
}

check_server_context <- function(.envir) {
  if (!is_server_context(.envir)) {
    calling_func = deparse(sys.calls()[[sys.nframe()-1]])

    err = paste0(
      "Function `", calling_func,"`",
      " must be called from an Rmd chunk where `context = \"server\"`"
    )

    stop(err, call. = FALSE)
  }
}

is_server_context <- function(.envir) {
  # We are in the server context if there are the follow:
  # * input - input reactive values
  # * output - shiny output
  # * session - shiny session
  #
  # Check context by examining the class of each of these.
  # If any is missing then it will be a NULL which will fail.

  inherits(.envir$input,   "reactivevalues") &
    inherits(.envir$output,  "shinyoutput")    &
    inherits(.envir$session, "ShinySession")
}

#' Encode an R object into hashed text; from github::rundel/learnrhash
#'
#' @param obj R object
#' @param compress Compression method.
#'
#' @export

# DK: We can delete this next function and just hard code
# the encoding call above.

encode_obj = function(obj, compress = c("bzip2", "gzip", "xz", "none"))  {
  compress = match.arg(compress)

  raw = serialize(obj, NULL)
  comp_raw = memCompress(raw, type = compress)

  base64enc::base64encode(comp_raw)
}


#' @rdname submission_functions
#' @export

submission_ui <- shiny::div(

  "When you have completed this tutorial, follow these steps:",

  shiny::tags$br(),
  shiny::tags$ol(
    shiny::tags$li("Click the Download button below to download a file containing your answer. A window will pop up."),
    shiny::tags$li("Save the file onto your computer in a convenient location. It should have an 'rds' suffix. Do not open it."),
    shiny::tags$li("Submit the file which you just downloaded as instructed.")),
  shiny::fluidPage(
    shiny::mainPanel(
      shiny::div(id = "form",
                 shiny::downloadButton(outputId = "downloadRds", label = "Download RDS"),
                 shiny::downloadButton(outputId = "downloadPdf", label = "Download PDF"))
    )
  )
)


# Never understand what this hack does or why it is necessary.

utils::globalVariables(c("session"))
