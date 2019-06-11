library(tidyverse)
library(ggplot2)
library(RJSONIO)
library(RPostgreSQL)
library(showtext)
library(lubridate)
library(xtable)

font_add('Helvetica', '/usr/share/fonts/OTF/Helvetica-Light.otf')
font_add('Futura', '/usr/share/fonts/TTF/futura-poster-light.ttf')

if(!exists("probes_manual")) { load("../../data/other/processing-data.rdata") }

probes_manual$location <- sub('Carphone, Camden',"1",probes_manual$location)
probes_manual$location <- sub('Cabana, Bucknall St.',"2",probes_manual$location)
probes_manual$location <- sub('Kiosk, Holborn Stn.',"3",probes_manual$location)
probes_manual$location <- sub('Leon, Russel Sq.',"4",probes_manual$location)
probes_manual$location <- sub('Whittard, Strand',"5",probes_manual$location)

p <- probes_manual %>% 
  mutate(type = ifelse(type=="Original Sensor","Smart Street Sensor",type)) %>%
  mutate(type = ifelse(type=="Modified Sensor","Pilot Study",type)) %>%
	filter(type!="Manual") %>% 
	ggplot() + 
  geom_histogram(aes(signal, y=..count../1000, fill=oui_type), bins = 30)+
  facet_grid(location~type,scale="free")+
  theme(legend.position="bottom") +
  xlab("Signal Strength") +
  ylab("No. of Probe Requests (in thousands)") +
  scale_fill_discrete(name = "Type of OUI") +
  theme_light() +
  theme(text = element_text(family = "Helvetica Neue"),
    strip.background = element_blank(),
    strip.text = element_text(size = 10, color = "black"),
    legend.title = element_blank(),
    legend.position = "bottom",
    legend.key.size = unit(3,"mm"),
    legend.spacing.x = unit(2,'mm'),
    legend.margin = margin(-2,0,2,0),
    axis.text = element_text(size = 6, color = "black"),
    panel.grid.major = element_blank(),
    panel.grid.minor = element_blank(),
    axis.ticks.y = element_blank(),
    axis.title.y = element_text(size=8, color="#444444",margin=margin(0,10,0,10)),
    axis.title.x = element_text(size=8, color="#444444",margin=margin(5,0,0,0)),
    axis.line.x = element_line(color= "black", size = 0.1))


ggsave("../../images/processing-sss-signalsnew.png", plot=p, height=4, width=5, units="in")
