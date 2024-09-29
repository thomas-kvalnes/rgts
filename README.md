
<!-- README.md is generated from README.Rmd. Please edit that file -->

# rgts <img src="man/figures/logo.png" align="right" height="139" alt="" />

<!-- badges: start -->
<!-- badges: end -->

## Overview

The goal of rgts is to provide convenient methods for accessing and
downloading the GridTimeSeries (GTS) data for Norway
(api.nve.no/doc/gridtimeseries-data-gts/) from the Norwegian Water
Resources and Energy Directorate (NVE). This data reposiory contains 1x1
km gridded time series data for Norway and includes several weather and
environmental parameters, such as temperature, precipitation, wind
direction and strength and snow depth. Data is available at 1h, 3h and
daily intervals depending on the variable of interest. Many of the daily
variables go back from present to 1957.

## Installation

You can install the development version of rgts from
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
using gts_parameters(). Here we show the first five:

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

If we have some points of interest we can download data for the points
in grid cells using:

``` r
## Create a data frame with coordinates
coords <- data.frame(x = c(58200, 74225), y = c(6708225, 6715025))
## Download data
gts_dl_coords(coords = coords, env_layer = "tm", start_date = "2023-12-01", end_date = "2023-12-02")
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

Lets create a polygon, which we imagine covers an area of interest at
Hardangervidda in Norway.

``` r
## Create a sf polygon
library(sf)
#> Linking to GEOS 3.12.1, GDAL 3.8.4, PROJ 9.3.1; sf_use_s2() is TRUE
xx <- c(58200, 74225, 58200, 74226)
yy <- c(6708225, 6708225, 6715025, 6715025)
points <- st_as_sf(x = data.frame(x = xx, y = yy), coords = c("x", "y"), crs = 25833)
pol <- st_as_sf(st_as_sfc(st_bbox(points)))
```

We can now take this polygon and download daily temperature data (“tm”)
for all grid cells within the polygon. First we need to convert the
polygon to json using the function sf_to_json(). We only show the first
10 lines of data.

``` r
## Convert to json
pol_json <- gts_sf2json(pol)
## Download data
head(gts_dl_polygon(polygon = pol_json, env_layer = "tm", start_date = "2023-12-01", end_date = "2023-12-01"), 10)
#>    cellindex altitude       date  time time_resolution_minutes    unit    tm
#> 1    1535708     1245 2023-12-01 00:00                    1440 Celcius -12.9
#> 2    1535709     1314 2023-12-01 00:00                    1440 Celcius -13.5
#> 3    1535710     1177 2023-12-01 00:00                    1440 Celcius -12.5
#> 4    1535711     1083 2023-12-01 00:00                    1440 Celcius -11.9
#> 5    1535712     1096 2023-12-01 00:00                    1440 Celcius -12.1
#> 6    1535713     1100 2023-12-01 00:00                    1440 Celcius -12.1
#> 7    1535714     1136 2023-12-01 00:00                    1440 Celcius -12.4
#> 8    1535715      975 2023-12-01 00:00                    1440 Celcius -11.6
#> 9    1535716     1009 2023-12-01 00:00                    1440 Celcius -11.8
#> 10   1535717      961 2023-12-01 00:00                    1440 Celcius -11.6
```

Each 1x1 km grid cell have a unique ID, called cellindex. It is faster
to query the API using cellindices directly instead of going the way
around with polygons. The cellindices for a given polygon can be
obtained by

``` r
cells <- gts_cellindex(geometry = pol)
cells
#>   [1] 1535708 1535709 1535710 1535711 1535712 1535713 1535714 1535715 1535716
#>  [10] 1535717 1535718 1535719 1535720 1535721 1535722 1535723 1536903 1536904
#>  [19] 1536905 1536906 1536907 1536908 1536909 1536910 1536911 1536912 1536913
#>  [28] 1536914 1536915 1536916 1536917 1536918 1538098 1538099 1538100 1538101
#>  [37] 1538102 1538103 1538104 1538105 1538106 1538107 1538108 1538109 1538110
#>  [46] 1538111 1538112 1538113 1539293 1539294 1539295 1539296 1539297 1539298
#>  [55] 1539299 1539300 1539301 1539302 1539303 1539304 1539305 1539306 1539307
#>  [64] 1539308 1540488 1540489 1540490 1540491 1540492 1540493 1540494 1540495
#>  [73] 1540496 1540497 1540498 1540499 1540500 1540501 1540502 1540503 1541683
#>  [82] 1541684 1541685 1541686 1541687 1541688 1541689 1541690 1541691 1541692
#>  [91] 1541693 1541694 1541695 1541696 1541697 1541698 1542878 1542879 1542880
#> [100] 1542881 1542882 1542883 1542884 1542885 1542886 1542887 1542888 1542889
#> [109] 1542890 1542891 1542892 1542893
```

Then the daily temperature data can be obtained. Again we only show the
first 10 lines of data.

``` r
## Download data
head(gts_dl_cellindex(cellindex = cells, env_layer = "tm", start_date = "2023-12-01", end_date = "2023-12-01"), 10)
#>    cellindex altitude       date  time time_resolution_minutes    unit    tm
#> 1    1535708     1245 2023-12-01 00:00                    1440 Celcius -12.9
#> 2    1535709     1314 2023-12-01 00:00                    1440 Celcius -13.5
#> 3    1535710     1177 2023-12-01 00:00                    1440 Celcius -12.5
#> 4    1535711     1083 2023-12-01 00:00                    1440 Celcius -11.9
#> 5    1535712     1096 2023-12-01 00:00                    1440 Celcius -12.1
#> 6    1535713     1100 2023-12-01 00:00                    1440 Celcius -12.1
#> 7    1535714     1136 2023-12-01 00:00                    1440 Celcius -12.4
#> 8    1535715      975 2023-12-01 00:00                    1440 Celcius -11.6
#> 9    1535716     1009 2023-12-01 00:00                    1440 Celcius -11.8
#> 10   1535717      961 2023-12-01 00:00                    1440 Celcius -11.6
```

We can also obtain data aggregated across grid cells. We then need to
choose a method for aggregating data, “sum”, “min”, “max”, “avg” or
“median”. Choosing “avg” we can obtain daily averages by:

``` r
## Download data
gts_dl_cellindex_aggr(cellindex = cells, env_layer = "tm", start_date = "2023-12-01", end_date = "2023-12-10", method = "avg")
#>          date  time time_resolution_minutes    unit     tm_avg
#> 1  2023-12-01 00:00                    1440 Celcius -13.075893
#> 2  2023-12-02 00:00                    1440 Celcius -12.500893
#> 3  2023-12-03 00:00                    1440 Celcius -11.951786
#> 4  2023-12-04 00:00                    1440 Celcius -12.035714
#> 5  2023-12-05 00:00                    1440 Celcius -14.912500
#> 6  2023-12-06 00:00                    1440 Celcius -13.713393
#> 7  2023-12-07 00:00                    1440 Celcius  -9.762500
#> 8  2023-12-08 00:00                    1440 Celcius -12.035714
#> 9  2023-12-09 00:00                    1440 Celcius  -9.708036
#> 10 2023-12-10 00:00                    1440 Celcius  -6.480357
```
