#! /usr/bin/Rscript

rm(list=ls())
suppressMessages(library(tidyverse))
suppressMessages(library(RJSONIO))

day <- "~/unorganised-files/ff_sample/2018/01/01"
sensors <- paste(day, dir(day), sep = "/")[1:25]

probes <- NULL

for(sensor in sensors) {
  files <- paste(sensor, dir(sensor), sep = "/")
  for( file in files ) {
    records <- fromJSON(file)
    location <- vector(); signal <- vector(); mac <- vector(); packets <- vector(); vendor <- vector(); type <- vector(); time <- vector();
    for(record in records) {
      signal <- append(signal,record$Signal);
      mac <- append(mac,record$MacAddress);
      packets <- append(packets,record$PacketCount);
      type <- append(type,record$PacketType);
      vendor <- append(vendor,record$VendorMacPart);
      time <- append(time,strsplit(strsplit(file,'\\.')[[1]][1],'/')[[1]][8])
      location <- append(location,strsplit(strsplit(file,'\\.')[[1]][1],'/')[[1]][7])
    }
    recordsdf <- data.frame(location,time,signal,mac,packets,type,vendor)
    if(is.null(probes)) { probes <- recordsdf } else { probes <- rbind(probes,recordsdf) }
  }
  print(sensor)
}

probes %>%
  group_by(location,time) %>%
  summarise(count = length(unique(paste0(vendor,mac)))) %>%
  write.csv("output-old.csv",row.names=FALSE)
