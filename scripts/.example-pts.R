library(data.table)
library(spatsoc)

DT <- data.table(
  X = c(
    700291,
    700390,
    700244,
    700451,
    700406,
    700604,
    700399,
    700345,
    700204,
    700694,
    700731,
    700602
  ),
  Y = c(
    5508822,
    5508621,
    5508352,
    5508505,
    5508632,
    5508771,
    5508324,
    5508612,
    5508724,
    5508322,
    5508525,
    5508627
  ),
  ID = rep(c("E", "F", "G", "H"), each = 3),
  datetime = c(
    as.POSIXct('2017-02-05 00:00:00'),
    as.POSIXct('2017-02-05 00:58:40'),
    as.POSIXct('2017-02-05 02:00:00'),

    as.POSIXct('2017-02-05 00:01:00'),
    as.POSIXct('2017-02-05 01:00:00'),
    as.POSIXct('2017-02-05 01:58:00'),

    as.POSIXct('2017-02-05 00:01:01'),
    as.POSIXct('2017-02-05 00:58:40'),
    as.POSIXct('2017-02-05 01:58:56'),

    as.POSIXct('2017-02-05 00:02:00'),
    as.POSIXct('2017-02-05 01:02:20'),
    as.POSIXct('2017-02-05 02:02:00')

  ),
  highlight = c(F, T, F, F, T, F, F, T, F, F, T, F),
  ord = c(1, 5, 9,
          2, 6, 10,
          3, 7, 11,
          4, 8, 12)
)

group_times(DT, 'datetime', '5 minutes')

group_pts(DT, 50, 'ID', c('X', 'Y'), 'timegroup')

saveRDS(DT, 'objects/data/example-pts.Rds')
