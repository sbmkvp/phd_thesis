library(tidyverse)
library(showtext)
library(lubridate)
library(xtable)

font_add('Helvetica', '/usr/share/fonts/OTF/Helvetica-Light.otf')
font_add('Futura', '/usr/share/fonts/TTF/futura-poster-light.ttf')

data <- read.csv("../../data/pilot-study/01-home-sensor.csv") %>%
  mutate(time = as.POSIXct(time, "%Y-%m-%d %H:%M:%S"))

hometotal <- data %>%
  mutate(time = ceiling_date(time, 'minute')) %>%
  group_by(time) %>% summarise(count = length(unique(mac))) %>% 
  ggplot() + 
  geom_bar(aes(time, count ), stat = "identity",
           fill="#E68E22", color = "#E68E22", size =0.12, show.legend = FALSE) +
  ylab("No. of probes") + xlab("") +
  theme(text = element_text(family = "Helvetica"),
        panel.background = element_blank(),
        axis.text = element_text(size = 10, color = "black"),
        axis.ticks.y = element_blank(),
        axis.title.y = element_text(size=10, color="black",margin=margin(0,5,0,0)),
        axis.text.x = element_text(size=8, color="black",margin=margin(0,0,-15,0)),
        axis.line.x = element_line(color= "black", size = 0.1))

ggsave("../../images/home-total-count.png", plot=hometotal, height=1, width=2.5,units="in")

vendortable <- data %>%
  group_by(vendor) %>%
  summarise(probes = length(mac),
         macs = length(unique(mac)),
         signal = mean(signal),
         length = length(unique(length)),
         duration = length(unique(duration)),
         tags = length(unique(tags)),
         ssid = length(unique(ssid)),
         seq = length(unique(sequence)) ) 

cat(print(xtable(vendortable)), file = "vendor-table.txt")
