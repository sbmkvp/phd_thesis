library(tidyverse)
library(showtext)
library(lubridate)

font_add('Helvetica', '/usr/share/fonts/OTF/Helvetica-Light.otf')
font_add('Futura', '/usr/share/fonts/TTF/futura-poster-light.ttf')

data <- read.csv("../../data/pilot-study/03-oxfordst-sensor.csv") %>%
  mutate(time = as.POSIXct(time, format = "%b %d, %Y %H:%M:%OS")) %>%
  select(-ssid,-tags,-id,-oui) %>%
  filter(time > as.POSIXct("2017-12-20 12:30:00")) %>%
  filter(time <= as.POSIXct("2017-12-20 13:00:00")) 

counts <- data %>% mutate(time = ceiling_date(time, 'minute')) %>%
  group_by(time) %>%
  summarize(`Probes Requests`= length(mac), `MAC addresses` = length(unique(mac)))

manual <- read.csv("../../data/pilot-study/03-oxfordst-manual.csv") %>%
  mutate(time = as.POSIXct(time, format = "%Y-%m-%d %H:%M:%OS")) %>%
  filter(time > as.POSIXct("2017-12-20 12:30:00")) %>%
  filter(time <= as.POSIXct("2017-12-20 13:00:00")) %>%
  mutate(time = ceiling_date(time,"minute")) %>%
  group_by(time) %>% summarise(`Manual Counts` = sum(count))

theme1 <- theme(text = element_text(family = "Helvetica"),
  legend.position = "none",
  legend.title = element_blank(),
  panel.background = element_blank(),
  axis.text = element_text(size = 10, color = "black"),
  axis.ticks.y = element_blank(),
  legend.key = element_blank(),
  legend.spacing.x = unit(4.0,'mm'),
  axis.title.y = element_text(size=5, color="black",margin=margin(0,-10,0,0)),
  axis.text.x = element_text(size=10, color="black",margin=margin(5,0,0,0)),
  axis.text.y = element_text(size=9, color="black",margin=margin(0,0,0,0)),
  axis.line.x = element_line(color= "black", size = 0.1))

labels <- data.frame(
  y = c(2000,950,300),
  x = as.POSIXct(c("2017-12-20 12:54:00", "2017-12-20 12:45:00", "2017-12-20 12:35:00")),
  labels = c("Probes","MACs","Real")
)

p <- counts %>% left_join(manual) %>%
  gather(type, count, -time) %>%
  ggplot() + geom_line(aes(time, count, group = type, color = type), size = 1) +
  geom_text(data = labels, aes(label=labels,x=x,y=y)) +
  xlab("") + ylab("") + 
  theme1

ggsave("../../images/oxst-counts.png", plot=p, height=3, width=6,units="in")
