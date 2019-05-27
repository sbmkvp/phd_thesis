library(tidyverse)
library(ggplot2)
library(ggrepel)
library(showtext)
font_add('Helvetica', '/usr/share/fonts/OTF/Helvetica-Light.otf')


data <- data.frame(
  year = c(2012,2013,2014,2015,2016,2017,2018),
  "18-24" = c(75,83,85,90,90,97,96),
  "25-34" = c(71,84,84,89,91,92,95),
  "35-44" = c(66,74,81,85,91,92,91),
  "45-54" = c(49,60,67,76,82,86,89),
  "55-75" = c(29,40,50,57,65,71,77)
  # "all" = c(52,62,70,76,81,85,87),
) 

names(data) <- c("year", "18-24", "25-34", "35-44", "45-54", "55+  .")

data <- data %>% gather("age","pen",-year)


p <- data %>% 
  ggplot() + 
  geom_line(aes(year, pen, group=age, color=age),
            show.legend = TRUE, size = 1) +
  ylab("Smartphone penetration") + xlab("") +
  scale_y_continuous(limits=c(0,100), labels = function(x){paste0(x,"%")}) +
  # geom_text_repel(data=data %>% filter(year == 2014),
  #           aes(label = age, x = 2014, y = pen), hjust = 0,
  #           color = "black", show.legend = FALSE) +
  guides(color=guide_legend(ncol=3,bycol=TRUE)) +
  theme(text = element_text(family = "Helvetica"),
        legend.title = element_blank(),
        legend.position = "bottom",
        legend.spacing.x = unit(0.2, 'cm'),
        legend.key = element_blank(),
        panel.background = element_blank(),
        axis.text = element_text(size = 10, color = "black"),
        axis.ticks.y = element_blank(),
        axis.title.y = element_text(size=10, color="black",margin=margin(0,0,0,0)),
        axis.title.x = element_text(size=10, color="black",margin=margin(0,0,-10,0)),
        axis.line.x = element_line(color= "black", size = 0.1))

ggsave("../../images/mobile-ownership.png", plot=p, height=3, width=2.5,units="in")
