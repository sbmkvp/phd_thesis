library(tidyverse)
library(RPostgreSQL)
library(RJSONIO)
library(ggplot2)
library(lubridate)
library(ggridges)
config <- fromJSON("../../config.json", simplify = FALSE)
con <- dbConnect(dbDriver('PostgreSQL'),
                 dbname = config$dbname,
                 user = config$dbuser,
                 password = config$dbpassword,
                 host = config$dbhost )
rm(config)
get_data <- function(con,loc,start,end){
  query <- paste0("select timestamp,counts_global+adjusted_local as count from counts where location = ",loc,
                  " and date(timestamp) between '",start,"'and'",end,"';")
  return(dbGetQuery(con,query))
}
  
plot_save <- function(data,filename) {
  data <- data[rep(seq_len(dim(data)[1]), as.integer(data$count)), ] %>% select(-count)
  plot <- ggplot(data) + 
    geom_density_ridges(
      aes(x = as.POSIXct(format(timestamp,"%H:%M"), format="%H:%M"),
          y = factor(format(timestamp,"%a, %b %d"),
                     levels=format(timestamp,"%a, %b %d") %>% unique %>% rev),
          height = ..density..),
      lwd = 0.5, alpha = 0.75, stat="density", scale=2.5,adjust=0.5,
      fill="#2471A3",color="#dddddd") +
    scale_x_datetime(date_labels="%H:%M") + 
    scale_fill_manual(values=c("orange","grey")) +
    theme_minimal() +
    theme(
      axis.title.x = element_blank(),
      axis.title.y = element_blank(),
      legend.position = "bottom",
      legend.title = element_blank(),
      panel.grid = element_blank())
  ggsave(filename,plot=plot, height=5, width=3.5,units="in")
}

counts <- get_data(con,314,'2019-03-04','2019-03-17')
plot_save(counts,"camden.png")
counts <- get_data(con,837,'2019-03-04','2019-03-17')
plot_save(counts,"leicestersq.png")
counts <- get_data(con,710,'2019-03-04','2019-03-17')
plot_save(counts,"regentst.png")
# counts <- get_data(con,583,'2019-03-04','2019-03-17')
# plot_save(counts,"holbornst.png")
