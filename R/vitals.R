
require(data.table)
require(ggplot2)
require(patchwork)

.args <- commandArgs(trailingOnly = TRUE)

vitals.dt <- fread(.args[1]) |>
  subset(time_secs > 0 & warning == 0 & error == 0)

units <- vitals.dt[, .(units = unique(valueuom)), by=label]
units[label %like% "Temp", units := "F"]

plt.dt <- vitals.dt |>
  melt(id.vars = c("time_secs", "label"), measure.vars = c("valuenum"))

xlims <- plt.dt[, round(range(time_secs/3600))]

plt.dt[units, on = .(label), ulabel := sprintf("%s (%s)", label, units)]

pfun <- function(dt, ...
                 #legend.pos, legend.jus
                 ) ggplot(dt) +
  aes(time_secs/3600, value, color = ulabel) +
  geom_line() +
  scale_x_continuous(
    name = NULL, breaks = function(ls) seq(ls[1], ls[2], by=12),
    limits = xlims, expand = c(0, 0),
    labels = function(bs) sprintf("%s hrs", bs)
  ) + theme_minimal(base_size = 6) +
  scale_y_continuous(name = NULL) +
  theme(
#    legend.position = legend.pos,
 #   legend.justification = legend.jus,
    legend.title = element_blank()
  )

p.heart <- pfun(
  plt.dt[(label %like% "Pressure") | (label == "Heart Rate")],
  c(0.5, 1), c(0.5, 1)
)

p.other <- pfun(
  plt.dt[!((label %like% "Pressure") | (label %like% "Heart") | (label %like% "Resp"))],
  c(1,0), c(1,0)
)

p.resp <- pfun(
  plt.dt[(label %like% "Resp")],
  c(0.5,1), c(0.5,1)
)

p.res <- p.heart / p.resp / p.other

ggsave(tail(.args, 1), width = 7, height = 3, bg = "white")