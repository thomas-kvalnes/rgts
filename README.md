
<!-- README.md is generated from README.Rmd. Please edit that file -->

# rgts

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
gts_parameters()
#>                        Name                                      Fullname
#> 1                        rr                                    Døgnnedbør
#> 2                      rr3d                           Nedbør siste 3 døgn
#> 3                      rr1h                                 Nedbør 1 time
#> 4                      rr3h                                Nedbør 3 timer
#> 5                       rrl                                          Regn
#> 6                     rrl3h                                          Regn
#> 7                 rrprrrxm5                           *Nedbør i % av 5 år
#> 8             rr3hprrr3hxm5 3 timer nedbør i % av 5 års gjentaksnedbør 3t
#> 9                   rrmix3h                              Nysnø og regn 3t
#> 10                     rrsc                                Nedbør som snø
#> 11                   rrsc3h                             Nedbør som snø 3t
#> 12                   darr3h        Disaggregert nedbør seNorge2018_v22.09
#> 13                       tm                                Døgntemperatur
#> 14                     tm1h                             Temperatur 1 time
#> 15                     tm3h                            Temperatur 3 timer
#> 16                   datm3h    Disaggregert temperatur seNorge2018_v22.09
#> 17                      swe                                     Snømengde
#> 18                    swe3h                      Snøens vannekvivalent 3t
#> 19                 snowload                                       Snølast
#> 20                       sd                                      Snødybde
#> 21                     sd3h                              Snødybde 3 timer
#> 22                    swepr                           Snømengde i prosent
#> 23                      age                                  Snøens alder
#> 24                      sca                               Snødekningsgrad
#> 25                      ski                                       Skiføre
#> 26                      qtt                           Regn og snøsmelting
#> 27                    qtt3h             Regn og snøsmelting siste 3 timer
#> 28                    qtt7d                 Regn og snøsmelting siste uke
#> 29                   qtt10d            Regn og snøsmelting siste 10 dager
#> 30                  qttsdai                              Sørpeskredindeks
#> 31                    gwb_q                                     Avrenning
#> 32                  gwb_eva                                   Fordampning
#> 33                  qtt3dls                         *Vanntilførsel 3 døgn
#> 34                     tmgr                             Temperaturendring
#> 35              swechange7d                         Snø endring siste uke
#> 36                      fsw                              Nysnø siste døgn
#> 37                    fsw3h                           Nysnø siste 3 timer
#> 38                    fsw3d                            Nysnø siste 3 døgn
#> 39                    fsw7d                               Nysnø siste uke
#> 40                    sdfsw                                    Nysnødybde
#> 41                  sdfsw3h                      Nysnødybde siste 3 timer
#> 42                      qsw                        Snøsmelting siste døgn
#> 43                    qsw7d                     Snøsmelting sum siste uke
#> 44                    qsw3h                           Snøsmelting 3 timer
#> 45                      lwc                                   Snøtilstand
#> 46                    lwc3h                           Snøtilstand 3 timer
#> 47               gwb_sssdev                          Jordas vannkapasitet
#> 48                  gwb_frd                                       Teledyp
#> 49               gwb_sssrel                            Vannmetning i jord
#> 50                  sdfsw3d                             Nysnødybde 3 døgn
#> 51         gwb_qttprrrxm200                 Vanntilførsel 1 døgn % 200 år
#> 52       gwb_qtt3dprrrxm200                 Vanntilførsel 3 døgn % 200 år
#> 53         gwb_qprqxyrx30yr                     Avrenning i % av maksimum
#> 54     gwb_qttprqttxyrx30yr                 Vanntilførsel 1 døgn i % maks
#> 55 gwb_qtt3dprqtt3dxyrx30yr                 Vanntilførsel 3 døgn i % maks
#> 56      additionalSnowDepth                                 Fokksnøindeks
#> 57          depthHoarIndex1                         Begerkrystallindeks 2
#> 58          depthHoarIndex2                         Begerkrystallindeks 2
#> 59                  gwb_qtt                             HBV Vanntilførsel
#> 60      gwb_landslideindex1                              xJordskredindeks
#> 61      gwb_landslideindex2                             xJordskredindeks2
#> 62                    qttls                                *Vanntilførsel
#> 63               gwb_gwtdev                         Døgnendring Grunnvann
#> 64                  gwb_gwt                                     Grunnvann
#> 65                gwb_qtt3d                      HBV Vanntilførsel 3 døgn
#> 66    gwb_qttprgwb_rryr30yr                          Vanntilførsel 1 døgn
#> 67             gwb_qtt3dlst                          Vanntilførsel 3 døgn
#> 68                  sdfsw7d                            xNysnødybde 7 døgn
#> 69                  swerank                        Snømengde rangert (NY)
#> 70    windDirection10m24h06                          Vindretning 10m døgn
#> 71       windDirection10m1h                        Vindretning 10m 1 time
#> 72       windDirection10m3h                       Vindretning 10m 3 timer
#> 73        windSpeed10m24h06                        Vindhastighet 10m døgn
#> 74           windSpeed10m1h                      Vindhastighet 10m 1 time
#> 75           windSpeed10m3h                     Vindhastighet 10m 3 timer
#> 76                qswenergy           Snøsmelting fra energibalanse model
#> 77              qswenergy3h    Snøsmelting 3timer fra energibalanse model
#> 78           slushflowRatio                            Forholdstall sørpe
#> 79                   fmi10d              Fryse tine grader siste 10 dager
#>    NoDataValue       RawUnit HumanReadableUnit TimeResolutionInMinutes
#> 1        65535            mm                mm                    1440
#> 2        65535            mm                mm                    1440
#> 3        65535            mm                mm                      60
#> 4        65535            mm                mm                     180
#> 5        65535            mm                mm                    1440
#> 6        65535            mm                mm                     180
#> 7        65535             %                 %                    1440
#> 8        65535             %                 %                    1440
#> 9        65535            mm                mm                     180
#> 10       65535            mm                mm                    1440
#> 11       65535            mm                mm                     180
#> 12       65535            mm                mm                     180
#> 13       65535        Kelvin           Celcius                    1440
#> 14       65535        Kelvin           Celcius                      60
#> 15       65535        Kelvin           Celcius                     180
#> 16       65535        Kelvin           Celcius                     180
#> 17       65535            mm                mm                    1440
#> 18       65535            mm                mm                     180
#> 19       65535         kg/m2             kg/m2                    1440
#> 20       65535            mm                cm                    1440
#> 21       65535            mm                cm                     180
#> 22       65535             %                 %                    1440
#> 23         255         Dager             Dager                    1440
#> 24       65535             %                 %                    1440
#> 25         255 Skiføreklasse     Skiføreklasse                    1440
#> 26         255            mm                mm                    1440
#> 27         255            mm                mm                     180
#> 28       65535            mm                mm                    1440
#> 29       65535            mm                mm                    1440
#> 30       65535            mm                mm                    1440
#> 31       65535            mm                mm                    1440
#> 32         255            mm                mm                    1440
#> 33       65535             %                 %                    1440
#> 34       32767    Celcius/10           Celcius                    1440
#> 35       32767            mm                mm                    1440
#> 36         255            mm                mm                    1440
#> 37         255            mm                mm                     180
#> 38       65535            mm                mm                    1440
#> 39       65535            mm                mm                    1440
#> 40       65535            mm                cm                    1440
#> 41       65535            mm                cm                     180
#> 42         255            mm                mm                    1440
#> 43       65535            mm                mm                    1440
#> 44         255            mm                mm                     180
#> 45         255             %                 %                    1440
#> 46         255             %                 %                     180
#> 47       65535            mm                mm                    1440
#> 48       65535            cm                cm                    1440
#> 49       65535             %                 %                    1440
#> 50       65535            mm                cm                    1440
#> 51       65535             %                 %                    1440
#> 52       65535             %                 %                    1440
#> 53       65535             %                 %                    1440
#> 54       65535             %                 %                    1440
#> 55       65535             %                 %                    1440
#> 56       65535            mm                cm                    1440
#> 57       65535     C/m dager         C/m dager                    1440
#> 58       65535         dager             dager                    1440
#> 59       65535            mm                mm                    1440
#> 60       65535         Index             Index                    1440
#> 61       65535         Index             Index                    1440
#> 62       65535             %                 %                    1440
#> 63       32767            mm                mm                    1440
#> 64       65535            mm                mm                    1440
#> 65       65535            mm                mm                    1440
#> 66       65535             %                 %                    1440
#> 67       65535             %                 %                    1440
#> 68       65535            mm                cm                    1440
#> 69         255                                                    1440
#> 70       65535                                                    1440
#> 71       65535                                                      60
#> 72       65535                                                     180
#> 73       65535           m/s               m/s                    1440
#> 74       65535           m/s               m/s                      60
#> 75       65535           m/s               m/s                     180
#> 76       65535            mm                mm                    1440
#> 77       65535            mm                mm                     180
#> 78       65535  Forholdstall      Forholdstall                    1440
#> 79       65535    Døgngrader        Døgngrader                    1440
#>    FirstDateInTimeSerie
#> 1            1957-01-01
#> 2            2010-01-01
#> 3            2010-01-01
#> 4            2010-01-01
#> 5            1957-01-01
#> 6            2010-01-01
#> 7            2018-01-01
#> 8            2010-01-01
#> 9            2010-01-01
#> 10           1957-01-01
#> 11           2010-01-01
#> 12           1971-01-01
#> 13           1957-01-01
#> 14           2010-01-01
#> 15           2010-01-01
#> 16           1971-01-01
#> 17           1957-01-01
#> 18           2010-01-01
#> 19           2000-01-01
#> 20           1957-01-01
#> 21           2010-01-01
#> 22           1957-01-01
#> 23           1957-01-01
#> 24           1957-01-01
#> 25           1957-01-01
#> 26           1957-01-01
#> 27           2010-01-01
#> 28           1957-01-01
#> 29           1957-01-01
#> 30           1957-01-01
#> 31           1957-01-01
#> 32           1957-01-01
#> 33           1957-01-01
#> 34           2018-01-01
#> 35           1957-01-01
#> 36           1957-01-01
#> 37           2010-01-01
#> 38           1957-01-01
#> 39           1957-01-01
#> 40           1957-01-01
#> 41           2010-01-01
#> 42           1957-01-01
#> 43           1957-01-01
#> 44           2010-01-01
#> 45           1957-01-01
#> 46           2010-01-01
#> 47           1957-01-01
#> 48           1957-01-01
#> 49           1957-01-01
#> 50           1957-01-01
#> 51           1957-01-01
#> 52           1957-01-01
#> 53           1957-01-01
#> 54           1957-01-01
#> 55           1957-01-01
#> 56           2021-01-01
#> 57           2010-01-01
#> 58           2010-01-01
#> 59           1957-01-01
#> 60           1957-01-01
#> 61           1957-01-01
#> 62           1957-01-01
#> 63           1957-01-01
#> 64           1957-01-01
#> 65           1957-01-01
#> 66           1957-01-01
#> 67           1957-01-01
#> 68           1957-01-01
#> 69           1957-01-01
#> 70           2010-01-01
#> 71           2010-01-01
#> 72           2010-01-01
#> 73           2010-01-01
#> 74           2010-01-01
#> 75           2010-01-01
#> 76           2019-01-01
#> 77           2019-01-01
#> 78           1957-01-01
#> 79           1957-01-01
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
#> Linking to GEOS 3.11.2, GDAL 3.7.2, PROJ 9.3.0; sf_use_s2() is TRUE
xx <- c(58200, 74225, 58200, 74226)
yy <- c(6708225, 6708225, 6715025, 6715025)
pol <- st_as_sf(x = data.frame(x = xx, y = yy), coords = c("x", "y"), crs = 25833)
pol <- st_as_sf(st_as_sfc(st_bbox(pol)))
```

We can now take this polygon and download daily temperature data (“tm”)
for all grid cells within the polygon. First we need to convert the
polygon to json using the function sf_to_json().

``` r
## Convert to json
pol <- sf_to_json(pol)
## Download data
gts_dl_polygon(polygon = pol, env_layer = "tm", start_date = "2023-12-01", end_date = "2023-12-01")
#>     cellindex altitude       date  time time_resolution_minutes    unit    tm
#> 1     1535708     1245 2023-12-01 00:00                    1440 Celcius -12.9
#> 2     1535709     1314 2023-12-01 00:00                    1440 Celcius -13.5
#> 3     1535710     1177 2023-12-01 00:00                    1440 Celcius -12.5
#> 4     1535711     1083 2023-12-01 00:00                    1440 Celcius -11.9
#> 5     1535712     1096 2023-12-01 00:00                    1440 Celcius -12.1
#> 6     1535713     1100 2023-12-01 00:00                    1440 Celcius -12.1
#> 7     1535714     1136 2023-12-01 00:00                    1440 Celcius -12.4
#> 8     1535715      975 2023-12-01 00:00                    1440 Celcius -11.6
#> 9     1535716     1009 2023-12-01 00:00                    1440 Celcius -11.8
#> 10    1535717      961 2023-12-01 00:00                    1440 Celcius -11.6
#> 11    1535718     1013 2023-12-01 00:00                    1440 Celcius -11.9
#> 12    1535719     1198 2023-12-01 00:00                    1440 Celcius -13.2
#> 13    1535720     1224 2023-12-01 00:00                    1440 Celcius -13.8
#> 14    1535721     1273 2023-12-01 00:00                    1440 Celcius -14.3
#> 15    1535722     1357 2023-12-01 00:00                    1440 Celcius -15.0
#> 16    1535723     1441 2023-12-01 00:00                    1440 Celcius -15.8
#> 17    1536903     1259 2023-12-01 00:00                    1440 Celcius -13.0
#> 18    1536904     1241 2023-12-01 00:00                    1440 Celcius -13.0
#> 19    1536905     1121 2023-12-01 00:00                    1440 Celcius -12.2
#> 20    1536906     1045 2023-12-01 00:00                    1440 Celcius -11.8
#> 21    1536907     1041 2023-12-01 00:00                    1440 Celcius -11.8
#> 22    1536908     1048 2023-12-01 00:00                    1440 Celcius -11.9
#> 23    1536909     1009 2023-12-01 00:00                    1440 Celcius -11.8
#> 24    1536910     1032 2023-12-01 00:00                    1440 Celcius -11.9
#> 25    1536911      922 2023-12-01 00:00                    1440 Celcius -11.5
#> 26    1536912     1014 2023-12-01 00:00                    1440 Celcius -11.9
#> 27    1536913     1102 2023-12-01 00:00                    1440 Celcius -12.5
#> 28    1536914     1139 2023-12-01 00:00                    1440 Celcius -12.8
#> 29    1536915     1140 2023-12-01 00:00                    1440 Celcius -13.0
#> 30    1536916     1205 2023-12-01 00:00                    1440 Celcius -13.8
#> 31    1536917     1270 2023-12-01 00:00                    1440 Celcius -14.4
#> 32    1536918     1436 2023-12-01 00:00                    1440 Celcius -15.8
#> 33    1538098     1200 2023-12-01 00:00                    1440 Celcius -12.8
#> 34    1538099     1188 2023-12-01 00:00                    1440 Celcius -12.8
#> 35    1538100     1093 2023-12-01 00:00                    1440 Celcius -12.1
#> 36    1538101     1092 2023-12-01 00:00                    1440 Celcius -12.1
#> 37    1538102     1176 2023-12-01 00:00                    1440 Celcius -12.8
#> 38    1538103     1085 2023-12-01 00:00                    1440 Celcius -12.2
#> 39    1538104     1091 2023-12-01 00:00                    1440 Celcius -12.3
#> 40    1538105     1114 2023-12-01 00:00                    1440 Celcius -12.5
#> 41    1538106     1010 2023-12-01 00:00                    1440 Celcius -12.0
#> 42    1538107      979 2023-12-01 00:00                    1440 Celcius -11.9
#> 43    1538108     1137 2023-12-01 00:00                    1440 Celcius -12.8
#> 44    1538109     1224 2023-12-01 00:00                    1440 Celcius -13.5
#> 45    1538110     1232 2023-12-01 00:00                    1440 Celcius -13.8
#> 46    1538111     1238 2023-12-01 00:00                    1440 Celcius -13.8
#> 47    1538112     1210 2023-12-01 00:00                    1440 Celcius -13.8
#> 48    1538113     1276 2023-12-01 00:00                    1440 Celcius -14.4
#> 49    1539293     1342 2023-12-01 00:00                    1440 Celcius -13.8
#> 50    1539294     1325 2023-12-01 00:00                    1440 Celcius -13.8
#> 51    1539295     1220 2023-12-01 00:00                    1440 Celcius -13.0
#> 52    1539296     1142 2023-12-01 00:00                    1440 Celcius -12.5
#> 53    1539297     1182 2023-12-01 00:00                    1440 Celcius -12.9
#> 54    1539298     1140 2023-12-01 00:00                    1440 Celcius -12.6
#> 55    1539299     1144 2023-12-01 00:00                    1440 Celcius -12.8
#> 56    1539300     1161 2023-12-01 00:00                    1440 Celcius -12.9
#> 57    1539301     1007 2023-12-01 00:00                    1440 Celcius -12.0
#> 58    1539302     1025 2023-12-01 00:00                    1440 Celcius -12.2
#> 59    1539303     1123 2023-12-01 00:00                    1440 Celcius -12.8
#> 60    1539304     1210 2023-12-01 00:00                    1440 Celcius -13.5
#> 61    1539305     1268 2023-12-01 00:00                    1440 Celcius -14.1
#> 62    1539306     1310 2023-12-01 00:00                    1440 Celcius -14.5
#> 63    1539307     1244 2023-12-01 00:00                    1440 Celcius -14.0
#> 64    1539308     1310 2023-12-01 00:00                    1440 Celcius -14.6
#> 65    1540488     1266 2023-12-01 00:00                    1440 Celcius -13.3
#> 66    1540489     1352 2023-12-01 00:00                    1440 Celcius -14.0
#> 67    1540490     1214 2023-12-01 00:00                    1440 Celcius -13.1
#> 68    1540491     1089 2023-12-01 00:00                    1440 Celcius -12.3
#> 69    1540492     1105 2023-12-01 00:00                    1440 Celcius -12.4
#> 70    1540493     1099 2023-12-01 00:00                    1440 Celcius -12.4
#> 71    1540494     1142 2023-12-01 00:00                    1440 Celcius -12.8
#> 72    1540495     1181 2023-12-01 00:00                    1440 Celcius -13.1
#> 73    1540496     1006 2023-12-01 00:00                    1440 Celcius -12.1
#> 74    1540497     1021 2023-12-01 00:00                    1440 Celcius -12.2
#> 75    1540498     1142 2023-12-01 00:00                    1440 Celcius -13.0
#> 76    1540499     1188 2023-12-01 00:00                    1440 Celcius -13.4
#> 77    1540500     1208 2023-12-01 00:00                    1440 Celcius -13.6
#> 78    1540501     1228 2023-12-01 00:00                    1440 Celcius -13.9
#> 79    1540502     1283 2023-12-01 00:00                    1440 Celcius -14.4
#> 80    1540503     1459 2023-12-01 00:00                    1440 Celcius -15.8
#> 81    1541683     1242 2023-12-01 00:00                    1440 Celcius -13.2
#> 82    1541684     1152 2023-12-01 00:00                    1440 Celcius -12.6
#> 83    1541685     1136 2023-12-01 00:00                    1440 Celcius -12.6
#> 84    1541686     1191 2023-12-01 00:00                    1440 Celcius -13.0
#> 85    1541687     1045 2023-12-01 00:00                    1440 Celcius -12.1
#> 86    1541688     1063 2023-12-01 00:00                    1440 Celcius -12.3
#> 87    1541689     1075 2023-12-01 00:00                    1440 Celcius -12.3
#> 88    1541690     1144 2023-12-01 00:00                    1440 Celcius -12.8
#> 89    1541691     1097 2023-12-01 00:00                    1440 Celcius -12.5
#> 90    1541692      991 2023-12-01 00:00                    1440 Celcius -11.9
#> 91    1541693     1018 2023-12-01 00:00                    1440 Celcius -12.2
#> 92    1541694     1121 2023-12-01 00:00                    1440 Celcius -12.9
#> 93    1541695     1193 2023-12-01 00:00                    1440 Celcius -13.5
#> 94    1541696     1273 2023-12-01 00:00                    1440 Celcius -14.2
#> 95    1541697     1431 2023-12-01 00:00                    1440 Celcius -15.5
#> 96    1541698     1367 2023-12-01 00:00                    1440 Celcius -15.2
#> 97    1542878     1294 2023-12-01 00:00                    1440 Celcius -13.8
#> 98    1542879     1294 2023-12-01 00:00                    1440 Celcius -13.8
#> 99    1542880     1243 2023-12-01 00:00                    1440 Celcius -13.4
#> 100   1542881     1263 2023-12-01 00:00                    1440 Celcius -13.8
#> 101   1542882     1110 2023-12-01 00:00                    1440 Celcius -12.6
#> 102   1542883     1052 2023-12-01 00:00                    1440 Celcius -12.3
#> 103   1542884     1047 2023-12-01 00:00                    1440 Celcius -12.1
#> 104   1542885     1008 2023-12-01 00:00                    1440 Celcius -11.9
#> 105   1542886      994 2023-12-01 00:00                    1440 Celcius -11.9
#> 106   1542887     1080 2023-12-01 00:00                    1440 Celcius -12.5
#> 107   1542888     1105 2023-12-01 00:00                    1440 Celcius -12.8
#> 108   1542889     1184 2023-12-01 00:00                    1440 Celcius -13.5
#> 109   1542890     1334 2023-12-01 00:00                    1440 Celcius -14.8
#> 110   1542891     1506 2023-12-01 00:00                    1440 Celcius -15.9
#> 111   1542892     1459 2023-12-01 00:00                    1440 Celcius -15.8
#> 112   1542893     1481 2023-12-01 00:00                    1440 Celcius -15.9
```

Each 1x1 km grid cell have a unique ID, called cellindex. It is faster
to query the API using cellindices directly instead of going the way
around with polygons. The cellindices for a given polygon can be
obtained by

``` r
cells <- gts_cellindex(polygon = pol)
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

