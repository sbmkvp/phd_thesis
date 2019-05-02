library(tidyverse)
library(scales)
library(extrafont)
library(showtext)

font_add('Helvetica', '/usr/share/fonts/OTF/Helvetica-Light.otf')

data <- read.csv("data-veracity-tcr-data.csv") %>% 
  mutate(present = ifelse(present,"#CCCCCC","#FF5733")) %>%
  mutate(location = as.character(location)) %>% # 
  mutate(timestamp = timestamp %>% as.character %>% substr(12,16))

showtext_auto()


p <- ggplot(data) + 
  geom_tile(aes(timestamp,location,fill=present), show.legend = FALSE) +
  geom_hline(aes(yintercept=c(1.5)),color="white") +
  geom_hline(aes(yintercept=c(2.5)),color="white") +
  geom_hline(aes(yintercept=c(3.5)),color="white") +
  geom_hline(aes(yintercept=c(4.5)),color="white") +
  geom_hline(aes(yintercept=c(5.5)),color="white") +
  ylab("Locations") +
  xlab("") +
  scale_fill_identity() +
  scale_x_discrete(breaks=c("00:00","06:00","12:00","18:00","23:00"),
                   labels=c("12 AM","6 AM","12 PM","6 PM", "11 PM")) +
  theme(text = element_text(family = "Helvetica"),
        # axis.title.x = element_text(size = 35, color = "black"),
        axis.title.y = element_text(size = 35, color = "black"),
        panel.background = element_blank(),
        axis.ticks.x = element_blank(),
        axis.ticks.y = element_blank(),
        # axis.text.y = element_text(size = 35, color = "#444444",margin =margin(0,10,0,5)),
        axis.text.y = element_blank(),
        axis.text.x = element_text(size = 25, color = "#444444",margin =margin(5,0,0,0)))

ggsave("../../images/data-veracity-gaps.png",plot=p,height=2.5,width=2.5,units="in")
