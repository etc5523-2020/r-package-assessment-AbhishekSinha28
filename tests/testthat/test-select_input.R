test_that("select_input", {
  test <- select_input("state", usa_state_map)
  test <- as.character(test)
  expect_match(test, sample(unique(usa_state_map$region),1))
  
  expect_error(select_input("state"))
})
