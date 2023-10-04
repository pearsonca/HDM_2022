
require(RPostgreSQL)
require(data.table)

.args <- commandArgs(trailingOnly = TRUE)

user <- readline("user? ")
password <- readline("password? ")

sql <- readLines(.args[1])
tarcsv <- tail(.args, 1)

mimic <- dbConnect(
  PostgreSQL(),
  dbname = "mimic",
  host = "healthdatascience.lshtm.ac.uk",
  port = 5432,
  user = user,
  password = password
)

mimic |> dbGetQuery(sql) |> as.data.table() |> fwrite(file = tarcsv)

dbDisconnect(mimic)