library(tidyverse)
library(scales)

data <- read.csv("data-size-comparison.csv")

p <- ggplot(data) + 
  geom_bar(aes(reorder(name_s, size), size, fill = color),
           show.legend = FALSE,
           width = 0.75,
           stat = "identity") +
  geom_text(aes(reorder(name_s, size), size, label = labels), 
            nudge_y = 1.75, 
            family = "Helvetica Neue",
            size = 4) +
  scale_fill_identity() +
  scale_y_continuous(trans = "log10",
                     labels = trans_format("log10", math_format(10^.x))) +
  ylab("") + xlab("") +
  coord_flip(clip="off") +
  theme(text = element_text(family = "Helvetica Neue"),
        panel.background = element_blank(),
        axis.text.x = element_text(size = 10, color = "black"),
        axis.ticks.y = element_blank(),
        axis.text = element_text(size = 15, color = "black"))
        
ggsave("../../images/data-size-comparison.png",plot=p,height=5,width=3.5,units="in")
