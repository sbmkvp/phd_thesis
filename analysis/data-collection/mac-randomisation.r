library(RPostgreSQL)
library(tidyverse)
library(RJSONIO)
library(ggplot2)

config <- fromJSON("../config.json", simplify = FALSE)
con <- dbConnect(dbDriver('PostgreSQL'),
                 dbname = config$dbname,
                 user = config$dbuser,
                 password = config$dbpassword,
                 host = config$dbhost )
query <- "select
            extract(month from timestamp) as month,
            extract(year from timestamp) as year,
            probes_local as randomised,
            probes_global as original
          from counts
          where location = 20;"

data <- dbGetQuery(con,query) %>% 
  mutate(date = as.Date(paste(year,month,"15",sep="-"))) %>% 
  group_by(date) %>% 
  summarise(randomised = sum(randomised),original = sum(original)) %>% 
  mutate(randomised_perc = randomised/(randomised+original) * 100) %>% 
  mutate(original_perc = original/(randomised+original) * 100) %>% 
  select(date, random = randomised_perc, original = original_perc) %>% 
  gather("type","count", -date)

dbDisconnect(con)

p <- data %>% 
  ggplot() + 
  geom_line(aes(date, count, group=type, color=type),
            show.legend = FALSE, size = 1) +
  ylab("") + xlab("") +
  scale_y_continuous(limits=c(0,100), labels = function(x){paste0(x,"%")}) +
  geom_text(data=data.frame(l=c("Original","Random"),y=c(80,20)),
            aes(label = l, x = as.Date("2019-02-01"), y = y), hjust = 1,
            color = "black", show.legend = FALSE) +
  theme(text = element_text(family = "Helvetica Neue"),
        panel.background = element_blank(),
        axis.text = element_text(size = 10, color = "black"),
        axis.ticks.y = element_blank(),
        axis.title.y = element_text(size=10, color="black",margin=margin(0,-15,0,0)),
        axis.title.x = element_text(size=10, color="black",margin=margin(0,0,-10,0)),
        axis.line.x = element_line(color= "black", size = 0.1))

ggsave("../../images/mac-randomisation.png", plot=p, height=3, width=3,units="in")
