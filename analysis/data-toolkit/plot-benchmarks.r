rm(list=ls())
suppressMessages(library(tidyverse))
suppressMessages(library(RJSONIO))
library(showtext)
font_add('Helvetica', '/usr/share/fonts/OTF/Helvetica-Light.otf')

data <- read.csv("r-times.csv")
p <- data %>% 
  filter(type %in% c("bash","parallel")) %>%
  ggplot() + 
  geom_line(aes(as.integer(x), as.integer(y), group=type,color=type),
            show.legend = FALSE,
            size = 0.5) +
  ylab("Processing time (s)") + xlab("Number of locations") +
  # scale_y_continuous(limits=c(0,200)) +
  scale_x_continuous(breaks=c(2,4,6,8,10)) +
  theme(text = element_text(family = "Helvetica Neue"),
        panel.background = element_blank(),
        axis.text = element_text(size = 10, color = "black"),
        axis.ticks.y = element_blank(),
        axis.title.y = element_text(size=10, color="black",margin=margin(0,10,0,0)),
        axis.title.x = element_text(size=10, color="black",margin=margin(10,0,0,0)),
        axis.line.x = element_line(color= "black", size = 0.1))
 
ggsave("../../images/processing-times-all.png", plot=p, height=3, width=3,units="in")

