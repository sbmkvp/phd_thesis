library(reshape2)
library(digest)
library(dplyr)
library(ggplot2)

getData <- function(path) {
	data <- read.csv(path,header=FALSE,stringsAsFactors=FALSE)
	names(data) <- c("id","time","length","signal","duration","mac","sequence","tags","ssid")
	temp <- data.frame(do.call('rbind',strsplit(data$mac,split="_",fixed=TRUE)),stringsAsFactors=FALSE)[,1]
	data$vendor <- ifelse(grepl("_",data$mac),temp,NA)
	data$mac <- sapply(data$mac,digest,algo="sha256")
	data$time <- as.POSIXct(data$time, format="%b %d, %Y %H:%M:%OS")
	return(data)
}

analyseMac <- function(data,field,extra=FALSE){
	vendors <- dcast(data,vendor~"total",length,value.var=field)
	vendors$unique <- dcast(data,vendor~"u",function(d){length(unique(d))},value.var=field)$u
	if(extra) {
		vendors$mean <- dcast(data,vendor~"u",function(d){floor(mean(d))},value.var=field)$u
		vendors$min <- dcast(data,vendor~"u",function(d){min(d)},value.var=field)$u
		vendors$max <- dcast(data,vendor~"u",function(d){max(d)},value.var=field)$u
	}
	return(vendors)
}

countUnique <- function(data,fields) {
	vendors <- dcast(data,vendor~"total",length,value.var="mac")
	for(i in fields) {
		vendors[[i]] <- dcast(data,vendor~"x",function(d){length(unique(d))},value.var=i)$x
	}
	return(vendors)
}
