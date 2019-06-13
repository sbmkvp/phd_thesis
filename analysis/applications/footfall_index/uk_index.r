library(tidyverse)
library(tidyquant)
library(ggplot2)
library(showtext)
library(RPostgreSQL)
library(RJSONIO)
font_add('Helvetica', '/usr/share/fonts/OTF/Helvetica-Light.otf')
font_add('Futura', '/usr/share/fonts/TTF/futura-poster-light.ttf')
config <- fromJSON("../../config.json", simplify = FALSE)
con <- dbConnect(dbDriver('PostgreSQL'),
                 dbname = config$dbname,
                 user = config$dbuser,
                 password = config$dbpassword,
                 host = config$dbhost )
rm(config)
query <- "select
            location,
            date(timestamp) as date,
            min(date_trunc('week',timestamp)) as week,
            sum(counts_global+adjusted_local) as counts
          from counts
          where date(timestamp) between '2017-01-02' and '2018-12-30'
          group by 1,2";
data <- dbGetQuery(con, query)

mb <- 0.002
weekly <- data %>%
  group_by(date) %>% mutate(week = min(week), counts = mean(counts)) %>%
  arrange(date) %>% group_by(week) %>%
  summarise(open = counts[1], close = counts[length(counts)],
            high = max(counts), low = min(counts), mean =mean(counts)) %>%
  arrange(week) %>% mutate(week_number = 1:104) %>%
  mutate(open = open - (week_number*mb*open),
         close = close - (week_number*mb*close),
         high = high - (week_number*mb*high),
         low = low - (week_number*mb*low),
         mean = mean - (week_number*mb*mean)) %>%
  mutate(mean_prev = c(NA,mean[1:(length(mean)-1)])) %>%
  filter(!is.na(mean_prev)) %>%
  group_by(week) %>%
  mutate(min = ifelse(mean>mean_prev,mean_prev,mean),
         max = ifelse(mean>mean_prev,mean,mean_prev)) %>%
  mutate(movement = ifelse((mean_prev-mean)<0,"up","down"))

uk_index <- weekly %>% ggplot() +
  geom_rect(aes(xmin = ymd(week)-2,xmax=ymd(week)+2,
    ymin = min, ymax = max,
    fill = movement), show.legend = FALSE) +
  ylab("Average weekly footfall") + xlab("") +
  theme(text = element_text(family = "Helvetica Neue"),
        panel.background = element_blank(),
        axis.text = element_text(size = 10, color = "black"),
        axis.ticks.y = element_blank(),
        axis.title.y = element_text(size=10, color="black",margin=margin(0,5,0,0)),
        axis.title.x = element_text(size=10, color="black",margin=margin(10,0,0,0)),
        axis.line.x = element_line(color= "black", size = 0.1))
ggsave("../../../images/application-footfall-index.png",plot=uk_index, height=3, width=11,units="in")


