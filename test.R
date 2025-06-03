library(tidymodels)
library(marginaleffects)

mtcars_binary <- mtcars |> 
  mutate(high_mpg = factor(ifelse(mpg > median(mpg), "high", "low")))

mod <- logistic_reg() |> 
  set_engine("glm") |> 
  fit(high_mpg ~ wt, data = mtcars_binary)

class(mod)

plot_predictions(mod, condition = "drat")
