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

    output$downloadData <- shiny::downloadHandler(
      
      # Next code chunk is key. downloadHandler is a function, one of the
      # arguments for which is filename. We want to have the file name be
      # different for each tutorial. But how do we know the name of the tutorial
      # in the middle of the session? It is easy to access some information from
      # the session object if we know the correct learnr function. (Note that
      # the call to session only seems to work within a reactive function like
      # this.) 

      filename = paste0(learnr:::read_request(session, 
                                              "tutorial.tutorial_id"),
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
    shiny::tags$li("Click the Download button to download the `.rds` file. A window will pop up with some options."),
    shiny::tags$li("The default file name will be something like `answers_zzzzz.rds`, where the z's are random characters."),
    shiny::tags$li("Save the file onto your computer in a convenient location. Do not open it."),
    shiny::tags$li("Upload the file which you just downloaded to the appropriate Canvas assignment.")),
  shiny::fluidPage(
    shiny::mainPanel(
      shiny::div(id = "form",
                 shiny::downloadButton(outputId = "downloadData", label = "Download"))
    )
  )
)

# This is the usual hack to avoid warnings with random global variables. But why
# is that necessary with something like session, which we never created in the
# first place?

utils::globalVariables(c("session"))
