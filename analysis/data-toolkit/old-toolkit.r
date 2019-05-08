#! /usr/bin/Rscript
suppressMessages(library(tidyverse))
suppressMessages(library(RJSONIO))

day <- "~/unorganised-files/ff_sample/2018/01/01"
sensors <- paste(day, dir(day), sep = "/")[1:25]
probes <- NULL

for(sensor in sensors) {
  files <- paste(sensor, dir(sensor), sep = "/");
  for( file in files ) {
    records <- fromJSON(file);
    location <- vector(); signal <- vector();
    mac <- vector(); packets <- vector();
    vendor <- vector(); type <- vector(); time <- vector();
    for(record in records) {
      t <- strsplit(strsplit(file, '\\.')[[1]][1], '/')[[1]][8]
      l <- strsplit(strsplit(file, '\\.')[[1]][1], '/')[[1]][7]
      signal <- append(signal, record$Signal);
      mac <- append(mac, record$MacAddress);
      packets <- append(packets, record$PacketCount);
      type <- append(type, record$PacketType);
      vendor <- append(vendor, record$VendorMacPart);
      time <- append(time, t);
      location <- append(location, l);
    }
    recordsdf <- data.frame(location, time, signal,
                            mac, packets, type, vendor);
    if(is.null(probes)) { probes <- recordsdf; } 
      else { probes <- rbind(probes, recordsdf); }
  }
}

probes %>%
  group_by(location, time) %>%
  summarise(count = length(unique(paste0(vendor, mac)))) %>%
  write.csv("output-old.csv", row.names = FALSE);
