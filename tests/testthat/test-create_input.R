test_that("create_input", {
  test <- create_input("state", usa_state_map)
  test <- as.character(test)
  expect_match(test, sample(toupper(unique(usa_state_map$region)),1))
  
  expect_error(create_input("state"))
})
