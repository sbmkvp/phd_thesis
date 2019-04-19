#! /usr/bin/Rscript

suppressMessages(library(RPostgreSQL))
suppressMessages(library(tidyverse))
suppressMessages(library(RJSONIO))

config <- fromJSON("../config.json", simplify=FALSE);

con <- dbConnect(dbDriver('PostgreSQL'),
                 dbname = config$dbname,
                 user = config$dbuser,
                 password = config$dbpass,
                 host = config$dbhost)

raw_data <- dbGetQuery(con, "select * from counts where date(timestamp) = '15-01-2018';")
addresses <- dbGetQuery(con, "select id,address from locations;")
tcr_locations <- addresses$id[grep("Tottenham", addresses$address)]
raw_data %>% filter(location %in% tcr_locations ) %>%
  mutate(present = ((probes_global+probes_local)!=0)&(!imputed)) %>%
  select(timestamp,location,present) %>%
  format_csv %>% cat
