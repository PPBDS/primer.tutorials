library(tidyverse)
library(learnr)
library(stringr)
library(primer.tutorials)
library(parsermd)

# * Create new file: test-code-chunks.R. It should use the tutorial_paths object to go through all tutorials, use parsermd to parse them and then check for various problems:
#
#   + No duplicated code chunk names. DONE
#
# + Code chunks begin with r, followed by a space. (If you don't have an r at the start of the r code chunk options, the entire tutorial breaks and, at least sometimes, it breaks by creating the tutorial but with only questions and with three columns.) DONE
#
#   + Check that all hints have eval = FALSE. (In other words, any code chunk with "hint" in the code chunk name should have eval = FALSE.) DONE
#
#   + No code chunks with no lines. This causes a weird error which is very hard to diagnose. DONE
#
# * (Delay for now.) Can we use knitr::purl() to create .R files which might then become part of our testing process? Perhaps to test whether the code in the hints is OK?
#
# * Is there some way to ensure that all the answers we have for each question --- including complete answers we provide in hints --- work correctly. For example, if a input csv file becomes corrupted, how will we catch that?
#
# * Update Technical Details document. It is filled with nonsense!

for(i in tutorial_paths) {
  # Gets the first line (the chunk label) of each code chunk in the file
  lines <- readLines(i)
  labels <- lines[grepl("^```\\{", lines)]

  # Gets the labels that don't have r at the beginning.
  # I'm doing this with a grepl because parsermd doesn't detect code chunks like
  # this.
  no_r_labels <- labels[grepl("```\\{[^r]", labels)]
  if(length(no_r_labels) > 0){
    stop("From test-code-chunks.R. Missing `r` at beginning of code chunk labels: ",
         toString(no_r_labels), " Found in file ", i, "\n")
  }

  # Gets the labels that don't have a space, a comma, or a }.
  # This is because labels like {r chunk-name}, {r}, and {r, include = FALSE}
  # are all valid and used throughout the tutorial.
  # parsermd also doesn't detect chunks if there's no space so this
  # is easier.
  no_space_labels <- labels[grepl("```\\{r[^\ },]", labels)]
  if(length(no_space_labels) > 0){
    stop("From test-code-chunks.R. Missing space or comma at beginning of code chunk labels: ",
         toString(no_space_labels), " Found in file ", i, "\n")
  }

  # Gets the labels that don't have a } at the end.
  # This is so that everything parses correctly.
  no_end_labels <- labels[!grepl("}$", labels)]
  if(length(no_end_labels) > 0){
    stop("From test-code-chunks.R. Missing `}` at end of code chunk labels: ",
         toString(no_end_labels), " Found in file ", i, "\n")
  }

  # Uses parse_rmd to get the structure of the document
  doc_structure <- parse_rmd(i)

  # Filters out the document so that we only pull the chunks and their labels
  doc_labels <- doc_structure %>% rmd_node_label()
  doc_labels <- doc_labels[!is.na(doc_labels)]
  doc_labels <- doc_labels[doc_labels != ""]

  # Checks for duplicates then stops it if there's multiple
  dups <- doc_labels[duplicated(doc_labels)]
  dups <- dups[!is.na(dups)]
  if(length(dups) != 0){
    stop("From test-code-chunks.R. Duplicated code chunk labels ",
         toString(dups), " found in file ", i, "\n")
  }

  # Check for eval = false in hints
  hint_labels <- labels[grepl("hint", labels)]
  for(label in hint_labels){
    if(!str_detect(label, "eval = FALSE")){
      stop("From test-code-chunks.R. `eval = false` missing from code chunk ",
           label, " in file ", i, "\n")
    }
  }

  # Checks for empty chunks by extracting the code from the document
  doc_code <- doc_structure %>% rmd_node_code()
  doc_code[sapply(doc_code, is.null)] <- NULL
  empty_counter <- 0
  for(chunk_code in doc_code){
    if(length(chunk_code) == 0){
      empty_counter <- empty_counter + 1
    }
  }

  # There should be less than 3 empty chunks: the copycodechunk, info, and the
  # download chunks
  if(empty_counter > 3){
    warning("From test-code-chunks.R. ", empty_counter,
            " empty code chunks present in file ", i, "\n")
  }
}
