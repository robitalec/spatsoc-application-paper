# [spatsoc](spatsoc.robitalec.ca) application paper



[![DOI](https://zenodo.org/badge/186687068.svg)](https://zenodo.org/badge/latestdoi/186687068)



- Authors:
  - [Alec L. Robitaille](http://robitalec.ca)
  - [Quinn M.R. Webber](https://qwebber.weebly.com/)
  - [Eric Vander Wal](http://weel.gitlab.io)




### Data

Data used for most figures and tables is the example data from `spatsoc`. The exception is the small mock dataset provided here (`data/example-pts.Rds`).

```r
# install.packages('spatsoc')

library(data.table)
library(spatsoc)

DT <- fread(system.file("extdata", "DT.csv", package = "spatsoc"))
```
