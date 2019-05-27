library(tidyverse)
library(showtext)
font_add('Helvetica', '/usr/share/fonts/OTF/Helvetica-Light.otf')
font_add('Futura', '/usr/share/fonts/TTF/futura-poster-light.ttf')


data <- read.csv("../../data/pilot-study/01-home-sensor.csv") %>%
  mutate(time = as.POSIXct(time, "%Y-%m-%d %H:%M:%S"))

p <- data %>% ggplot() + 
  geom_bar(aes(time %>% ceiling_date('minute')),
           fill="#E68E22", color = "#E68E22", width = 30, show.legend = FALSE) +
  ylab("No. of probes") + xlab("") +
  # coord_cartesian(clip = 'off') +
  theme(text = element_text(family = "Helvetica"),
        panel.background = element_blank(),
        # plot.margin = margin(1,12,1,1),
        axis.text = element_text(size = 10, color = "black"),
        axis.ticks.y = element_blank(),
        # axis.title.y = element_text(size=10, color="black",margin=margin(0,10,0,0)),
        # axis.title.x = element_text(size=10, color="black",margin=margin(10,0,0,0)),
        axis.line.x = element_line(color= "black", size = 0.1))

ggsave("../../images/home-total-count.png", plot=p, height=2.5, width=2.5,units="in")


