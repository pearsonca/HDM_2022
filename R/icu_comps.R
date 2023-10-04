
require(data.table)
require(ggplot2)
require(patchwork)

.args <- commandArgs(trailingOnly = TRUE)

icu.dt <- fread(.args[1])[, icutime := as.numeric(icutime) ] |>
  subset(!is.na(icutime))

dt <- rbind(
  icu.dt[,.(
    icutime = mean(icutime),
    age = "all", simv = NA),
    by=.(icu_careunit)
  ],
  icu.dt[,.(
    icu_careunit = "all",
    icutime = mean(icutime),
    age = "all", simv = NA)
  ],
  icu.dt[admitage == "60-65" & has_device == TRUE, .(
    icu_careunit = "all",
    icutime = mean(icutime),
    age = admitage, simv = NA)
  ],
  icu.dt[admitage == "60-65" & has_device == TRUE, .(
    icutime = mean(icutime),
    age = admitage, simv = NA),
    by=.(icu_careunit)
  ],
  icu.dt[admitage == "60-65" & has_device == TRUE & has_simvastatin == TRUE, .(
    icu_careunit = "all",
    icutime = mean(icutime),
    age = admitage, simv = has_simvastatin)
  ],
  icu.dt[admitage == "60-65" & has_device == TRUE & has_simvastatin == FALSE, .(
    icu_careunit = "all",
    icutime = mean(icutime),
    age = admitage, simv = has_simvastatin)
  ],
  icu.dt[admitage == "60-65" & has_device == TRUE & has_simvastatin == TRUE, .(
    icutime = mean(icutime),
    age = admitage, simv = has_simvastatin),
    by=.(icu_careunit)
  ],
  icu.dt[admitage == "60-65" & has_device == TRUE & has_simvastatin == FALSE, .(
    icutime = mean(icutime),
    age = admitage, simv = has_simvastatin),
    by=.(icu_careunit)
  ]
)

p <- ggplot(dt) + aes(icu_careunit, icutime, color = age, shape = simv) +
  geom_point(data = \(dt) subset(dt, icu_careunit != "all")) +
  geom_hline(
    aes(yintercept = icutime, color = age, linetype = simv),
    data = \(dt) subset(dt, icu_careunit == "all")
  ) +
  scale_shape_discrete("Simvastatin?", breaks = c(TRUE, FALSE, NA), labels = c("Yes", "No", "Mixed"), na.value = 1) +
  scale_linetype_discrete("Simvastatin?", breaks = c(TRUE, FALSE, NA), labels = c("Yes", "No", "Mixed"), na.value = "dotted") +
  scale_y_log10(name = "Time in ICU (hours)") +
  scale_color_discrete(name = NULL) +
  scale_x_discrete(name = NULL) +
  theme_minimal() +
  theme(
    legend.position = c(0,1), legend.justification = c(0,1),
    legend.direction = "horizontal",
    legend.margin = margin()
  )

ggsave(tail(.args, 1), width = 7, height = 2.5, bg = "white")
