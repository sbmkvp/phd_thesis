library(tidyverse)
library(showtext)
font_add('Helvetica', '/usr/share/fonts/OTF/Helvetica-Light.otf')
showtext_auto()

Type <- c("Bespoke","Ideal","Turn-key")
Scalability <- c(3,2,2)
Flexibility <- c(3,3,1)
Complexity <- c(3,2,1)
Cost <- c(1,1,3)

data <- data.frame(Type,Scalability,Flexibility,Complexity,Cost) %>%
  gather(key="Consideration", value = "Value", -Type) %>%
  mutate(Type = factor(Type,levels = c("Turn-key","Ideal","Bespoke" )))

p <- ggplot(data) + 
  geom_tile(aes(Type,Consideration,fill=factor(Value)),color="white",size=2,  show.legend = FALSE) +
  ylab("") + xlab("") +
  scale_fill_manual(values = c("#FAE5D3","#F0B27A","#E67E22")) +
  theme(text = element_text(family = "Helvetica"),
        panel.background = element_blank(),
        axis.ticks.x = element_blank(),
        axis.ticks.y = element_blank(),
        axis.text = element_text(size = 25, color = "black",margin =margin(0,10,0,5)))

ggsave("../../images/data-toolkit-collection.png",plot=p,height=2.5,width=2.5,units="in")
