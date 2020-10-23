test_that("output_table", {
  expect_error(output_table(usa_covid_data))
  expect_error(output_table("present_table"))
})
