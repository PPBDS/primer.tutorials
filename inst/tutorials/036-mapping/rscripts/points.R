library(tidyverse)
library(tidycensus)

cook_stores <- read_rds("inst/tutorials/036-mapping/data/cook-map.rds")
cook_map <- read_rds("inst/tutorials/036-mapping/data/cook-stores.rds")

cook_stores_map <- cook_map %>%
  mutate(Percent = 100 * (estimate / summary_est)) %>%
  ggplot(aes(fill = Percent, color = Percent)) +
  geom_sf() +
  scale_fill_viridis_c(direction = -1) +
  scale_color_viridis_c(direction = -1) +
  geom_point(data = cook_stores,
             aes(x = Longitude,
                 y = Latitude),
             stroke = 0,
             size = 0.5) +
  theme_map()
cook_stores_map