Then the daily temperature data can be obtained by:

``` r
## Download data
gts_dl_cellindex(cellindex = cells, env_layer = "tm", start_date = "2023-12-01", end_date = "2023-12-01")
#>     cellindex altitude       date  time time_resolution_minutes    unit    tm
#> 1     1535708     1245 2023-12-01 00:00                    1440 Celcius -12.9
#> 2     1535709     1314 2023-12-01 00:00                    1440 Celcius -13.5
#> 3     1535710     1177 2023-12-01 00:00                    1440 Celcius -12.5
#> 4     1535711     1083 2023-12-01 00:00                    1440 Celcius -11.9
#> 5     1535712     1096 2023-12-01 00:00                    1440 Celcius -12.1
#> 6     1535713     1100 2023-12-01 00:00                    1440 Celcius -12.1
#> 7     1535714     1136 2023-12-01 00:00                    1440 Celcius -12.4
#> 8     1535715      975 2023-12-01 00:00                    1440 Celcius -11.6
#> 9     1535716     1009 2023-12-01 00:00                    1440 Celcius -11.8
#> 10    1535717      961 2023-12-01 00:00                    1440 Celcius -11.6
#> 11    1535718     1013 2023-12-01 00:00                    1440 Celcius -11.9
#> 12    1535719     1198 2023-12-01 00:00                    1440 Celcius -13.2
#> 13    1535720     1224 2023-12-01 00:00                    1440 Celcius -13.8
#> 14    1535721     1273 2023-12-01 00:00                    1440 Celcius -14.3
#> 15    1535722     1357 2023-12-01 00:00                    1440 Celcius -15.0
#> 16    1535723     1441 2023-12-01 00:00                    1440 Celcius -15.8
#> 17    1536903     1259 2023-12-01 00:00                    1440 Celcius -13.0
#> 18    1536904     1241 2023-12-01 00:00                    1440 Celcius -13.0
#> 19    1536905     1121 2023-12-01 00:00                    1440 Celcius -12.2
#> 20    1536906     1045 2023-12-01 00:00                    1440 Celcius -11.8
#> 21    1536907     1041 2023-12-01 00:00                    1440 Celcius -11.8
#> 22    1536908     1048 2023-12-01 00:00                    1440 Celcius -11.9
#> 23    1536909     1009 2023-12-01 00:00                    1440 Celcius -11.8
#> 24    1536910     1032 2023-12-01 00:00                    1440 Celcius -11.9
#> 25    1536911      922 2023-12-01 00:00                    1440 Celcius -11.5
#> 26    1536912     1014 2023-12-01 00:00                    1440 Celcius -11.9
#> 27    1536913     1102 2023-12-01 00:00                    1440 Celcius -12.5
#> 28    1536914     1139 2023-12-01 00:00                    1440 Celcius -12.8
#> 29    1536915     1140 2023-12-01 00:00                    1440 Celcius -13.0
#> 30    1536916     1205 2023-12-01 00:00                    1440 Celcius -13.8
#> 31    1536917     1270 2023-12-01 00:00                    1440 Celcius -14.4
#> 32    1536918     1436 2023-12-01 00:00                    1440 Celcius -15.8
#> 33    1538098     1200 2023-12-01 00:00                    1440 Celcius -12.8
#> 34    1538099     1188 2023-12-01 00:00                    1440 Celcius -12.8
#> 35    1538100     1093 2023-12-01 00:00                    1440 Celcius -12.1
#> 36    1538101     1092 2023-12-01 00:00                    1440 Celcius -12.1
#> 37    1538102     1176 2023-12-01 00:00                    1440 Celcius -12.8
#> 38    1538103     1085 2023-12-01 00:00                    1440 Celcius -12.2
#> 39    1538104     1091 2023-12-01 00:00                    1440 Celcius -12.3
#> 40    1538105     1114 2023-12-01 00:00                    1440 Celcius -12.5
#> 41    1538106     1010 2023-12-01 00:00                    1440 Celcius -12.0
#> 42    1538107      979 2023-12-01 00:00                    1440 Celcius -11.9
#> 43    1538108     1137 2023-12-01 00:00                    1440 Celcius -12.8
#> 44    1538109     1224 2023-12-01 00:00                    1440 Celcius -13.5
#> 45    1538110     1232 2023-12-01 00:00                    1440 Celcius -13.8
#> 46    1538111     1238 2023-12-01 00:00                    1440 Celcius -13.8
#> 47    1538112     1210 2023-12-01 00:00                    1440 Celcius -13.8
#> 48    1538113     1276 2023-12-01 00:00                    1440 Celcius -14.4
#> 49    1539293     1342 2023-12-01 00:00                    1440 Celcius -13.8
#> 50    1539294     1325 2023-12-01 00:00                    1440 Celcius -13.8
#> 51    1539295     1220 2023-12-01 00:00                    1440 Celcius -13.0
#> 52    1539296     1142 2023-12-01 00:00                    1440 Celcius -12.5
#> 53    1539297     1182 2023-12-01 00:00                    1440 Celcius -12.9
#> 54    1539298     1140 2023-12-01 00:00                    1440 Celcius -12.6
#> 55    1539299     1144 2023-12-01 00:00                    1440 Celcius -12.8
#> 56    1539300     1161 2023-12-01 00:00                    1440 Celcius -12.9
#> 57    1539301     1007 2023-12-01 00:00                    1440 Celcius -12.0
#> 58    1539302     1025 2023-12-01 00:00                    1440 Celcius -12.2
#> 59    1539303     1123 2023-12-01 00:00                    1440 Celcius -12.8
#> 60    1539304     1210 2023-12-01 00:00                    1440 Celcius -13.5
#> 61    1539305     1268 2023-12-01 00:00                    1440 Celcius -14.1
#> 62    1539306     1310 2023-12-01 00:00                    1440 Celcius -14.5
#> 63    1539307     1244 2023-12-01 00:00                    1440 Celcius -14.0
#> 64    1539308     1310 2023-12-01 00:00                    1440 Celcius -14.6
#> 65    1540488     1266 2023-12-01 00:00                    1440 Celcius -13.3
#> 66    1540489     1352 2023-12-01 00:00                    1440 Celcius -14.0
#> 67    1540490     1214 2023-12-01 00:00                    1440 Celcius -13.1
#> 68    1540491     1089 2023-12-01 00:00                    1440 Celcius -12.3
#> 69    1540492     1105 2023-12-01 00:00                    1440 Celcius -12.4
#> 70    1540493     1099 2023-12-01 00:00                    1440 Celcius -12.4
#> 71    1540494     1142 2023-12-01 00:00                    1440 Celcius -12.8
#> 72    1540495     1181 2023-12-01 00:00                    1440 Celcius -13.1
#> 73    1540496     1006 2023-12-01 00:00                    1440 Celcius -12.1
#> 74    1540497     1021 2023-12-01 00:00                    1440 Celcius -12.2
#> 75    1540498     1142 2023-12-01 00:00                    1440 Celcius -13.0
#> 76    1540499     1188 2023-12-01 00:00                    1440 Celcius -13.4
#> 77    1540500     1208 2023-12-01 00:00                    1440 Celcius -13.6
#> 78    1540501     1228 2023-12-01 00:00                    1440 Celcius -13.9
#> 79    1540502     1283 2023-12-01 00:00                    1440 Celcius -14.4
#> 80    1540503     1459 2023-12-01 00:00                    1440 Celcius -15.8
#> 81    1541683     1242 2023-12-01 00:00                    1440 Celcius -13.2
#> 82    1541684     1152 2023-12-01 00:00                    1440 Celcius -12.6
#> 83    1541685     1136 2023-12-01 00:00                    1440 Celcius -12.6
#> 84    1541686     1191 2023-12-01 00:00                    1440 Celcius -13.0
#> 85    1541687     1045 2023-12-01 00:00                    1440 Celcius -12.1
#> 86    1541688     1063 2023-12-01 00:00                    1440 Celcius -12.3
#> 87    1541689     1075 2023-12-01 00:00                    1440 Celcius -12.3
#> 88    1541690     1144 2023-12-01 00:00                    1440 Celcius -12.8
#> 89    1541691     1097 2023-12-01 00:00                    1440 Celcius -12.5
#> 90    1541692      991 2023-12-01 00:00                    1440 Celcius -11.9
#> 91    1541693     1018 2023-12-01 00:00                    1440 Celcius -12.2
#> 92    1541694     1121 2023-12-01 00:00                    1440 Celcius -12.9
#> 93    1541695     1193 2023-12-01 00:00                    1440 Celcius -13.5
#> 94    1541696     1273 2023-12-01 00:00                    1440 Celcius -14.2
#> 95    1541697     1431 2023-12-01 00:00                    1440 Celcius -15.5
#> 96    1541698     1367 2023-12-01 00:00                    1440 Celcius -15.2
#> 97    1542878     1294 2023-12-01 00:00                    1440 Celcius -13.8
#> 98    1542879     1294 2023-12-01 00:00                    1440 Celcius -13.8
#> 99    1542880     1243 2023-12-01 00:00                    1440 Celcius -13.4
#> 100   1542881     1263 2023-12-01 00:00                    1440 Celcius -13.8
#> 101   1542882     1110 2023-12-01 00:00                    1440 Celcius -12.6
#> 102   1542883     1052 2023-12-01 00:00                    1440 Celcius -12.3
#> 103   1542884     1047 2023-12-01 00:00                    1440 Celcius -12.1
#> 104   1542885     1008 2023-12-01 00:00                    1440 Celcius -11.9
#> 105   1542886      994 2023-12-01 00:00                    1440 Celcius -11.9
#> 106   1542887     1080 2023-12-01 00:00                    1440 Celcius -12.5
#> 107   1542888     1105 2023-12-01 00:00                    1440 Celcius -12.8
#> 108   1542889     1184 2023-12-01 00:00                    1440 Celcius -13.5
#> 109   1542890     1334 2023-12-01 00:00                    1440 Celcius -14.8
#> 110   1542891     1506 2023-12-01 00:00                    1440 Celcius -15.9
#> 111   1542892     1459 2023-12-01 00:00                    1440 Celcius -15.8
#> 112   1542893     1481 2023-12-01 00:00                    1440 Celcius -15.9
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
