data <- read.csv("data-size-comparison.csv")

ggplot(data) + 
  geom_bar(aes(reorder(dataset, size), size, fill = color),
           show.legend = FALSE,
           stat = "identity") +
  geom_text(aes(reorder(dataset, size), size, label = labels), 
            nudge_y = 1, 
            family = "Helvetica Neue",
            size = 3) +
  scale_fill_identity() +
  scale_y_continuous(trans = "log10",
                     labels = trans_format("log10", math_format(10^.x)))+
  ylab("") + 
  xlab("") +
  coord_flip()+
  theme(text = element_text(family = "Helvetica Neue Thin"),
        panel.background = element_blank())
