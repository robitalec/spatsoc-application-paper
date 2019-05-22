### Figure 1 - group_times ====

### Packages ----
pkgs <- c('data.table',
					'ggplot2',
					'ggthemes',
					'scales',
					'spatsoc',
					'patchwork',
					'gridExtra')
p <- lapply(pkgs, library, character.only = TRUE)

### Data ----
# Spatsoc example data
DT <- fread('data/DT.csv')

tz <- 'America/St_Johns'
DT[, datetime := as.POSIXct(datetime, tz = tz)]

selID <- c('E', 'F', 'G', 'H')
DT <- DT[ID %in% selID]

# Intervals
mintervals <- data.table(mid = as.POSIXct(
  c(
    '2016-11-01 00:00:00',
    '2016-11-01 02:00:00',
    '2016-11-01 04:00:00'
  ), tz = tz
))
mintervals[, c('left', 'right') := .(mid - (2.5 * 60), mid + (2.5 * 60))]

hintervals <- data.table(mid = as.POSIXct(
  c('2016-11-01 02:00:00',
    '2016-11-01 10:00:00',
    '2016-11-01 18:00:00'
  ), tz = tz
))

dintervals <- data.table(mid = as.POSIXct(
  c('2017-01-03 00:00:00',
    '2017-01-13 00:00:00',
    '2017-01-23 00:00:00',
    '2017-02-02 00:00:00'
  ), tz = tz
))


### Set theme ----
pal <- c("#E69F00", "#56B4E9", "#009E73", "#F0E442")

theme_set(theme_classic())

font <- 'Futura'
fontSize <- 24
gridTheme <- gridExtra::ttheme_default(
  base_family = font,
  base_size = fontSize
)

### Plots ----
DT[, ID := factor(ID, levels = c('H', 'G', 'F', 'E'))]

# Full temporal
fullts <- ggplot(DT) +
	geom_point(aes(datetime, ID,
								 color = ID), size = 0.5) +
	labs(x = NULL, y = NULL) +
	guides(color = FALSE) +
	theme(axis.text.x = element_blank(),
				axis.ticks.x = element_blank()) +
	scale_color_manual(breaks = DT$ID,
										 values = pal)

# Detail minutes temporal
n <- 1
detailDT <- DT[order(datetime)][, .SD[1:n], ID]
mins <- ggplot(detailDT) +
	geom_vline(aes(xintercept = mid),
						 data = mintervals,
						 size = 1,
						 alpha = 0.8) +
	geom_vline(aes(xintercept = left), data = mintervals, size = 0.5) +
	geom_vline(aes(xintercept = right), data = mintervals, size = 0.5) +
	geom_point(aes(trunc(datetime, unit = 'mins') + c(120, 0, 14, -80),
								 ID, color = ID), size = 2) +
	labs(x = NULL, y = NULL) +
	guides(color = FALSE) +
	scale_x_datetime(limits = mintervals[1, mid + c(-60 * 5, 60 * 5)],
									 labels = date_format("%H:%M")) +
	scale_color_manual(breaks = DT$ID,
										 values = pal)

# Detail hours temporal
n <- 10
detailDT <- DT[order(datetime)][, .SD[1:n], ID]
detailDT[, datetime := datetime + runif(.N, -300, 300)]
hours <- ggplot(detailDT) +
	geom_vline(aes(xintercept = mid), data = hintervals) +
	geom_point(aes(datetime, ID,
								 color = ID)) +
	labs(x = NULL, y = NULL) +
	guides(color = FALSE) +
	scale_x_datetime(labels = date_format("%H:%M"),
									 breaks = hintervals$mid) +
	scale_color_manual(breaks = DT$ID,
										 values = pal)


# Detail days temporal
n <- 40
detailDT <- DT[year(datetime) == 2017 & yday(datetime) < n]
days <- ggplot(detailDT) +
	geom_vline(aes(xintercept = mid), data = dintervals) +
	geom_point(aes(datetime, ID,
								 color = ID)) +
	labs(x = NULL, y = NULL) +
	guides(color = FALSE) +
	scale_x_datetime(labels = date_format("%m/%d"),
									 breaks = dintervals$mid) +
	scale_color_manual(breaks = DT$ID,
										 values = pal)


### Output
fig1 <-
	fullts / (mins + hours + days) +
	plot_annotation(tag_levels = 'A') +
	plot_layout(heights = c(1, 2)) &
	theme(plot.tag = element_text(size = 12, face = 2),
				panel.border = element_rect(fill = NA))


ggsave(
	filename = 'objects/Figure1.pdf',
	plot = fig1,
	width = 220,
	height = 120,
	units = 'mm'
)
