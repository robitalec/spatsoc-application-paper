### Figure 5 - edges ====

### Packages ----
pkgs <- c(
	'data.table',
	'ggplot2',
	'patchwork',
	'ggthemes',
	'spatsoc',
	'igraph',
	'ggnetwork',
	'gridExtra'
)
p <- lapply(pkgs, library, character.only = TRUE)

### Import data ----
DT <- readRDS('data/example-pts.Rds')

DT <- DT[timegroup == 2]

DT[ID == 'H', c('X', 'Y') := .(700445, 5508555)]

### Set theme ----
pal <- c("#E69F00", "#56B4E9", "#009E73", "#F0E442")

theme_set(theme_classic())
theme_update(axis.text = element_blank(),
             axis.title = element_blank(),
             axis.ticks = element_blank(),
             aspect.ratio = 1)

fontSize <- 24
gridTheme <- gridExtra::ttheme_default(
  base_size = fontSize
)

### Distance matrix ----
distm <- DT[, as.matrix(dist(cbind(X, Y)))]
distm <- round(distm, digits = 2)

rownames(distm) <- unique(DT$ID)
colnames(distm) <- unique(DT$ID)

m <- melt(distm < 50)
setDT(m)
m <- m[(value) & Var1 != Var2, .(Var1, Var2)]
setnames(m, c('ID1', 'ID2'))

## Edge dist ----
setnames(DT, 'ID', 'ID1')
m[DT, c('X', 'Y') := .(X, Y), on = 'ID1']
m <- merge(m,
					 DT[, .(ID1, X, Y)],
					 by.x = 'ID2',
					 by.y = 'ID1',
					 suffixes = c('', 'end'))
m <- rbind(m, DT[ID1 == 'H', .(ID1, X, Y)], fill = TRUE)


edgedist <-
	ggplot() +
	annotation_custom(tableGrob(m[order(ID1), .(ID1, ID2)], rows = NULL))



gdist <- ggplot(m, aes(
	x = X,
	y = Y,
	xend = Xend,
	yend = Yend
)) +
	geom_edges() +
	geom_nodes(aes(color = ID1), size = 7) +
	geom_nodetext(aes(label = ID1)) +
	scale_color_manual(breaks = DT$ID1, values = pal) +
	guides(color = FALSE) +
	theme(axis.line = element_blank(),
				panel.border = element_rect(fill = NA))


### Edge nn ----
m <- melt(distm)
setDT(m)
m <-
	m[value != 0][, .SD[value == min(value)], Var1][order(value), .(Var1, Var2)]
setnames(m, c('ID', 'NN'))
setnames(DT, 'ID1', 'ID')
m[DT, c('X', 'Y') := .(X, Y), on = 'ID']
m <- merge(m,
					 DT[, .(ID, X, Y)],
					 by.x = 'NN',
					 by.y = 'ID',
					 suffixes = c('', 'end'))


edgenn <-
	ggplot() +
	annotation_custom(tableGrob(m[order(ID), .(ID, NN)], rows = NULL))

gnn <- ggplot(m, aes(
	x = X,
	y = Y,
	xend = Xend,
	yend = Yend
)) +
	geom_edges() +
	geom_nodes(aes(color = ID), size = 7) +
	geom_nodetext(aes(label = ID)) +
	scale_color_manual(breaks = DT$ID, values = pal) +
	guides(color = FALSE) +
	theme(axis.line = element_blank(),
				panel.border = element_rect(fill = NA))

### Output ----
fig5 <- gdist + edgedist + gnn + edgenn +
	plot_layout(ncol = 2, widths = c(3.4, 1)) +
	plot_annotation(tag_levels = 'A') &
	theme(
		plot.tag = element_text(size = 14, face = 2),
		legend.position = c(.9, .75),
		legend.text = element_text(size = 16, face = 1),
		legend.title = element_text(size = 16, face = 1)
	)

ggsave(
	filename = 'figures/Figure5.pdf',
	plot = fig5,
	width = 115,
	height = 145,
	units = 'mm'
)


