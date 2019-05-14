### Figure 4 - group_polys ====

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

theme_set(theme_classic() +
						theme(axis.text = element_blank()))

fontSize <- 24
gridTheme <- gridExtra::ttheme_default(base_size = fontSize)

### Plots ----
utm <- '+proj=utm +zone=21 +ellps=WGS84 +datum=WGS84 +units=m +no_defs'
percent <- 82

# Detail polygons
DT[ID == 'G', Y := Y + 4500]
polys <- build_polys(
	DT,
	hrType = 'kernel',
	list(percent = percent),
	projection = utm,
	id = 'ID',
	coords = c('X', 'Y')
)

polys$id <- factor(polys$id, levels = c('H', 'G', 'F', 'E'))
pols <- ggplot(polys) +
	geom_polygon(aes(
		x = long,
		y = lat,
		group = id,
		color = id
	), fill = NA) +
	geom_polygon(aes(
		x = long,
		y = lat,
		group = id,
		fill = id
	),
	color = NA,
	alpha = 0.25) +
	scale_color_manual(breaks = polys$id,
										 values = pal) +
	scale_fill_manual(breaks = polys$id,
										values = pal) +
	theme(panel.border = element_rect(fill = NA)) +
	labs(x = NULL,
			 y = NULL,
			 fill = 'ID',
			 color = 'ID')

### group_polys ----
group_polys(
	DT,
	area = FALSE,
	hrType = 'kernel',
	list(percent = percent),
	projection = utm,
	id = 'ID',
	coords = c('X', 'Y')
)

areas <- group_polys(
	DT,
	area = TRUE,
	hrType = 'kernel',
	list(percent = percent),
	projection = utm,
	id = 'ID',
	coords = c('X', 'Y')
)


tab <- unique(DT[order(group, -ID), .(ID, group)])
ovrtab <-
	ggplot() +
	annotation_custom(tableGrob(tab, theme = gridTheme, rows = NULL))

tab <- areas[ID1 != ID2,
						 .(ID1, ID2, area = area / 1e6,
						 	proportion = round(proportion / 10000, digits = 2))]
proptab <-
	ggplot() +
	annotation_custom(tableGrob(tab, theme = gridTheme, rows = NULL))


### Output ----
fig4 <- pols + (ovrtab / proptab) +
	plot_layout(widths = c(1.2, 1)) +
	plot_annotation(tag_levels = 'A') &
	theme(
		plot.tag = element_text(size = 18, face = 2),
		legend.position = c(.10, .8),
		legend.text = element_text(size = 16, face = 1),
		legend.title = element_text(size = 16, face = 1)
	)


ggsave(
	filename = 'figures/Figure4.pdf',
	plot = fig4,
	width = 300,
	height = 160,
	units = 'mm'
)
