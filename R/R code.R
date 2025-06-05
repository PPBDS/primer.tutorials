tibble(poll_ID = c("1", "2", 
                   "...", "200", "201", "...", "1,559"),
       biden = c("0", "0", 
                 "...", "1", "0", "...", "1")) |>
  gt() |>
  tab_header(title = "Polling Data") |> 
  cols_label(poll_ID = "Poll ID",
             biden = "Would Vote for Biden") |>
  tab_style(cell_borders(sides = "right"),
            location = cells_body(columns = c(poll_ID))) |>
  cols_align(align = "center", columns = everything())