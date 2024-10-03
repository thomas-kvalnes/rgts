
<!-- README.md is generated from README.Rmd. Please edit that file -->

# rgts <img src="man/figures/logo.png" align="right" height="139" alt="" />

<!-- badges: start -->
<!-- badges: end -->

## Overview

The goal of `rgts` is to provide convenient methods for accessing and
downloading the GridTimeSeries (GTS) data for Norway
(api.nve.no/doc/gridtimeseries-data-gts/) from the Norwegian Water
Resources and Energy Directorate (NVE). This data repository contains
1x1 km grid time series data for Norway and includes several weather and
environmental parameters, such as temperature, precipitation, wind
direction and strength and snow depth. Data is available at 1h, 3h and
daily intervals depending on the variable of interest. Many of the daily
variables go back from present to 1957.

## Installation

You can install the development version of `rgts` from
[GitHub](https://github.com/) with:

``` r
# install.packages("devtools")
devtools::install_github("thomas-kvalnes/rgts")
```

## Features

``` r
library(rgts)
```

The variables available in the GridTimeSeries (GTS) data can be listed
using the `gts_parameters`-function. Here we show the first five:

``` r
head(gts_parameters(), 5)
#>   Name            Fullname NoDataValue RawUnit HumanReadableUnit
#> 1   rr          Døgnnedbør       65535      mm                mm
#> 2 rr3d Nedbør siste 3 døgn       65535      mm                mm
#> 3 rr1h       Nedbør 1 time       65535      mm                mm
#> 4 rr3h      Nedbør 3 timer       65535      mm                mm
#> 5  rrl                Regn       65535      mm                mm
#>   TimeResolutionInMinutes FirstDateInTimeSerie
#> 1                    1440           1957-01-01
#> 2                    1440           2010-01-01
#> 3                      60           2010-01-01
#> 4                     180           2010-01-01
#> 5                    1440           1957-01-01
```

The `Name` column contain the parameter names which is used to specify
which data layer to download. Downloading GTS data is made simple by a
set of functions with prefix `gts_dl_...`. We can download data for
points of interest with `gts_dl_points`, and for areas of interest with
`gts_dl_polygon` or `gts_dl_polygon_aggr`. The first returns values for
each grid cell within the polygon, while the latter returns aggregated
values across the grid cells within the polygon. Faster downloads for
areas or points can be done with the `gts_dl_cellindex` and
`gts_dl_cellindex_aggr`-functions, if the cellindex for each grid cell
of interest is known or identified using the `gts_cellindex`-function.
See the ‘Get started’ tab for more details on using all of these
functions. As a brief first demonstration, data for grid cells which
contain some points of interest can be downloaded using:

``` r
## Create a data frame with coordinates
coords <- data.frame(x = c(58200, 74225), y = c(6708225, 6715025))
## Download data
gts_dl_coords(coords = coords, parameter = "tm", start_date = "2023-12-01", end_date = "2023-12-02")
#>       x       y cellindex altitude       date  time time_resolution_minutes
#> 1 58200 6708225   1542878     1294 2023-12-01 00:00                    1440
#> 2 58200 6708225   1542878     1294 2023-12-02 00:00                    1440
#> 3 74225 6715025   1534529     1371 2023-12-01 00:00                    1440
#> 4 74225 6715025   1534529     1371 2023-12-02 00:00                    1440
#>      unit    tm
#> 1 Celcius -13.8
#> 2 Celcius -13.0
#> 3 Celcius -15.2
#> 4 Celcius -14.1
```

Here the coordinates we supplied are returned, as well as the
corresponding cellindex, average altitude in the grid cell, date, time,
time resolution, units of measurement and the values of `tm`, the
parameter of interest, in these grid cells.

## More information about data

Questions about the data should be directed to
[NVE](https://www.nve.no/om-nve/kontakt/). The R-package maintainer is
only responsible for developing the `rgts`-package which provide access
to the data.
