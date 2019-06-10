library(tidyverse)
library(ggplot2)
library(RJSONIO)
library(RPostgreSQL)
library(showtext)
library(lubridate)
library(xtable)

font_add('Helvetica', '/usr/share/fonts/OTF/Helvetica-Light.otf')
font_add('Futura', '/usr/share/fonts/TTF/futura-poster-light.ttf')

data <- read.csv("../../data/pilot-study/01-home-sensor.csv") %>%
  mutate(time = as.POSIXct(time, "%Y-%m-%d %H:%M:%S"))

filtered <- data %>%
  mutate(error = ifelse(vendor %in% c("Google","Fn-LinkT"),"Data","Noise")) %>%
  group_by(error) %>% summarise(count = length(error)) %>%
  mutate(per = count/sum(count)*100) %>%
  arrange(per) %>%
  mutate(error = factor(error,levels=error)) %>%
  arrange(-per) %>%
  mutate(lab = cumsum(per))

s <- filtered %>%  ggplot() + 
  geom_bar(aes(x=.9,y=per, fill = error),
          stat = "identity",
          color = "white", width = 0.6, size=3) +
  xlim(c(0, 1.3)) +
  geom_text(aes(x=0.9,y=lab-(per/2),label=lapply(error,function(d){str_wrap(d,width=5)})),
           ,show.legend=FALSE, color="white",size = 4) +
  geom_text(aes(x=.4,y=lab-(per/2),label=paste0(round(per),"%")),
           size = 3,fontface="bold",color="darkgrey") +
  scale_fill_brewer(palette = "Dark2") +
  coord_polar(theta="y",start = 0,) +
  ylab("") + xlab("") +
  guides(fill=guide_legend(ncol=2)) +
  theme(text = element_text(family = "Helvetica"),
        legend.title = element_blank(),
        legend.position = "none",
        legend.text = element_text(size=11, color="black"),
        plot.margin = margin(0,0,0,0),
        panel.background = element_blank(),
        axis.text = element_blank(),
        axis.ticks.y = element_blank(),
        axis.title.y = element_blank(),
        axis.title.x = element_blank(),
        axis.line.x = element_blank())

ggsave("../../images/processing-error-signal.png", plot=s, height=3, width=3,units="in")

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
            macs_global + macs_local as macs
          from counts where
          date(timestamp) < '2018-07-02' and
          location in",locs,";")

macs <- dbGetQuery(con,query) %>% 
  group_by(week) %>% 
  summarise(macs = sum(macs)/length(unique(location))/1000000)

p <- macs %>% 
  ggplot() + 
  geom_line(aes(week, macs, group="macs"), color = "#993300",
            show.legend = FALSE, size = 1) +
  ylab("(millions)") + xlab("") +
  theme(text = element_text(family = "Helvetica Neue"),
        panel.background = element_blank(),
        axis.text = element_text(size = 10, color = "black"),
        axis.ticks.y = element_blank(),
        axis.title.y = element_text(size=8, color="black",margin=margin(0,5,0,0)),
        axis.title.x = element_text(size=10, color="black",margin=margin(10,0,0,0)),
        axis.line.x = element_line(color= "black", size = 0.1))

ggsave("../../images/processing-error-randomisation.png", plot=p, height=2, width=7,units="in")

dbDisconnect(con)

#
# load("../../data/other/processing-data.rdata")
# rm(probes_all,probes_all_raw,probes_manual_raw, query)
# counts <- source("aggregate_counts.r")$value(probes_manual)
#
# counts_plot <- counts %>% 
#   arrange(count_type, location, interval) %>%
#   group_by(paste(count_type,location,date(interval))) %>%
#   mutate(int = 1:length(interval)) %>%
#   ggplot() +
# 	geom_line(aes(int,
# 				  footfall,
# 				  color=type,
# 				  group=type),
# 			  stat="identity") + 
# 	facet_grid(paste(location,date(interval))~.,scale="free") +
# 	theme(legend.position = "bottom") +
#   ylab("") + xlab("") +
# 	# scale_fill_continuous(name = "Type of Counts")
#   theme(text = element_text(family = "Helvetica Neue"),
#         panel.background = element_blank(),
#         axis.text = element_text(size = 5, color = "black"),
#         axis.ticks.y = element_blank(),
#         axis.title.y = element_text(size=3, color="black",margin=margin(0,0,0,0)),
#         axis.title.x = element_text(size=10, color="black",margin=margin(0,0,0,0)),
#         axis.line.x = element_line(color= "black", size = 0.1))
#
# ggsave("../../images/processing-sss-comparison.png", plot=counts_plot, height=7, width=7,units="in")
#
