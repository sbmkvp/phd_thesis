#================================================================================
# Loading necessary libraries
#================================================================================
library(tidyverse)
library(ggplot2)
library(RJSONIO)
library(RPostgreSQL)
library(showtext)
library(lubridate)
library(xtable)
font_add('Helvetica', '/usr/share/fonts/OTF/Helvetica-Light.otf')
font_add('Futura', '/usr/share/fonts/TTF/futura-poster-light.ttf')

#================================================================================
# Download and pre-process data
#================================================================================
if(!exists("probes_manual")) { load("../../data/other/processing-data.rdata") }

data <- probes_manual

data$location <- sub('Carphone, Camden',     "1. Camden St.",   data$location)
data$location <- sub('Cabana, Bucknall St.', "2. St. Giles",    data$location)
data$location <- sub('Kiosk, Holborn Stn.',  "3. Holborn Stn.", data$location)
data$location <- sub('Leon, Russel Sq.',     "4. Brunswick Cn.",data$location)
data$location <- sub('Whittard, Strand',     "5. The Strand",   data$location)

counts <- source("aggregate_counts.r")$value(data) %>%
  arrange(count_type, location, interval) %>%
  group_by(paste(count_type,location,date(interval))) %>%
  mutate(int = 1:length(interval)) %>%
  ungroup() %>%
  mutate(location = paste0("'",location,"'")) %>%
  mutate(date = paste0("NULL^{~", format(interval,"'%a, %b %d'"),"}")) %>% 
  mutate(type = ifelse(type=="Manual","Manual Count",type)) %>%
  mutate(type = ifelse(type=="Modified Sensor","Pilot Study",type)) %>%
  mutate(type = ifelse(type=="Original Sensor","Smart Street Sensor",type)) %>%
  mutate(interval = ifelse(type == "Smart Street Sensor",
                           interval+minutes(5),
                           interval) %>% as_datetime)

#================================================================================
# Creating and saving plots
#================================================================================
plot <- counts %>% 
  ggplot() +
	geom_line(aes(interval, footfall, color=type, group=type),
    size = 0.75, stat="identity") + 
	facet_wrap(.~location+date,scale="free",labeller = label_parsed) +
	theme(legend.position = "bottom") +
  ylab("") + xlab("") +
  theme_light() +
  theme(text = element_text(family = "Helvetica Neue"),
    strip.background = element_blank(),
    strip.text = element_text(size = 7, color = "black",margin=margin(0,0,0,0)),
    legend.title = element_blank(),
    legend.position = "bottom",
    legend.key.size = unit(3,"mm"),
    legend.spacing.x = unit(2,'mm'),
    legend.margin = margin(-2,0,2,0),
    axis.text = element_text(size = 5, color = "black"),
    panel.grid.major = element_blank(),
    panel.grid.minor = element_blank(),
    panel.spacing = unit(4,"mm"),
    axis.ticks.y = element_blank(),
    axis.title.y = element_text(size=8, color="#444444",margin=margin(0,10,0,10)),
    axis.title.x = element_text(size=8, color="#444444",margin=margin(5,0,0,0)),
    axis.line.x = element_line(color= "black", size = 0.1))

ggsave("../../images/processing-sss-compare.png",
       plot=plot, 
       height=5, width=7, units="in")
