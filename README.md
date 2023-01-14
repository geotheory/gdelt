
# gdelt

A simple function to pull down any timeseries data from GDELT's [DOC API](https://blog.gdeltproject.org/gdelt-doc-2-0-api-debuts/).

## Installation

``` r
# install.packages("devtools")
devtools::install_github("geotheory/gdelt")
```

## Usage

``` r
library(gdelt)

gdelt('https://api.gdeltproject.org/api/v2/doc/doc?query=(Christmas OR COVID)&mode=TimelineVol&timelinesmooth=7&timespan=5y')
```

You can use [gdelt.github.io](https://gdelt.github.io/#api=doc&query=COVID&timelinemode=TimelineVol&timelinesmooth=0&timespan=5y) to query interactively, and copy the link in bottom-left when ready.
