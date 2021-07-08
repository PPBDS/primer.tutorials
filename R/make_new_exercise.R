#' Make New Exercise
#'
#' @return exercise skeleton with appropriate labels and numbers
make_new_exercise <- function(){

  # Get current active document
  ctx = rstudioapi::getActiveDocumentContext()

  # Get current row
  row = ctx$selection[[1]]$range$end[["row"]]

  # Get everything until the current row as a list of lines
  # and reverse that list
  cut_content = rev(ctx$contents[1:row])

  # Default exercise number is 1
  exercise_number = "1"

  # Default section id is NONE_SET
  section_id = "NONE_SET"

  # Set up boolean to make sure the exercise nunber is not set twice
  exercise_set = FALSE

  # going in reverse (because we reversed it)
  for (l in cut_content){

    # Find the latest exercise and make sure we have not already set the exercise number
    if (stringr::str_detect(l, "### Exercise") & !stringr::str_detect(l, "str_detect")& !exercise_set){

      # Set the exercise number to 1 + the latest exercise number
      exercise_number = readr::parse_integer(gsub("[^0-9]", "", l)) + 1

      # Set exercise_set to TRUE, so we don't set the exercise number more than once
      exercise_set = TRUE

    }

    # Find the latest section
    if (stringr::str_detect(l, "## ")){

      # Check if there is a manually set section id
      if (stringr::str_detect(l, "\\{#") & !stringr::str_detect(l, "str_detect")){

        # Parse the section id from the curly brackets and stuff
        to_clean = gsub(".*(\\{#)", "", l)
        section_id = substr(to_clean, 1, nchar(to_clean)-1)


      } else {
        # If there is no manually set section id, then make its own id
        # by stringing together section name with dashes

        # remove possible id stuff
        possible_id_removed_prev = gsub("\\{#(.*)\\}", "", l)

        # only keep letters and spaces
        possible_id_removed = gsub("[^a-zA-Z ]", "", possible_id_removed_prev)

        # make everything lowercase and trim trailing spaces on both sides
        lowercase_id = tolower(trimws(possible_id_removed))

        # replace all spaces between words with dashes
        section_id = gsub(" ", "-", lowercase_id)
      }

      # After finding a section, stop looping immediately
      break
    }
  }

  # Make new exercise skeleton by
  # inserting the appropriate label
  # and exercise number at the right places
  new_exercise = sprintf("### Exercise %s\n\n\n```{r %s-%s, exercise = TRUE}\n\n```\n\n<button onclick = \"transfer_code(this)\">Copy previous code</button>\n\n```{r %s-%s-hint, eval = FALSE}\n\n```\n\n###\n\n",
                         exercise_number,
                         section_id,
                         exercise_number,
                         section_id,
                         exercise_number)

  # Insert the skeleton into the current active document
  rstudioapi::insertText(new_exercise)
}
