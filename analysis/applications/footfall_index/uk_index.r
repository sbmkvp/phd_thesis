library(tidyverse)
library(tidyquant)
library(ggplot2)
library(showtext)
library(RPostgreSQL)
library(RJSONIO)

# font_add('Helvetica', '/usr/share/fonts/OTF/Helvetica-Light.otf')
# font_add('Futura', '/usr/share/fonts/TTF/futura-poster-light.ttf')
#
config <- fromJSON("../../config.json", simplify = FALSE)
con <- dbConnect(dbDriver('PostgreSQL'),
                 dbname = config$dbname,
                 user = config$dbuser,
                 password = config$dbpassword,
                 host = config$dbhost )
rm(config)
query <- "select
            location,
            date_trunc('week',timestamp) as week,
            sum(counts_global+adjusted_local) as counts
          from counts
          where date(timestamp) between '2018-01-01' and '2018-12-31'
          group by 1,2";
data <- dbGetQuery(con, query);
