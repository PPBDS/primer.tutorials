 # Needed for chapter 6

 dc_income <- get_acs(
  geography = "tract",
   variables = "B19013_001",
   state = "DC",
   year = 2020,
   geometry = TRUE
 )

 write_rds(dc_income, "data/dc_income.rds")


 # Needed for chapter 6

 dallas_bachelors <- get_acs(
   geography = "tract",
   variables = "DP02_0068P",
   year = 2020,
   state = "TX",
   county = "Dallas",
   geometry = TRUE
 )

 write_rds(dallas_bachelors, "data/dallas_bachelors.rds")


# Needed for chapter 6

 hennepin_race <- get_decennial(
   geography = "tract",
  state = "MN",
  county = "Hennepin",
   variables = c(
     Hispanic = "P2_002N",
     White = "P2_005N",
     Black = "P2_006N",
     Native = "P2_007N",
     Asian = "P2_008N"
   ),
   summary_var = "P2_001N",
   year = 2020,
   geometry = TRUE
 ) %>%
   mutate(percent = 100 * (value / summary_value))

write_rds(hennepin_race, "data/hennepin_race.rds")

# Needed for chapter 6

 us_median_age <- get_acs(
   geography = "state",
   variables = "B01002_001",
  year = 2019,
   survey = "acs1",
  geometry = TRUE,
  resolution = "20m"
) |>
   shift_geometry()

 write_rds(us_median_age, "data/us_median_age.rds")

# Needed for chapter 12

 fertility_data <- get_idb(
   country = "all",
   year = 2021,
   variables = "tfr",
   geometry = TRUE,
 )

 write_rds(fertility_data, "data/fertility_data.rds")
