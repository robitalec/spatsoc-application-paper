### Figure 2 - group_pts ====

### Packages ----
pkgs <- c('data.table', 'ggplot2', 'patchwork', 'ggthemes',
          'spatsoc', 'igraph', 'ggnetwork',
          'gridExtra')
p <- lapply(pkgs, library, character.only = TRUE)

### Import data ----
DT <- readRDS('data/example-pts.Rds')

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

### Plot points ----
gp <- ggplot(DT, aes(X, Y)) +
	geom_path(aes(group = ID, color = ID), size = 2) +
	geom_point(aes(X, Y),
						 data = DT[(highlight)],
						 size = 15,
						 alpha = 0.5) +
	geom_point(data = DT[(!highlight)],
						 size = 2,
						 alpha = 0.5) +
	scale_color_manual(breaks = DT$ID,
										 values = pal) +
	theme(
		legend.position = c(.9, .75),
		legend.text = element_text(size = 12, face = 1),
		panel.border = element_rect(fill = NA)
	)


### Distance matrix ----
subDT <- DT[timegroup == 2]

distm <- subDT[, as.matrix(dist(cbind(X, Y)))]
distm <- round(distm, digits = 2)

rownames(distm) <- unique(DT$ID)
colnames(distm) <- unique(DT$ID)

# Build highlight theme
thresh <- 50
highlight <- data.table(i = which(distm > 1 & distm < thresh), col = '#fff487')
reg <- data.table(i = which(distm > thresh | distm == 0), col = 'grey95')
cols <- rbindlist(list(highlight, reg))[order(i)]

highlightTheme <- ttheme_default(core = list(bg_params = list(fill = cols$col)),
																 base_size = fontSize)

disttab <-
	ggplot() +
	annotation_custom(tableGrob(
		round(distm, digits = 1),
		theme = highlightTheme,
		rows = rownames(distm)
	))


### Connected components ----
subDT[ID == 'H', c('X', 'Y') := .(700445, 5508555)]

m <- melt(distm < 50)
setDT(m)
m <- m[(value) & Var1 != Var2, .(Var1, Var2)]
setnames(m, c('ID', 'ID2'))
m[subDT, c('X', 'Y') := .(X, Y), on = 'ID']
m <- merge(
	m,
	subDT[, .(ID, X, Y, group)],
	by.x = 'ID2',
	by.y = 'ID',
	suffixes = c('', 'end')
)
m <- rbind(m, subDT[ID == 'H', .(ID, X, Y, group)], fill = TRUE)

gnet <- ggplot(m, aes(
	x = X,
	y = Y,
	xend = Xend,
	yend = Yend
)) +
	geom_edges() +
	geom_nodes(aes(color = factor(group)), size = 7) +
	geom_nodetext(aes(label = ID)) +
	theme(
		axis.line = element_blank(),
		legend.position = c(.2, .25),
		panel.border = element_rect(fill = NA)
	) +
	labs(color = 'group') +
	scale_color_manual(breaks = m$group,
										 values = c("#4c9cc9", "#CC79A7"))


### group_pts tab ----
g2 <- data.table(i = which(DT$group == 2), col = '#4c9cc9')
g9 <- data.table(i = which(DT$group == 9), col = '#CC79A7')
reg <- data.table(i = which(!(DT$group %in% c(2, 9))), col = 'grey95')
cols <- rbindlist(list(g2, g9, reg))
DT[, i := .I]
cols[DT, ord := ord, on = 'i']
cols <- cols[order(ord)]

highlightTheme <- ttheme_default(core = list(bg_params = list(fill = cols$col)),
																 base_size = fontSize)

tab <- DT[order(ord), .(ID, timegroup, group)]
grpstab <-
	ggplot() +
	annotation_custom(tableGrob(tab, theme = highlightTheme, rows = NULL))

### Output ----
fig2 <- gp + (disttab / gnet) + grpstab +
	plot_annotation(tag_levels = 'A') &
	theme(
		plot.tag = element_text(size = 20, face = 2),
		legend.text = element_text(size = 16, face = 1),
		legend.title = element_text(size = 16, face = 1)
	)

ggsave(
	filename = 'figures/Figure2.pdf',
	plot = fig2,
	width = 400,
	height = 170,
	units = 'mm'
)
