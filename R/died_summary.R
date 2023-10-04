
require(data.table)

.args <- commandArgs(trailingOnly = TRUE)

dt <- fread(.args[1])

setnames(dt, \(nm) {
  gsub("^.+_careunit$", "careunit", nm)
})

dt[, curtail := paste0(substring(title_summary, 1, 100), "...") ]
dt[, codecur := paste0(substring(code_summary, 1, 35), "...") ]
dt$code_summary <- dt$title_summary <- NULL
dt[, idsum := sprintf("%i %s%i", subject_id, gender, admitage) ]
dt$subject_id <- dt$gender <- dt$admitage <- NULL
dt[, icusum := sprintf("%s: %02.1f", careunit, icutime_days)]
dt$careunit <- dt$icutime_days <- NULL
setcolorder(dt, c("idsum", "icusum", "codecur", "curtail"))

setnames(dt,
  c("idsum", "icusum", "codecur", "curtail"),
  c("Patient", "ICU (stay hrs)", "ICD9 Codes", "Abbr. ICD9 Titles")
)

fwrite(dt, tail(.args, 1))