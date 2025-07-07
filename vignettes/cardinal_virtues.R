## -----------------------------------------------------------------------------
#| label: hidden-libraries
#| message: false
#| echo: false
#| warning: false
library(tidyverse)
library(gt)

library(tidymodels)
library(broom)
library(primer.data)
library(marginaleffects)


## -----------------------------------------------------------------------------
#| echo: false
tibble(ID = c("1", "2", "...", "10", "11", "...", "N"),
       liberal = c("0", "0", "...", "1", "1", "...", "1"),
       income = c("150000", "50000", "...", "65000", "35000", "...", "78000")) |>
  gt() |>
  tab_header(title = "Preceptor Table") |> 
  cols_label(ID = md("ID"),
             liberal = md("Liberal"),
             income = md("Income")) |>
  tab_style(cell_borders(sides = "right"),
            location = cells_body(columns = c(ID))) |>
  tab_style(style = cell_text(align = "left", v_align = "middle", size = "large"), 
            locations = cells_column_labels(columns = c(ID))) |>
  cols_align(align = "center", columns = everything()) |>
  cols_align(align = "left", columns = c(ID)) |>
  fmt_markdown(columns = everything()) |>
  tab_spanner(label = "Outcome", columns = c(liberal)) |>
  tab_spanner(label = "Covariate", columns = c(income))


## -----------------------------------------------------------------------------
#| echo: false
tibble(source = c("...", "Data", "Data", "...", 
                  "...", "Preceptor Table", "Preceptor Table", "..."),
       year = c("...", "2012", "2012", "...", 
                "...", "2020", "2020", "..."),
       income = c("...", "150000", "50000", "...",
                 "...", "...", "...", "..."),
       city = c("...", "Boston", "Boston", "...", 
                "...", "Chicago", "Chicago", "..."),
       age = c("...", "43", "52", "...", 
               "...", "...", "...", "...")) |>
  
  gt() |>
  tab_header(title = "Population Table") |> 
  cols_label(source = md("Source"),
             year = md("Year"),
             income = md("Income"),
             city = md("City"),
             age = md("Age")) |>
  tab_style(cell_borders(sides = "right"),
            location = cells_body(columns = c(source))) |>
  cols_align(align = "center", columns = everything()) |>
  cols_align(align = "left", columns = c(source)) |>
  fmt_markdown(columns = everything()) |>
  tab_spanner(label = "Outcome", columns = c(income)) |>
  tab_spanner(label = "Covariates", columns = c(age, city))
  


## -----------------------------------------------------------------------------
linear_reg(engine = "lm") |>
  fit(att_end ~ sex + treatment + age, data = trains) |>
  tidy(conf.int = TRUE, digits = 2) |>
  select(term, estimate, conf.low, conf.high)


## -----------------------------------------------------------------------------
#| cache: true
logistic_reg(engine = "glm") |>
  fit(as.factor(arrested) ~ sex + race, data = stops) |>
  tidy(conf.int = TRUE) |>
  select(term, estimate, conf.low, conf.high)


## -----------------------------------------------------------------------------
fit_attitude <- linear_reg(engine = "lm") |>
  fit(att_end ~ sex + treatment + age, data = trains)


## -----------------------------------------------------------------------------
plot_predictions(fit_attitude,
                 condition = "sex")


## -----------------------------------------------------------------------------
plot_predictions(fit_attitude,
                 condition = "treatment")


## -----------------------------------------------------------------------------
plot_predictions(fit_attitude,
                 condition = "age")


## -----------------------------------------------------------------------------
plot_predictions(fit_attitude,
                 condition = c("treatment", "age", "sex"))


## -----------------------------------------------------------------------------
# plot_comparisons(fit_attitude,
#                  variables = "treatment",
#                  condition = "treatment")

