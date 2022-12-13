names(years) <- years

asdf <- map_dfr(years, ~{
  get_acs(
    geography = "county", 
    variables = "B25077_001", 
    state = "OR", 
    county = "Deschutes", 
    year = .x,
    survey = "acs1")
})
