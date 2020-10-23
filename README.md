
<!-- README.md is generated from README.Rmd. Please edit that file -->

# Covid19US

<!-- badges: start -->

<!-- badges: end -->

The goal of **Covid19US** is to embed a newly created shiny application
for exploring COVID-19 data in the United States of America (USA) within
a package, and to refactor various parts of the application logic into R
functions exported by the package.

## Shiny application

As stated above, the shiny application was created using the R package,
shiny, to allow users to explore COVID-19 related data in the
continental United States of America. For both the total number of cases
and total number of deaths, the following data visualizations are
provided:

1.  A choropleth map displaying the spatial distribution of the total
    number of cases and deaths respectively, recorded at the state
    level.  
2.  A timseries chart displaying the change in total cases and deaths
    recorded at the state level between the January’22 and the
    September’28 of 2020, compared to the national average number of
    cases and deaths respectively.  
3.  An accompanying table recording the exact number of cases and deaths
    recorded at the state level, and the national average, over the same
    time frame.

For more information on the application itself and the data contained
within it, please click
[here](https://github.com/etc5523-2020/r-package-assessment-AbhishekSinha28).

## Installation

<!-- You can install the released version of Covid19US from [CRAN](https://CRAN.R-project.org) with: -->

<!-- ``` r -->

<!-- install.packages("Covid19US") -->

<!-- ``` -->

The development version of **Covid19US** can be installed directly from
[GitHub](https://github.com/etc5523-2020/r-package-assessment-AbhishekSinha28)
with:

``` r
# install.packages("devtools")
devtools::install_github("etc5523-2020/r-package-assessment-AbhishekSinha28")
```

## Getting started

The application can then be launched using the following code:

``` r
library(Covid19US)

launch_app()
```

## Package functions

This function was created and implemented within the `select_input`
function in order to automatically select two different US states for
comparison each time the application is launched. In addition, this
function is used to create all adjustable inputs for the application.

``` r
set.seed(10)
library(Covid19US)

random_states(usa_state_map)
#> [1] "utah"    "florida"
```

``` r
select_input("state", usa_state_map)
```

Secondly, on the server side, the function `average_measure` can be used
to produce a summary count of either `tot_cases` or `tot_death` for
COVID19 in the USA. This is used to construct the time series plot seen
in the application.

``` r
library(dplyr)

example <- average_measure(usa_covid_data, "tot_cases") %>%
  arrange(-tot_cases) %>%
  head(10)

example
#> # A tibble: 10 x 3
#>    date       tot_cases state  
#>    <date>         <dbl> <chr>  
#>  1 2020-09-28    118822 average
#>  2 2020-09-27    118257 average
#>  3 2020-09-26    117651 average
#>  4 2020-09-25    116820 average
#>  5 2020-09-24    115977 average
#>  6 2020-09-23    115272 average
#>  7 2020-09-22    114583 average
#>  8 2020-09-21    113762 average
#>  9 2020-09-20    113106 average
#> 10 2020-09-19    112482 average
```

The final function, `output_table`, converts any data frame into a
stylish and presentable table using the `kableExtra` package and can be
seen alongside the time series chart in the application.

``` r
library(dplyr)

usa_covid_data %>%
  select(date, state, tot_cases)%>%
  filter(state == "california") %>%
  head(5) %>%
output_table("cases", "Total cases in California per day")
```

<div style="border: 1px solid #ddd; padding: 0px; overflow-y: scroll; height:500px; ">

<table class="table table-bordered" style="margin-left: auto; margin-right: auto;">

<caption>

Total cases in California per day

</caption>

<thead>

<tr>

<th style="text-align:left;position: sticky; top:0; background-color: #FFFFFF;">

date

</th>

<th style="text-align:left;position: sticky; top:0; background-color: #FFFFFF;">

state

</th>

<th style="text-align:right;position: sticky; top:0; background-color: #FFFFFF;">

tot\_cases

</th>

</tr>

</thead>

<tbody>

<tr>

<td style="text-align:left;">

2020-01-22

</td>

<td style="text-align:left;">

california

</td>

<td style="text-align:right;">

0

</td>

</tr>

<tr>

<td style="text-align:left;">

2020-01-23

</td>

<td style="text-align:left;">

california

</td>

<td style="text-align:right;">

0

</td>

</tr>

<tr>

<td style="text-align:left;">

2020-01-24

</td>

<td style="text-align:left;">

california

</td>

<td style="text-align:right;">

0

</td>

</tr>

<tr>

<td style="text-align:left;">

2020-01-25

</td>

<td style="text-align:left;">

california

</td>

<td style="text-align:right;">

0

</td>

</tr>

<tr>

<td style="text-align:left;">

2020-01-26

</td>

<td style="text-align:left;">

california

</td>

<td style="text-align:right;">

2

</td>

</tr>

</tbody>

</table>

</div>

## Additional information

For more detailed instructions on how to use the package and the
functions contained within it, please consult the
[vignette](https://github.com/etc5523-2020/r-package-assessment-AbhishekSinha28)
