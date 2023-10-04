
require(data.table)

.args <- commandArgs(trailingOnly = TRUE)

dt <- fread(.args[1])[, 
  icutime_hrs := as.numeric(icutime_hrs) 
][ !is.na(icutime_hrs) ] |> melt(
  id.vars = c("gender", "died"),
  measure.vars = c("staytime_hrs", "icutime_hrs")
)

qs.dt <- dt[,{
  qs <- quantile(value, probs = seq(0,1,by=.25)) |>
    setNames(c("min","lo","med","hi","max")) |> signif(2)
  as.list(qs)
}, by=.(gender, died, variable)]

qs.dt[, output := sprintf("%2.f (mn-mx: %2.f-%2.f, 50%%Q: %2.f-%2.f)", med, min, max, lo, hi)]

res.dt <- qs.dt |> dcast(gender + died ~ variable, value.var = "output")

fwrite(res.dt, tail(.args, 1))
