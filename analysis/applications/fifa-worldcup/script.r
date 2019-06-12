library(RPostgreSQL)
library(tidyverse)
library(lubridate)
library(ggplot2)
library(ggridges)
library(viridis)

schedule <- read.csv("schedule.csv",stringsAsFactors=FALSE) %>%
	filter(team1 == "England" | team2 == "England") %>%
	mutate(winner = ifelse(st1>st2, team1, ifelse(st2>st1,team2,ifelse(pt1>pt2, team1, team2)))) %>%
	mutate(start = as.POSIXct(paste(date,time),format="%Y-%m-%d %I:%M %p"),
		   end = as.POSIXct(paste(date,time),format="%Y-%m-%d %I:%M %p")+minutes(duration*60), 
		   against = ifelse(team1=="England",team2,team1),
		   result = ifelse(winner=="England","Win","Loss")) %>%
	select(date,start,end,against,result)

count_trend <- function(s,d){
	matchday_counts <- read.csv("counts.csv",header=FALSE,stringsAsFactors=FALSE)
	matchday_counts <- matchday_counts %>%
		filter(V2 == s) %>%	
		mutate(interval = as.POSIXct(format(as.POSIXct(V1),"%H:%M"),format="%H:%M"), date = as.Date(V1), count = V7+V9) %>%
		filter(date == as.Date(d)) %>%
		select(interval, date, count)
	matchday_counts <- left_join(expand.grid(seq(as.POSIXct("00:00",format = "%H:%M"), as.POSIXct("23:55",format = "%H:%M"), by = "5 min"),matchday_counts$date) %>% select(interval=Var1,date=Var2),matchday_counts,by=c("interval","date")) %>%
		mutate(type="Match Day")
	con <- dbConnect(dbDriver('PostgreSQL'), dbname = 's3nsor', user = 's3nsor_read', password = 'mcYX99hd', host = 'cdrc-footfall.geog.ucl.ac.uk')
	historic_counts <- dbGetQuery(con, paste0("select * from five_minute_counts where extract(dow from timestamp) = ",wday(d)-1," and date(timestamp) > '2018-01-01' and device = ",s)) %>%
		mutate(interval = as.POSIXct(format(as.POSIXct(timestamp),"%H:%M"),format="%H:%M"),
			   date = as.Date(format(timestamp,"%Y-%m-%d")),
			   count = count_high_global+count_low_global) %>%
		select(interval, date, count)
	historic_counts <- left_join(expand.grid(seq(as.POSIXct("00:00",format = "%H:%M"), as.POSIXct("23:55",format = "%H:%M"), by = "5 min"),historic_counts$date) %>% select(interval=Var1,date=Var2),historic_counts,by=c("interval","date")) %>%
		mutate(type="Normal Day")
	counts <- rbind(matchday_counts,historic_counts)
	counts[is.na(counts)] <- 0
	counts$p1 <- c(0,counts$count[1:(nrow(counts)-1)])
	counts$p2 <- c(c(0,0),counts$count[1:(nrow(counts)-2)])
	counts$p3 <- c(c(0,0,0),counts$count[1:(nrow(counts)-3)])
	counts$p4 <- c(c(0,0,0,0),counts$count[1:(nrow(counts)-4)])
	counts$p5 <- c(c(0,0,0,0,0),counts$count[1:(nrow(counts)-5)])
	counts$p6 <- c(c(0,0,0,0,0,0),counts$count[1:(nrow(counts)-6)])
	counts$n1 <- c(counts$count[2:nrow(counts)],0)
	counts$n2 <- c(counts$count[3:nrow(counts)],c(0,0))
	counts$n3 <- c(counts$count[4:nrow(counts)],c(0,0,0))
	counts$n4 <- c(counts$count[5:nrow(counts)],c(0,0,0,0))
	counts$n5 <- c(counts$count[6:nrow(counts)],c(0,0,0,0,0))
	counts$n6 <- c(counts$count[7:nrow(counts)],c(0,0,0,0,0,0))
	counts[counts$count == 0,]$count <- apply(counts[counts$count==0,c("p1","p2","p3","p4","p5","p6","n1","n2","n3","n4","n5","n6")],1,function(x){ x <- x[x!=0]; x <- x[!is.na(x)]; if(length(x)>0) { return(as.integer(mean(x))) } else { return(0) }})
	counts <- counts %>% select(interval,date,count, type)
	counts <- counts[rep(seq_len(dim(counts)[1]), as.integer(counts$count/3)), ] %>% select(-count)
	dbDisconnect(con)
	return(counts)
}

plot_trend <- function(counts) {
	plot_match_days <- ggplot(counts) + geom_density_ridges(
		aes(x = interval,
			y = fct_rev(factor(format(date,"%d %B\n%A"),format(unique(date)[order(unique(date))],"%d %B\n%A"))), height = ..density..,fill=type),
		lwd = 0.5, alpha = 0.9, stat="density", scale=2.5) +
		scale_x_datetime(date_labels="%H:%M") + 
		scale_fill_manual(values=c("orange","grey")) +
		theme_minimal() +
		theme(
			axis.title.x = element_blank(),
			axis.title.y = element_blank(),
			legend.position = "bottom",
			legend.title = element_blank(),
			panel.grid = element_blank())
	return(plot_match_days)
}
