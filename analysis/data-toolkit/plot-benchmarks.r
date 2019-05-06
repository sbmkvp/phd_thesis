rm(list=ls())
suppressMessages(library(tidyverse))
suppressMessages(library(RJSONIO))
library(showtext)
font_add('Helvetica', '/usr/share/fonts/OTF/Helvetica-Light.otf')

data <- read.csv("other-times.csv")
p <- data %>% 
  ggplot() + 
  geom_line(aes(as.integer(x), as.integer(y), group=type,color=type),
            show.legend = FALSE,
            size = 0.5) +
  ylab("Processing time (s)") + xlab("Number of locations") +
  # scale_y_continuous(limits=c(0,200)) +
  # scale_x_continuous(breaks=c(2,4,6,8,10)) +
  geom_text(data=subset(data, x == 20),
            aes(label = type, colour = type, x = 20, y = y),
            show.legend = FALSE,
            vjust = -0,
            hjust = 1,
            size = 4) +
  theme(text = element_text(family = "Helvetica Neue"),
        panel.background = element_blank(),
        axis.text = element_text(size = 10, color = "black"),
        axis.ticks.y = element_blank(),
        axis.title.y = element_text(size=10, color="black",margin=margin(0,10,0,0)),
        axis.title.x = element_text(size=10, color="black",margin=margin(10,0,0,0)),
        axis.line.x = element_line(color= "black", size = 0.1))
 
ggsave("../../images/processing-times-all.png", plot=p, height=3, width=3,units="in")

data <- read.csv("r-times.csv") %>% filter(type %in% c("R script","Unix tools"))
p <- data %>% 
  ggplot() + 
  geom_line(aes(as.integer(x), as.integer(y), group=type,color=type),
            show.legend = FALSE,
            size = 0.5) +
  ylab("Processing time (s)") + xlab("Number of locations") +
  scale_y_continuous(limits=c(0,200)) +
  scale_x_continuous(breaks=c(2,4,6,8,10)) +
  geom_text(data=subset(data, x == 10),
            aes(label = type, colour = type, x = 9, y = y),
            show.legend = FALSE,
            vjust = -1,
            size = 4) +
  theme(text = element_text(family = "Helvetica Neue"),
        panel.background = element_blank(),
        axis.text = element_text(size = 10, color = "black"),
        axis.ticks.y = element_blank(),
        axis.title.y = element_text(size=10, color="black",margin=margin(0,10,0,0)),
        axis.title.x = element_text(size=10, color="black",margin=margin(10,0,0,0)),
        axis.line.x = element_line(color= "black", size = 0.1))
 
ggsave("../../images/processing-times-r.png", plot=p, height=3, width=3,units="in")

