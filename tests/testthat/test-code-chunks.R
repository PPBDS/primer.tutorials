# * Create new file: test-code-chunks.R. It should use the tutorial_paths object to go through all tutorials, use parsermd to parse them and then check for various problems:
#
#   + No duplicated code chunk names.
#
# + Code chunks begin with r, followed by a space. (If you don't have an r at the start of the r code chunk options, the entire tutorial breaks and, at least sometimes, it breaks by creating the tutorial but with only questions and with three columns.)
#
#   + Check that all hints have eval = FALSE. (In other words, any code chunk with "hint" in the code chunk name should have eval = FALSE.)
#
#   + No code chunks with no lines. This causes a weird error which is very hard to diagnose.
#
# * (Delay for now.) Can we use knitr::purl() to create .R files which might then become part of our testing process? Perhaps to test whether the code in the hints is OK?
#
# * Is there some way to ensure that all the answers we have for each question --- including complete answers we provide in hints --- work correctly. For example, if a input csv file becomes corrupted, how will we catch that?
#
# * Update Technical Details document. It is filled with nonsense!

for(i in tutorial_paths){

}
