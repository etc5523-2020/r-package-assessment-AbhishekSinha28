test_that("average_measure", {
  test <- average_measure(usa_covid_data, "tot_cases")
  expect_null(average_measure(usa_covid_data, "total_cases"))
  expect_equal(ncol(test), 3)
  expect_error(average_measure("tot_cases"))
})

