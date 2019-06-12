library(tidyverse)
library(ggplot2)
library(lubridate)

# counts2 <- read.csv("../../../data/other/leicester_square_counts_normal.csv")

counts <- read.csv("../../../data/other/leicester_square_counts.csv") %>%
  mutate(timestamp = as.POSIXct(timestamp)) %>%
  mutate(date=format(timestamp,"%Y-%m-%d")) %>%
  mutate(interval=format(ceiling_date(timestamp,"15 minutes"),"%H:%M")) %>%
  group_by(interval,date) %>% summarise(counts = sum(counts)) %>%
  filter(date %in% c("2018-07-07","2018-07-11"))

plot <- ggplot(counts) +
  geom_line(aes(as.POSIXct(interval,format="%H:%M"),counts,
                group=date, color=date ),
            show.legend = FALSE )
print(plot)
