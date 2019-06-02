library(tidyverse)
library(showtext)
library(lubridate)
library(classInt)
suppressMessages(library(treemapify)) 
library(xtable)

font_add('Helvetica', '/usr/share/fonts/OTF/Helvetica-Light.otf')
font_add('Futura', '/usr/share/fonts/TTF/futura-poster-light.ttf')

data <- read.csv("../../data/pilot-study/02-ucl-sensor.csv") %>%
  mutate(time = as.POSIXct(time, "%Y-%m-%d %H:%M:%S")) %>%
  filter(time > as.POSIXct("2017-12-04 15:39:00")) %>%
  filter(time <= as.POSIXct("2017-12-04 16:20:00")) 

manual <- read.csv("../../data/pilot-study/02-ucl-manual.csv") %>%
  mutate(time = as.POSIXct(time, "%Y-%m-%d %H:%M:%S")) %>%
  select(time,`Manual Counts` = count)

counts_before <- data %>%
  mutate(time = ceiling_date(time,"minute")) %>%
  group_by(time) %>%
  summarise(`Unique MACs` = length(unique(mac)),
            `Unique Lengths` = length(unique(length)),
            `Unique Tags` = length(unique(tags)))

counts_after <- data %>%
  filter(signal > -69) %>%
  mutate(time = ceiling_date(time,"minute")) %>%
  group_by(time) %>%
  summarise(`Unique MACs` = length(unique(mac)),
            `Unique Lengths` = length(unique(length)),
            `Unique Tags` = length(unique(tags)))

theme1 <- theme(text = element_text(family = "Helvetica"),
  legend.title = element_blank(),
  panel.background = element_blank(),
  axis.text = element_text(size = 10, color = "black"),
  axis.ticks.y = element_blank(),
  legend.key = element_blank(),
  legend.spacing.x = unit(4.0,'mm'),
  axis.title.y = element_text(size=10, color="black",margin=margin(0,10,0,0)),
  axis.text.x = element_text(size=8, color="black",margin=margin(0,0,0,0)),
  axis.line.x = element_line(color= "black", size = 0.1))

comparison1 <- left_join(manual,counts_before)
comparison2 <- left_join(manual,counts_after)


before_signal <- comparison1 %>%
  gather(type,count,-time) %>%
  ggplot() + 
  geom_line(aes(time, count,group=type,color=type ), size = 1.1) +
  ylab("Counts") + xlab("") + theme1 +
  theme(legend.position = "bottom",
        axis.title.y = element_blank())

after_signal <- comparison2 %>%
  gather(type,count,-time) %>%
  ggplot() + 
  geom_line(aes(time, count,group=type,color=type ), size = 1.1) +
  ylab("Counts") + xlab("") + theme1 +
  theme(legend.position = "bottom",
        axis.title.y = element_blank())
#
# combined_data <- rbind(
#   comparison1 %>% gather(type,count,-time) %>% mutate(signal="before"),
#   comparison2 %>% gather(type,count,-time) %>% mutate(signal="after")
# )
#
# combined <- combined_data %>%
#   ggplot() + 
#   geom_line(aes(time, count,group=type,color=type ), size = 1.2) +
#   ylab("Counts") + xlab("") + facet_grid(signal~.) + theme1

ggsave("../../images/ucl-comparison-before.png", plot=before_signal, height=3, width=7,units="in")
ggsave("../../images/ucl-comparison-after.png", plot=after_signal, height=3, width=7,units="in")

local_tree <- data %>% 
  group_by(type,vendor) %>%
  summarise(count=length(vendor)) %>%
  ggplot(aes(area=count,label=vendor,subgroup=type,fill=type)) + 
  geom_treemap(color="white")+
  geom_treemap_subgroup_border( color = "white", size = 4 ) + 
  geom_treemap_subgroup_text(place = "bottomleft", alpha = 0.75, size = 17.5, # 
                             colour =  "white", family="Futura",
                             padding.x = unit(3, "mm"), padding.y = unit(10, "mm") ) +
  geom_treemap_text(colour = "white", place = "bottomright",
                    reflow = T, size = 10, family = "Helvetica",
                    padding.x = unit(2.5, "mm"), padding.y = unit(2.5, "mm")) +
  theme(legend.position = "none")

ggsave("../../images/ucl-local-treemap.png", plot=local_tree, height=3.5, width=7,units="in")

breaks <- classIntervals(data$signal,4,"kmeans")$brks
signal_dist <- data %>%
  ggplot() +
  geom_density(aes(signal),fill="blue",alpha = 0.2,size=0,adjust=0.8) +
  geom_text(data=data.frame(breaks=breaks[2:(length(breaks)-1)]),aes(breaks-2,0.01,label=breaks),
            size=2,hjust=-1,color="red") +
  geom_vline(xintercept=breaks[2:(length(breaks)-1)],color="red",linetype="dashed",size=0.25) +
  scale_y_continuous(limits = c(0,0.042),expand=c(0,0)) +
  theme1 + theme(axis.text.y = element_blank())

# ggsave("../../images/ucl-signal-dist.png", plot=signal_dist, height=1.5, width=5,units="in")
