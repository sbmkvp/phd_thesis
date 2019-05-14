rm(list=ls())
suppressMessages(library(tidyverse))
suppressMessages(library(RJSONIO))
suppressMessages(library(treemapify)) 

library(showtext)
font_add('Helvetica', '/usr/share/fonts/OTF/Helvetica-Light.otf')
font_add('Futura', '/usr/share/fonts/TTF/futura-poster-light.ttf')

data <- read.csv("literature-search.csv");

p <- data %>% 
  filter(year > 1979) %>%
  group_by(year) %>% summarize(count = length(year)) %>%
  ggplot() + 
  geom_line(aes(x = as.integer(year), y = count),
           color="#E67E22", show.legend = FALSE) +
  ylab("Number of Articles") + xlab("") +
  coord_cartesian(clip = 'off') +
  theme(text = element_text(family = "Helvetica"),
        panel.background = element_blank(),
        plot.margin = margin(1,12,1,1),
        axis.text = element_text(size = 10, color = "black"),
        axis.ticks.y = element_blank(),
        axis.title.y = element_text(size=10, color="black",margin=margin(0,10,0,0)),
        axis.title.x = element_text(size=10, color="black",margin=margin(10,0,0,0)),
        axis.line.x = element_line(color= "black", size = 0.1))

ggsave("../../images/literature-timeline.png", plot=p, height=3, width=3,units="in")

q <- data %>% 
  filter(include=="yes") %>%
  group_by(category,sub.category) %>%
  summarise(count=length(sub.category)) %>%
  ggplot(aes(area=count,label=sub.category,subgroup=category,fill=category)) + 
  geom_treemap(color="white")+
  geom_treemap_subgroup_border( color = "white", size = 4 ) + 
  geom_treemap_subgroup_text(place = "topleft", alpha = 0.75, size = 17.5, # 
                             colour =  "white", family="Futura",
                             padding.x = unit(3, "mm"), padding.y = unit(3, "mm") ) +
  geom_treemap_text(colour = "white", place = "bottomright",
                    reflow = T, size = 10, family = "Helvetica",
                    padding.x = unit(2.5, "mm"), padding.y = unit(2.5, "mm")) +
  theme(legend.position = "none")

ggsave("../../images/literature-themes-treemap.png", plot=q, height=5.5, width=8,units="in")

r <- data %>% 
  filter(include=="yes") %>%
  filter(year > 1979) %>%
  ggplot() + 
  geom_bar(aes(x = year, fill = category),
           color = "white", width = 1, size=0.5) +
  scale_fill_brewer(palette = "Dark2") +
  ylab("Number of Articles") + xlab("") +
  theme(text = element_text(family = "Helvetica"),
        legend.title = element_blank(),
        panel.background = element_blank(),
        axis.text = element_text(size = 10, color = "black"),
        axis.ticks.y = element_blank(),
        axis.title.y = element_text(size=10, color="black",margin=margin(0,10,0,0)),
        axis.title.x = element_text(size=10, color="black",margin=margin(10,0,0,0)),
        axis.line.x = element_line(color= "black", size = 0.1))

ggsave("../../images/literature-themes-timeline.png", plot=r, height=3.5, width=8,units="in")

tech <- data %>% 
  filter(technology!="-") %>%
  filter(year > 1979) %>%
  group_by(technology) %>% summarize(count = length(technology)) %>%
  # arrange(count) %>%
  mutate(per = count/sum(count)*100) %>%
  arrange(per) %>%
  mutate(technology = factor(technology,levels=technology)) %>%
  arrange(-per) %>%
  mutate(lab = cumsum(per))
s <- tech %>%  ggplot() + 
  geom_bar(aes(x=1,y=per, fill = technology),
          stat = "identity",
          color = "white", width = 0.6, size=3) +
  xlim(c(0, 1.3)) +
  geom_text(aes(x=1,y=lab-(per/2),label=lapply(technology,function(d){str_wrap(d,width=5)})),
           size = ifelse(tech$per<10,2.5,3.5),show.legend=FALSE) +
  geom_text(aes(x=.6,y=lab-(per/2),label=paste0(round(per),"%")),
           size = 2.5,fontface="bold",color="darkgrey") +
  scale_fill_brewer(palette = "Set2") +
  coord_polar(theta="y",start = 0) +
  ylab("") + xlab("") +
  guides(fill=guide_legend(ncol=2)) +
  theme(text = element_text(family = "Helvetica"),
        legend.title = element_blank(),
        legend.position = "none",
        legend.text = element_text(size=11, color="black"),
        plot.margin = margin(0,0,0,0),
        panel.background = element_blank(),
        axis.text = element_blank(),
        axis.ticks.y = element_blank(),
        axis.title.y = element_blank(),
        axis.title.x = element_blank(),
        axis.line.x = element_blank())

ggsave("../../images/literature-technology.png", plot=s, height=3.5, width=3.5,units="in")
