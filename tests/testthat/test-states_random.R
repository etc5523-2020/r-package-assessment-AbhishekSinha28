test_that("states_random()", {
  test <- states_random(usa_state_map)
  states <- unique(usa_state_map$region)
  expect_length(test, 2)
  expect_true(test[1] %in% states)
  expect_true(test[2] %in% states)
})
