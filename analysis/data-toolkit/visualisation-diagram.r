library(tidyverse)
library(showtext)
font_add('Helvetica', '/usr/share/fonts/OTF/Helvetica-Light.otf')

data <- read.csv("../../data/other/713-2018.csv")
data$timestamp <- as.POSIXct(data$timestamp)
data$probes[data$imputed] <- NA

range <- as.POSIXct(c('2018-01-01 00:00:00','2019-01-01 00:00:00'))

p <- data %>% 
  filter(timestamp>range[1],timestamp<range[2]) %>%
  ggplot() + 
  geom_line(aes(timestamp, probes, group="count"),
            show.legend = FALSE,
            size = 0.1,
            color = "#FF5733") +
  ylab("Probe requests") + xlab("") +
  scale_x_datetime(limits = range, expand = c(0.03,0.03)) +
  theme(text = element_text(family = "Helvetica Neue"),
        panel.background = element_blank(),
        axis.text.x = element_text(size = 10, color = "black"),
        axis.ticks.y = element_blank(),
        axis.text.y = element_text(size=10, color="black"),
        axis.title.y = element_text(size=10, color="black",margin=margin(0,10,0,0)),
        axis.line.x = element_line(color= "black", size = 0.1))
 
ggsave("../../images/data-visualisation-challenge.png",plot=p,height=2, width=12,units="in")
