#================================================================================
# Loading necessary libraries
#================================================================================
library(RPostgreSQL)
library(RJSONIO)
library(tidyverse)
library(ggplot2)
library(lubridate)
library(showtext)
library(xtable)
font_add('Helvetica', '/usr/share/fonts/OTF/Helvetica-Light.otf')
font_add('Futura', '/usr/share/fonts/TTF/futura-poster-light.ttf')

#================================================================================

config <- fromJSON("../config.json", simplify = FALSE)
con <- dbConnect(dbDriver('PostgreSQL'),
                 dbname = config$dbname,
                 user = config$dbuser,
                 password = config$dbpassword,
                 host = config$dbhost )

locs <- dbGetQuery(con, "select id from locations where city = 'Cardiff';");
locs <- paste0("(",paste(locs$id, collapse=","),")")

query <- paste0("select
            location,
            date_trunc('week', timestamp) as week,
            extract(year from timestamp) as year,
            probes_global + probes_local as probes,
            macs_global + macs_local as macs,
            counts_global + counts_local as counts,
            counts_global + adjusted_local as adjusted
          from counts where
          date(timestamp) < '2019-04-01' and
          location in",locs,";")

#================================================================================

if(!exists("probes_data")) { probes_data <- dbGetQuery(con,query) }
dbDisconnect(con)

#================================================================================

plot <- probes_data %>% 
  group_by(week) %>% 
  summarise(counts = sum(counts)/length(unique(location))/1000000,
    adjusted = sum(adjusted)/length(unique(location))/1000000) %>% 
  gather(type,footfall,-week) %>%
  # filter(type=="adjusted") %>%
  ggplot() + 
  geom_line(aes(week,footfall, group=type,color=type),
            show.legend = FALSE, size = 1) +
  geom_text(data=data.frame(l=c("Original","Adjusted"),y=c(0.33,0.13)),
            aes(label = l, x = as.POSIXct("2018-06-01"), y = y), hjust = 1,
            color = "black", show.legend = FALSE, size = 3.3) +
  ylab("(millions)") + xlab("") +
  theme(text = element_text(family = "Helvetica Neue"),
        panel.background = element_blank(),
        axis.text = element_text(size = 10, color = "black"),
        axis.ticks.y = element_blank(),
        axis.title.y = element_text(size=8, color="black",margin=margin(0,5,0,0)),
        axis.title.x = element_text(size=10, color="black",margin=margin(10,0,0,0)),
        axis.line.x = element_line(color= "black", size = 0.1))

#================================================================================

ggsave("../../images/processing-sss-final.png",
       plot=plot, height=2, width=7,units="in")

#================================================================================
