library(tidyverse)
library(tidycensus)

data <- read_csv("inst/tutorials/036-mapping/data/food-deserts-data.csv")

your_state <- "Illinois"
your_county <- "Cook County"

# Need to get grocery store addresses somehow. Seems like there's a public SNAP
# database somewhere because it's constantly cited in the studies but I just
# can't find it. Until I do find it it's remaining missing. May just do
# financial centers at some point.


county_data <- get_acs(state     = your_state,
                       county    = your_county,
                       geography = "tract",
                       variables = "B06010_004",
                       geometry  = TRUE) %>%
               mutate(GEOID = as.double(GEOID))

county_data %>%
  ggplot() +
  geom_sf()


