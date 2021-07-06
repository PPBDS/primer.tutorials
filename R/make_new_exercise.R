#' Make New Exercise
#'
#' @return exercise skeleton with appropriate labels and numbers
make_new_exercise <- function(){
  ctx = rstudioapi::getActiveDocumentContext()
  row = ctx$selection[[1]]$range$end[["row"]]
  cut_content = rev(ctx$contents[1:row])
  exercise_number = "1"
  section_id = "NONE_SET"
  exercise_set = FALSE
  for (l in cut_content){
    if (stringr::str_detect(l, "### Exercise") & !stringr::str_detect(l, "str_detect")& !exercise_set){
      exercise_number = readr::parse_integer(gsub("[^0-9]", "", l)) + 1
      exercise_set = TRUE

    }

    if (stringr::str_detect(l, "## ")){

      if (stringr::str_detect(l, "\\{#") & !stringr::str_detect(l, "str_detect")){
        to_clean = gsub(".*(\\{#)", "", l)
        section_id = substr(to_clean, 1, nchar(to_clean)-1)

      } else {
        possible_id_removed_prev = gsub("\\{#(.*)\\}", "", l)
        possible_id_removed = gsub("[^a-zA-Z ]", "", possible_id_removed_prev)
        lowercase_id = tolower(trimws(possible_id_removed))
        section_id = gsub(" ", "-", lowercase_id)
      }
      break
    }
  }
  new_exercise = sprintf("### Exercise %s\n\n\n```{r %s-%s, exercise = TRUE}\n\n```\n\n<button onclick = \"transfer_code(this)\">Copy previous code</button>\n\n```{r %s-%s-hint, eval = FALSE}\n\n```\n\n###\n\n",
                         exercise_number,
                         section_id,
                         exercise_number,
                         section_id,
                         exercise_number)
  rstudioapi::insertText(new_exercise)
}
