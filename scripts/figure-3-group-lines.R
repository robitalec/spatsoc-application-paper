### Figure 3 - group_lines ====

### Packages ----
pkgs <- c('data.table',
					'ggplot2',
					'ggthemes',
					'patchwork',
					'spatsoc',
					'gridExtra')
p <- lapply(pkgs, library, character.only = TRUE)


### Data ----
DT <- fread('data/DT.csv')

tz <- 'America/St_Johns'
DT[, datetime := as.POSIXct(datetime, tz = tz)]

selID <- c('E', 'F', 'G', 'H')
DT <- DT[ID %in% selID]

### Set theme ----
pal <- c("#E69F00", "#56B4E9", "#009E73", "#F0E442")

theme_set(theme_classic())

fontSize <- 24
gridTheme <- gridExtra::ttheme_default(
  base_size = fontSize
)

### Plots ----
DT[, ID := factor(ID, levels = c('H', 'G', 'F', 'E'))]

# Detail spatial lines
n <- 3
detailDT <- DT[yday(datetime) < min(yday(datetime)) + n]
detailDT[ID %in% c('E', 'F'), Y := Y + 1500]
detailDT[ID %in% 'H', X := X - 400]

lns <- ggplot(detailDT) +
	geom_path(aes(X, Y, color = ID, group = ID)) +
	geom_path(
		aes(X, Y, color = ID, group = ID),
		size = 2,
		alpha = 0.6,
		data = detailDT[yday(datetime) == 2]
	) +
	theme(
		axis.text = element_blank(),
		axis.ticks = element_blank(),
		panel.border = element_rect(fill = NA)
	) +
	labs(x = NULL, y = NULL) +
	scale_color_manual(breaks = detailDT$ID,
										 values = pal)



### group_lines ----
utm <- '+proj=utm +zone=21 +ellps=WGS84 +datum=WGS84 +units=m +no_defs'

group_times(detailDT, 'datetime', '1 day')
detailDT[, ID := as.character(ID)]

group_lines(
	DT = detailDT,
	threshold = 50,
	projection = utm,
	id = 'ID',
	coords = c('X', 'Y'),
	timegroup = 'timegroup',
	sortBy = 'datetime'
)

tab <- unique(detailDT[order(timegroup, ID), .(ID, timegroup, group)])
gtab <-
	ggplot() +
	annotation_custom(tableGrob(tab, theme = gridTheme, rows = NULL))


### Output ----
fig3 <- lns + gtab +
	plot_annotation(tag_levels = 'A') &
	theme(
		plot.tag = element_text(size = 18, face = 2),
		legend.position = c(.10, .13),
		legend.text = element_text(size = 16, face = 1),
		legend.title = element_text(size = 16, face = 1)
	)

ggsave(
	filename = 'figures/Figure3.pdf',
	plot = fig3,
	width = 250,
	height = 150,
	units = 'mm'
)


